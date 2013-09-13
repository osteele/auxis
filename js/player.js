var LoadingCallbacks, NoteBuffers, PianoSampleURLBase, PitchClassNames, PlayOnLoad, SampleNotes, SampleNotesLoaded, Theory, TimeOffset, chord, context, find_chord, loadAndPlay, midi2name, n, name2midi, note, onload, player, progression, rest, rewind, with_track, _ref,
  __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

_ref = Theory = this.Theory, PitchClassNames = _ref.PitchClassNames, find_chord = _ref.find_chord, midi2name = _ref.midi2name, name2midi = _ref.name2midi;

PianoSampleURLBase = "/media/piano/med/";

PianoSampleURLBase = "https://s3.amazonaws.com/assets.osteele.com/audio/piano/med/";

window.AudioContext || (window.AudioContext = window.webkitAudioContext);

context = new window.AudioContext;

SampleNotes = ['B0'].concat((function() {
  var _i, _results;
  _results = [];
  for (n = _i = 1; _i <= 8; n = ++_i) {
    _results.push("C" + n);
  }
  return _results;
})());

NoteBuffers = {};

LoadingCallbacks = {};

TimeOffset = 0;

loadAndPlay = function(note, cb) {
  var buffer, request, url;
  if (buffer = NoteBuffers[note]) {
    return cb(buffer);
  }
  LoadingCallbacks[note] || (LoadingCallbacks[note] = []);
  LoadingCallbacks[note].push(cb);
  if (LoadingCallbacks[note].length > 1) {
    return;
  }
  url = "" + PianoSampleURLBase + (note.toLowerCase()) + ".mp3";
  request = new XMLHttpRequest;
  request.open('GET', url, true);
  request.responseType = 'arraybuffer';
  request.onload = function() {
    return context.decodeAudioData(request.response, function(buffer) {
      var _i, _len, _ref1;
      NoteBuffers[note] = buffer;
      _ref1 = LoadingCallbacks[note];
      for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
        cb = _ref1[_i];
        cb(buffer);
      }
      return delete LoadingCallbacks[note];
    }, function(e) {
      return console.error('error loading', url);
    });
  };
  return request.send();
};

SampleNotesLoaded = false;

PlayOnLoad = [];

(function() {
  var countdown, note, _i, _len, _results;
  countdown = SampleNotes.length;
  _results = [];
  for (_i = 0, _len = SampleNotes.length; _i < _len; _i++) {
    note = SampleNotes[_i];
    _results.push(loadAndPlay(note, function() {
      var fn, _j, _len1;
      if (SampleNotesLoaded) {
        return;
      }
      countdown -= 1;
      SampleNotesLoaded || (SampleNotesLoaded = countdown === 0);
      if (!SampleNotesLoaded) {
        return;
      }
      TimeOffset = context.currentTime;
      for (_j = 0, _len1 = PlayOnLoad.length; _j < _len1; _j++) {
        fn = PlayOnLoad[_j];
        fn();
      }
      return PlayOnLoad = null;
    }));
  }
  return _results;
})();

onload = function(fn) {
  if (SampleNotesLoaded) {
    return fn();
  }
  return PlayOnLoad.push(fn);
};

note = function(note, options) {
  var base, bend, duration, startTime;
  if (options == null) {
    options = {};
  }
  options = _.extend({
    gain: 1,
    duration: 3
  }, options);
  startTime = TimeOffset + (options.start || 0);
  bend = options.bend || 0;
  duration = options.duration;
  if (options.staccato) {
    duration = .5;
  }
  note = note.toUpperCase();
  if (__indexOf.call(SampleNotes, note) < 0) {
    base = _.select(SampleNotes, function(c) {
      return name2midi(c) <= name2midi(note);
    }).reverse()[0];
    bend += name2midi(note) - name2midi(base);
    note = base;
  }
  return loadAndPlay(note, function(buffer) {
    var gainNode, output, sourceNode;
    sourceNode = context.createBufferSource();
    sourceNode.buffer = buffer;
    if (bend) {
      sourceNode.playbackRate.value = Math.pow(2, bend / 12);
    }
    output = sourceNode;
    if (options.gain || duration) {
      gainNode = context.createGain();
      gainNode.gain.value = options.gain;
      gainNode.gain.linearRampToValueAtTime(0, startTime + duration);
      sourceNode.connect(gainNode);
      gainNode.connect(context.destination);
      output = gainNode;
    }
    output.connect(context.destination);
    return sourceNode.start(startTime);
  });
};

chord = function(chord, options) {
  var i, start, _i, _j, _len, _len1, _ref1, _ref2, _results;
  if (options == null) {
    options = {};
  }
  chord = find_chord(chord);
  start = options.start || 0;
  if (options.pick) {
    _ref1 = options.pick;
    for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
      n = _ref1[_i];
      note(chord.notes[Number(n)], _.extend({}, options, {
        start: start
      }));
      start += options.note_separation || .25;
    }
    return;
  }
  _ref2 = chord.notes;
  _results = [];
  for (i = _j = 0, _len1 = _ref2.length; _j < _len1; i = ++_j) {
    n = _ref2[i];
    note(n, _.extend({}, options, {
      start: start
    }));
    if (options.arpeggiate) {
      _results.push(start += options.note_separation);
    } else {
      _results.push(void 0);
    }
  }
  return _results;
};

progression = function(chords, options) {
  var dur, _i, _len, _ref1, _results;
  if (options == null) {
    options = {};
  }
  options = _.extend({
    root: 'C4',
    note_separation: .2,
    chord_separation: .2
  }, options);
  if (typeof chords === 'string') {
    chords = Theory.progression(options.root, chords);
  }
  _results = [];
  for (_i = 0, _len = chords.length; _i < _len; _i++) {
    chord = chords[_i];
    player.chord(chord, options);
    dur = ((_ref1 = options.pick) != null ? _ref1.length : void 0) * options.note_separation || 0;
    dur += options.chord_separation;
    _results.push(player.rest(dur));
  }
  return _results;
};

rewind = function() {
  return TimeOffset = context.currentTime;
};

rest = function(t) {
  return TimeOffset += t;
};

with_track = function(fn) {
  var saved_time_offset;
  saved_time_offset = TimeOffset;
  try {
    return fn();
  } finally {
    TimeOffset = saved_time_offset;
  }
};

this.Player = player = {
  note: note,
  chord: chord,
  progression: progression,
  rest: rest,
  rewind: rewind,
  onload: onload,
  with_track: with_track
};

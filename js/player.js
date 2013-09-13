;(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var app, piece, pieces, player;

player = require('./player.coffee');

pieces = {};

piece = function(name, def) {
  return pieces[name] = def;
};

piece('single notes', function() {
  player.note('c4');
  player.note('e4', {
    start: 1 / 2
  });
  player.note('g4', {
    start: 1
  });
  player.note('c4', {
    start: 2,
    gain: 0.2
  });
  player.note('e4', {
    start: 2.5,
    gain: 0.2
  });
  return player.note('g4', {
    start: 3,
    gain: 0.2
  });
});

piece('arpeggiated chords', function() {
  player.chord('C4', {
    pick: '0121212'
  });
  player.rest(2);
  player.chord('F4', {
    pick: '0121212'
  });
  player.rest(2);
  player.chord('G4', {
    pick: '2101210'
  });
  player.rest(2);
  return player.chord('C4', {
    pick: '1202120',
    duration: 10
  });
});

piece('chord progression', function() {
  player.progression('I Ib Ic ii IV iii IVb V7 V7b V7c Ic Ib I', {
    pick: '0121',
    chord_separation: 0,
    gain: .5
  });
  return player.progression('I IV V ii V7 I', {
    chord_separation: .5,
    gain: .5
  });
});

app = angular.module('Player', []);

app.controller('Player', function($scope) {
  var fn, name;
  $scope.pieces = (function() {
    var _results;
    _results = [];
    for (name in pieces) {
      fn = pieces[name];
      _results.push({
        name: name,
        fn: fn
      });
    }
    return _results;
  })();
  return $scope.play = function(_arg) {
    var fn;
    fn = _arg.fn;
    player.rewind();
    return fn();
  };
});


},{"./player.coffee":3}],2:[function(require,module,exports){
var programs;

programs = {
  0: 'Acoustic Grand Piano',
  1: 'Bright Acoustic Piano',
  2: 'Electric Grand Piano',
  3: 'Honky-tonk Piano',
  4: 'Electric Piano 1',
  5: 'Electric Piano 2',
  6: 'Harpsichord',
  7: 'Clavinet',
  8: 'Celesta',
  9: 'Glockenspiel',
  10: 'Music Box',
  11: 'Vibraphone',
  12: 'Marimba',
  13: 'Xylophone',
  14: 'Tubular Bells',
  15: 'Dulcimer',
  16: 'Drawbar Organ',
  17: 'Percussive Organ',
  18: 'Rock Organ',
  19: 'Church Organ',
  20: 'Reed Organ',
  21: 'Accordion',
  22: 'Harmonica',
  23: 'Tango Accordion',
  24: 'Acoustic Guitar (nylon)',
  25: 'Acoustic Guitar (steel)',
  26: 'Electric Guitar (jazz)',
  27: 'Electric Guitar (clean)',
  28: 'Electric Guitar (muted)',
  29: 'Overdriven Guitar',
  30: 'Distortion Guitar',
  31: 'Guitar Harmonics',
  32: 'Acoustic Bass',
  33: 'Electric Bass (finger)',
  34: 'Electric Bass (pick)',
  35: 'Fretless Bass',
  36: 'Slap Bass 1',
  37: 'Slap Bass 2',
  38: 'Synth Bass 1',
  39: 'Synth Bass 2',
  40: 'Violin',
  41: 'Viola',
  42: 'Cello',
  43: 'Contrabass',
  44: 'Tremolo Strings',
  45: 'Pizzicato Strings',
  46: 'Orchestral Harp',
  47: 'Timpani',
  48: 'String Ensemble 1',
  49: 'String Ensemble 2',
  50: 'Synth Strings 1',
  51: 'Synth Strings 2',
  52: 'Choir Aahs',
  53: 'Voice Oohs',
  54: 'Synth Choir',
  55: 'Orchestra Hit',
  56: 'Trumpet',
  57: 'Trombone',
  58: 'Tuba',
  59: 'Muted Trumpet',
  60: 'French Horn',
  61: 'Brass Section',
  62: 'Synth Brass 1',
  63: 'Synth Brass 2',
  64: 'Soprano Sax',
  65: 'Alto Sax',
  66: 'Tenor Sax',
  67: 'Baritone Sax',
  68: 'Oboe',
  69: 'English Horn',
  70: 'Bassoon',
  71: 'Clarinet',
  72: 'Piccolo',
  73: 'Flute',
  74: 'Recorder',
  75: 'Pan Flute',
  76: 'Blown bottle',
  77: 'Shakuhachi',
  78: 'Whistle',
  79: 'Ocarina',
  80: 'Lead 1 (square)',
  81: 'Lead 2 (sawtooth)',
  82: 'Lead 3 (calliope)',
  83: 'Lead 4 (chiff)',
  84: 'Lead 5 (charang)',
  85: 'Lead 6 (voice)',
  86: 'Lead 7 (fifths)',
  87: 'Lead 8 (bass + lead)',
  88: 'Pad 1 (new age)',
  89: 'Pad 2 (warm)',
  90: 'Pad 3 (polysynth)',
  91: 'Pad 4 (choir)',
  92: 'Pad 5 (bowed)',
  93: 'Pad 6 (metallic)',
  94: 'Pad 7 (halo)',
  95: 'Pad 8 (sweep)',
  96: 'FX 1 (rain)',
  97: 'FX 2 (soundtrack)',
  98: 'FX 3 (crystal)',
  99: 'FX 4 (atmosphere)',
  100: 'FX 5 (brightness)',
  101: 'FX 6 (goblins)',
  102: 'FX 7 (echoes)',
  103: 'FX 8 (sci-fi)',
  104: 'Sitar',
  105: 'Banjo',
  106: 'Shamisen',
  107: 'Koto',
  108: 'Kalimba',
  109: 'Bagpipe',
  110: 'Fiddle',
  111: 'Shanai',
  112: 'Tinkle Bell',
  113: 'Agogo',
  114: 'Steel Drums',
  115: 'Woodblock',
  116: 'Taiko Drum',
  117: 'Melodic Tom',
  118: 'Synth Drum',
  119: 'Reverse Cymbal',
  120: 'Guitar Fret Noise',
  121: 'Breath Noise',
  122: 'Seashore',
  123: 'Bird Tweet',
  124: 'Telephone Ring',
  125: 'Helicopter',
  126: 'Applause',
  127: 'Gunshot'
};


},{}],3:[function(require,module,exports){
var LoadingCallbacks, NoteBuffers, PianoSampleURLBase, PitchClassNames, PlayOnLoad, SampleNotes, SampleNotesLoaded, TimeOffset, chord, context, find_chord, loadAndPlay, midi2name, n, name2midi, note, onload, progression, rest, rewind, with_track, _ref,
  __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

_ref = require('./theory.coffee'), PitchClassNames = _ref.PitchClassNames, find_chord = _ref.find_chord, midi2name = _ref.midi2name, name2midi = _ref.name2midi;

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

module.exports = {
  note: note,
  chord: chord,
  progression: progression,
  rest: rest,
  rewind: rewind,
  onload: onload,
  with_track: with_track
};


},{"./theory.coffee":4}],4:[function(require,module,exports){
var AccidentalValues, Chord, ChordDefinitions, Chords, PitchClassNames, chord, find_chord, midi2name, name2midi, progression,
  __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

PitchClassNames = 'C C♯ D D♯ E F F♯ G G♯ A A♯ B'.split(/\s+/);

AccidentalValues = {
  '♯': 1,
  '#': 1,
  '♭': -1,
  'b': -1,
  '𝄪': 2,
  '𝄫': -2
};

Chord = (function() {
  function Chord(_arg) {
    var pc;
    this.name = _arg.name, this.abbrs = _arg.abbrs, this.abbr = _arg.abbr, this.pitch_classes = _arg.pitch_classes, this.root = _arg.root;
    if (typeof this.abbrs === 'string') {
      this.abbrs = this.abbrs.split(/s/);
    }
    this.abbrs || (this.abbrs = [this.abbr]);
    this.abbr || (this.abbr = this.abbrs[0]);
    this.pitch_classes = (function(pitches) {
      var pc, pitch_class_codes, _i, _len, _results;
      pitch_class_codes = {
        't': 10,
        'e': 11
      };
      _results = [];
      for (_i = 0, _len = pitches.length; _i < _len; _i++) {
        pc = pitches[_i];
        _results.push(pitch_class_codes[pc] || parseInt(pc, 10));
      }
      return _results;
    })(this.pitch_classes);
    if (this.root != null) {
      this.notes = (function() {
        var _i, _len, _ref, _results;
        _ref = this.pitch_classes;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          pc = _ref[_i];
          _results.push(midi2name(name2midi(this.root) + pc));
        }
        return _results;
      }).call(this);
    }
  }

  Chord.prototype.at = function(root) {
    return new Chord({
      name: this.name,
      abbrs: this.abbrs,
      pitch_classes: this.pitch_classes,
      root: root
    });
  };

  return Chord;

})();

ChordDefinitions = [
  {
    name: 'Major',
    abbrs: ['', 'M'],
    pitch_classes: '047'
  }, {
    name: 'Minor',
    abbr: 'm',
    pitch_classes: '037'
  }, {
    name: 'Augmented',
    abbrs: ['+', 'aug'],
    pitch_classes: '048'
  }, {
    name: 'Diminished',
    abbrs: ['°', 'dim'],
    pitch_classes: '036'
  }, {
    name: 'Sus2',
    abbr: 'sus2',
    pitch_classes: '027'
  }, {
    name: 'Sus4',
    abbr: 'sus4',
    pitch_classes: '057'
  }, {
    name: 'Dominant 7th',
    abbrs: ['7', 'dom7'],
    pitch_classes: '047t'
  }, {
    name: 'Augmented 7th',
    abbrs: ['+7', '7aug'],
    pitch_classes: '048t'
  }, {
    name: 'Diminished 7th',
    abbrs: ['°7', 'dim7'],
    pitch_classes: '0369'
  }, {
    name: 'Major 7th',
    abbr: 'maj7',
    pitch_classes: '047e'
  }, {
    name: 'Minor 7th',
    abbr: 'min7',
    pitch_classes: '037t'
  }, {
    name: 'Dominant 7 b5',
    abbr: '7b5',
    pitch_classes: '046t'
  }, {
    name: 'Min 7th b5',
    abbrs: ['ø', 'Ø', 'm7b5'],
    pitch_classes: '036t'
  }, {
    name: 'Dim Maj 7th',
    abbr: '°Maj7',
    pitch_classes: '036e'
  }, {
    name: 'Min Maj 7th',
    abbrs: ['min/maj7', 'min(maj7)'],
    pitch_classes: '037e'
  }, {
    name: '6th',
    abbrs: ['6', 'M6', 'M6', 'maj6'],
    pitch_classes: '0479'
  }, {
    name: 'Minor 6th',
    abbrs: ['m6', 'min6'],
    pitch_classes: '0379'
  }
];

Chords = (function() {
  var _i, _len, _results;
  _results = [];
  for (_i = 0, _len = ChordDefinitions.length; _i < _len; _i++) {
    chord = ChordDefinitions[_i];
    _results.push(new Chord(chord));
  }
  return _results;
})();

find_chord = function(name) {
  var root, _ref;
  if (name instanceof Chord) {
    return name;
  }
  if (!name.match(/^([A-G][♯#♭b𝄪𝄫]*\d+)?\s*(.*)$/)) {
    throw new Error("Not a chord name: " + name);
  }
  _ref = [RegExp.$1, RegExp.$2 || 'Major'], root = _ref[0], name = _ref[1];
  chord = ((function() {
    var _i, _len, _results;
    _results = [];
    for (_i = 0, _len = Chords.length; _i < _len; _i++) {
      chord = Chords[_i];
      if (chord.name === name || __indexOf.call(chord.abbrs, name) >= 0) {
        _results.push(chord);
      }
    }
    return _results;
  })())[0];
  if (!chord) {
    throw new Error("Not a chord name: " + name);
  }
  if (root !== '') {
    chord = chord.at(root);
  }
  return chord;
};

midi2name = function(number) {
  return "" + PitchClassNames[(number + 12) % 12] + (Math.floor((number - 12) / 12));
};

name2midi = function(name) {
  var accidentals, bend, k, m, mm, note, octave, pitch_name, v, __;
  if (!(m = name.toUpperCase().match(/^([A-G])([♯#♭b𝄪𝄫]*)(\d+)/))) {
    throw new Error("" + name + " is not a note name");
  }
  __ = m[0], pitch_name = m[1], accidentals = m[2], octave = m[3];
  bend = 0;
  for (k in AccidentalValues) {
    v = AccidentalValues[k];
    if (mm = accidentals.match(RegExp(k, 'g'))) {
      bend += v * mm.length;
    }
  }
  note = {
    pitch: PitchClassNames.indexOf(pitch_name),
    bend: bend,
    octave: Number(octave)
  };
  return 12 + note.pitch + note.bend + note.octave * 12;
};

progression = function(root, chords) {
  var acc, chord_root, chord_type, cr, i, name, roman_numerals, scale, _i, _len, _ref, _results;
  scale = [0, 2, 4, 5, 7, 9, 11];
  roman_numerals = 'I II III IV V VI VII'.split(/\s+/);
  _ref = chords.split(/[\s+\-]+/);
  _results = [];
  for (_i = 0, _len = _ref.length; _i < _len; _i++) {
    name = _ref[_i];
    cr = name.replace(/[♭67°ø\+bcd]/g, '');
    i = roman_numerals.indexOf(cr.toUpperCase());
    if (i >= 0) {
      acc = 0;
      if (name.match(/♭/)) {
        acc = -1;
      }
      chord_root = midi2name(name2midi(root) + scale[i] + acc);
      chord_type = "Major";
      if (cr === cr.toLowerCase()) {
        chord_type = "Minor";
      }
      if (name.match(/\+/)) {
        chord_type = "aug";
      }
      if (name.match(/°/)) {
        chord_type = "dim";
      }
      if (name.match(/6/)) {
        chord_type = "maj6";
      }
      if (name.match(/7/)) {
        chord_type = "dom7";
      }
      if (name.match(/\+7/)) {
        chord_type = "+7";
      }
      if (name.match(/°7/)) {
        chord_type = "°7";
      }
      if (name.match(/ø7/)) {
        chord_type = "ø7";
      }
      chord = find_chord(chord_type).at(chord_root);
      if (name.match(/b/)) {
        chord.inversion = 1;
      }
      if (name.match(/c/)) {
        chord.inversion = 2;
      }
      if (name.match(/d/)) {
        chord.inversion = 3;
      }
      if (chord.inversion != null) {
        chord.notes = chord.notes.slice(chord.inversion).concat(chord.notes.slice(0, chord.inversion));
      }
      _results.push(chord);
    } else {
      _results.push(name);
    }
  }
  return _results;
};

module.exports = {
  Chords: Chords,
  PitchClassNames: PitchClassNames,
  find_chord: find_chord,
  midi2name: midi2name,
  name2midi: name2midi,
  progression: progression
};


},{}]},{},[1,2,3,4])
;
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

this.Theory = {
  Chords: Chords,
  PitchClassNames: PitchClassNames,
  find_chord: find_chord,
  midi2name: midi2name,
  name2midi: name2midi,
  progression: progression
};

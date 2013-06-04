PitchClassNames = 'C C♯ D D♯ E F F♯ G G♯ A A♯ B'.split(/\s+/)
AccidentalValues = {'♯': 1, '#': 1, '♭': -1, 'b': -1, '𝄪': 2, '𝄫': -2}

class Chord
  constructor: ({@name, @abbrs, @abbr, @pitch_classes, @root}) ->
    @abbrs = @abbrs.split(/s/) if typeof @abbrs == 'string'
    @abbr ||= @abbrs[0]
    @pitch_classes = do (pitches=@pitch_classes) ->
      pitch_class_codes = {'t': 10, 'e': 11}
      pitch_class_codes[pc] or parseInt(pc, 10) for pc in pitches
    @notes = (midi2name(name2midi(@root) + pc) for pc in @pitch_classes) if @root?

  at: (root) ->
    new Chord {@name, @abbrs, @pitch_classes, root}

ChordDefinitions = [
  {name: 'Major', abbrs: ['', 'M'], pitch_classes: '047'},
  {name: 'Minor', abbr: 'm', pitch_classes: '037'},
  {name: 'Augmented', abbrs: ['+', 'aug'], pitch_classes: '048'},
  {name: 'Diminished', abbrs: ['°', 'dim'], pitch_classes: '036'},
  {name: 'Sus2', abbr: 'sus2', pitch_classes: '027'},
  {name: 'Sus4', abbr: 'sus4', pitch_classes: '057'},
  {name: 'Dominant 7th', abbrs: ['7', 'dom7'], pitch_classes: '047t'},
  {name: 'Augmented 7th', abbrs: ['+7', '7aug'], pitch_classes: '048t'},
  {name: 'Diminished 7th', abbrs: ['°7', 'dim7'], pitch_classes: '0369'},
  {name: 'Major 7th', abbr: 'maj7', pitch_classes: '047e'},
  {name: 'Minor 7th', abbr: 'min7', pitch_classes: '037t'},
  {name: 'Dominant 7 b5', abbr: '7b5', pitch_classes: '046t'},
  # following is also half-diminished 7th
  {name: 'Min 7th b5', abbrs: ['ø', 'Ø', 'm7b5'], pitch_classes: '036t'},
  {name: 'Dim Maj 7th', abbr: '°Maj7', pitch_classes: '036e'},
  {name: 'Min Maj 7th', abbrs: ['min/maj7', 'min(maj7)'], pitch_classes: '037e'},
  {name: '6th', abbrs: ['6', 'M6', 'M6', 'maj6'], pitch_classes: '0479'},
  {name: 'Minor 6th', abbrs: ['m6', 'min6'], pitch_classes: '0379'},
]

Chords = (new Chord(chord) for chord in ChordDefinitions)

find_chord = (name) ->
  throw "Note a chord name: #{name}" unless name.match /^([A-G][♯#♭b𝄪𝄫]*\d+)\s*(.*)$/
  [root, name] = [RegExp.$1 or 'Major', RegExp.$2]
  chord = (chord for chord in Chords when (chord) -> chord.name == name or name in chord.abbrs)[0]
  throw "Note a chord name: #{name}" unless chord
  chord = chord.at root if root != ''
  chord

midi2name = (number) ->
  "#{PitchClassNames[(number + 12) % 12]}#{Math.floor((number - 12) / 12)}"

name2midi = (name) ->
  throw new Error("#{name} is not a note name") unless m = name.toUpperCase().match(/^([A-G])([♯#♭b𝄪𝄫]*)(\d+)/)
  [__, pitch_name, accidentals, octave] = m
  bend = 0
  bend += v * mm.length for k, v of AccidentalValues when mm = accidentals.match(RegExp(k, 'g'))
  note = {pitch: PitchClassNames.indexOf(pitch_name), bend, octave: Number(octave)}
  12 + note.pitch + note.bend + note.octave * 12

progression = (root, chords) ->
  scale = [0, 2, 4, 5, 7, 9, 11]
  roman_numerals = 'I II III IV V VI VII'.split(/\s+/)
  for name in chords.split(/[\s+\-]+/)
    cr = name.toUpperCase().replace(/[♭67°ø+bcd]/g, '')
    i = roman_numerals.indexOf cr
    if i >= 0
      acc = 0
      acc = -1 if name.match /♭/
      chord_root = midi2name(name2midi(root) + scale[i] + acc)
      chord_type = "Major"
      chord_type = "Minor" if name == name.toLowerCase()
      chord_type = "aug" if name.match /\+/
      chord_type = "dim" if name.match /°/
      chord_type = "maj6" if name.match /6/
      chord_type = "dom7" if name.match /7/
      chord_type = "+7" if name.match /\+7/
      chord_type = "°7" if name.match /°7/
      chord_type = "ø7" if name.match /ø7/
      # TODO inversions
      # TODO 9, 13, sharp, natural
      "#{chord_root}#{chord_type}"
    else
      name

@Theory = {
  Chords
  PitchClassNames
  find_chord
  midi2name
  name2midi
  progression
}

PitchClassNames = 'C C♯ D D♯ E F F♯ G G♯ A A♯ B'.split(/\s+/)
AccidentalValues = {'♯': 1, '#': 1, '♭': -1, 'b': -1, '𝄪': 2, '𝄫': -2}

midi2name = (number) ->
  "#{PitchClassNames[(number + 12) % 12]}#{Math.floor((number - 12) / 12)}"

name2midi = (name) ->
  throw new Error("#{name} is not a note name") unless m = name.toUpperCase().match(/^([A-G])([♯#♭b𝄪𝄫]*)(\d+)/)
  [__, pitch_name, accidentals, octave] = m
  bend = 0
  bend += v * mm.length for k, v of AccidentalValues when mm = accidentals.match(RegExp(k, 'g'))
  note = {pitch: PitchClassNames.indexOf(pitch_name), bend, octave: Number(octave)}
  12 + note.pitch + note.bend + note.octave * 12

@Theory = {
  PitchClassNames
  midi2name
  name2midi
}

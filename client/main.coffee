player = @Player

t1 = ->
  player.note 'c4'
  player.note 'e4', start: 1/2
  player.note 'g4', start: 1

  player.note 'c4', start: 2, gain: 0.2
  player.note 'e4', start: 2.5, gain: 0.2
  player.note 'g4', start: 3, gain: 0.2

t2 = ->
  player.chord 'C4', pick: '0121212'
  player.rest 2
  player.chord 'F4', pick: '0121212'
  player.rest 2
  player.chord 'G4', pick: '2101210'
  player.rest 2
  player.chord 'C4', pick: '1202120', duration: 10

{name2midi, midi2name, find_chord} = @Theory

progression = ->
  root = 'C4'
  scale = [0, 2, 4, 5, 7, 9, 11]
  # I IV V V
  # I I IV V
  # I VI I V
  # I IV V IV
  prog = 'I I I I7 IV IV7 I I7 V7 IV7 I I'
  nashville = 'I II III IV V VI VII'.split(/\s+/)
  for n in prog.split(/[\s+\-]+/)
    cr = n.toUpperCase().replace(/[7°]/, '')
    i = nashville.indexOf(cr)
    chord_root = midi2name(name2midi(root) + scale[i])
    chord_type = "Major"
    chord_type = "Minor" if n == n.toLowerCase()
    chord_type = "Diminished" if n.match(/°/)
    chord_type = "dom7" if n.match(/7/)
    chord_name = "#{chord_root}#{chord_type}"
    player.chord chord_name #, pick: '0121212'
    player.rest .25

Meteor.startup ->
  progression()

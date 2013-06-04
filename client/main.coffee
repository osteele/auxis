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

{name2midi, midi2name, find_chord, progression} = @Theory

play_progression = ->
  chords = progression 'C4', 'I ii IV iii IV V I'
  for chord in chords
    player.chord chord, pick: '0121'
    player.rest 1.75

Meteor.startup ->
  play_progression()

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

t3 = ->
  player.progression 'I Ib Ic ii IV iii IVb V7 V7b V7c Ic Ib I'
  , pick: '0121'
  , chord_separation: 0
  , gain: .5

  player.progression 'I IV V ii V7 I'
  , chord_separation: .5
  , gain: .5

t4 = ->
  for track_number in [0...5]
    break unless track_number == 0
    chord = ['C4', 'G4', 'D5', 'F5', 'E6'][track_number]
    player.with_track (t) ->
      # player.rest track_number * 5
      gain = 1
      tempo = 5
      for i in [1..100]
        player.note chord, gain: gain, start: Math.pow(1 + .1, i)
        # player.rest 1 * tempo
        tempo *= .9
        # gain *= .9

@play = ->
  player.rewind()
  t1()

# Meteor.startup ->
#   player.onload ->
#     t3()

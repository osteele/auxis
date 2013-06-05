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

Template.hello.events
  'click input': () ->
    player.rewind()
    t3()

Meteor.startup ->
  player.onload ->
    t3()

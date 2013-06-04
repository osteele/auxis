player = @Player

@playAll = ->
  player.note 'c4'
  player.note 'e4', when: 1/2
  player.note 'g4', when: 1

  player.note 'c4', when: 2, gain: 0.2
  player.note 'e4', when: 2.5, gain: 0.2
  player.note 'g4', when: 3, gain: 0.2

Meteor.startup ->
  @playAll()

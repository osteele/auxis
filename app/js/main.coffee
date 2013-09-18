Player = require './player.coffee'

InspectingPlayer =
  description: (playFunction) ->
    @segments = []
    playFunction(@)
    @segments.map((s) => @["#{s.type}Description"](s)).join(' ').replace(/,?-,?/g, '-')

  noteDescription: ({type, note, options}) ->
    note
  chordDescription: ({type, chord, options}) ->
    chord
  restDescription: ({type, options}) ->
    '-'
  progressionDescription: ({progression, options}) ->
    progression

  note: (note, options) -> @segments.push {type: 'note', note, options}
  rest: (rest, options) -> @segments.push {type: 'rest', options}
  chord: (chord, options) -> @segments.push {type: 'chord', chord, options}
  progression: (progression, options) -> @segments.push {type: 'progression', progression, options}

Pieces = []

piece = (name, playFunction) ->
  Pieces.push {name, playFunction}

piece 'Single notes', (player) ->
  player.note 'c4'
  player.note 'e4', start: 1/2
  player.note 'g4', start: 1

  player.note 'c4', start: 2, gain: 0.2
  player.note 'e4', start: 2.5, gain: 0.2
  player.note 'g4', start: 3, gain: 0.2

piece 'Arpeggiated chords', (player) ->
  player.chord 'C4', pick: '0121212'
  player.rest 2
  player.chord 'F4', pick: '0121212'
  player.rest 2
  player.chord 'G4', pick: '2101210'
  player.rest 2
  player.chord 'C4', pick: '1202120', duration: 10

piece 'Chord progression', (player) ->
  player.progression 'I Ib Ic ii IV iii IVb V7 V7b V7c Ic Ib I'
  , pick: '0121'
  , chord_separation: 0
  , gain: .5

  player.progression 'I IV V ii V7 I'
  , chord_separation: .5
  , gain: .5

app = angular.module 'Player', []

app.controller 'Player', ($scope) ->
  piece.description = InspectingPlayer.description(piece.playFunction) for piece in Pieces
  $scope.pieces = Pieces
  $scope.playing = false
  player = new Player
  player.promise.progress ({type}) -> $scope.$apply -> $scope.playing = false

  $scope.play = (piece) ->
    $scope.playing = true
    player.rewind()
    piece.playFunction(player)

var app, piece, pieces, player;

player = this.Player;

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

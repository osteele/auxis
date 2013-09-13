var player, t1, t2, t3, t4;

player = this.Player;

t1 = function() {
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
};

t2 = function() {
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
};

t3 = function() {
  player.progression('I Ib Ic ii IV iii IVb V7 V7b V7c Ic Ib I', {
    pick: '0121',
    chord_separation: 0,
    gain: .5
  });
  return player.progression('I IV V ii V7 I', {
    chord_separation: .5,
    gain: .5
  });
};

t4 = function() {
  var chord, track_number, _i, _results;
  _results = [];
  for (track_number = _i = 0; _i < 5; track_number = ++_i) {
    if (track_number !== 0) {
      break;
    }
    chord = ['C4', 'G4', 'D5', 'F5', 'E6'][track_number];
    _results.push(player.with_track(function(t) {
      var gain, i, tempo, _j, _results1;
      gain = 1;
      tempo = 5;
      _results1 = [];
      for (i = _j = 1; _j <= 100; i = ++_j) {
        player.note(chord, {
          gain: gain,
          start: Math.pow(1 + .1, i)
        });
        _results1.push(tempo *= .9);
      }
      return _results1;
    }));
  }
  return _results;
};

this.play = function() {
  player.rewind();
  return t1();
};

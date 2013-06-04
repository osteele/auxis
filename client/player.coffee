{PitchClassNames, find_chord, midi2name, name2midi} = Theory = @Theory

window.AudioContext ||= window.webkitAudioContext
context = new window.AudioContext

SampleNotes = ['B0'].concat ("D#{n}" for n in [0..8])
NoteBuffers = {}
LoadingCallbacks = {}

Delay = 0

loadAndPlay = (note, cb) ->
  return cb buffer if buffer = NoteBuffers[note]
  LoadingCallbacks[note] ||= []
  LoadingCallbacks[note].push cb
  return if LoadingCallbacks[note].length > 1
  url = "/piano/med/#{note.toUpperCase()}.mp3"
  request = new XMLHttpRequest
  request.open 'GET', url, true
  request.responseType = 'arraybuffer'
  request.onload = () ->
    context.decodeAudioData request.response, (buffer) ->
      NoteBuffers[note] = buffer
      cb buffer for cb in LoadingCallbacks[note]
      delete LoadingCallbacks[note]
    , (e) -> console.error 'error loading', url if (e)
  request.send()

loadAndPlay(note, ->) for note in SampleNotes

note = (note, options={}) ->
  options = _.extend {gain: 1, duration: 3}, options
  startTime = context.currentTime + Delay + (options.start or 0)
  bend = options.bend or 0
  {duration} = options
  duration = .5 if options.staccato
  note = note.toUpperCase()
  unless note in SampleNotes
    base = _.select(SampleNotes, (c) -> name2midi(c) <= name2midi(note)).reverse()[0]
    bend += name2midi(note) - name2midi(base)
    note = base
  loadAndPlay note, (buffer) ->
    sourceNode = context.createBufferSource()
    sourceNode.buffer = buffer
    # TODO different tuning
    sourceNode.playbackRate.value = Math.pow(2, bend / 12) if bend
    # sourceNode.playbackRate.linearRampToValueAtTime 10, startTime + 1
    output = sourceNode
    if options.gain or duration
      gainNode = context.createGain()
      gainNode.gain.value = options.gain
      gainNode.gain.linearRampToValueAtTime 0, startTime + duration
      sourceNode.connect gainNode
      gainNode.connect context.destination
      output = gainNode
    output.connect context.destination
    sourceNode.start startTime

chord = (chord, options={}) ->
  chord = find_chord chord
  start = options.start or 0
  if options.pick
    for n in options.pick
      note chord.notes[Number(n)], _.extend({}, options, {start})
      start += options.arpeggio or .25
    return
  for n, i in chord.notes
    note n, _.extend({}, options, {start})
    start += options.arpeggio or 0

progression = (chords, options={}) ->
  chords = Theory.progression (options.root or 'C4'), chords if typeof chords == 'string'
  for chord in chords
    player.chord chord, options
    dur = options.pick.length * options.arpeggio
    player.rest dur

rest = (r) -> Delay += r

@Player = player = {
  note
  chord
  progression
  rest
}

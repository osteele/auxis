{PitchClassNames, find_chord, midi2name, name2midi} = Theory = @Theory

window.AudioContext ||= window.webkitAudioContext
context = new window.AudioContext

SampleNotes = ['B0'].concat ("C#{n}" for n in [1..8])
NoteBuffers = {}
LoadingCallbacks = {}

TimeOffset = 0

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
    , (e) -> console.error 'error loading', url
  request.send()


SampleNotesLoaded = false
PlayOnLoad = []

do ->
  countdown = SampleNotes.length
  for note in SampleNotes
    loadAndPlay note, ->
      return if SampleNotesLoaded
      countdown -= 1
      SampleNotesLoaded ||= countdown == 0
      return unless SampleNotesLoaded
      TimeOffset = context.currentTime
      fn() for fn in PlayOnLoad
      PlayOnLoad = null

onload = (fn) ->
  return fn() if SampleNotesLoaded
  PlayOnLoad.push fn

note = (note, options={}) ->
  options = _.extend {gain: 1, duration: 3}, options
  startTime = TimeOffset + (options.start or 0)
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
      start += options.note_separation or .25
    return
  for n, i in chord.notes
    note n, _.extend({}, options, {start})
    start += options.note_separation if options.arpeggiate

progression = (chords, options={}) ->
  options = _.extend {root: 'C4', note_separation: .2, chord_separation: .2}, options
  chords = Theory.progression options.root, chords if typeof chords == 'string'
  for chord in chords
    player.chord chord, options
    dur = options.pick?.length * options.note_separation or 0
    dur += options.chord_separation
    player.rest dur

rewind = ->
  TimeOffset = context.currentTime

rest = (t) ->
  TimeOffset += t

@Player = player = {
  note
  chord
  progression
  rest
  rewind
  onload
}

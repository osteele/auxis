Theory = require './theory.coffee'
{PitchClassNames, find_chord, midi2name, name2midi} = Theory

# PianoSampleURLBase = "/media/piano/med/"
PianoSampleURLBase = "https://s3.amazonaws.com/assets.osteele.com/audio/piano/med/"

window.AudioContext ?= window.webkitAudioContext

SampleManager =
  sampleNotes: ['B0'].concat ("C#{n}" for n in [1..8])
  noteBuffers: {}
  loadingCallbacks: {}
  sampleNotesLoaded: false
  playOnLoad: []

  withNoteBuffer: (note, cb) ->
    return cb(buffer) if buffer = @noteBuffers[note]
    @loadingCallbacks[note] ||= []
    @loadingCallbacks[note].push cb
    return if @loadingCallbacks[note].length > 1
    url = "#{PianoSampleURLBase}#{note.toLowerCase()}.mp3"
    request = new XMLHttpRequest
    request.open 'GET', url, true
    request.responseType = 'arraybuffer'
    request.onload = =>
      @noteBuffers[note] = buffer = request.response
      cb(buffer) for cb in @loadingCallbacks[note]
      delete @loadingCallbacks[note]
    request.send()

  load: ->
    countdown = @sampleNotes.length
    for note in @sampleNotes
      @withNoteBuffer note, =>
        return if @sampleNotesLoaded
        countdown -= 1
        @sampleNotesLoaded ||= countdown == 0
        return unless @sampleNotesLoaded
        fn() for fn in @playOnLoad
        playOnLoad = null

  onload: (cb) ->
    return window.setTimeout(cb, 1) if @sampleNotesLoaded
    @playOnLoad.push cb

Player =
  audioContext: null
  playheadTime: 0
  loadingCallbacks: {}
  noteBuffers: {}

  init: ->
    @audioContext = new window.AudioContext
    SampleManager.sampleNotes.map (note) =>
      @withNoteBuffer note, ->
    SampleManager.onload =>
      @playheadTime = @audioContext.currentTime

  withNoteBuffer: (note, cb) ->
    return cb(buffer) if buffer = @noteBuffers[note]
    @loadingCallbacks[note] ||= []
    @loadingCallbacks[note].push cb
    return if @loadingCallbacks[note].length > 1
    SampleManager.withNoteBuffer note, (arrayBuffer) =>
      @audioContext.decodeAudioData arrayBuffer, (buffer) =>
        @noteBuffers[note] = buffer
        cb(buffer) for cb in @loadingCallbacks[note]
        delete @loadingCallbacks[note]
      , (e) -> console.error 'error decoding', note

  note: (note, options={}) ->
    options = _.extend {gain: 1, duration: 3}, options
    startTime = @playheadTime + (options.start or 0)
    bend = options.bend or 0
    {duration} = options
    duration = .5 if options.staccato
    note = note.toUpperCase()
    unless note in SampleManager.sampleNotes
      base = _.select(SampleManager.sampleNotes, (c) -> name2midi(c) <= name2midi(note)).reverse()[0]
      bend += name2midi(note) - name2midi(base)
      note = base
    @withNoteBuffer note, (buffer) =>
      sourceNode = @audioContext.createBufferSource()
      sourceNode.buffer = buffer
      # TODO different tuning
      sourceNode.playbackRate.value = Math.pow(2, bend / 12) if bend
      # sourceNode.playbackRate.linearRampToValueAtTime 10, startTime + 1
      output = sourceNode
      if options.gain or duration
        gainNode = @audioContext.createGain()
        gainNode.gain.value = options.gain
        gainNode.gain.linearRampToValueAtTime 0, startTime + duration
        sourceNode.connect gainNode
        gainNode.connect @audioContext.destination
        output = gainNode
      output.connect @audioContext.destination
      sourceNode.start startTime

  chord: (chord, options={}) ->
    chord = find_chord chord
    start = options.start or 0
    if options.pick
      for n in options.pick
        @note chord.notes[Number(n)], _.extend({}, options, {start})
        start += options.note_separation or .25
    else
      for n, i in chord.notes
        @note n, _.extend({}, options, {start})
        start += options.note_separation if options.arpeggiate

  progression: (chords, options={}) ->
    options = _.extend {root: 'C4', note_separation: .2, chord_separation: .2}, options
    chords = Theory.progression options.root, chords if typeof chords == 'string'
    for chord in chords
      @chord chord, options
      dur = options.pick?.length * options.note_separation or 0
      dur += options.chord_separation
      @rest dur

  rewind: ->
    @playheadTime = @audioContext.currentTime

  rest: (t) ->
    @playheadTime += t

  withTrack: (fn) ->
    savedPlayheadTime = @playheadTime
    try
      fn()
    finally
      @playheadTime = savedPlayheadTime

SampleManager.load()
Player.init()

module.exports = {
  note: (args...) -> Player.note(args...)
  chord: (args...) -> Player.chord(args...)
  progression: (args...) -> Player.progression(args...)
  rest: (args...) -> Player.rest(args...)
  rewind: (args...) -> Player.rewind(args...)
  # onload
  # with_track
}

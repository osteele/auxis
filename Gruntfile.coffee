module.exports = (grunt) ->
  grunt.initConfig
    directories:
      build: '<%= directories.dev %>'
      dev: 'build'
      release: 'release'
      ':release':
        build: '<%= directories.release %>'

    browserify:
      app:
        files: ['<%= directories.build %>/js/player.js': 'app/**/*.coffee']
        options:
          transform: ['coffeeify']
          debug: true
          fast: true
          ':release':
            debug: false

    clean:
      dev: '<%= directories.dev %>'
      target: '<%= directories.build %>/*'
      release: '<%= directories.release %>/*'

    coffeelint:
      app: ['Gruntfile.coffee', 'app/**/*.coffee']
      options:
        max_line_length: { value: 120 }

    connect:
      server:
        options:
          base: '<%= directories.build %>'

    copy:
      app:
        expand: true
        cwd: 'app'
        dest: '<%= directories.build %>'
        src: ['**/*', '!**/*.coffee', '!**/*.jade', '!**/*.scss']
        filter: 'isFile'

    githubPages:
      target:
        src: '<%= directories.release %>'

    jade:
      app:
        expand: true
        cwd: 'app'
        src: '**/*.jade'
        dest: '<%= directories.build %>'
        ext: '.html'
      options:
        pretty: true
        ':release':
          pretty: false

    peg:
      music:
        grammar: 'grammars/music.peg'
        outputFile: 'meteor/lib/music-parser.js'
        exportVar: "MusicParser"

    shell:
      play:
        command: 'coffee ./bin/midi-api-play.coffee'
        options:
          stdout: true
          stderr: true

    watch:
      options:
        livereload: true
      jade:
        files: 'app/**/*.jade'
        tasks: ['jade']
      play:
        files: 'midi-api-play.coffee'
        tasks: ['shell:play']
        options:
          nospawn: true
      peg:
        files: 'grammars/music.peg'
        tasks: ['peg:music']
      scripts:
        files: 'app/**/*.coffee'
        tasks: ['browserify']

  require('load-grunt-tasks')(grunt)

  grunt.registerTask 'context', (contextName) ->
    contextKey = ":#{contextName}"
    installContexts = (obj) ->
      recursiveMerge obj, obj[contextKey] if contextKey of obj
      for k, v of obj
        installContexts v if typeof v == 'object' and not k.match(/^:/)
    recursiveMerge = (target, source) ->
      for k, v of source
        if k of target and typeof v == 'object'
          recursiveMerge target[k], v
        else
          target[k] = v
    installContexts grunt.config.data
    return

  grunt.registerTask 'build', ['clean:target', 'browserify', 'copy', 'jade']
  grunt.registerTask 'build:release', ['context:release', 'build']
  grunt.registerTask 'deploy', ['build:release', 'githubPages:target']
  grunt.registerTask 'default', ['build', 'connect', 'watch']

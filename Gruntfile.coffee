module.exports = (grunt) ->
  grunt.initConfig
    directories:
      dev: 'build'
      release: 'release'
      build: '<%= directories.dev %>'
      build$release: '<%= directories.release %>'

    browserify:
      app:
        files: ['<%= directories.build %>/js/player.js': 'app/**/*.coffee']
        options:
          transform: ['coffeeify']
          debug: true
          debug$release: false
          fast: true

    clean:
      dev: '<%= directories.dev %>'
      target: '<%= directories.build %>/*'
      release: '<%= directories.release %>/*'

    coffeelint:
      app: 'app/**/*.coffee'
      gruntfile: 'Gruntfile.coffee'
      options: max_line_length: { value: 120 }

    connect:
      server: options: base: '<%= directories.build %>'

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
        pretty$release: false

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

    update:
      targets: ['browserify', 'copy', 'jade']

    watch:
      options:
        livereload: true
      copy: {}
      jade: {}
      # play:
      #   files: 'midi-api-play.coffee'
      #   tasks: ['shell:play']
      #   options:
      #     nospawn: true
      peg:
        tasks: ['peg:music']
        files: 'grammars/music.peg'
      browserify:
        files: ['app/**/*.coffee', 'node_modules/schoen/dist/**/*.{js,coffee}']

  require('load-grunt-tasks')(grunt)

  grunt.registerTask 'build', ['clean:target', 'browserify', 'copy', 'jade']
  grunt.registerTask 'build:release', ['contextualize:release', 'build']
  grunt.registerTask 'deploy', ['build:release', 'githubPages:target']
  grunt.registerTask 'default', ['update', 'connect', 'autowatch']

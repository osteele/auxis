module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')
    browserify:
      debug:
        files: [{src: 'app/**/*.coffee', dest:'build/js/player.js'}]
        options:
          transform: ['coffeeify']
          debug: true
          fast: true
      release:
        files: [{src: 'app/**/*.coffee', dest:'release/js/player.js'}]
        options:
          transform: ['coffeeify']
          fast: true
    clean:
      debug: 'build'
      release: 'release/*'
    coffeelint:
      app: ['Gruntfile.coffee', 'app/**/*.coffee']
      options:
        max_line_length: { value: 120 }
    connect:
      server:
        options:
          base: 'build'
    copy:
      debug:
        expand: true
        cwd: 'app'
        dest: 'build'
        src: ['**/*', '!**/*.coffee', '!**/*.jade', '!**/*.scss']
        filter: 'isFile'
      release:
        expand: true
        cwd: 'app'
        dest: 'release'
        src: ['**/*', '!**/*.coffee', '!**/*.jade', '!**/*.scss']
        filter: 'isFile'
    githubPages:
      target:
        src: 'release'
    jade:
      debug:
        expand: true
        cwd: 'app'
        src: '**/*.jade'
        dest: 'build'
        ext: '.html'
        options:
          pretty: true
      release:
        expand: true
        cwd: 'app'
        src: '**/*.jade'
        dest: 'release'
        ext: '.html'
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
        files: ['app/**/*.jade']
        tasks: ['jade:debug']
      play:
        files: ['midi-api-play.coffee']
        tasks: ['shell:play']
        options:
          nospawn: true
      peg:
        files: ['grammars/music.peg']
        tasks: ['peg:music']
      scripts:
        files: ['app/**/*.coffee']
        tasks: ['browserify:debug']

  grunt.loadNpmTasks 'grunt-browserify'
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-github-pages'
  grunt.loadNpmTasks 'grunt-peg'
  grunt.loadNpmTasks 'grunt-shell'
  grunt.loadNpmTasks 'grunt-notify'

  grunt.registerTask 'build', ['clean:debug', 'browserify:debug', 'copy:debug', 'jade:debug']
  grunt.registerTask 'build:release', ['clean:release', 'browserify:release', 'copy:release', 'jade:release']
  grunt.registerTask 'deploy', ['build:release', 'githubPages:target']
  grunt.registerTask 'default', ['build', 'connect', 'watch']

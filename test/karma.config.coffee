module.exports = (config) ->
  config.set
    # base path, that will be used to resolve files and exclude
    basePath: '..'
    
    # testing framework to use (jasmine/mocha/qunit/...)
    frameworks: ['mocha', 'chai-sinon', 'browserify']
    
    # client options
    client:
      mocha:
        ui: 'bdd'
    
    # see https://github.com/cjohansen/karma-browserifast
    preprocessors:
      "/**/*.browserify": ["browserify"]
    
    browserify:
      extensions: ['.coffee']
      transform: ['coffeeify', 'deamdify', 'debowerify']
      watch: true # Watches dependencies only (Karma watches the tests)
      debug: true # Adds source maps to bundle
      files: [
        'src/scripts/**/*.coffee'
        'test/spec/**/*_spec.+(coffee|js)'
      ]
    
    # Files that are to be loaded as globals
    files: []
    
    # list of files / patterns to exclude
    exclude: []
    
    # test results reporter to use
    # possible values: 'dots', 'progress', 'junit', 'growl', 'coverage'
    reporters: ['progress']
    colors: true
    
    # web server port
    port: 9876
    
    # cli runner port
    runnerPort: 9100
    
    # level of logging
    # possible values: LOG_DISABLE || LOG_ERROR || LOG_WARN || LOG_INFO || LOG_DEBUG
    logLevel: config.LOG_INFO
    
    # watch files and execute tests on changes
    autoWatch: true
    
    # Start these browsers:
    # - Chrome
    # - ChromeCanary
    # - Firefox
    # - Opera
    # - Safari
    # - PhantomJS
    browsers: ['PhantomJS']
    
    # Continuous Integration mode
    # if true, it capture browsers, run tests and exit
    singleRun: false
    captureTimeout: 60000

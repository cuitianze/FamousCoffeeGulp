'use strict'
# node modules
path         = require 'path'
browserify   = require 'browserify'
source       = require 'vinyl-source-stream'

# gulp modules - keep it obvious and avoid auto loading plugins
gulp         = require 'gulp'
autoprefix   = require 'gulp-autoprefixer'
clean        = require 'gulp-clean'
concat       = require 'gulp-concat'
connect      = require 'gulp-connect'
cssmin       = require 'gulp-cssmin'
plumber      = require 'gulp-plumber'
sass         = require 'gulp-sass'
util         = require 'gulp-util'

# watch      = require 'gulp-watch'
# cache      = require 'gulp-cache'
# changed    = require 'gulp-changed'
# gp         = (require 'gulp-load-plugins') lazy: false


###############################################
# configuration options to change
config =
  src   : 'src'            # main path for all source files
  dest  : 'www'            # output path for all deployable files
  debug : true             # include source maps
  port  : 9000             # dev server port
  reload: true             # enable livereload
  env   : 'dev'            # when not set to dev js and css will be compressed

config.scripts =
  src: [                   # js/coffeescript source paths
    "./#{config.src}/scripts/main.coffee"
  ]
  dest: 'js'               # output path
  filename: 'main.js'      # output filename

config.styles =
  src: [                   # js/coffeescript source paths
    "#{config.src}/styles/*.scss"
  ]
  dest: 'css'              # output path
  filename: 'main.css'     # output filename
#
###############################################



# main html pages
gulp.task 'html', ->
  gulp.src "#{config.src}/*.html"
    .pipe plumber()
    .pipe gulp.dest config.dest


# javascripts and coffeescripts
gulp.task 'scripts', ->
  task = browserify
      entries: config.scripts.src
      extensions: ['.coffee', '.js']
    .transform 'coffeeify'
    .transform 'deamdify'
    .transform 'debowerify'
    
  if config.env != 'dev'
    task = task.transform 'uglifyify'
  
  task.bundle(debug: config.debug)
    # Pass desired file name to browserify with vinyl
    .pipe source config.scripts.filename
    .pipe gulp.dest "#{config.dest}/#{config.scripts.dest}"


# css and sass style sheets
gulp.task 'styles', ->
  task = gulp.src config.styles.src
    .pipe plumber()
    .pipe sass(
        errLogToConsole: true
        sourceComments: (if config.debug then 'map' else false)
        includePaths: ["#{config.src}/bower_components", '.']
      )
    .pipe concat(config.styles.filename)
    .pipe autoprefix(['last 1 version', 'iOS 6'], map: config.debug, from: config.styles.filename, to: config.styles.filename, cascade: true)
  
  if config.env != 'dev'
    task = task.pipe cssmin()
  
  task.pipe gulp.dest "#{config.dest}/#{config.styles.dest}"


# main tasks
gulp.task 'main', ['clean'], -> gulp.start 'build'

gulp.task 'clean', ->
  gulp.src config.dest, read: false
    .pipe clean(force: true)

gulp.task 'build', ['html', 'scripts', 'styles']

gulp.task 'dist', ['clean'], ->
  config.debug = false
  gulp.start 'build'


# development server
gulp.task 'default', ['watch']

gulp.task 'watch', ['connect'], ->
  gulp.watch "#{config.src}/**/*", read: false, (event) ->
    ext = path.extname event.path
    taskname = null
    reloadasset = null
    
    switch ext
      when '.html', '.md', '.svg'
        taskname = 'html'
        reloadasset = "#{config.dest}/#{path.basename event.path}"
      
      when '.sass', '.css', '.scss'
        taskname = 'styles'
        reloadasset = "#{config.dest}/#{config.styles.dest}/#{config.styles.filename}"
      
      when '.coffee', '.js'
        taskname = 'scripts'
        reloadasset = "#{config.dest}/#{config.scripts.dest}/#{config.scripts.filename}"
      # else
      #   taskname = 'img'
      #   reloadasset = "#{config.dest}/images/#{path.basename event.path}"
    
    if taskname && config.reload
      gulp.task 'reload', [taskname], ->
        gulp.src reloadasset
          .pipe connect.reload()
      
      gulp.start 'reload'


gulp.task 'connect', ['main'], ->
  connect.server
    root: config.dest
    port: config.port
    livereload: config.reload


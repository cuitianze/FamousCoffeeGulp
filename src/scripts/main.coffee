'use strict'

require 'famous-polyfills/index'

# famo.us libraries
Engine  = require 'famous/core/Engine'
Surface = require 'famous/core/Surface'

# custom libraries
DummyView  = require './app/dummy'
CustomView = require './app/custom_view'

# Create the main context
mainContext = Engine.createContext()

mainContext.add new Surface
  content: 'I am a surface'
  size: [320, 240]
  align: [0.5, 0.5]
  properties:
    backgroundColor: '#9AC5B1'
    textAlign: 'center'
    color: '#FFF'
    lineHeight: '50px'

dummyView = new DummyView(content: 'Dummy view overrides MyView')
mainContext.add dummyView

customView = new CustomView()
customView.setSize([320, 240])
mainContext.add customView

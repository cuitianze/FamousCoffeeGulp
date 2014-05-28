View          = require 'famous/core/View'
Surface       = require 'famous/core/Surface'
Transform     = require('famous/core/Transform');
StateModifier = require('famous/modifiers/StateModifier')


class MyView extends View
  DEFAULT_OPTIONS:
    size: [480, 320]
    content: 'My view'
  
  constructor: (@options) ->
    @constructor.DEFAULT_OPTIONS = @DEFAULT_OPTIONS
    super @options
    
    @rootMod = new StateModifier
      size: this.options.size
      origin: [0.5, 0.5]
      transform: Transform.translate(0, 0, 0)
    
    @rootNode = @add(@rootMod)
    
    @surface = new Surface
      size: [@options.width, @options.height]
      origin: [0.5, 0.5]
      content: @options.content
      classes: ['my_view']
    
    @rootNode.add @surface
    @name = 'My View'
  
  
  moveTo: (x, y, z = 0) ->
    @rootMod.setTransform(Transform.translate(x, y, z))
  
  
  setSize: (size) ->
    @rootMod.setSize(size)
  
  
  show: ->
    @visibile = true
  
  
  hide: ->
    @visible = false
  
  
  

module.exports = MyView

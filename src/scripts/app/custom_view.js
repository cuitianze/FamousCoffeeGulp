// this uses the standard require.js module definition, 
// which is automatically removed as part of the browsification process
define(function(require, exports, module) {
  // jshint validthis:true
  'use strict';
  
  // famo.us classes
  var View          = require('famous/core/View');
  var Surface       = require('famous/core/Surface');
  var Transform     = require('famous/core/Transform');
  var StateModifier = require('famous/modifiers/StateModifier');
  
  // constructor
  function CustomView()
  {
    View.apply(this, arguments);
    
    _setupView.call(this);
    this._eventInput.pipe(this._eventOutput);
  }
  
  
  // extends famo.us View class
  CustomView.prototype = Object.create(View.prototype);
  CustomView.prototype.constructor = CustomView;
  
  
  // default options (referred to by this.options within class)
  CustomView.DEFAULT_OPTIONS = {
    size: [320, 240],
    visible: true
  };
  
  // private methods
  function _setupView() {
    // root
    this.rootMod = new StateModifier({
      size: this.options.size,
      origin: [1, 0],
      transform: Transform.translate(0, 0, 0)
    });
    this.rootNode = this.add(this.rootMod);
    
    this.surface = new Surface({
      size: [undefined, undefined],
      content: 'Custom view',
      properties: {
        backgroundColor: '#9AC2C5',
        color: '#FFF',
        textAlign: 'center',
        lineHeight: '50px'
      }
    });
    
    this.rootNode.add(this.surface);
  }
  
  
  CustomView.prototype.moveTo = function moveTo(x, y) {
    this.rootMod.setTransform(Transform.translate(x, y, 0));
  };
  
  
  CustomView.prototype.setSize = function setSize(size) {
    this.rootMod.setSize(size);
  };
  
  
  CustomView.prototype.show = function show() {
    this.visible = true;
  };
  
  
  CustomView.prototype.hide = function hide() {
    this.visible = false;
  };
  
  module.exports = CustomView;
});

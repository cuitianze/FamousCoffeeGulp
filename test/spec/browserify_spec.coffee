Dummy      = require '../../src/scripts/app/dummy'
MyView     = require '../../src/scripts/app/my_view'
CustomView = require '../../src/scripts/app/custom_view'

describe 'karma tests with browserify', ->

  it 'should load the different types of module', ->
    dummy = new Dummy(content: 'Dummy overrides MyView')
    dummy.options.content.should.equal('Dummy overrides MyView')
    
    coffeeView = new MyView()
    coffeeView.options.content.should.equal('My view')
    
    jsView = new CustomView(size: [100, 200])
    jsView.options.size[0].should.equal(100)
  

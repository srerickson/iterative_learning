'use strict'

describe 'Directive: ilSlider', ->

  # load the directive's module
  beforeEach module 'iterativeLearningApp'

  scope = {}

  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()

  it 'should make hidden element visible', inject ($compile) ->
    element = angular.element '<il-slider></il-slider>'
    element = $compile(element) scope
    # expect(element.text()).toBe 'this is the ilSlider directive'

'use strict'

###*
 # @ngdoc directive
 # @name iterativeLearningApp.directive:ilSlider
 # @description
 # # ilSlider
###

angular.module('iterativeLearningApp')
  .directive('ilSlider', ->
    restrict: 'A'
    require: 'ngModel'
    link: (scope, element, attrs, ngModel) ->

      # defaults
      options =
        orientation: "vertical"
        range: "min"
        min: 1
        max: 100

      init = ->
        angular.extend(options, scope.$eval(attrs.ilSlider) || {})
        element.slider(options)
        init = angular.noop # only once

      # Update model value from slider
      element.bind('slide', (event, ui)->
        ngModel.$setViewValue(ui.value)
        scope.$apply()
      )
      
      # Update slider from model value
      ngModel.$render = ->
        init()
        element.slider('value', ngModel.$viewValue)

  )

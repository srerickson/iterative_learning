'use strict'
angular
  .module('iterativeLearningApp')
  .controller 'TaskTestingCtrl', ($scope, $state) ->

    $scope.$parent.state = 
      name: "testing"
      step: 0
      show_feedback: false
      transitioning: false
      guess: null

    $scope.next = ()->
      # do nothing if no input
      return if $scope.state.guess == null 
      $scope.save_response()
      if $scope.state.step < $scope.task_length('testing')-1
        $scope.state.guess = null
        $scope.state.step += 1 # continue with testing 
      else
        $state.go("task.final")
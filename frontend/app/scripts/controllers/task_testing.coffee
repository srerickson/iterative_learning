'use strict'
angular
  .module('iterativeLearningApp')
  .controller 'TaskTestingCtrl', ($scope, $state) ->

    angular.merge($scope.$parent.state,
      name: "testing"
      step: 0
      show_feedback: false
      transitioning: false
      guess: null
      task_timer: false
    )

    $scope.start_task_timer()


    $scope.next = ()->
      # do nothing if no input
      return if $scope.state.guess == null 
      $scope.save_response()
      if $scope.state.step < $scope.task_length('testing')-1
        $scope.state.guess = null
        $scope.state.step += 1 # continue with testing
        $scope.start_task_timer()
      else
        $scope.next_in_sequence()
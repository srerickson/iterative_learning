'use strict'


angular.module('iterativeLearningApp')
  .controller 'TaskCtrl', ($scope, $http, $stateParams, $state, ilHost, task) ->

    # UI help texts 
    $scope.intro_text = task.frontend_config.intro_help_text

    # task state values
    $scope.state =
      name: null            # testing or training
      step: 0               # value index
      guess: null           # the value of the response for current step
      show_feedback: false  # whether feedback bar is showing

    # results go here
    responses = {
      training: []
      testing: []
    }

    # build response structure
    for phase in ['testing', 'training']
      for i in task._start_values[phase]
        responses[phase].push({
          x: i.x
          y: null
          time: null
        })

    # adds a response for the current step
    $scope.push_response = ()->
      new_response = responses[$scope.state.name][$scope.state.step]
      new_response.time = new Date().getTime()
      new_response.y = $scope.state.guess

    # x value for current step
    $scope.x = ()-> 
      try
        task._start_values[$scope.state.name][$scope.state.step].x
      catch
        null

    # y value for current step (i.e., the right answer)
    $scope.y = ()-> 
      try
        task._start_values[$scope.state.name][$scope.state.step].y
      catch
        null

    $scope.task_length = (phase)->
      task._start_values[phase].length

    # is the current y_guess correct?
    $scope.guess_is_correct = (tolerance = 5)->
      return false if $scope.state.guess == null # force slider movement
      Math.abs($scope.state.guess - $scope.y()) <= tolerance

    $scope.status_message = ->
      s_name = $scope.state.name
      "#{s_name}: step #{$scope.state.step+1} of #{$scope.task_length(s_name)} "

    $scope.submit = ()->
      if current_state == states.complete
        data = task: 
          response_values: responses
        $http.post(ilHost+"/task?key=#{$stateParams.key}", data)



angular.module('iterativeLearningApp')
  .controller 'TaskTrainingCtrl', ($scope, $state) ->

    $scope.$parent.state = 
      name: "training"
      step: 0
      show_feedback: false
      guess: null

    $scope.next = ()-> 
      # do nothing if no input 
      return if $scope.state.guess == null 
      # keep the first guess for this step
      $scope.push_response() if !$scope.state.show_feedback
      if $scope.guess_is_correct()
        if $scope.state.step < $scope.task_length('training')-1
          # continue to next training value
          $scope.state.step += 1 
          $scope.state.guess = null
          $scope.state.show_feedback = false
          $scope.state.guess = null
        else
          # transition to testing
          $state.go("task.testing")
      else
        $scope.state.show_feedback = true # show feedback




angular.module('iterativeLearningApp')
  .controller 'TaskTestingCtrl', ($scope) ->

    $scope.$parent.state = 
      name: "testing"
      step: 0
      show_feedback: false
      guess: null

    $scope.next = ()->
      # do nothing if no input
      return if $scope.state.guess == null 
      $scope.push_response()
      $scope.state.guess = null
      if $scope.state.step < $scope.task_length('testing')-1
        $scope.state.step += 1 # continue with testing 
      else
        $state.go("task.submit")




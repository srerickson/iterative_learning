'use strict'


angular.module('iterativeLearningApp')
  .controller 'TaskCtrl', ($scope, $stateParams, $state, $http, ilHost, task) ->

    # UI help texts 
    if task.frontend_config
      $scope.intro_text = task.frontend_config.intro_help_text

    # task state values
    $scope.state =
      name: null            # testing or training
      step: 0               # value index
      guess: null           # the value of the response for current step
      show_feedback: false  # whether feedback bar is showing
      transitioning: false  # transitioning b/w steps or states?

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
    $scope.save_response = ()->
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
        data = task: 
          response_values: responses
        $http.post(ilHost+"/task?key=#{$stateParams.key}", data)
          .then (ok)->
            $scope.submitted = true
          ,(err)->
            console.log err




  .controller 'TaskTrainingCtrl', ($scope, $state, $timeout) ->

    $scope.$parent.state = 
      name: "training"
      step: 0
      show_feedback: false
      transitioning: false
      guess: null

    default_message = "Adjust the vertical slider and click Next"
    correct_message = "Good!"
    wrong_message = "Adjust the slider to the correct value (indicated by the yellow bar) and click next"
    delay = 1500

    $scope.feedback_message = default_message


    $scope.next = ()-> 
      if $scope.state.guess != null and !$scope.state.transitioning
        # keep the first guess for this step
        if !$scope.state.show_feedback
          $scope.save_response() 
        # always show feedback
        $scope.state.show_feedback = true 
        if $scope.guess_is_correct()
          $scope.feedback_message = correct_message
          $scope.state.transitioning = true
          $timeout( ()->
            if $scope.state.step < $scope.task_length('training')-1
              $scope.state.step += 1 
              $scope.state.guess = null
              $scope.state.show_feedback = false
              $scope.state.transitioning = false
              $scope.feedback_message = default_message
            else
              $state.go("task.testing")
          , delay)
          return true
        else
          $scope.feedback_message = wrong_message
          return false    




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




  .controller 'TaskFinalCtrl', ($scope, $stateParams, $state, $http, ilHost) ->
    $scope.$parent.submit()




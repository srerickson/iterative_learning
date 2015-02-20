'use strict'


angular.module('iterativeLearningApp')
  .controller 'TaskCtrl', ($scope, $stateParams, $state, $http, ilHost, task) ->

    # UI help texts 
    if task.frontend_config
      $scope.messages = task.frontend_config

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

    # stuff for mturk form
    $scope.mturk = 
      submit_action: $stateParams.turkSubmitTo + "/mturk/externalSubmit"
      assignmentId: $stateParams.assignmentId

    # has the data ben submitted?
    $scope.submitted = false

    # are we on mturk? 
    $scope.task_is_mturk = ()->
      !!$stateParams.assignmentId

    # returns true if this is an MTurk task/hit and
    # the HIT is being previewed, not yet assigned
    $scope.mturk_preview = ()->
      $stateParams.assignmentId == "ASSIGNMENT_ID_NOT_AVAILABLE"


    $scope.mturk_sandbox = ()->
      /sandbox/.test($stateParams.turkSubmitTo)

    # whether the task can be done, hasn't already been done
    $scope.task_is_doable = ()->
      !!task._start_values and 
      !!task._start_values.testing and
      !!task._start_values.training and
      task.response_values == null

    # all responses collected?
    $scope.task_is_complete = (phase = null)->
      check = (_phase)-> 
        try
          # task responses present and initialized
          if responses[_phase].length != task._start_values[_phase].length
            return false
          # responses not nil
          for vals in responses[_phase]
            return false if vals.y == null
          return true
        catch 
          return false

      if !!phase
        return check(phase)
      else 
        return check('testing') and check('training')

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
      if !$scope.mturk_preview() and $scope.task_is_complete()
        data = task: 
          response_values: responses
        if !!$stateParams.workerId
          data.task.mturk_worker_id = $stateParams.workerId
        $http.post(ilHost+"/task?key=#{$stateParams.key}", data)
          .then (ok)->
            $scope.submitted = data
          ,(err)->
            console.log err

    # Initialize
    #  - build response structure
    if $scope.task_is_doable()
      for phase in ['testing', 'training']
        for i in task._start_values[phase]
          responses[phase].push({
            x: i.x
            y: null
            time: null
          })




  .controller 'TaskTrainingCtrl', ($scope, $state, $timeout) ->

    $scope.$parent.state = 
      name: "training"
      step: 0
      show_feedback: false
      transitioning: false
      guess: null
    
    # feedback delay in milliseconds
    try
      delay = $scope.messages.feedback_delay
    catch
      delay = 1500

    $scope.feedback_message = $scope.messages.next_button_help_text


    $scope.next = ()-> 
      if $scope.state.guess != null and !$scope.state.transitioning
        # keep the first guess for this step
        if !$scope.state.show_feedback
          $scope.save_response() 
        # always show feedback
        $scope.state.show_feedback = true 
        if $scope.guess_is_correct()
          $scope.feedback_message = $scope.messages.training_correct_text
          $scope.state.transitioning = true
          $timeout( ()->
            if $scope.state.step < $scope.task_length('training')-1
              $scope.state.step += 1 
              $scope.state.guess = null
              $scope.state.show_feedback = false
              $scope.state.transitioning = false
              $scope.feedback_message = $scope.messages.next_button_help_text
            else
              $state.go("task.testing_intro")
          , delay)
          return true
        else
          $scope.feedback_message = $scope.messages.training_wrong_text
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




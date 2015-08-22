'use strict'


angular.module('iterativeLearningApp')
  .controller 'TaskCtrl', ($scope, $stateParams, $state, $http, $timeout, ilHost, task) ->

    # UI defaults
    default_config =
      sequence: ['_training','_testing']
      minimum_task_time: 0
      feedback_delay: 1500
      pages: {}
      demographics: {}
      next_button_help_text: "Adjust the vertical slider and click Next"
      training_correct_text: "<b>Correct!</b>"
      training_wrong_text:   "<b>Incorrect.</b><br/>Adjust the slider to the correct value (indicated by the yellow bar) and click Next"
      final_help_text:       "Thank you for taking part."

    $scope.config = angular.merge(default_config, task.config)

    # task state values
    $scope.state =
      name: null            # testing or training
      sequence_step: -1     # index of current position in sequence
      step: 0               # value index
      guess: null           # the value of the response for current step
      show_feedback: false  # whether feedback bar is showing
      transitioning: false  # transitioning b/w steps or states?
      task_timer: false     # whether the minimum task time has elapsed


    # results go here
    responses = {
      training: []
      testing: []
    }

    $scope.demographics = {}

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

    # timer for enforcing minimum task time
    $scope.start_task_timer = ()->
      $scope.state.task_timer = true
      $timeout( ()->
        $scope.state.task_timer = false
      ,$scope.config.minimum_task_time)

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
          demographics: $scope.demographics
        if !!$stateParams.workerId
          data.task.mturk_worker_id = $stateParams.workerId
        $http.post(ilHost+"/task?key=#{$stateParams.key}", data)
          .then (ok)->
            $scope.submitted = data
          ,(err)->
            console.log err


    $scope.next_in_sequence = ()->
      $scope.state.sequence_step += 1
      step = $scope.config.sequence[$scope.state.sequence_step]
      # console.log "going to: #{step} (#{$scope.state.sequence_step})"
      if /^_.*$/.test(step)
        $state.go('task.'+ step.slice(1) )
      else if step != undefined
        $state.go('task.page',{name: step})
      else
        $state.go('task.final')


    # Initialize
    #  - build response structure
    #  - go to initial state
    if $scope.task_is_doable()
      for phase in ['testing', 'training']
        for i in task._start_values[phase]
          responses[phase].push({
            x: i.x
            y: null
            time: null
          })
    $scope.next_in_sequence()
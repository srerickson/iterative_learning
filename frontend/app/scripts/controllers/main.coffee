'use strict'

###*
 # @ngdoc function
 # @name iterativeLearningApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the iterativeLearningApp
###
angular.module('iterativeLearningApp')
  .controller 'MainCtrl', ($scope, $http, $stateParams, ilHost) ->

    task = null

    states =
      initial: 1
      training: 2 
      testing: 3
      complete: 4

    current_state = states.training

    # Counter for progress through training and testing
    $scope.step = 0
    $scope.show_feedback = false

    # where responses go 
    responses = {
      training: []
      testing: []
    }
    $scope.active_response = null

    # SETUP
    $http.get(ilHost+"/task?key=#{$stateParams.key}")
      .then (resp)->
        task = resp.data
        # build response data structure
        for i in task._start_values.training
          responses.training.push({
            x: i.x
            y: null
            time: null
          })
        for i in task._start_values.testing
          responses.testing.push({
            x: i.x
            y: null
            time: null
          }) 
      ,(err)->
        console.log err

    # x value for current step
    $scope.x = ()-> 
      try
        task._start_values[$scope.state_name()][$scope.step].x
      catch
        null

    # y value for current step (i.e., the right answer)
    $scope.y = ()-> 
      try
        task._start_values[$scope.state_name()][$scope.step].y
      catch
        null


    push_response = (val,type,step)->
      responses[type][step].time = new Date().getTime()
      responses[type][step].y = val


    # is the current y_guess correct?
    guess_is_correct = (tolerance = 5)->
      return false if $scope.active_response == null # force slider movement
      Math.abs($scope.active_response - $scope.y()) <= tolerance


    # return string representation of current state
    $scope.state_name = ->
      for k in Object.keys(states)
        return k if current_state == states[k]


    $scope.status_message = ->
      s_name = $scope.state_name()
      try
        "#{s_name}: step #{$scope.step+1} of #{task._start_values[s_name].length} "
      catch 
        ""

    ## State Transition Logic

    $scope.next = ()->
      # Initial Phase Logic 
      if current_state == states.initial
        current_state = states.training
        $scope.active_response = null

      # Training Phase Logic
      else if current_state == states.training
        # keep the first (uncorrected) guess for this step
        if !$scope.show_feedback 
          push_response($scope.active_response, 'training', $scope.step)
        if guess_is_correct()
          if $scope.step < task._start_values.training.length-1
            # continue to next training value
            $scope.step += 1 
            $scope.active_response = null
          else 
            # transition to testing phase
            $scope.step = 0
            current_state = states.testing
          # either way ...
          $scope.show_feedback = false
          $scope.active_response = null
        # wrong answer ...
        else if $scope.active_response != null  
          $scope.show_feedback = true # show feedback

      # Testing Phase Logic
      else if current_state == states.testing
        return if $scope.active_response == null # do nothing if no input
        push_response($scope.active_response,'testing',$scope.step)
        $scope.active_response = null
        if $scope.step < task._start_values.testing.length-1
          $scope.step += 1 # continue with testing 
        else
          current_state = states.complete

      # Final Phase Logic
      else if current_state == states.complete
        return
      else
        throw 'oh no, undefined state!'


    $scope.submit = ()->
      if current_state == states.complete
        data = task: 
          response_values: responses
        $http.post(ilHost+"/task?key=#{$stateParams.key}", data)





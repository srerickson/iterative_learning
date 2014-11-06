'use strict'


shuffle = (a) ->
  # From the end of the list to the beginning, pick element `i`.
  for i in [a.length-1..1]
    # Choose random element `j` to the front of `i` to swap with.
    j = Math.floor Math.random() * (i + 1)
    # Swap `j` with `i`, using destructured assignment
    [a[i], a[j]] = [a[j], a[i]]
  # Return the shuffled array.
  a

###*
 # @ngdoc function
 # @name iterativeLearningApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the iterativeLearningApp
###
angular.module('iterativeLearningApp')
  .controller 'MainCtrl', ($scope, $http, $stateParams) ->

    task = null

    states =
      initial: 1
      training: 2 
      feedback: 3
      testing: 4
      complete: 5

    current_state = states.training

    # Counter for progress through training and testing
    # last step = training.length + testing.length - 1
    $scope.step = 0
    start_test_step = 0 # first step of the testing phase
    $scope.max_steps = 0

    # where responses go 
    $scope.current_response = null
    responses = []

    # SETUP
    $http.get("/task?key=#{$stateParams.key}")
      .then (resp)->
        task = resp.data
        start_test_step = task._start_values.training.length
        $scope.max_steps = start_test_step + task._start_values.testing.length
        for i in [0..$scope.max_steps-1]
          responses.push({
            x: value_at_step(i).x
            y: null
            time: null
          }) 
      ,(err)->
        console.log err


    # return the x/y at the current step
    # accounts for training/testing split
    value_at_step = (step)->
      return {} if !task
      if step < task._start_values.training.length
        i = step
        lookup = 'training'
      else
        i = step - task._start_values.training.length
        lookup = 'testing'
      task._start_values[lookup][i]

    $scope.x = ()-> 
      try
        value_at_step($scope.step).x
      catch
        null

    $scope.y = ()-> 
      try
        value_at_step($scope.step).y
      catch
        null


    push_current_response = ()->
      responses[$scope.step].time = new Date().getTime()
      responses[$scope.step].y = $scope.current_response
      $scope.current_response = null


    # is the current y_guess correct?
    guess_is_correct = ()->
      return false if $scope.current_response == null # force slider movement
      Math.abs($scope.current_response - $scope.y()) <= 5


    # return string representation of current state
    $scope.state_name = ->
      for k in Object.keys(states)
        return k if current_state == states[k]


    # Increment step, update state depending on guess
    # FIXME
    # a little crude
    $scope.next = ()->
      return if current_state == states.complete
      if guess_is_correct()
        push_current_response()
        $scope.step += 1
        if current_state == states.feedback
          current_state = states.training 
      else # wrong answer .. 
        if current_state == states.testing
          # ...increment anways
          push_current_response()
          $scope.step += 1 
        if current_state == states.training
          # give feedback
          current_state = states.feedback

      # regardless of right or wrong ... 
      if $scope.step == start_test_step
        current_state = states.testing

      if $scope.step == $scope.max_steps
        current_state = states.complete


    $scope.submit = ()->
      if current_state == states.complete
        data = task: 
          response_values: responses
        $http.post("/task?key=#{$stateParams.key}", data)





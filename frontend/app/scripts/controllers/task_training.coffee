'use strict'
angular
  .module('iterativeLearningApp') 
  .controller 'TaskTrainingCtrl', ($scope, $state, $timeout) ->

    angular.merge($scope.$parent.state,
      name: "training"
      step: 0
      show_feedback: false
      transitioning: false
      guess: null
      task_timer: false # no task timer during training
    )

    $scope.feedback_message = $scope.config.next_button_help_text

    $scope.next = ()-> 
      if $scope.state.guess != null and !$scope.state.transitioning
        # keep the first guess for this step
        if !$scope.state.show_feedback
          $scope.save_response() 
        # always show feedback
        $scope.state.show_feedback = true 
        if $scope.guess_is_correct()
          $scope.feedback_message = $scope.config.training_correct_text
          $scope.state.transitioning = true
          $timeout( ()->
            if $scope.state.step < $scope.task_length('training')-1
              $scope.state.step += 1 
              $scope.state.guess = null
              $scope.state.show_feedback = false
              $scope.state.transitioning = false
              $scope.feedback_message = $scope.config.next_button_help_text
            else
              # $state.go("task.testing_intro")
              $scope.next_in_sequence()
          , $scope.config.feedback_delay)
          return true
        else
          $scope.feedback_message = $scope.config.training_wrong_text
          return false 
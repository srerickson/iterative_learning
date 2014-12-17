'use strict'

###*
 # @ngdoc overview
 # @name iterativeLearningApp
 # @description
 # # iterativeLearningApp
 #
 # Main module of the application.
###
angular.module('iterativeLearningApp', ['ui.router', 'ngSanitize'])

.config ($stateProvider) ->
  $stateProvider.state "task",
    url: "/task?key&assignmentId&hitId&workerId&turkSubmitTo"
    controller: "TaskCtrl"
    templateUrl: "views/task/main.html"
    resolve: 
        task: ($http, $stateParams, ilHost) ->
          $http.get(ilHost+"/task?key=#{$stateParams.key}")
            .then (resp)->
              resp.data

.config ($stateProvider) ->
  $stateProvider.state "task.training",
    url: "/training"
    controller: "TaskTrainingCtrl"
    templateUrl: "views/task/training.html"

.config ($stateProvider) ->
  $stateProvider.state "task.testing",
    url: "/testing"
    controller: "TaskTestingCtrl"
    templateUrl: "views/task/training.html"




  $stateProvider.state "experiment",
    url: "/experiment?key"
    controller: "ExperimentCtrl"
    templateUrl: "views/experiment.html"


  $stateProvider.state "experiment.results",
    url: "/viz?task_key"
    controller: "ExperimentResultsCtrl"
    templateUrl: "views/results.html"


# For production:
.constant("ilHost","")

# For development:
#.constant("ilHost","http://localhost:3000/")

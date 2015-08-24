'use strict'

###*
 # @ngdoc overview
 # @name iterativeLearningApp
 # @description
 # # iterativeLearningApp
 #
 # Main module of the application.
###
angular.module('iterativeLearningApp', ['ui.router','ngSanitize','schemaForm'])

.config ($stateProvider) ->
  $stateProvider.state "task",
    url: "/task?key&assignmentId&hitId&workerId&turkSubmitTo"
    controller: "TaskCtrl"
    templateUrl: "views/task/task.html"
    resolve: 
        task: ($http, $stateParams, ilHost) ->
          $http.get(ilHost+"/task?key=#{$stateParams.key}&workerId=#{$stateParams.workerId}")
            .then(
              (resp)->
                resp.data
              ,(err)->
                err
            )

# Task States
.config ($stateProvider) ->
  $stateProvider.state "task.demographics",
    url: "/demographics"
    controller: "TaskDemographicsCtrl"
    templateUrl: "views/task/demographics.html"

.config ($stateProvider) ->
  $stateProvider.state "task.training",
    url: "/training"
    controller: "TaskTrainingCtrl"
    templateUrl: "views/task/training.html"

.config ($stateProvider) ->
  $stateProvider.state "task.testing",
    url: "/testing"
    controller: "TaskTestingCtrl"
    templateUrl: "views/task/testing.html"

.config ($stateProvider) ->
  $stateProvider.state "task.final",
    url: "/final"
    controller: "TaskFinalCtrl"
    templateUrl: "views/task/final.html"

.config ($stateProvider) ->
  $stateProvider.state "task.page",
    url: "/page?name"
    controller: "TaskPageCtrl"
    templateUrl: "views/task/page.html"

  # Experiment Dashboard 
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

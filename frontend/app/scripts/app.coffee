'use strict'

###*
 # @ngdoc overview
 # @name iterativeLearningApp
 # @description
 # # iterativeLearningApp
 #
 # Main module of the application.
###
angular.module('iterativeLearningApp', ['ui.router'])

.config ($stateProvider) ->
  $stateProvider.state "task",
    url: "/task?key&assignmentId&hitId&workerId&turkSubmitTo"
    controller: "MainCtrl"
    templateUrl: "views/main.html"

  $stateProvider.state "experiment",
    url: "/experiment?key"
    controller: "ExperimentCtrl"
    templateUrl: "views/experiment.html"

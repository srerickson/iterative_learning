'use strict'

angular.module('iterativeLearningApp')
  .controller 'ExperimentCtrl', ($scope, $http, $stateParams) ->



    $scope.experiment = {}

    # SETUP
    $http.get("/experiment?key=#{$stateParams.key}")
      .then (resp)->
        $scope.experiment = resp.data
      ,(err)->
        console.log err



'use strict'

angular.module('iterativeLearningApp')
  .controller 'ExperimentCtrl', ($scope, $http, $stateParams, ilHost) ->



    $scope.experiment = {}

    # SETUP
    $http.get(ilHost+"/experiment?key=#{$stateParams.key}")
      .then (resp)->
        $scope.experiment = resp.data
      ,(err)->
        console.log err



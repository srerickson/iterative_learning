'use strict'
angular.module('iterativeLearningApp')
.controller('TaskPageCtrl',['$scope','$stateParams',($scope, $stateParams) ->
  $scope.page = $scope.config.pages[$stateParams.name]
])





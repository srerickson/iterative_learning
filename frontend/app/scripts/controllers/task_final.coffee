'use strict'
angular
  .module('iterativeLearningApp')
  .controller 'TaskFinalCtrl', ($scope, $stateParams, $state, $http, ilHost) ->
    $scope.$parent.state.name = 'final'
    $scope.$parent.submit()
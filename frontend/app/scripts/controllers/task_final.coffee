'use strict'
angular
  .module('iterativeLearningApp')
  .controller 'TaskFinalCtrl', ($scope, $stateParams, $state, $http, ilHost) ->
    $scope.$parent.submit()
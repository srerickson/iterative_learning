'use strict'
angular
  .module('iterativeLearningApp')
  .controller 'TaskDemographicsCtrl', ($scope, $state,ilHost) ->

    $scope.schema =
      type: "object"
      properties: $scope.$parent.config.demographics

    $scope.form = ["*",
      {
        type: "submit",
        title: "Next"
      }
    ];

    $scope.onSubmit = (form)-> 
      #First we broadcast an event so all fields validate themselves
      $scope.$broadcast('schemaFormValidate');

      #T hen we check if the form is valid
      if (form.$valid)
        $state.go('task.training')
        # ... do whatever you need to do with your data.




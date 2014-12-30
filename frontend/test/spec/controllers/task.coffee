'use strict'

describe 'Controller: TaskTrainingCtrl', ->

  # load the controller's module
  beforeEach module('iterativeLearningApp', 'mockTask')

  TaskCtrl = {}
  TrainingCtrl = {}
  scope = {}
  task = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope, mockTaskJSON) ->
    task = mockTaskJSON
    main_scope = $rootScope.$new()
    $controller 'TaskCtrl', {
      $scope: main_scope
      task: task
    }
    scope = main_scope.$new()
    TrainingCtrl = $controller 'TaskTrainingCtrl', {
      $scope: scope
    }


  it 'should set $parent.state to correct values', -> 
    expect( scope.state.name          ).toBe 'training'
    expect( scope.state.step          ).toBe 0
    expect( scope.state.show_feedback ).toBe false
    expect( scope.state.guess         ).toBe null


  it 'should proceed to testing after all responses collected', inject ($state, $timeout)->
    spyOn($state, 'go');
    for data in task._start_values.training 
      scope.state.guess = data.y
      expect( scope.guess_is_correct(0)).toBe true
      scope.next()
      $timeout.flush()
    expect($state.go).toHaveBeenCalledWith("task.testing_intro")






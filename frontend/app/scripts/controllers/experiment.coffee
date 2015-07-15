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


  .controller 'ExperimentResultsCtrl', ($scope, $http, $stateParams, ilHost) ->

    $http.get(ilHost+"/task?key=#{$stateParams.task_key}")
      .then (resp)->
        $scope.task = resp.data
      ,(err)->
        console.log err



  .directive 'ilFunctionPlot', ()->
    render = (chart,task)->
      chart.selectAll(".dot.start_vals")
        .data(task._start_values.testing)
        .enter()
          .append("circle")
          .attr("class", "dot")
          .attr("class", "start_vals")
          .attr("r", 2)
          .attr("cx", (d)-> d.x*2 )
          .attr("cy", (d)-> (100-d.y)*2 )

      if task.response_values and task.response_values.testing
        chart.selectAll(".dot.response_vals")
          .data(task.response_values.testing)
          .enter()
            .append("circle")
            .attr("class", "dot")
            .attr("class", "response_vals")
            .attr("r", 2)
            .attr("cx", (d)-> d.x*2 )
            .attr("cy", (d)-> (100-d.y)*2 )
            .attr("fill", "#F00")


    {
      link: (scope, elem, attrs)->
        chart = d3.select(elem[0]).append("svg")
        scope.$watch "task", (new_data,old_data)->
          render(chart,new_data) if new_data
      scope:
        task: "="
    }
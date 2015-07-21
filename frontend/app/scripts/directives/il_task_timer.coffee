'use strict'

###*
 # @ngdoc directive
 # @name iterativeLearningApp.directive:ilSlider
 # @description
 # # ilSlider
###

angular.module('iterativeLearningApp')
  .directive('ilTaskTimer', ->
    template:'<svg><path id="border"/><path id="loader"/></svg>'
    restrict: 'A'
    scope:
      ilTaskTimer: "="
      time: "="
    link: (scope, element, attrs) ->

      svg = element.find("svg")
      loader = element.find("#loader")
      border = element.find("#border")
      h = element.height()
      w = element.width()
      svg.attr("width",w)
      svg.attr("height",h)
      svg.attr("viewbox","0 0 #{w} #{h}")
      border.attr("transform","translate(#{w/2},#{h/2})")
      loader.attr("transform","translate(#{w/2},#{h/2}) scale(.84)")

      scope.$watch "ilTaskTimer", (timer_started)->
        start_draw() if timer_started

      start_draw = ()->
        α = 0
        π = Math.PI
        rate = 33 # draw a frame every 33 milliseconds
        draw = ()->
          t = scope.time || 0
          α += (360.0 * rate)/t
          return if α > 360 
          r = ( α * π / 180 )
          x = Math.sin( r ) * w/2
          y = Math.cos( r ) * -1 * h/2
          mid = if ( α > 180 ) then 1 else 0
          # anim = 'M 0 0 v -125 A 125 125 1 '+mid+' 1 '+x+ ' '+y+' z';
          anim = "M 0 0 v -#{w/2} A #{w/2} #{h/2} 1 #{mid} 1 #{x} #{y} z"
          border.attr( 'd', anim );
          loader.attr( 'd', anim );
          setTimeout(draw, rate)
        draw()





  )

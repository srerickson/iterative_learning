(function(){"use strict";angular.module("iterativeLearningApp",["ui.router","ngSanitize"]).config(["$stateProvider",function(a){return a.state("task",{url:"/task?key&assignmentId&hitId&workerId&turkSubmitTo",controller:"TaskCtrl",templateUrl:"views/task/intro.html",resolve:{task:["$http","$stateParams","ilHost",function(a,b,c){return a.get(c+("/task?key="+b.key)).then(function(a){return a.data})}]}})}]).config(["$stateProvider",function(a){return a.state("task.training",{url:"/training",controller:"TaskTrainingCtrl",templateUrl:"views/task/training.html"})}]).config(["$stateProvider",function(a){return a.state("task.testing_intro",{url:"/testing_intro",templateUrl:"views/task/testing_intro.html"})}]).config(["$stateProvider",function(a){return a.state("task.testing",{url:"/testing",controller:"TaskTestingCtrl",templateUrl:"views/task/testing.html"})}]).config(["$stateProvider",function(a){return a.state("task.final",{url:"/final",controller:"TaskFinalCtrl",templateUrl:"views/task/final.html"}),a.state("experiment",{url:"/experiment?key",controller:"ExperimentCtrl",templateUrl:"views/experiment.html"}),a.state("experiment.results",{url:"/viz?task_key",controller:"ExperimentResultsCtrl",templateUrl:"views/results.html"})}]).constant("ilHost","")}).call(this),function(){"use strict";angular.module("iterativeLearningApp").controller("TaskCtrl",["$scope","$stateParams","$state","$http","ilHost","task",function(a,b,c,d,e,f){var g,h,i,j,k,l,m,n,o;if(f.frontend_config&&(a.messages=f.frontend_config),a.state={name:null,step:0,guess:null,show_feedback:!1,transitioning:!1},i={training:[],testing:[]},a.mturk_preview=function(){return"ASSIGNMENT_ID_NOT_AVAILABLE"===b.assignmentId},a.task_is_doable=function(){return!!f._start_values.testing&&!!f._start_values.training&&null===f.response_values},a.task_is_complete=function(a){var b;return null==a&&(a=null),b=function(a){var b,c,d,e,f;for(b=!0,f=i[a],d=0,e=f.length;e>d;d++)if(c=f[d],null===c.y){b=!1;break}return b},a?b(a):b("testing")&&b("training")},a.task_is_doable())for(n=["testing","training"],j=0,l=n.length;l>j;j++)for(h=n[j],o=f._start_values[h],k=0,m=o.length;m>k;k++)g=o[k],i[h].push({x:g.x,y:null,time:null});return a.save_response=function(){var b;return b=i[a.state.name][a.state.step],b.time=(new Date).getTime(),b.y=a.state.guess},a.x=function(){try{return f._start_values[a.state.name][a.state.step].x}catch(b){return null}},a.y=function(){try{return f._start_values[a.state.name][a.state.step].y}catch(b){return null}},a.task_length=function(a){return f._start_values[a].length},a.guess_is_correct=function(b){return null==b&&(b=5),null===a.state.guess?!1:Math.abs(a.state.guess-a.y())<=b},a.status_message=function(){var b;return b=a.state.name,""+b+": step "+(a.state.step+1)+" of "+a.task_length(b)+" "},a.submit=function(){var c;return a.task_is_complete()?(c={task:{response_values:i}},d.post(e+("/task?key="+b.key),c).then(function(){return a.submitted=!0},function(a){return console.log(a)})):void 0}}]).controller("TaskTrainingCtrl",["$scope","$state","$timeout",function(a,b,c){var d;return a.$parent.state={name:"training",step:0,show_feedback:!1,transitioning:!1,guess:null},d=1500,a.feedback_message=a.messages.next_button_help_text,a.next=function(){return null===a.state.guess||a.state.transitioning?void 0:(a.state.show_feedback||a.save_response(),a.state.show_feedback=!0,a.guess_is_correct()?(a.feedback_message=a.messages.training_correct_text,a.state.transitioning=!0,c(function(){return a.state.step<a.task_length("training")-1?(a.state.step+=1,a.state.guess=null,a.state.show_feedback=!1,a.state.transitioning=!1,a.feedback_message=a.messages.next_button_help_text):b.go("task.testing_intro")},d),!0):(a.feedback_message=a.messages.training_wrong_text,!1))}}]).controller("TaskTestingCtrl",["$scope","$state",function(a,b){return a.$parent.state={name:"testing",step:0,show_feedback:!1,transitioning:!1,guess:null},a.next=function(){return null!==a.state.guess?(a.save_response(),a.state.step<a.task_length("testing")-1?(a.state.guess=null,a.state.step+=1):b.go("task.final")):void 0}}]).controller("TaskFinalCtrl",["$scope","$stateParams","$state","$http","ilHost",function(a){return a.$parent.submit()}])}.call(this),function(){"use strict";angular.module("iterativeLearningApp").controller("ExperimentCtrl",["$scope","$http","$stateParams","ilHost",function(a,b,c,d){return a.experiment={},b.get(d+("/experiment?key="+c.key)).then(function(b){return a.experiment=b.data},function(a){return console.log(a)})}]).controller("ExperimentResultsCtrl",["$scope","$http","$stateParams","ilHost",function(a,b,c,d){return b.get(d+("/task?key="+c.task_key)).then(function(b){return a.task=b.data},function(a){return console.log(a)})}]).directive("ilFunctionPlot",function(){var a;return a=function(a,b){return a.selectAll(".dot.start_vals").data(b._start_values.testing).enter().append("circle").attr("class","dot").attr("class","start_vals").attr("r",2).attr("cx",function(a){return 2*a.x}).attr("cy",function(a){return 2*(100-a.y)}),b.response_values&&b.response_values.testing?(console.log("here"),a.selectAll(".dot.response_vals").data(b.response_values.testing).enter().append("circle").attr("class","dot").attr("class","response_vals").attr("r",2).attr("cx",function(a){return 2*a.x}).attr("cy",function(a){return 2*(100-a.y)}).attr("fill","#F00")):void 0},{link:function(b,c){var d;return d=d3.select(c[0]).append("svg"),b.$watch("task",function(b){return b?a(d,b):void 0})},scope:{task:"="}}})}.call(this),function(){"use strict";angular.module("iterativeLearningApp").directive("ilSlider",function(){return{restrict:"A",require:"ngModel",link:function(a,b,c,d){var e,f;return f={orientation:"vertical",range:"min",min:1,max:100},e=function(){return angular.extend(f,a.$eval(c.ilSlider)||{}),b.slider(f),e=angular.noop},b.bind("slide",function(b,c){return d.$setViewValue(c.value),a.$apply()}),d.$render=function(){return e(),b.slider("value",d.$viewValue)}}}})}.call(this);
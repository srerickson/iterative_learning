(function(){"use strict";angular.module("iterativeLearningApp",["ui.router","ngSanitize","schemaForm"]).config(["$stateProvider",function(a){return a.state("task",{url:"/task?key&assignmentId&hitId&workerId&turkSubmitTo",controller:"TaskCtrl",templateUrl:"views/task/intro.html",resolve:{task:["$http","$stateParams","ilHost",function(a,b,c){return a.get(c+("/task?key="+b.key+"&workerId="+b.workerId)).then(function(a){return a.data},function(a){return a})}]}})}]).config(["$stateProvider",function(a){return a.state("task.demographics",{url:"/demographics",controller:"TaskDemographicsCtrl",templateUrl:"views/task/demographics.html"})}]).config(["$stateProvider",function(a){return a.state("task.training",{url:"/training",controller:"TaskTrainingCtrl",templateUrl:"views/task/training.html"})}]).config(["$stateProvider",function(a){return a.state("task.testing_intro",{url:"/testing_intro",templateUrl:"views/task/testing_intro.html"})}]).config(["$stateProvider",function(a){return a.state("task.testing",{url:"/testing",controller:"TaskTestingCtrl",templateUrl:"views/task/testing.html"})}]).config(["$stateProvider",function(a){return a.state("task.final",{url:"/final",controller:"TaskFinalCtrl",templateUrl:"views/task/final.html"}),a.state("experiment",{url:"/experiment?key",controller:"ExperimentCtrl",templateUrl:"views/experiment.html"}),a.state("experiment.results",{url:"/viz?task_key",controller:"ExperimentResultsCtrl",templateUrl:"views/results.html"})}]).constant("ilHost","")}).call(this),function(){"use strict";angular.module("iterativeLearningApp").controller("TaskCtrl",["$scope","$stateParams","$state","$http","ilHost","task",function(a,b,c,d,e,f){var g,h,i,j,k,l,m;if(f.frontend_config&&(a.config=f.frontend_config),a.state={name:null,step:0,guess:null,show_feedback:!1,transitioning:!1},i={training:[],testing:[]},a.demographics={},a.mturk={submit_action:b.turkSubmitTo+"/mturk/externalSubmit",assignmentId:b.assignmentId},a.submitted=!1,a.task_is_mturk=function(){return!!b.assignmentId},a.mturk_preview=function(){return"ASSIGNMENT_ID_NOT_AVAILABLE"===b.assignmentId},a.mturk_sandbox=function(){return/sandbox/.test(b.turkSubmitTo)},a.task_is_doable=function(){return!!f._start_values&&!!f._start_values.testing&&!!f._start_values.training&&null===f.response_values},a.task_is_complete=function(a){var b;return null==a&&(a=null),b=function(a){var b,c,d,e;try{if(i[a].length!==f._start_values[a].length)return!1;for(e=i[a],c=0,d=e.length;d>c;c++)if(b=e[c],null===b.y)return!1;return!0}catch(g){return!1}},a?b(a):b("testing")&&b("training")},a.save_response=function(){var b;return b=i[a.state.name][a.state.step],b.time=(new Date).getTime(),b.y=a.state.guess},a.x=function(){try{return f._start_values[a.state.name][a.state.step].x}catch(b){return null}},a.y=function(){try{return f._start_values[a.state.name][a.state.step].y}catch(b){return null}},a.task_length=function(a){return f._start_values[a].length},a.guess_is_correct=function(b){return null==b&&(b=5),null===a.state.guess?!1:Math.abs(a.state.guess-a.y())<=b},a.status_message=function(){var b;return b=a.state.name,""+b+": step "+(a.state.step+1)+" of "+a.task_length(b)+" "},a.submit=function(){var c;return!a.mturk_preview()&&a.task_is_complete()?(c={task:{response_values:i,demographics:a.demographics}},b.workerId&&(c.task.mturk_worker_id=b.workerId),d.post(e+("/task?key="+b.key),c).then(function(){return a.submitted=c},function(a){return console.log(a)})):void 0},a.next=function(){try{return c.go(Object.keys(a.config.demographics).length>1?"task.demographics":"task.training")}catch(b){return c.go("task.training")}},a.task_is_doable()){for(l=["testing","training"],m=[],j=0,k=l.length;k>j;j++)h=l[j],m.push(function(){var a,b,c,d;for(c=f._start_values[h],d=[],a=0,b=c.length;b>a;a++)g=c[a],d.push(i[h].push({x:g.x,y:null,time:null}));return d}());return m}}])}.call(this),function(){"use strict";angular.module("iterativeLearningApp").controller("TaskDemographicsCtrl",["$scope","$state","ilHost",function(a,b){return a.schema={type:"object",properties:a.$parent.config.demographics},a.form=["*",{type:"submit",title:"Next"}],a.onSubmit=function(c){return a.$broadcast("schemaFormValidate"),c.$valid?b.go("task.training"):void 0}}])}.call(this),function(){"use strict";angular.module("iterativeLearningApp").controller("TaskTestingCtrl",["$scope","$state",function(a,b){return a.$parent.state={name:"testing",step:0,show_feedback:!1,transitioning:!1,guess:null},a.next=function(){return null!==a.state.guess?(a.save_response(),a.state.step<a.task_length("testing")-1?(a.state.guess=null,a.state.step+=1):b.go("task.final")):void 0}}])}.call(this),function(){"use strict";angular.module("iterativeLearningApp").controller("TaskTrainingCtrl",["$scope","$state","$timeout",function(a,b,c){var d;a.$parent.state={name:"training",step:0,show_feedback:!1,transitioning:!1,guess:null};try{d=a.config.feedback_delay||1500}catch(e){d=1500}return a.feedback_message=a.config.next_button_help_text,a.next=function(){return null===a.state.guess||a.state.transitioning?void 0:(a.state.show_feedback||a.save_response(),a.state.show_feedback=!0,a.guess_is_correct()?(a.feedback_message=a.config.training_correct_text,a.state.transitioning=!0,c(function(){return a.state.step<a.task_length("training")-1?(a.state.step+=1,a.state.guess=null,a.state.show_feedback=!1,a.state.transitioning=!1,a.feedback_message=a.config.next_button_help_text):b.go("task.testing_intro")},d),!0):(a.feedback_message=a.config.training_wrong_text,!1))}}])}.call(this),function(){"use strict";angular.module("iterativeLearningApp").controller("TaskFinalCtrl",["$scope","$stateParams","$state","$http","ilHost",function(a){return a.$parent.submit()}])}.call(this),function(){"use strict";angular.module("iterativeLearningApp").controller("ExperimentCtrl",["$scope","$http","$stateParams","ilHost",function(a,b,c,d){return a.experiment={},b.get(d+("/experiment?key="+c.key)).then(function(b){return a.experiment=b.data},function(a){return console.log(a)})}]).controller("ExperimentResultsCtrl",["$scope","$http","$stateParams","ilHost",function(a,b,c,d){return b.get(d+("/task?key="+c.task_key)).then(function(b){return a.task=b.data},function(a){return console.log(a)})}]).directive("ilFunctionPlot",function(){var a;return a=function(a,b){return a.selectAll(".dot.start_vals").data(b._start_values.testing).enter().append("circle").attr("class","dot").attr("class","start_vals").attr("r",2).attr("cx",function(a){return 2*a.x}).attr("cy",function(a){return 2*(100-a.y)}),b.response_values&&b.response_values.testing?(console.log("here"),a.selectAll(".dot.response_vals").data(b.response_values.testing).enter().append("circle").attr("class","dot").attr("class","response_vals").attr("r",2).attr("cx",function(a){return 2*a.x}).attr("cy",function(a){return 2*(100-a.y)}).attr("fill","#F00")):void 0},{link:function(b,c){var d;return d=d3.select(c[0]).append("svg"),b.$watch("task",function(b){return b?a(d,b):void 0})},scope:{task:"="}}})}.call(this),function(){"use strict";angular.module("iterativeLearningApp").directive("ilSlider",function(){return{restrict:"A",require:"ngModel",link:function(a,b,c,d){var e,f;return f={orientation:"vertical",range:"min",min:1,max:100},e=function(){return angular.extend(f,a.$eval(c.ilSlider)||{}),b.slider(f),e=angular.noop},b.bind("slide",function(b,c){return d.$setViewValue(c.value),a.$apply()}),d.$render=function(){return e(),b.slider("value",d.$viewValue)}}}})}.call(this);
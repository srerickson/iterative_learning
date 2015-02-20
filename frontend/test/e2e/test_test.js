describe('iterative learning', function() {
  it('full run', function() {

    var request = require('sync-request');

    var resp = request('GET', 
      "http://localhost:3000/experiment?key=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHBlcmltZW50X25hbWUiOiJleGFtcGxlX2Jhc2ljIn0.X2LYqKkWFtyFOoMJ33PstxjHYDMGlLgIPf1dotnhjck")
    var experiment = JSON.parse(resp.getBody('utf8'));

    for(i in experiment.conditions){
      var condition = experiment.conditions[i]
      for(j in condition.chains){
        var chain = condition.chains[j]
        for(k in chain.generations){
          var generation = chain.generations[k]
          for(l in generation.tasks){

            var task = generation.tasks[l]
            task_url = "http://localhost:3000/#/task?key=" + task._jwt_key

            // Intro Instructions
            browser.get(task_url)
            expect(browser.getCurrentUrl()).toEqual(task_url)
            element(by.css("[ui-sref='task.training']")).click()

            // Testing Page
            expect(element(by.css('.feedback .fill')).isPresent()).toBe(true)
            browser.waitForAngular();

            for(val in task._start_values.training){

              // A guess .. 
              browser.driver.actions()
                .mouseDown(element(by.css(".ui-slider-handle")))
                .mouseMove({x:0, y: -10})
                .mouseUp()
                .perform()
              element(by.css('[ng-click="next()"]')).click()

              // check if correction is required
              element(by.css('.feedback .fill')).getSize().then(
                function(dims){
                  var y = dims.height
                  if(y > 0){ // guess was wrong, need to correct
                    browser.driver.actions()
                      .mouseDown(element(by.css(".ui-slider-handle")))
                      .mouseMove({x:0, y: y*-1})
                      .mouseUp()
                      .perform()
                    element(by.css('[ng-click="next()"]')).click()
                  }
                }, function(err){}
              )
            }

            // Training Intro
            expect(element(by.css('[ui-sref="task.testing"]')).isPresent()).toBe(true)
            element(by.css('[ui-sref="task.testing"]')).click()

            // Testing Phase
            browser.waitForAngular();
            for(val in task._start_values.testing){
              guess = Math.ceil(Math.random() * 350)
              browser.driver.actions()
                .mouseDown(element(by.css(".ui-slider-handle")))
                .mouseMove({x:0, y: guess*-1})
                .mouseUp()
                .perform()
              element(by.css('[ng-click="next()"]')).click()
            }


            // Final
            expect(element(by.css('h4')).isDisplayed()).toBeTruthy();


          }
        }
      }

    }


    // browser.get('http://localhost:3000/#/experiment?key=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHBlcmltZW50X25hbWUiOiJyb3VuZDFfZmViMjAxNSJ9.P8h4khtwcA9Yd8rLDlq8A85ZaRcnH1Pp55uw2_KjeQI');


    // var conditions = element.all(by.repeater("condition in experiment.conditions"));
    // expect(conditions.count()).toEqual(4);
    // conditions.each(function(condition){
      
    //   var chains = condition.all(by.repeater("chain in condition.chains"))
    //   expect(chains.count()).toEqual(2)
    //   chains.each(function(chain){

    //     var generations = chain.all(by.repeater("generation in chain.generations"))
    //     expect(generations.count()).toEqual(3)
    //     generations.each(function(generation){

    //       var tasks = generation.all(by.repeater("task in generation.tasks"))
    //       expect(tasks.count()).toEqual(3)

    //     })
    //   })
    // })

  });
});
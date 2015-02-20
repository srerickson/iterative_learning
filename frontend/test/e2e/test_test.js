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

        var training_length = chain.generations[0].tasks[0]._start_values.training.length
        var testing_length  = chain.generations[0].tasks[0]._start_values.testing.length

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
            browser.waitForAngular();
            expect(element(by.css('.feedback .fill')).isPresent()).toBe(true)

            for(m=0;m<training_length;++m){
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
            browser.waitForAngular();
            expect(element(by.css('[ui-sref="task.testing"]')).isPresent()).toBe(true)
            element(by.css('[ui-sref="task.testing"]')).click()

            // Testing Phase
            browser.waitForAngular();
            for(m=0;m<testing_length;++m){
              guess = Math.ceil(Math.random() * 350)
              browser.driver.actions()
                .mouseDown(element(by.css(".ui-slider-handle")))
                .mouseMove({x:0, y: guess*-1})
                .mouseUp()
                .perform()
              element(by.css('[ng-click="next()"]')).click()
              browser.sleep(300)
            }

            // Final
            expect(element(by.css('h4')).isDisplayed()).toBeTruthy();

          }
        }
      }

    }

  });
});
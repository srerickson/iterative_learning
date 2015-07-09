describe('iterative learning', function() {

  /**
   * @name waitForUrlToChangeTo
   * @description Wait until the URL changes to match a provided regex
   * @param {RegExp} urlRegex wait until the URL changes to match this regex
   * @returns {!webdriver.promise.Promise} Promise
   */
  function waitForUrlToChangeTo(urlRegex) {
    var currentUrl;
    return browser.getCurrentUrl().then(function storeCurrentUrl(url) {
      currentUrl = url;
    }
      ).then(function waitForUrlToChangeTo() {
        return browser.wait(function waitForUrlToChangeTo() {
          return browser.getCurrentUrl().then(function compareCurrentUrl(url) {
            return urlRegex.test(url);
          });
        });
      }
    );
  }


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

          (function(task){

            // var task = generation.tasks[l]
            var task_url = "http://localhost:3000/#/task?key=" + task._jwt_key
            var test_name = "completes task - cond:"+i+", chn:"+j+", gen:"+k+" ,tsk: "+l;
            // var test_name = "completes a task"

            it(test_name, function() {

              // Intro Instructions
              browser.get(task_url)
              waitForUrlToChangeTo(/task/)
              element(by.css('[ng-click="next()"]')).click()

              //demographics
              waitForUrlToChangeTo(/demographics/)
              element(by.css('#age')).sendKeys(1)
              element(by.css('option[value="Male"]')).click()
              element(by.css('input[type="submit"]')).click()

              // testing page
              waitForUrlToChangeTo(/training/)
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
              waitForUrlToChangeTo(/testing_intro/)
              element(by.css('[ui-sref="task.testing"]')).click()

              // Testing Phase
              waitForUrlToChangeTo(/testing/)
              for(m=0;m<testing_length;++m){
                guess = Math.ceil(Math.random() * 345) + 5
                browser.driver.actions()
                  .mouseDown(element(by.css(".ui-slider-handle")))
                  .mouseMove({x:0, y: guess*-1})
                  .mouseUp()
                  .perform()
                element(by.css('[ng-click="next()"]')).click()
              }

              // Final
              waitForUrlToChangeTo(/final/)
              expect(element(by.css('h4')).isDisplayed()).toBeTruthy();
            });

          })(generation.tasks[l])
 
        }
      }
    }
  }
});
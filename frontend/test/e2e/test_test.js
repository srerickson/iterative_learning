describe('iterative learning experiment admin page', function() {
  it('should load', function() {

    var request = require('sync-request');
    var resp = request('GET', 
      "http://localhost:3000/experiment?key=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHBlcmltZW50X25hbWUiOiJyb3VuZDFfZmViMjAxNSJ9.P8h4khtwcA9Yd8rLDlq8A85ZaRcnH1Pp55uw2_KjeQI")
    var experiment = JSON.parse(resp.getBody('utf8'));
    console.log(experiment);

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
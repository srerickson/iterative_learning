exports.config = {
  // seleniumAddress: 'http://localhost:4444/wd/hub',
  specs: ['e2e/*_test.js'],
  baseUrl: 'http://localhost:9001', //default test port with Yeoman
  jasmineNodeOpts: {
    onComplete: null,
    isVerbose: true,
    showColors: true,
    includeStackTrace: true,
    defaultTimeoutInterval: 360000
  }
}
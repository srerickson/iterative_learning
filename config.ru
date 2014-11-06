$:.unshift("./")

require 'environment.rb'

require 'rack/cors'

use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: [:get, :post, :put, :delete]
  end
end

use Rack::Static, urls: [
 "/scripts",
 "/styles",
 "/views"
], root: "public", index: 'index.html'

run IterativeLearning::API
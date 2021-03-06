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
  "/bower_components",
  "/scripts",
  "/styles",
  "/views",
  "/images"
], root: "frontend/dist", index: 'index.html'


run IterativeLearning::API
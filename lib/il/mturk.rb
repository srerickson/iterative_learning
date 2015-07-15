require 'mturk'
require 'digest/sha2'

module IterativeLearning
  module MTurk

    def requester(sandbox = true)
      if sandbox
        Amazon::WebServices::MechanicalTurkRequester.new :Host => :Sandbox
      else
        Amazon::WebServices::MechanicalTurkRequester.new :Host => :Production
      end
    end

    def createHIT(uri, title, desc, keywords = [], reward = 0.01, duration = 3600, lifetime = 31536000, sandbox=true)
      question = '<ExternalQuestion xmlns="http://mechanicalturk.amazonaws.com/AWSMechanicalTurkDataSchemas/2006-07-14/ExternalQuestion.xsd">'
      question += "<ExternalURL>#{uri}</ExternalURL>"
      question +=  "<FrameHeight>400</FrameHeight>"
      question += "</ExternalQuestion>"

      requester(sandbox).createHIT(
        :Title => title,
        :Description => desc,
        :MaxAssignments => 1,
        :Reward => { :Amount => reward, :CurrencyCode => 'USD' },
        :Question => question,
        :Keywords => keywords,
        :AssignmentDurationInSeconds => duration,
        :LifetimeInSeconds => lifetime,
        :RequesterAnnotation => uri,
        :UniqueRequestToken => Digest::SHA2.hexdigest(uri)
      )
    end

  end
end
require 'ruby-aws'

module IterativeLearning
  module MTurk

    def mturk_sandbox
      true
    end

    def requester
      if mturk_sandbox
        Amazon::WebServices::MechanicalTurkRequester.new :Host => :Sandbox
      else 
        Amazon::WebServices::MechanicalTurkRequester.new :Host => :Production
      end
    end

    def createHIT(uri, title, desc, keywords = [], reward = 0.01, duration = 3600, lifetime = 31536000)
      question = '<ExternalQuestion xmlns="http://mechanicalturk.amazonaws.com/AWSMechanicalTurkDataSchemas/2006-07-14/ExternalQuestion.xsd">'
      question += "<ExternalURL>#{uri}</ExternalURL>"
      question +=  "<FrameHeight>400</FrameHeight>"
      question += "</ExternalQuestion>"
      requester.createHIT(
        :Title => title,
        :Description => desc,
        :MaxAssignments => 1,
        :Reward => { :Amount => reward, :CurrencyCode => 'USD' },
        :Question => question,
        :Keywords => keywords,
        :AssignmentDurationInSeconds => duration,
        :LifetimeInSeconds => lifetime
      )
    end

  end
end
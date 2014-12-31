require 'ruby-aws'

module IterativeLearning
  module MTurk


    @question =<<EOF
    <ExternalQuestion xmlns="http://mechanicalturk.amazonaws.com/AWSMechanicalTurkDataSchemas/2006-07-14/ExternalQuestion.xsd">
      <ExternalURL></ExternalURL>
      <FrameHeight>400</FrameHeight>
    </ExternalQuestion>
EOF

    @mturk = Amazon::WebServices::MechanicalTurkRequester.new :Host => :Sandbox
    #@mturk = Amazon::WebServices::MechanicalTurkRequester.new :Host => :Production


    def self.requester
      @mturk
    end

    def self.createHIT(uri, title, desc, keywords = [], reward = 0.01)

      question = @question.sub(/<ExternalURL><\/ExternalURL>/,"<ExternalURL>#{uri}</ExternalURL>")
      # result = @mturk.createHIT( 
      @mturk.createHIT(
        :Title => title,
        :Description => desc,
        :MaxAssignments => 1,
        :Reward => { :Amount => reward, :CurrencyCode => 'USD' },
        :Question => question,
        :Keywords => keywords 
      )
      #puts "Created HIT: #{result[:HITId]}"
      #puts "HIT Location: #{getHITUrl( result[:HITTypeId] )}"
      # return result
    end


    def self.getHITUrl( hitTypeId )
      if @mturk.host =~ /sandbox/
        "http://workersandbox.mturk.com/mturk/preview?groupId=#{hitTypeId}" #Sandbox Url
      else
        "http://mturk.com/mturk/preview?groupId=#{hitTypeId}" # Production Url
      end
    end
  

  end
end
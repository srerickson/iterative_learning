require 'ruby-aws'

module IterativeLearning
  module MTurk


    @mturk = Amazon::WebServices::MechanicalTurkRequester.new :Host => :Sandbox
    #@mturk = Amazon::WebServices::MechanicalTurkRequester.new :Host => :Production


    def createNewHIT
      title = "Iterative Learning Test"
      desc = "This is test iterative learning widget"
      keywords = "iterative learning"
      numAssignments = 2
      rewardAmount = 0.01 # 5 cents
      # Define the location of the externalized question (QuestionForm) file.
      rootDir = File.dirname $0
      questionFile = rootDir + "/external.question"
      # Load the question (QuestionForm) file
      question = File.read( questionFile )
      result = @mturk.createHIT( :Title => title,
        :Description => desc,
        :MaxAssignments => numAssignments,
        :Reward => { :Amount => rewardAmount, :CurrencyCode => 'USD' },
        :Question => question,
        :Keywords => keywords 
      )
      puts "Created HIT: #{result[:HITId]}"
      puts "HIT Location: #{getHITUrl( result[:HITTypeId] )}"
      return result
    end

    def getHITUrl( hitTypeId )
      if @mturk.host =~ /sandbox/
        "http://workersandbox.mturk.com/mturk/preview?groupId=#{hitTypeId}" #Sandbox Url
      else
        "http://mturk.com/mturk/preview?groupId=#{hitTypeId}" # Production Url
      end
    end
      end
    end
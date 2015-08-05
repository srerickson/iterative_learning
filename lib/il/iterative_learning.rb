require 'mail'

module IterativeLearning

  @@FitnessFunctions = {}
  @@TaskConditions = {}

  def self.register_fitness_function(name, method)
    @@FitnessFunctions[name] = method
  end

  def self.call_fitness_function(name, values, target)
    @@FitnessFunctions[name].call(values, target)
  end

  def self.register_condition_builder(name, method )
    @@TaskConditions[name] = method
  end

  def self.build_condition(build_string, scope=nil)
    # match things like NAME(ARGS)
    if match = /^(.*)\((.*)\)$/.match(build_string)
      name = match[1]
      eval_build_string = Proc.new{|scope, expr| eval "[#{expr}]"}
      args = eval_build_string.call(scope, match[2])
    else
      name = build_string
      args = []
    end
    @@TaskConditions[name].call(*args)
  end
  
  # Partition values into training/testing sets
  def self.training_test_split(values=[], train_ratio=0.5)
    training_count = (values.length*train_ratio).floor
    {
      'training' => values.shuffle.take(training_count),
      'testing' => values.shuffle
    }
  end

  def self.send_task_notification(task)
    gen = task.generation
    chn = gen.chain
    cnd = chn.condition
    exp = cnd.experiment
    if exp.config["task_notification"].present?
      options = { :address              => "smtp.gmail.com",
                  :port                 => 587,
                  :user_name            => ENV['SMTP_USERNAME'],
                  :password             => ENV['SMTP_PASSWORD'],
                  :authentication       => 'plain',
                  :enable_starttls_auto => true  }
      Mail.defaults do
        delivery_method :smtp, options
      end
      Mail.deliver do
        to exp.config["task_notification"]
        from ENV['SMTP_USERNAME']
        subject "Iterative Learning Notification [#{exp.name}]"
        body """A task has been completed:\n
          experiment: #{exp.name}
          condition: #{cnd.position+1} (#{cnd.name})
          chain: #{chn.position+1}
          generation: #{gen.position+1}

          See full results here: #{ENV['BASE_URL']}/#/experiment/viz?task_key=#{task.jwt_key}&key=#{exp.jwt_key}
        """
      end
    end
  end


  def self.send_error_email(msg)
    if ENV["ALERT_EMAIL"].present?
      options = { :address              => "smtp.gmail.com",
                  :port                 => 587,
                  :user_name            => ENV['SMTP_USERNAME'],
                  :password             => ENV['SMTP_PASSWORD'],
                  :authentication       => 'plain',
                  :enable_starttls_auto => true  }
      Mail.defaults do
        delivery_method :smtp, options
      end
      Mail.deliver do
        to ENV["ALERT_EMAIL"]
        from ENV['SMTP_USERNAME']
        subject "Iterative Learning Application Error"
        body "host: #{ENV['BASE_URL']}\nerror: #{msg}"
      end
    end
  rescue SandardError => e
  end

end
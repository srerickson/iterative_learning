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


end
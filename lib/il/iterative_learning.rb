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

  def self.build_condition(name,num)
    @@TaskConditions[name].call(num)
  end

end
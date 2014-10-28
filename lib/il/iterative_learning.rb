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

  
  # Partition values into training/testing sets
  # QUESTION: overlap?
  def self.partition_values(values=[], train_ratio=0.5)
    shuffled = values.shuffle
    training_count = (values.length*train_ratio).floor
    {
      'training' => shuffled.take(training_count),
      'testing' => shuffled.drop(training_count)
    }
  end

  def self.departition_values(partitioned_values)
    partitioned_values['training'] + partitioned_values['testing']
  end

  def self.repartition_values(values=[], train_ratio=0.5)
    self.partition_values(
      self.departition_values(values), train_ratio
    )
  end

end
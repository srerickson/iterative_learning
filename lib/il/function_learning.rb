
module IterativeLearning

  module FunctionLearning

    def self.positive(num)
      values = []
      (1..num).each do |i|
        x = i
        y = x
        values.push({x: x, y: y})
      end
      values
    end

    def self.negative(num)
      values = []
      (1..num).each do |i|
        x = i
        y = num + 1 - i
        values.push({x: x, y: y})
      end
      values
    end

    def self.random(num)
      values = []
      (1..num).each do |i|
        x = i
        y = rand(num)+1
        values.push({x: x, y: y})
      end
      values
    end

    def self.nonlinear(num)
      values = []
      (1..num).each do |i|
        x = i
        y = (50.5 + 49.5 * Math::sin(Math::PI/2 + x/(5*Math::PI))).round
        values.push({x: x, y: y})
      end
      values
    end


    IterativeLearning.register_condition_builder('FUNC_POSITIVE', self.method(:positive))
    IterativeLearning.register_condition_builder('FUNC_NEGATIVE', self.method(:negative))
    IterativeLearning.register_condition_builder('FUNC_RANDOM', self.method(:random))
    IterativeLearning.register_condition_builder('FUNC_NONLINEAR',self.method(:nonlinear))


    def self.sum_of_error(target, trial)
      if target.length != trial.length
        raise "target and trial do not have same length"
      end
      target = IterativeLearning.departition_values(target) if target.is_a? Hash
      trial = IterativeLearning.departition_values(trial) if trial.is_a? Hash
      [target, trial].each{ |list| list.sort!{ |a,b| a[:x] <=> b[:x] }}
      err = 0
      (0..target.length-1).each do |i|
        a = target[i].with_indifferent_access
        b = trial[i].with_indifferent_access
        if (i != a[:x]-1 ) and (i != b[:x]-1)
          raise "target and trial values do not correspond"
        end
        err += (a[:y] - b[:y]).abs
      end
      err
    end

    IterativeLearning.register_fitness_function('FUNC_SUM_OF_ERR', self.method(:sum_of_error))

  end

end
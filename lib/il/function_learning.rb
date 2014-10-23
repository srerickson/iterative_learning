
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



  end

end
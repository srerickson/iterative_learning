
module IterativeLearning

  module FunctionLearning

    # utility for pulling evenly distributed subset of array elements
    class ::Array
      def spread(n)
        step = self.length.to_f / (n -1) 
        (0..(n-2)).to_a.collect{|i| self[i * step]} + [self.last]
      end
    end

    def self.positive(num=1, range=[1,num])
      values = []
      (range[0]..range[1]).each do |i|
        x = i
        y = x
        values.push({x: x, y: y})
      end
      values.spread(num)
    end

    def self.negative(num=1, range=[1,num])
      values = []
      (range[0]..range[1]).each do |i|
        x = i
        y = range[1] + 1 - i
        values.push({x: x, y: y})
      end
      values.spread(num)
    end

    def self.v_shape(num=1, range=[1,num])
      values = []
      # half = ((range[1]-range[0])/2.0).floor
      (range[0]..range[1]).each do |i|
        x = i
        y = (range[1]+1-i*2).abs
        values.push({x: x, y: y})
      end
      values.spread(num)
    end

    def self.random(num=1, range=[1,num], seed=Random.new_seed)
      values = []
      (range[0]..range[1]).each do |i|
        x = i
        y = Random.new(seed**(i+1)).rand(range[0]..range[1])
        values.push({x: x, y: y})
      end
      values.spread(num)
    end

    def self.nonlinear(num=1, range=[1,num])
      values = []
      mid = (range[1]-range[0]+1)/2.0
      (range[0]..range[1]).each do |i|
        x = i
        y = (mid+0.5 + (mid-0.5) * Math::sin(Math::PI/2 + x/(5*Math::PI))).round
        values.push({x: x, y: y})
      end
      values.spread(num)
    end


    IterativeLearning.register_condition_builder('FUNC_POSITIVE', self.method(:positive))
    IterativeLearning.register_condition_builder('FUNC_NEGATIVE', self.method(:negative))
    IterativeLearning.register_condition_builder('FUNC_RANDOM', self.method(:random))
    IterativeLearning.register_condition_builder('FUNC_VSHAPE',self.method(:v_shape))
    IterativeLearning.register_condition_builder('FUNC_NONLINEAR',self.method(:nonlinear))

    # Returns the sum of difference between test and target.
    # test & target may be either arrays of objects with 'x','y' keys
    # OR a hash with testing/training sets, which are arrays of objects with x/y keys.
    # In the latter case, only the 'test' array will be used to evaluate sum of difference. 
    #
    def self.sum_of_error(target, test)

      # may be partitioned into test/training sets 
      test = test['testing'] if test.is_a? Hash and test.has_key? 'testing'
      target = target['testing'] if target.is_a? Hash and target.has_key? 'testing'

      if target.length != test.length
        raise "target and test do not have same length"
      end

      # sort test & target by x values
      [target, test].each do |list|
        list.sort!{ |a,b| a.with_indifferent_access[:x] <=> b.with_indifferent_access[:x] }
      end

      err = 0
      (0..target.length-1).each do |i|
        a = target[i].with_indifferent_access
        b = test[i].with_indifferent_access
        if (a[:x] != b[:x])
          raise "target and test do not correspond"
        end
        err += (a[:y] - b[:y]).abs
      end
      err
    end

    IterativeLearning.register_fitness_function('FUNC_SUM_OF_ERR', self.method(:sum_of_error))

  end

end
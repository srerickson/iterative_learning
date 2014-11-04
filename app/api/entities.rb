module IterativeLearning
  module Entities

    class Task < Grape::Entity
      expose :mturk_worker_id
      expose :mturk_hit_id
      expose :worker_age
      expose :worker_gender
      expose :start_values, as: :_start_values
      expose :response_values
      expose :jwt_key, as: :_jwt_key
      expose :complete?, as: :_complete
    end

    class Generation < Grape::Entity
      expose :active?, as: :_active
      expose :complete?, as: :_complete
      expose :tasks, using: IterativeLearning::Entities::Task
    end

    class Chain < Grape::Entity
      expose :generations, using: IterativeLearning::Entities::Generation
    end

    class Condition < Grape::Entity
      expose :name
      expose :start_values
      expose :target_values
      expose :chains, using: IterativeLearning::Entities::Chain
    end

    class Experiment < Grape::Entity
      expose :name
      expose :description
      expose :jwt_key, as: :_jwt_key
      expose :chains_per_condition
      expose :generations_per_chain
      expose :tasks_per_generation
      expose :percent_test_for_training
      expose :generation_shared_values
      expose :is_mturk
      expose :mturk_title
      expose :mturk_description
      expose :mutkr_keywords
      expose :mturk_award # USD
      expose :mturk_time_to_complete
      expose :mturk_time_to_expire
      expose :mturk_qualifications
      expose :conditions, using: IterativeLearning::Entities::Condition
    end



  end
end
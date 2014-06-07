module Mongoid
  module Userstamp
    class Config
      attr_writer :user_model
      attr_accessor :user_reader
      attr_accessor :creator_field
      attr_accessor :updater_field

      def initialize(&block)
        reset!
        instance_eval(&block) if block_given?
      end

      def reset!
        @user_model = :user
        @user_reader = :current_user
        @creator_field = :creator
        @updater_field = :updater
      end

      def user_model_name
        @user_model.to_s.classify
      end

      def user_model
        @user_model.to_s.classify.constantize
      end
    end
  end
end

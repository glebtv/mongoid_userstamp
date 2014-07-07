module Mongoid
  module Userstamp
    extend ActiveSupport::Concern

    included do
      belongs_to Userstamp.config.creator_field, class_name: Userstamp.config.user_model_name
      belongs_to Userstamp.config.updater_field, class_name: Userstamp.config.user_model_name

      before_validation :set_updater
      before_validation :set_creator

      protected

      def set_updater
        return if !Userstamp.has_current_user?
        self.send("#{Userstamp.config.updater_field}=", Userstamp.current_user)
      end

      def set_creator
        return if !Userstamp.has_current_user? || self.send(Userstamp.config.creator_field)
        self.send("#{Userstamp.config.creator_field}=", Userstamp.current_user)
      end
    end

    class << self
      def config(&block)
        if block_given?
          @@config = Userstamp::Config.new(&block)
        else
          @@config ||= Userstamp::Config.new
        end
      end

      def has_current_user?
        config.user_model.respond_to?(:current)
      end

      def current_user
        config.user_model.try(:current)
      end

      def find_user(user_id)
        begin
          user_id ? Userstamp.config.user_model.unscoped.find(user_id) : nil
        rescue Mongoid::Errors::DocumentNotFound => e
          nil
        end
      end
    end
  end
end

module Mongoid
  module Userstamp
    class Railtie < Rails::Railtie
      ActiveSupport.on_load :action_controller do
        before_action do |c|
          unless Mongoid::Userstamp.config.user_model.respond_to? :current
            Mongoid::Userstamp.config.user_model.send(
              :include,
              Mongoid::Userstamp::User
            )
          end

          begin
            Mongoid::Userstamp.config.user_model.current = c.send(Mongoid::Userstamp.config.user_reader)
          rescue
          end
        end
      end
    end
  end
end

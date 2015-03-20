module Mongoid
  module Userstamp
    module User
      extend ActiveSupport::Concern

      included do
        def current?
          !RequestStore.store[:user].nil? && self._id == RequestStore.store[:user]._id
        end
      end

      module ClassMethods
        def current
          RequestStore.store[:user]
        end

        def current=(value)
          RequestStore.store[:user] = value
        end

        def do_as(user, &block)
          old = self.current

          begin
            self.current = user
            response = block.call unless block.nil?
          ensure
            self.current = old
          end

          response
        end
      end
    end
  end
end

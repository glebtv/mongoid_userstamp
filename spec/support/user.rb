# -*- encoding : utf-8 -*-
class User
  include Mongoid::Document
  include Mongoid::Userstamp::User

  field :name

  belongs_to :book, optional: true
end

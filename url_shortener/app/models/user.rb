class User < ActiveRecord::Base
  validates :email, { :presence => true, :unique => true }
end

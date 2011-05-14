# == Schema Information
# Schema version: 20110514193952
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
  attr_accessible :name, :email
  
  email_regex = /\A[\w.+\-\d]+@[\w\-\d]+\.[a-zA-Z]{2,3}\.?[a-zA-Z]{0,3}\z/i
  
  validates :name,  :presence => true, 
                    :length   => { :maximum => 50 }
  validates :email, :presence => true, 
                    :uniqueness => { :case_sensitive => false },
                    :format   => { :with => email_regex }
end
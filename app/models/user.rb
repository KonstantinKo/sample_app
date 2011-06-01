# == Schema Information
# Schema version: 20110527110513
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#  admin              :boolean
#

class User < ActiveRecord::Base
  attr_accessor     :password
  attr_accessible   :name, :email, :password, :password_confirmation
  
  has_many :microposts,    :dependent => :destroy
  has_many :relationships, :dependent => :destroy,
                           :foreign_key => "follower_id"
  has_many :reverse_relationships, :class_name => "Relationship", 
                                   :foreign_key => "followed_id",
                                   :dependent => :destroy
  has_many :following,     :through => :relationships, :source => :followed
  has_many :followers,     :through => :reverse_relationships,
                           :source  => :follower
  
  
  email_regex = /\A[\w.+\-\d]+@[\w\-\d]+\.[a-zA-Z]{2,3}\.?[a-zA-Z]{0,3}\z/i
  
  validates :name,    :presence => true, 
                      :length   => { :maximum => 50 }
  validates :email,   :presence => true, 
                      :uniqueness => { :case_sensitive => false },
                      :format   => { :with => email_regex }
  validates :password,  :presence => true,
                        :confirmation => true,
                        :length => { :within => 6..40 }
                        
  before_save :encrypt_password
  
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end
  
  def feed
    Micropost.where("user_id = ?", id)
  end
  
  def following?(followed)
    !!relationships.find_by_followed_id(followed)
  end
  
  def follow!(followed)
    relationships.create!(:followed_id => followed.id)
  end
  
  def unfollow!(followed)
    relationships.find_by_followed_id(followed).destroy
  end
  
  class << self
    def authenticate(email, submitted_password)
      user = find_by_email(email)
      # ( user && user.has_password?(submitted_password) ) ? user : nil
      return nil if user.nil?
      return user if user.has_password?(submitted_password)
    end
    
    def authenticate_with_salt(id, cookie_salt)
      user = find_by_id(id)
      (user && user.salt == cookie_salt) ? user : nil
    end
  end
  
  private
  
  def encrypt_password
    self.salt = make_salt if new_record?
    self.encrypted_password = encrypt(self.password)
  end
  
  def encrypt(string)
    secure_hash("#{salt}--#{string}")
  end
  
  def make_salt
    secure_hash("#{Time.now.utc}--#{password}")
  end
  
  def secure_hash(string)
    Digest::SHA2.hexdigest(string)
  end
end

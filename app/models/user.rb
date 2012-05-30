#encoding: utf-8
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  

  def custom_label
    if self.email.nil?
      "#{I18n.t(:new)} #{I18n.t(:user)}"
    else
      "#{I18n.t(:user)}: #{self.email}"
    end
  end 

  def account
    Account.new
  end
  
  def value
    0
  end
end

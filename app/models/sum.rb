class Sum < ActiveRecord::Base	
	attr_accessible :value

	           
  def account
    Account.new
  end
  
  def value
    0
  end
end

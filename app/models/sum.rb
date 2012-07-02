class Sum < ActiveRecord::Base	
	attr_accessible :value

	         
  def account
    @a = Account.new
    @a.operation= '+'
    return @a
  end
  
  def value
    0.0
  end
end

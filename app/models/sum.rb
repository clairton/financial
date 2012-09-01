class Sum < ActiveRecord::Base	
	attr_accessible :value
  before_create :unique_registry

	def unique_registry
    if Sum.all.size >= 1
      self.errors.add(:value, "Pode haver somente um registro em #{I18n.t(:sum)}")
      return false
    end
  end

  def custom_label
      I18n.t(:sum)
  end 

  def account
    @a = Account.new
    @a.operation= '+'
    return @a
  end
  
  def value
    0.0
  end
end

#encoding: utf-8
class Account < ActiveRecord::Base
  has_many :invoices, :inverse_of => :account
  has_many :postings, :inverse_of => :account
	#has_many :inverses, :class_name => "Account", :foreign_key => "reverse_id"
	belongs_to :reverse, :class_name => "Account", :foreign_key => "reverse_id"
	#has_many :childrens, :class_name => "Account", :foreign_key => "father_id"
	belongs_to :father, :class_name => "Account", :foreign_key => "father_id"
	
  validates_presence_of :name, :operation, :reverse
  validates_uniqueness_of :name
  validates_inclusion_of :operation, :in => ['+', '-']  
  validate :reverse_validate, :father_validate
  
  attr_accessible :name,  
                  :operation, 
                  :invoices, 
                  :postings,
                  :reverse_id,
                  :reverse,
                  :father_id,
                  :father,
                  :invoice_ids, 
                  :posting_ids,
                  :id
                  
  def reverse_validate
    if !self.reverse.nil? && Account.find(:all).size > 0
      if self.reverse.operation == self.operation
        self.errors.add(:reverse, 'conta estorno deve ter operação diferente operation(+/-)')
        return false 
      end
      if self.id == self.reverse.id
        self.errors.add(:father, 'conta estorno não pode ser ela mesma')
        return false        
      end     
    end
  end   
  
  def father_validate
    if !self.father.nil? && Account.find(:all).size > 0
      if self.father.operation != self.operation
        self.errors.add(:father, 'conta pai deve ter a mesma operation(+/-)')
        return false      
      end      
      if self.id == self.father.id
        self.errors.add(:father, 'conta pai não pode ser ela mesma')
        return false        
      end        
    end
  end  

  def custom_label
    if self.name.nil?
      "#{I18n.t(:new)} #{I18n.t(:account)}"
    else
      "#{I18n.t(:account)}: #{self.name}"
    end
  end          
                  
  def account
    Account.new
  end
  
  def value
    0
  end
end

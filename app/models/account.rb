class Account < ActiveRecord::Base
  has_many :invoices, :inverse_of => :account
  has_many :postings, :inverse_of => :account
	has_many :inverses, :class_name => "Account", :foreign_key => "reverse_id"
	belongs_to :reverse, :class_name => "Account"
	has_many :childrens, :class_name => "Account", :foreign_key => "father_id"
	belongs_to :father, :class_name => "Account"
  validates_presence_of :name, :code, :operation
  #validates_associated :reverse, :father
  validates_uniqueness_of :name, :code
  validates_inclusion_of :operation, :in => ['+', '-']
  attr_accessible :name, :code, :operation, 
                  :invoices, 
                  :postings,
                  :inverse_ids, 
                  :reverse_id,
                  :reverse,
                  :children_ids,
                  :invoice_ids, 
                  :posting_ids
  def account
    @father = Account.new
  end
  
  def value
    0
  end
end
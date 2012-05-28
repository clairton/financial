#encoding: utf-8
class Posting < ActiveRecord::Base
  belongs_to :invoice, :inverse_of => :postings
  belongs_to :account, :inverse_of => :postings
  validates_presence_of :invoice, :account, :value, :issue
  validates_numericality_of :value
  validates_associated :invoice
  validates_associated :account
  validates_date :issue
  attr_accessible :invoice, 
                  :account, 
                  :value, 
                  :issue,
                  :additional, 
                  :invoice_id, 
                  :account_id


  def custom_label
    "Lançamento: #{self.additional} #{self.value}"
  end 
end

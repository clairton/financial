class Posting < ActiveRecord::Base
  belongs_to :account#, :inverse_of => :postings
  validates_presence_of :account, :value, :issue
  validates_numericality_of :value
  validates_associated :account
  attr_accessible :account, :value, :issue, :account_id
  #field :issue, :type => Date
end

#encoding: utf-8
require 'date'
require 'validates_date_time'
class Invoice < ActiveRecord::Base
  #relacionamento
  belongs_to :account
  has_many :postings, :inverse_of => :invoice, :dependent => :destroy
  #validaçoes
  validates_presence_of :expiration, :value, :account
  validates_associated :account
  validates_numericality_of :value
  validates_date :expiration
  validates_date :payment, :allow_nil => true
  #callbacks
  before_update :posting_on_update
  before_create :posting_on_create
  #metodos acessores
  attr_accessible :expiration, :payment,
                  :value, :account,
                  :account, :account_id,:posting_ids,
                  :postings

  def posting_on_update
    #se o estado de pagamento foi modificado
    if  self.payment_changed?
      #estorno
      if self.payment.nil?
        #lançar na conta de estorno
        if self.account.reverse.nil?
          self.errors.add(:account, 'conta para estorno esta nula, clique em editar e adicione uma conta para estorno')
          return false
        end
        @a = self.account.reverse
        date = Date::today
      #pagamento
      else
        @a = self.account
        date = self.payment
      end
      @posting = Posting.create(
        :issue => date,
        :value => self.value,
        :account => @a,
        :invoice => self
      )
      if(@posting.errors)
        @posting.errors.each { |k, v| self.errors.add(:postings, v)}
      else
        @posting.save
      end
    end
  end

  def posting_on_create
    if !self.payment.nil?
      @posting = Posting.create(
        :issue => self.issue,
        :value => self.value,
        :account => self.account,
        :invoice => self
      )
      if(@posting.errors)
        @posting.errors.each { |k, v| self.errors.add(:postings, v)}
      else
        @posting.save
      end
    end
  end
end
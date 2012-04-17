#encoding: utf-8
require 'date'
require 'validates_date_time'
class Invoice < ActiveRecord::Base
  #relacionamento
  belongs_to :account
  #validaçoes
  validates_presence_of :expiration, :issue, :value, :account
  validates_associated :account
  validates_numericality_of :value
  validates_inclusion_of :pay, :in => [true, false]
  validate :validates
  validates_date :expiration
  validates_date :issue
  validates_date :payment, :allow_nil => true
  #callbacks
  before_update :posting_on_update
  before_create :posting_on_create
  #metodos acessores
  attr_accessible :expiration, :issue,
                  :payment, :issue,
                  :value, :account,
                  :account, :account_id, :pay

  #se for para ser paga deve haver data de pagamento
  def validates
    if(self.pay and self.payment.nil?)
      errors.add(:payment, "data de pagamento não pode ficar em branco")
    end
  end

  def posting_on_update
    #se o estado de pagamento foi modificado
    if  self.pay_changed?
      #estorno
      if self.pay == false
        puts 'false, tem q estornar'
        #lançar na conta de estorno
        @a = self.account.reverse
        #apagar data de pagamento
        self.payment = nil
        date = Date::today
      #pagamento
      else
        puts 'true, tem q pagar'
        @a = self.account
        date = self.payment
      end
      @posting = Posting.create(
        :issue => date,
        :value => self.value,
        :account => @a
      )
      if(@posting.errors)
        @posting.errors.each { |k, v| self.errors.add(k, v)}
      else
        @posting.save
      end
    end
  end

  def posting_on_create
    if self.pay
      @posting = Posting.create(
        :issue => self.issue,
        :value => self.value,
        :account => self.account
      )
      if(@posting.errors)
        @posting.errors.each { |k, v| self.errors.add(k, v)}
      else
        @posting.save
      end
    end
  end
end
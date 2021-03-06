#encoding: utf-8
require 'date'
require 'validates_date_time'
class Invoice < ActiveRecord::Base
  #relacionamento
  belongs_to :account
  has_many :postings, :inverse_of => :invoice, :dependent => :destroy
  #validaçoes
  validates_presence_of :expiration, :value
  validates_associated :account
  validates_numericality_of :value
  validates_date :expiration
  validates_date :payment, :allow_nil => true
  #callbacks
  before_update :posting_on_update
  after_create :posting_on_create
  #metodos acessores
  attr_accessible :expiration, :payment,
                  :value, :additional, :account,
                  :account_id,:posting_ids,
                  :postings

  def custom_label
    if self.account.nil?
      "#{I18n.t(:new)} #{I18n.t(:invoice)}"
    else
      "#{I18n.t(:invoice)}: #{self.account.name} #{self.value} #{self.additional}"
    end
  end 

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
        add = "estorno #{self.additional}" 
      #pagamento
      else
        @a = self.account
        date = self.payment
        add = self.additional
      end
      @posting = Posting.create(
        :issue => date,
        :value => self.value,
        :account => @a,
        :invoice => self,
        :additional => add
      )
      self.calculator(self.value, @a.operation)
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
        :issue => Date::today,
        :value => self.value,
        :account => self.account,
        :invoice => self,
        :additional => self.additional
      )
      self.calculator(self.value, self.account.operation)
      if(@posting.errors)
        @posting.errors.each { |k, v| self.errors.add(:postings, v)}
      else
          @posting.save
      end
    end
  end

  def calculator(value, operation)
    @sum = Sum.find(1)
    value_current = @sum.value
    e = "#{value_current} #{operation} #{value}";
    puts e
    @sum.value = eval(e)
    @sum.save
  end
end

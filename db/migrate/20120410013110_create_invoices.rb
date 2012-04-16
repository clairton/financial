class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.date :expiration, :null => false
      t.date :issue, :null => false
      t.date :payment
      t.float :value, :null => false
      t.boolean :pay, :null => false, :default => false
      t.references :account, :null => false

      t.timestamps
    end
    add_index :invoices, :account_id
  end
end

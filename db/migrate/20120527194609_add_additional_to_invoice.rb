class AddAdditionalToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :additional, :string
    add_column :postings, :additional, :string
  end
end

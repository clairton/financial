class AddInvoiceFromPosting < ActiveRecord::Migration
  def change
    add_column :postings, :invoice_id, :integer
  end

  def down
    remove_column :postings, :invoice_id
  end
end

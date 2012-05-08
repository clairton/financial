class RemoveIssueFromInvoice < ActiveRecord::Migration
  def up
    remove_column :invoices, :issue
  end

  def down
    add_column :invoices, :issue, :date
  end
end

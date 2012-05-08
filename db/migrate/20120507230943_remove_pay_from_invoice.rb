class RemovePayFromInvoice < ActiveRecord::Migration
  def up
    remove_column :invoices, :pay
      end

  def down
    add_column :invoices, :pay, :boolean
  end
end

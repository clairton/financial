class RemoveCodeFromAccount < ActiveRecord::Migration
  def up
    remove_column :accounts, :code
      end

  def down
    add_column :accounts, :code, :string
  end
end

class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :name, :length => 50, :null => false
      t.string :code, :length => 20, :null => false
      t.string :operation, :length => 1, :null => false
      t.integer :father_id
      t.integer :reverse_id
      t.timestamps
    end
    add_index :accounts, :operation
  end
end

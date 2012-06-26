class CreateSums < ActiveRecord::Migration
  def change
    create_table :sums do |t|
      t.decimal :value, :null => false

      t.timestamps
    end
  end
end

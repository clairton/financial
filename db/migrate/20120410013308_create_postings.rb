class CreatePostings < ActiveRecord::Migration
  def change
    create_table :postings do |t|
      t.references :account, :null => false
      t.float :value, :null => false
      t.date :issue, :null => false

      t.timestamps
    end
  end
end

class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :query
      t.string :search_type
      t.string :search_question
      t.string :fined_query, default: false

      t.timestamps
    end
  end
end

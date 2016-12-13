class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
    	t.string :url
    	t.string :name
    	t.string :brand
    	t.float :overall_rating
    	t.integer :num_reviews
      t.timestamps
    end
  end
end

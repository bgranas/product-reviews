class CreateReviews < ActiveRecord::Migration[5.0]
  def change
    create_table :reviews do |t|
    	t.references :product
    	t.date :date_submitted
    	t.float :score
    	t.string :username
    	t.boolean :verified_purchase, default: false
    	t.string :title
    	t.text :text
    	t.integer :num_comments
    	t.integer :num_helpful_votes
    	t.string :comments_url

      t.timestamps
    end
  end
end

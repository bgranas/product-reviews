class CreateReviewMatches < ActiveRecord::Migration[5.0]
  def change
    create_table :review_matches do |t|
    	t.references :review
    	t.references :match
      t.timestamps
    end
  end
end

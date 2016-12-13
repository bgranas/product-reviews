class Match < ApplicationRecord
	has_many :review_matches
	has_many :reviews, through :review_match
end

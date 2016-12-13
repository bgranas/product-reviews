class ReviewMatch < ApplicationRecord
	belongs_to :review
	belongs_to :match
end

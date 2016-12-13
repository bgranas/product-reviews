class Product < ApplicationRecord
	has_many :reviews

	#Gets product page and pulls product details onlys
	def get_prod_details
		a = Mechanize.new
		a.user_agent_alias = 'Mac Safari'

		url = self.url
		p = a.get(url)
 
		price = p.search('#productTitle').text if p.search('#productTitle')
		overall_rating = p.search('#acrCustomerReviewText').partition.first.gsub(',','') if p.search('#acrCustomerReviewText')
		num_reviews = p.search() if p.search()
		brand = p.search('#brand').text.squish if p.search('#brand')
	end

	#Gets first product_review page, then iterates through all review_pages to scrape all reviews
	def get_reviews
		a = Mechanize.new
		a.user_agent_alias = 'Linux Firefox'

		curr_page = 415
		product_id = 1
		total_pages = nil
		reached_end = false

		while !reached_end

			review_url = "/ref=cm_cr_arp_d_viewopt_rvwer?ie=UTF8&reviewerType=all_reviews&showViewpoints=1&sortBy=helpful&pageNumber=" + curr_page.to_s
			url = self.url.to_s + review_url
			total_pages = 482
			#url = 'https://www.amazon.com/GermGuardian-AC4825-Cleaning-Sanitizer-Reduction/product-reviews/B004VGIGVY/ref=cm_cr_arp_d_viewopt_rvwer?ie=UTF8&reviewerType=all_reviews&showViewpoints=1&sortBy=helpful&pageNumber=1'

			p = a.get(url)
			#puts pp p
			#if !total_pages
			#	total_pages = p.search('.page-button').last.text if p.search('.page-button')
			#end

			reviews = p.search('.a-section .review')
			reviews.each do |review|
				date_submitted = convert_date(review.search('.review-date').text)
				score = review.search('.review-rating').text.partition(' ').first.to_f
				username = review.search('.author').text
				verified_purchase = p.search('.a-icon-text-separator').count > 1 ? true : false
				title = review.search('.review-title').text
				text = review.search('.review-text').text
				num_comments = review.search('.review-comment-total')[0].text
				num_helpful_votes = convert_votes(review.search('.review-votes').text.squish)
				comments_url = review.search('.review-title')[0]['href']

				Review.find_or_create_by(product_id: product_id, date_submitted: date_submitted, score: score, username: username, verified_purchase: verified_purchase,
																	title: title, text: text, num_comments: num_comments, num_helpful_votes: num_helpful_votes,
																	comments_url: comments_url)
				puts 'Saving review ' + title.to_s
			end

			if curr_page == total_pages
				reached_end = true
			end

			puts 'Done with page ' + curr_page.to_s
			curr_page = curr_page + 1
			sl = rand(7..11)
			puts 'sleeping ' + sl.to_s
			sleep(sl)
		end
	end

	def convert_date(date)
		m = date.split(' ')[1]
		d = date.split(' ')[2].gsub(',','')
		y = date.split(' ')[3]
		date = y + "-" + m + "-" + d
		return date
	end

	def convert_votes(sentence)
		if sentence.partition(' ').first == "One"
			votes = 1
		elsif sentence.partition(' ').first == "Was"
			votes = 0
		else
			votes = sentence.partition(' ').first.gsub(',','')
		end

		return votes		
	end

end

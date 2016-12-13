class Review < ApplicationRecord
	belongs_to :product
	has_many :review_matches
	has_many :matches, through: :review_matches

	#splits text up into ngrams and counts frequency of any given sequence
	def self.generate_ngrams(n)
		reviews = Review.where(score: [1,2,3])
		arr = []
		reviews.each do |review|
			arr = arr + review.text.split(' ').each_cons(n).to_a
		end
		h = arr.inject(Hash.new(0)) { |k, v| k[v] += 1 ; k }
		h = h.sort_by { |k,v| v}.reject { |k,v| v < 10}
		h.each { |k,v| puts "#{v} => #{k}\n"}
	end

	def self.text_rank
		reviews = Review.where(score: [1]).limit(1)
		
		#Splits review texts into array of single sentences
		arr = []
		full_string = ''
		reviews.each do |review|
			sens = review.text.split(/[.!?]/)
			sens.map {|sen| arr << sen}
			full_string += review.text #to pass to keywork match
		end
 
		#terms = TermExtract.extract(full_string)
		#p terms

		#Builds Keyword rank for review text; tr.run accepts string so need to pass one long string of all reviews
		tr = GraphRank::Keywords.new
		word_list = tr.run(full_string)
		#word_list.sort_by {|x| x[1]}.reverse[0..49].each {|x,y| puts "#{x} => #{y}"}

		#matched_list = top_strings(word_list,arr)
		#matched_list.sort_by {|x| x[2]}.reverse[0..9].each {|x,y,z| puts "#{x}. **** found #{y.length} words with SCORE: #{z}****\n\n"}
		#p matched_list[0..9]

		cooccurrence(word_list, arr).each {|x,y| puts "#{x} |\n#{y}\n\n"}

	end

	def self.top_strings(word_list,review_arr)
		#creating hash out of Keyword Rank array so I can get scores for each word later
		word_list_hash = Hash[word_list.map {|a| [a[0], a[1]]}]

		#building string matcher
		matcher = AhoC::Trie.new
		match_list = []
		word_list.each do |word|
			matcher.add(word[0])
		end
		matcher.build()
		
		#iterating each sentence to match words and get total score
		totals = []
		review_arr.each do |sentence|
			sen_score = 0.0
			found = matcher.lookup(sentence)

			#gets sentence score by lookig up keyword in Keyword hash
			found.each do |word|
				sen_score += (word_list_hash[word]).to_i
			end

			#Adds sentence as string, matched words as array, and score as int
			#totals << [sentence, found, sen_score] #if found.length < 40
			totals << found
		end

		return totals

	end

	def self.cooccurrence(word_list, review_arr)
		#creating hash out of Keyword Rank array so I can get scores for each word later
		word_list_hash = Hash[word_list.map {|a| [a[0], a[1]]}]

		#building string matcher
		matcher = AhoC::Trie.new
		match_list = []
		word_list.each do |word|
			matcher.add(word[0])
		end
		matcher.build()

		totals = []

		#splits sentences into tokens
		tokens = []
		
		review_arr.each_with_index do |sentence,i|
			tokens << sentence.gsub(',','').gsub('-','').gsub('(','').gsub(')','').gsub('"','').split
			found = matcher.lookup(sentence)
			puts 'Found: ' + found.length.to_s
			cooc_list = []
			found.each do |word|
				ind = tokens[i].index(word)
				cooc_list << [word, ind]
			end
			totals << [sentence, cooc_list]
		end

		return totals
	

	end
end

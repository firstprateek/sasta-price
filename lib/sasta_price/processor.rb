module SastaPrice
	class Processor
		def self.process(product)
			response = []
			#flipkart doc.css("[data-aid^='product_title_']")

			url = "http://www.flipkart.com/search?q=#{CGI.escape(product)}&as=off&as-show=off&otracker=start"
	    doc = Nokogiri::HTML(HTTParty.get(url).body)
	    doc.css('#products .lastUnit').each do |item|
	      puts "inside"
	      next if item.at_css('.fk-display-block').blank? || item.at_css('.pu-final .fk-bold').blank?
	      title = item.at_css('.fk-display-block').text.strip
	      price = item.at_css('.pu-final .fk-bold').text[/[rR][sS][0-9\.\,\s]+/]
	      next if price.blank?
	      amount = price[/[0-9\,]+/].gsub(',','').to_i
	      puts"#{title} #{price}"
	      append_link = item.at_css('.fk-display-block')[:href] # append http://www.flipkart.com/
	    	link = "http://www.flipkart.com#{append_link}"
				response << {title: title, price: price, vendor: "flipkart", link: link, amount: amount}
	    end

	    #snapdeal http://www.snapdeal.com/search?keyword=samsung+galaxy+s6&santizedKeyword=moto+g&catId=&categoryId=&suggested=false&vertical=p&noOfResults=20&clickSrc=go_header&lastKeyword=moto+g&prodCatId=&changeBackToAll=false&foundInAll=false&categoryIdSearched=&cityPageUrl=&url=&utmContent=&dealDetail=
	    url = "http://www.snapdeal.com/search?keyword=#{CGI.escape(product)}&santizedKeyword=&catId=&categoryId=&suggested=false&vertical=&noOfResults=20&clickSrc=go_header&lastKeyword=&prodCatId=&changeBackToAll=false&foundInAll=false&categoryIdSearched=&cityPageUrl=&url=&utmContent=&dealDetail="
	    doc = Nokogiri::HTML(HTTParty.get(url).body)

			doc.css('.js-tuple').each do |item|
	      puts "inside"
	      next if item.at_css('.product-price').nil? || item.at_css('.product-title').nil?
	      title = item.at_css('.product-title').text.strip
	      price = item.at_css('.product-price').text[/[rR][sS][0-9\.\,\s]+/]
	      next if price.blank?
	      amount = price[/[0-9]+/].to_i
	      puts "#{title} #{price}"
	      link = item.at_css('a')[:href]
	    	response << {title: title, price: price, vendor: "snapdeal", link: link, amount: amount}
	    end

	    #ebay
	    url = "http://www.ebay.in/sch/i.html?_from=R40&_trksid=p2050601.m570.l1313.TR0.TRC0.H0.X#{CGI.escape(product)}.TRS0&_nkw=#{CGI.escape(product)}&_sacat=0"
	    doc = Nokogiri::HTML(HTTParty.get(url).body)

	    doc.css('.li').each do |item|
	      puts "inside"
	      next if item.at_css('.vip').nil? || item.at_css('.prc .bold').nil?
	      title = item.at_css('.vip').text.strip
	      price = item.at_css('.prc .bold').text[/[rR][sS][0-9\.\,\s]+/]
	      next if price.blank?
	      amount = price[/[0-9\,]+/].gsub(',','').to_i
	      puts"#{title} #{price}"
	      link = item.at_css('.vip')[:href]
	    	response << {title: title, price: price, vendor: "ebay", link: link, amount: amount}
	    end

	    #amazon
	    url = "http://www.amazon.in/s/ref=nb_sb_noss?url=search-alias%3Daps&field-keywords=#{CGI.escape(product)}"
	    doc = Nokogiri::HTML(HTTParty.get(url).body)

	    doc.css('.s-item-container').each do |item|
	      puts "inside"
	      next if item.at_css('.s-access-title').nil? || item.at_css('.a-text-bold').nil?
	      title = item.at_css('.s-access-title').text.strip
	      price = item.at_css('.a-text-bold').text[/[0-9\.\,]+/]
	      next if price.nil?
	      amount = price[/[0-9\,]+/].gsub(',','').to_i
	      puts"#{title} #{price}"
	      link = item.at_css('a')[:href]
	    	response << {title: title, price: price, vendor: "amazon", link: link, amount: amount}
	    end

	    response = sanitize_response(response, product)
	  end

	  def self.sanitize_response(response, product)
	  	words = product.split
	  	if words.count < 1
	  		response = nil
	  	elsif words.count == 1
	  		response.reject! { |res| res[:title].downcase.match(product).nil? }
	  	else
	  		match_ratio = (words.count/2.0).ceil
	  		response.select! do |res|
	  			value = nil
	  			words.each_cons(match_ratio) do |cons_word|
	  				match_string = cons_word.join('.*') + "|" + cons_word.reverse.join('.*')
	  				if res[:title].downcase.match(match_string).present?
	  					value = true
	  					break
	  				end
	  			end
	  			puts "#{res[:title]}" unless value
	  			value
	  		end
	  	end

	  	response = remove_big_deviants(response, response.first[:amount])
	  	response.sort! { |a,b| a[:amount] <=> b[:amount]} if response.present?
	  end

	  def self.remove_big_deviants(response, amount_one)
	  	response.select! { |res| res[:amount].between?(0.5*amount_one, 1.5*amount_one) }
	  end
	end
end

# words.each_cons(match_ratio) do |cons_word|
# 	match_string = cons_word.join('.*') + "|" + cons_word.reverse.join('.*')
# 	puts "#{match_string}"
# 	puts "true" if statement.match(match_string).present?
# end

# match_ratio = (words.count/2.0).ceil
# response.select do |res|
# 	value = nil
# 	words.each_cons(match_ratio) do |cons_word|
# 		match_string = cons_word.join('.*') + "|" + cons_word.reverse.join('.*')
# 		puts "#{match_string}"
# 		puts "res_title: #{res[:title]}"
# 		if res[:title].downcase.match(match_string).present?
# 			value = true
# 			puts "#{value}"
# 			break
# 		end
# 	end
# 	puts "value_out: #{value}"
# 	value
# end

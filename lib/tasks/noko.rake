namespace :noko do
  desc 'test nokogiri'
  task test: :environment do
    url = "http://www.flipkart.com/search?q=moto+g&as=off&as-show=off&otracker=start"
    doc = Nokogiri::HTML(HTTParty.get(url))
    # content = doc.at_css('title').text
    # puts content
    # put all of this in a begin end block 

    doc.css('#products .lastUnit').each do |item|
    	puts "inside"
    	title = item.at_css('.fk-display-block').text
    	price = item.at_css('.fk-bold').text[/[rR][sS][0-9\.\,\s]+/]
    	puts"#{title} #{price}"
    	puts item.at_css('.fk-display-block')[:href] # append http://www.flipkart.com/
    end

    # {title, price, link, vendor}
    # snapdeal     url = "http://www.snapdeal.com/search?keyword=#{CGI.escape(product.title)}&santizedKeyword=moto+g&catId=&categoryId=&suggested=false&vertical=p&noOfResults=20&clickSrc=go_header&lastKeyword=moto+g&prodCatId=&changeBackToAll=false&foundInAll=false&categoryIdSearched=&cityPageUrl=&url=&utmContent=&dealDetail="
 			
    url = "http://www.snapdeal.com/search?keyword=samsung+galaxy+s6&santizedKeyword=moto+g&catId=&categoryId=&suggested=false&vertical=p&noOfResults=20&clickSrc=go_header&lastKeyword=moto+g&prodCatId=&changeBackToAll=false&foundInAll=false&categoryIdSearched=&cityPageUrl=&url=&utmContent=&dealDetail="
    doc = Nokogiri::HTML(HTTParty.get(url))

		doc.css('.product-txtWrapper').each do |item|
    	puts "inside"
    	title = item.at_css('.product-title').text
    	price = item.at_css('#price').text[/[rR][sS][0-9\.\,\s]+/]
    	puts"#{title} #{price}"
    	puts item.at_css('a')[:href]
    end
		
		# ebay
		url = "http://www.ebay.in/sch/i.html?_from=R40&_trksid=p2050601.m570.l1313.TR0.TRC0.H0.Xsamsung+galaxy+s6.TRS0&_nkw=samsung+galaxy+s6&_sacat=0"
    doc = Nokogiri::HTML(HTTParty.get(url))

		doc.css('.li').each do |item|
    	puts "inside"
    	title = item.at_css('.vip').text
    	price = item.at_css('.prc .bold').text[/[rR][sS][0-9\.\,\s]+/]
    	puts"#{title} #{price}"
    	puts item.at_css('.vip')[:href]
    end

    #amazon
    url = "http://www.amazon.in/s/ref=nb_sb_noss?url=search-alias%3Daps&field-keywords=samsung+galaxy+s6"
    doc = Nokogiri::HTML(HTTParty.get(url))

		doc.css('.s-item-container').each do |item|
    	puts "inside"
    	title = item.at_css('.s-access-title').text
    	price = item.at_css('.a-text-bold').text[/[0-9\.\,]+/]
    	puts"#{title} #{price}"
    	puts item.at_css('a')[:href]
    end

  end
end

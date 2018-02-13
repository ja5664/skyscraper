def hays(num_of_pages, count, increment, search_location, search_term)
    count = 0
    website = "www.hays.co.uk/"
    results = []
    puts "Scraping #{website} for jobs"
    while count < num_of_pages * increment
      begin
        response = open("https://m.hays.co.uk/search/?q=#{search_term}&location=#{search_location}&locationId=&locationSet=&locationLevel=&p=#{count}")
        rescue => error_message
        if results.empty?
          puts "Requested #{num_of_pages} pages from #{website} however there are no results for this search"
          break
        else
          puts "Requested #{num_of_pages} pages from #{website} however only #{count / increment} pages found before #{error_message}"
        break
        end
      end
      page = Nokogiri::HTML(open("https://m.hays.co.uk/search/?q=#{search_term}&location=#{search_location}&locationId=&locationSet=&locationLevel=&p=#{count}"))
      page.search(".result").each do |result|
        results << {
          website: website,
          title: result.search(".hays-result-title").text.strip,
          company: "anonymous",
          link: "https://m.hays.co.uk/" + result.search("a").first['href'],
          location: result.search(".hays-result-location").text.strip,
          salary: result.search(".hays-result-rate-value").text.strip
        }
      end
      count += increment
    end
    if results.empty?
      puts "Requested #{num_of_pages} pages from #{website} however there are no results for this search"
    else
      puts ""
      puts "Success! #{count / increment} pages found from #{website} with #{results.size} results!"
    end
    results
end

def reed(num_of_pages, count, increment, search_location, search_term)
    count = 0
    website = "www.reed.co.uk"
    results = []
    puts "Scraping #{website} for jobs"
    while count < num_of_pages * increment
      begin
        response = open("https://www.reed.co.uk/jobs/jobs-in-#{search_location}?keywords=#{search_term}&cached=True&pageno=#{count}")
        rescue => error_message
        if results.empty?
          puts "Requested #{num_of_pages} pages from #{website} however there are no results for this search"
          break
        else
          puts "Requested #{num_of_pages} pages from #{website} however only #{count / increment} pages found before #{error_message}"
        break
        end
      end
      page = Nokogiri::HTML(open("https://www.reed.co.uk/jobs/jobs-in-#{search_location}?keywords=#{search_term}&cached=True&pageno=#{count}"))
      page.search(".job-result").each do |result|
        results << {
          website: website,
          title: result.search(".gtmJobTitleClickResponsive").text.strip,
          company: result.search(".gtmJobListingPostedBy").text.strip,
          link: "https://www.reed.co.uk" + result.search("a").first['href'],
          location: result.search(".location").text.strip.gsub(/\s{1,}/, " "),
          salary: result.search(".salary").text.strip
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

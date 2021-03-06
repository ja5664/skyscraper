def indeed(num_of_pages, count, increment, search_location, search_term)
    count = 0
    website = "www.indeed.co.uk"
    results = []
    puts "Scraping #{website} for jobs"
    while count < num_of_pages * increment
      begin
        response = open("https://www.indeed.co.uk/jobs?q=#{search_term}&l=#{search_location}&start=#{count}")
        rescue => error_message
        if results.empty?
          puts "Requested #{num_of_pages} pages from #{website} however there are no results for this search"
          break
        else
          puts "Requested #{num_of_pages} pages from #{website} however only #{count / increment} pages found before #{error_message}"
        break
        end
      end
      page = Nokogiri::HTML(open("https://www.indeed.co.uk/jobs?q=#{search_term}&l=#{search_location}&start=#{count}"))
      page.search(".result").each do |result|
        results << {
          website: website,
          title: result.search(".jobtitle").text.strip,
          company: result.search(".company").text.strip,
          link: "https://www.indeed.co.uk" + result.search("a").first["href"],
          location: result.search(".location").text.strip
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

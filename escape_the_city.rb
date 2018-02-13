def escape_the_city(num_of_pages, count, increment, search_location, search_term)
    count = 0
    website = "www.escapethecity.org"
    results = []
    puts "Scraping #{website} for jobs"
    while count < num_of_pages * increment
      begin
        response = open("https://jobs.escapethecity.org/jobs/search?cat=&d=&l=#{search_location}%2C+UK&lat=51.5073509&long=-0.12775829999998223&page=#{count}&q=#{search_term}")
        rescue => error_message
        if results.empty?
          puts "Requested #{num_of_pages} pages from #{website} however there are no results for this search"
          break
        else
          puts "Requested #{num_of_pages} pages from #{website} however only #{count / increment} pages found before #{error_message}"
        break
        end
      end
      page = Nokogiri::HTML(open("https://jobs.escapethecity.org/jobs/search?cat=&d=&l=#{search_location}%2C+UK&lat=51.5073509&long=-0.12775829999998223&page=#{count}&q=#{search_term}"))
      page.search(".jobList-intro").each do |result|
        results << {
          website: website,
          title: result.search(".u-textLarge").text.strip,
          company: "https://jobs.escapethecity.org" + result.search("a").first['href'].split("-at-")[1].gsub(/-/, " ").capitalize,
          link: "https://jobs.escapethecity.org" + result.search("a").first['href'],
          location: search_location
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

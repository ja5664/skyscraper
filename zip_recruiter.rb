def zip_recruiter(num_of_pages, count, increment, search_location, search_term)
    count = 0
    website = "www.ziprecruiter.co.uk"
    results = []
    puts "Scraping #{website} for jobs"
    while count < num_of_pages * increment
      begin
        response = open("https://www.ziprecruiter.com/candidate/search?search=#{search_term}&location=#{search_location}%2C+ENG&page=#{count}")
        rescue => error_message
        if results.empty?
          puts "Requested #{num_of_pages} pages from #{website} however there are no results for this search"
          break
        else
          puts "Requested #{num_of_pages} pages from #{website} however only #{count / increment} pages found before #{error_message}"
        break
        end
      end
      page = Nokogiri::HTML(open("https://www.ziprecruiter.com/candidate/search?search=#{search_term}&location=#{search_location}%2C+ENG&page=#{count}"))
      page.search(".job_content").each do |result|
        results << {
          website: website,
          title: result.search(".just_job_title").text.strip,
          company: result.search(".name").text.strip,
          link: result.search("a").first['href'],
          location: result.search(".location").text.strip.gsub(/\s{1,}/, " ")
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

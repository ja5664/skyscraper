def cv_library(num_of_pages, count, increment, search_location, search_term)
    count = 0
    website = "www.cv-library.co.uk"
    results = []
    puts "Scraping #{website} for jobs"
    while count < num_of_pages * increment
      begin
        response = open("https://www.cv-library.co.uk/search-jobs?distance=15&fp=1&geo=#{search_location}&offset=#{count}&posted=28&q=#{search_term}&salarymax=&salarymin=&salarytype=annum&search=1&tempperm=Any")
        rescue => error_message
        if results.empty?
          puts "Requested #{num_of_pages} pages from #{website} however there are no results for this search"
          break
        else
          puts "Requested #{num_of_pages} pages from #{website} however only #{count / increment} pages found before #{error_message}"
        break
        end
      end
      page = Nokogiri::HTML(open("https://www.cv-library.co.uk/search-jobs?distance=15&fp=1&geo=#{search_location}&offset=#{count}&posted=28&q=#{search_term}&salarymax=&salarymin=&salarytype=annum&search=1&tempperm=Any"))
      page.search(".job-search-description").each do |result|
        results << {
          website: website,
          title: result.search("#js-jobtitle-details").text.strip,
          company: result.search(".agency-link-mobile").text.strip,
          link: "https://www.cv-library.co.uk" + result.search(".jobtitle-divider a").first['href'],
          location: result.search("#js-loc-details").text.strip,
          salary: result.search("#js-salary-details").text.strip
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

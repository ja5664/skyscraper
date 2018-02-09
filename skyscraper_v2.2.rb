require 'nokogiri'
require 'open-uri'
# require 'mechanize'
require 'csv'
require 'date'

def scrape_all
  puts "How many pages would you like to search? - max: 3"
  num_of_pages = gets.chomp.to_i

  indeed_pages = num_of_pages * 10
  escape_the_city_pages = num_of_pages
  hays_pages = num_of_pages
  cvlibrary_pages = num_of_pages
  reed_pages = num_of_pages
  ziprecruiter_pages = num_of_pages

  search_term = [USER_KEYWORD]
  search_location = "London"
  targetjobs_counter = "england-greater-london"
  results = []

  escape_the_city_jobs_to_scrape = (num_of_pages)
  escape_the_city_counter = 0

  # ZIPRECRUITER.CO.UK
  ziprecruiter_jobs_to_scrape = ziprecruiter_pages
  ziprecruiter_counter = 0

  # INDEED.CO.Uk
  indeed_jobs_to_scrape = indeed_pages
  indeed_counter = 0

  # HAYS.CO.UK
  # hays_jobs_to_scrape = hays_pages
  # hays_counter = 0
  # hays_results_per_page = 11
  # page = Nokogiri::HTML(open("https://m.hays.co.uk/search/?q=#{search_term}&location=#{search_location}&locationId=&locationSet=&locationLevel=&p=#{hays_counter}"))
  # hays_total_jobs_perm = page.search(".filter-list")&.search(".filter").first.search(".count").text
  # hays_total_jobs_temp = page.search(".filter-list")&.search(".filter")[1].search(".count").text
  # hays_total_jobs_con = page.search(".filter-list")&.search(".filter")[2].search(".count").text
  # hays_total_jobs = hays_total_jobs_perm.to_i + hays_total_jobs_temp.to_i + hays_total_jobs_con.to_i
  # hays_max_pages = (hays_total_jobs.to_f / hays_results_per_page.to_f).ceil
  # if (hays_jobs_to_scrape * hays_results_per_page) > hays_max_pages
  #   hays_jobs_to_scrape = hays_max_pages
  # end

  # CVLIBRARY.CO.UK
  cvlibrary_jobs_to_scrape = cvlibrary_pages
  cvlibrary_counter = 0

  # REED.CO.UK
  reed_results_per_page = 25
  reed_jobs_to_scrape = reed_pages
  reed_counter = 0
  page = Nokogiri::HTML(open("https://www.reed.co.uk/jobs/jobs-in-#{search_location}?keywords=#{search_term}&cached=True&pageno=#{reed_counter}"))
  reed_total_jobs = page.search(".search-results-header").search(".count").text.gsub(/\s{1,}/, " ")
  reed_max_pages = (reed_total_jobs.to_f / reed_results_per_page.to_f).ceil
  if (reed_jobs_to_scrape * reed_results_per_page) > reed_max_pages
    reed_jobs_to_scrape = reed_max_pages
  end

  while escape_the_city_jobs_to_scrape > escape_the_city_counter
    escape_the_city_counter += 1
    page = Nokogiri::HTML(open("https://jobs.escapethecity.org/jobs/search?cat=&d=&l=#{search_location}%2C+UK&lat=51.5073509&long=-0.12775829999998223&page=#{escape_the_city_counter}&q=#{search_term}"))
    page.search(".jobList-intro").each do |result_card|
      title = result_card.search(".u-textLarge").text.strip
      link = "https://jobs.escapethecity.org" + result_card.search("a").first['href']
      location = search_location
      company = link.split("-at-")[1].gsub(/-/, " ").capitalize
      website = "www.escapethecity.org"
      results << {website: website, title: title, company: company, link: link, location: location}
    end

    page = Nokogiri::HTML(open("https://www.indeed.co.uk/jobs?q=#{search_term}&l=#{search_location}&start=#{indeed_counter}"))
    page.search(".result").each do |result_card|
      title = result_card.search(".jobtitle").text.strip
      link = "https://www.indeed.co.uk" + result_card.search("a").first['href']
      company = result_card.search('.company').text.strip
      location = result_card.search('.location').text.strip
      salary = result_card.search(".no-wrap").text.strip
      website = "www.indeed.co.uk"
      results << {website: website, title: title, company: company, link: link, location: location, salary: salary}
    end
    indeed_counter += 10

    # hays_counter += 1
    # page = Nokogiri::HTML(open("https://m.hays.co.uk/search/?q=#{search_term}&location=#{search_location}&locationId=&locationSet=&locationLevel=&p=#{hays_counter}"))
    # page.search(".result").each do |result_card|
    #   title = result_card.search(".hays-result-title").text.strip
    #   link = "https://m.hays.co.uk/" + result_card.search("a").first['href']
    #   location = result_card.search(".hays-result-location").text.strip
    #   company = "anonymous"
    #   salary = result_card.search(".hays-result-rate-value").text.strip
    #   website = "www.hays.co.uk/"
    #   results << {website: website, title: title, company: company, link: link, location: location, salary: salary}
    # end

    page = Nokogiri::HTML(open("https://www.cv-library.co.uk/search-jobs?distance=15&fp=1&geo=#{search_location}&offset=#{cvlibrary_counter}&posted=28&q=#{search_term}&salarymax=&salarymin=&salarytype=annum&search=1&tempperm=Any"))
    page.search(".job-search-description").each do |result_card|
      title = result_card.search("#js-jobtitle-details").text.strip
      link = "https://www.cv-library.co.uk" + result_card.search(".jobtitle-divider a").first['href']
      location = result_card.search("#js-loc-details").text.strip
      company = result_card.search(".agency-link-mobile").text.strip
      salary = result_card.search("#js-salary-details").text.strip
      website = "www.cv-library.co.uk"
      results << {website: website, title: title, company: company, link: link, location: location, salary: salary}
    end
    cvlibrary_counter += 25

    reed_counter += 1
    page = Nokogiri::HTML(open("https://www.reed.co.uk/jobs/jobs-in-#{search_location}?keywords=#{search_term}&cached=True&pageno=#{reed_counter}"))
    page.search(".job-result").each do |result_card|
      title = result_card.search(".gtmJobTitleClickResponsive").text.strip
      link = "https://www.reed.co.uk" + result_card.search("a").first['href']
      location = result_card.search(".location").text.strip.gsub(/\s{1,}/, " ")
      company = result_card.search(".gtmJobListingPostedBy").text.strip
      salary = result_card.search(".salary").text.strip
      website = "www.reed.co.uk"
      results << {website: website, title: title, company: company, link: link, location: location, salary: salary}
    end

    ziprecruiter_counter += 1
    page = Nokogiri::HTML(open("https://www.ziprecruiter.com/candidate/search?search=#{search_term}&location=#{search_location}%2C+ENG&page=#{ziprecruiter_counter}"))
    page.search(".job_content").each do |result_card|
      title = result_card.search(".just_job_title").text.strip
      link = result_card.search("a").first['href']
      location = result_card.search(".location").text.strip.gsub(/\s{1,}/, " ")
      company = result_card.search(".name").text.strip
      website = "www.ziprecruiter.co.uk"
      results << {website: website, title: title, company: company, link: link, location: location}
    end
  end

  headers = ["Website Name", "Job Title", "Company Name", "Location", "Salary", "Link"]
  i = 0
  while i < results.size
    # puts "#{results[i][:title]} - #{results[i][:company]} - #{results[i][:location]}"
    CSV.open("skyscraper_data/skyscraper_#{USER_KEYWORD}_data_#{Date.today}.csv", 'a+', headers:true) do |csv|
      csv << headers if csv.count.eql? 0 # csv.count method gives number of lines in file if zero insert headers
      csv << [results[i][:website],results[i][:title], results[i][:company], results[i][:location], results[i][:salary], results[i][:link]]
    end
    i += 1
  end
  puts ""
  puts "Success! You have found #{results.size} results!"
end


def scrape_indeed
  puts "How many pages would you like to search? - max: 15"
  num_of_pages = gets.chomp.to_i

  indeed_pages = num_of_pages * 10
  escape_the_city_pages = num_of_pages
  hays_pages = num_of_pages
  cvlibrary_pages = num_of_pages

  search_term = [USER_KEYWORD]
  search_location = "London"
  targetjobs_counter = "england-greater-london"
  results = []

  indeed_jobs_to_scrape = indeed_pages
  indeed_counter = 0
  while indeed_jobs_to_scrape > indeed_counter
    page = Nokogiri::HTML(open("https://www.indeed.co.uk/jobs?q=#{search_term}&l=#{search_location}&start=#{indeed_counter}"))
    page.search(".result").each do |result_card|
      title = result_card.search(".jobtitle").text.strip
      link = "https://www.indeed.co.uk" + result_card.search("a").first['href']
      company = result_card.search('.company').text.strip
      location = result_card.search('.location').text.strip
      salary = result_card.search(".no-wrap").text.strip
      website = "www.indeed.co.uk"
      results << {website: website, title: title, company: company, link: link, location: location, salary: salary}
    end
    indeed_counter += 10
  end

  headers = ["Website Name", "Job Title", "Company Name", "Location", "Salary", "Link"]
  i = 0
  while i < results.size
    # puts "#{results[i][:title]} - #{results[i][:company]} - #{results[i][:location]}"
    CSV.open("skyscraper_data/skyscraper_#{USER_KEYWORD}_data_#{Date.today}.csv", 'a+', headers:true) do |csv|
      csv << headers if csv.count.eql? 0 # csv.count method gives number of lines in file if zero insert headers
      csv << [results[i][:website],results[i][:title], results[i][:company], results[i][:location], results[i][:salary], results[i][:link]]
    end
    i += 1
  end

  puts ""
  puts "Success! You have found #{results.size} results!"
end

puts "Hello there!"
puts "->If you want to scrape all websites, type a 'search term'."
puts "->If you want to scrape a specific website, type '1'"
USER_INPUT = gets.chomp.to_s

if USER_INPUT.to_s == '1'
  puts ""
  puts "You chose to scrape one website."
  puts "Please enter a valid 'search term'."
  USER_KEYWORD = gets.chomp.to_s
  scrape_indeed
else
  USER_KEYWORD = USER_INPUT
  puts ""
  puts "You chose to scrape all websites."
  if USER_KEYWORD.strip.include?(" ")
    USER_KEYWORD.gsub(/ /,"+")
  end
  scrape_all
end





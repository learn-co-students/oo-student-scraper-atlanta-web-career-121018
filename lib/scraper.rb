require 'open-uri'
require 'nokogiri'
require 'pry'

require_relative './student.rb'

class Scraper


    # This is a class method that should take in an argument of the URL of the index page,
    # for the purposes of our test the URL will be "./fixtures/student-site/index.html".
    # It should use Nokogiri and Open-URI to access that page. The return value of this
    # method should be an array of hashes in which each hash represents a single student.
    # The keys of the individual student hashes should be :name, :location and :profile_url.
    # Scraper.scrape_index_page(index_url)
        # # => [
            # {:name => "Abby Smith", :location => "Brooklyn, NY", :profile_url => "students/abby-smith.html"},
            # {:name => "Joe Jones", :location => "Paris, France", :profile_url => "students/joe-jonas.html"},
            # {:name => "Carlos Rodriguez", :location => "New York, NY", :profile_url => "students/carlos-rodriguez.html"},
            # {:name => "Lorenzo Oro", :location => "Los Angeles, CA", :profile_url => "students/lorenzo-oro.html"},
            # {:name => "Marisa Royer", :location => "Tampa, FL", :profile_url => "students/marisa-royer.html"}
        # ]

    def self.scrape_index_page(index_url)

        # # This just opens a file and reads it into a variable - ./fixtures/student-site/index.html
        # html = File.read('./fixtures/student-site/index.html')
        index_profiles = []
        html = File.read(index_url)
        index_page = Nokogiri::HTML(html)

        index_page.css("div.student-card").each do |student|
            individual = {}
            individual[:name] = student.css(".card-text-container h4.student-name").text
            individual[:location] = student.css(".card-text-container p.student-location").text
            individual[:profile_url] = (student.css("a").first.values.shift)
            # Why do these not work below?
            # url = (student.css("a").first.values.shift)
            # url = student.css(".student-card a")[index].first[1]
            # url = student.css(".student-card a")[index].values[0]
            # url = student.css(".student-card a").attribute('href').value
            index_profiles << individual
        end
        index_profiles
    end






    # This is a class method that should take in an argument of a student's profile URL.
    # It should use Nokogiri and Open-URI to access that page. The return value of this
    # method should be a hash in which the key/value pairs describe an individual student.
    # Some students don't have a twitter or some other social link. Be sure to be able to
    # handle that. Here is what the hash should look like:
    # Get only their twitter url, linkedin url, github url, blog url, profile quote, and bio.
    # The hash you build using those attributes should be formatted like the one in the example above.

    # Scraper.scrape_profile_page(profile_url)
        # # => {:twitter=>"http://twitter.com/flatironschool",
            # :linkedin=>"https://www.linkedin.com/in/flatironschool",
            # :github=>"https://github.com/learn-co,
            # :blog=>"http://flatironschool.com",
            # :profile_quote=>"\"Forget safety. Live where you fear to live. Destroy your reputation. Be notorious.\" - Rumi",
            # :bio=> "I'm a school"
        # }
    def self.scrape_profile_page(profile_url)

        # # This just opens a file and reads it into a variable
        scraped_links_hash = {}
        html = File.read(profile_url)
        student_profile = Nokogiri::HTML(html)

        student_profile.css("div.vitals-container").css("div.social-icon-container a").each do |url|
            if url.attribute('href').value.include?("twitter")
                scraped_links_hash[:twitter] = (url.attribute('href').value)
            elsif url.attribute('href').value.include?("link")
                scraped_links_hash[:linkedin] = (url.attribute('href').value)
            elsif url.attribute('href').value.include?("git")
                scraped_links_hash[:github] = (url.attribute('href').value)
            else
                scraped_links_hash[:blog] = (url.attribute('href').value)
            end
        end

        scraped_links_hash[:profile_quote] = (student_profile.css("div.profile-quote").text)
        scraped_links_hash[:bio] = (student_profile.css("div.description-holder p").text)

        scraped_links_hash
    end
end
# Scraper.scrape_index_page('./fixtures/student-site/index.html')
# Scraper.scrape_profile_page("./fixtures/student-site/students/ryan-johnson.html")










#######################################################################################
#######################################################################################
##############################   ONLY FOR REFERENCE   #################################
#######################################################################################
#######################################################################################

# projects: kickstarter.css("li.project.grid_4")
# title: project.css("h2.bbcard_name strong a").text
# img link: project.css("div.project-thumbnail a img").attribute("src").value
# description: project.css("p.bbcard_blurb").text
# percent_funded: project.css("ul.project-stats li.first.funded strong").text.gsub("%","").to_i

# # This just opens a file and reads it into a variable
# html = File.read('fixtures/kickstarter.html')
# kickstarter = Nokogiri::HTML(html)
#
# projects = {}
#
# # Iterate through the projects
# kickstarter.css("li.project.grid_4").each do |project|
#     title = project.css("h2.bbcard_name strong a").text
#     projects[title.to_sym] = {
#         :image_link => project.css("div.project-thumbnail a img").attribute("src").value,
#         :description => project.css("p.bbcard_blurb").text,
#         :location => project.css("ul.project-meta span.location-name").text,
#         :percent_funded => project.css("ul.project-stats li.first.funded strong").text.gsub("%","").to_i
#     }
# end
#
# # Return the projects hash
# projects

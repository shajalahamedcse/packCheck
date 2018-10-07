require_relative "PackageResponse"
require 'net/http'
require  'json'
# create a dictionary of sites we wish to visit concurrently.
urls ={
    "pip" => "https://pypi.org/pypi/",
    "gem" => "https://rubygems.org/api/v1/gems/"
}

# Create an array to keep track of threads.
threads = []

pk = PackageResponse.new('django','npm')
name = "Django"
urls.each do |key,url|
    #spwan a new threa for each url
    threads << Thread.new do
        fullURL = pk.getFullURL(url, key, name)
        puts fullURL

        puts "Request Complete: #{key}\n"
        uri = URI.parse(fullURL)
        response = Net::HTTP.get_response(uri)
        puts response.code
    end
end

# wait for threads to finish before ending program.
threads.each { |t| t.join }


puts "All Done!" 

require 'net/http'
require 'os'

class PackageResponse
    attr_accessor :packageName ,:statusCode
    def initialize(packageName,statusCode)
        @packageName = packageName
        @statusCode = statusCode
    end
end

# Get the status code from package manager
def getStatusCode( inurl)
    uri = URI.parse(inurl)
    #puts uri
    response  = Net::HTTP.get_response(uri)
    return response.code
end



#Get the full url of the package manager based on name 
def getFullURL(url, manager, name)
    fullURL = url + name
    case manager
        when "pip"
            fullURL = fullURL + "/json"
        when "gem"
            fullURL = fullURL + ".json"
        end
    return fullURL
end




#Get the message tto prinntn on console
def getMessage(response, name)
    symbol = getSymbols()

    case response.statusCode
    when "404"
        puts "#{symbol[1]} #{name} is not avaiable on #{response.packageName}"
    when "200"
        puts "#{symbol[0]} #{name} is not avaiable on #{response.packageName}"
    else
        puts "#{response.statusCode} #{symbol[1]} Oops! something bad happened in #{response.packageName}"
    end
end


#Get success and error symbols
def getSymbols()
    if OS.windows?
        successSym = "\u001b[32m" + "√" + "\u001b[39m"
        errorSym = "\u001b[31m" + "×" + "\u001b[39m"
    else
        successSym = "\u001b[32m" + "✔" + "\u001b[39m"
        errorSym = "\u001b[31m" + "✖" + "\u001b[39m"
    end
    arr = []
    arr << successSym
    arr << errorSym

    return arr
end

        



# create a dictionary of sites we wish to visit concurrently.
urls ={
    "pip" => "https://pypi.org/pypi/",
    "gem" => "https://rubygems.org/api/v1/gems/"
}





name = "Django"



# Create an array to keep track of threads.
threads = []
responseArray = []

urls.each do |key,url|
    #spwan a new threa for each url

    threads << Thread.new do
        #Every thread making an new object. Need some optimization
        fullURL = getFullURL(url, key, name)
        #puts fullURL

        #puts "Request Complete: #{key}\n"
        uri = URI.parse(fullURL)
        
        statusCode = getStatusCode(fullURL)
        
        responseArray << PackageResponse.new(key, statusCode)

    end
end

# wait for threads to finish before ending program.
threads.each { |t| t.join }

responseArray.each do | re |
    getMessage(re, name)
end
require 'net/http'
require 'uri'
class PackageResponse



end

# Get the status code from package manager
def getStatusCode(name, inurl)
    uri = URI.parse(inurl)
    puts uri
    response  = Net::HTTP.get_response(uri)
    
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
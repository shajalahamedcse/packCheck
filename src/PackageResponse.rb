require 'net/http'
require 'uri'
class PackageResponse
    def initialize(packageManager, statusCode)
        @packageManager = packageManager
        @statusCode = statusCode
    end

    def getStatusCode(name, inurl)
        uri = URI.parse(inurl)
        puts uri
        response = Net::HTTP.get_response()
        puts response.body
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

end


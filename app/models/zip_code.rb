require 'net/http'

class ZipCode
    attr_reader :street, :neighborhood, :locality, :uf

    END_POINT = "https://viacep.com.br/ws/"
    FORMAT = "json"

    def initialize(zip_code)
        zip_code_found = found(zip_code) # hash
        populate_data(zip_code_found)
    end

    def address
        "#{@street} / #{@neighborhood} / #{@locality} - #{@uf}"
    end

    private

    def populate_data(zip_code_found)
        @street = zip_code_found["logradouro"]
        @neighborhood = zip_code_found["bairro"]
        @locality = zip_code_found["localidade"]
        @uf = zip_code_found["uf"]
    end

    def found(zip_code)
        ActiveSupport::JSON.decode(
        Net::HTTP.get(
            URI("#{END_POINT}#{zip_code}/#{FORMAT}/")
        )
        )
    end
end
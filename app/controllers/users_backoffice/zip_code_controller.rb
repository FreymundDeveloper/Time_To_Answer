class UsersBackoffice::ZipCodeController < UsersBackofficeController
    def show
        @zip_code = ZipCode.new(params[:zip_code])
    end
end

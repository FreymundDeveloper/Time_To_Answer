module UsersBackofficeHelper
    def user_welcome
        current_user.first_name == nil ? "Unamed Pal" : current_user.full_name
    end
end

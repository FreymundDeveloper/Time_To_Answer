module UsersBackofficeHelper
    def user_welcome
        current_user.first_name == nil ? "Unamed Pal" : current_user.full_name
    end

    def avatar_url
        avatar = current_user.user_profile.avatar
        avatar.attached? ? avatar : 'img.jpg'
    end
end

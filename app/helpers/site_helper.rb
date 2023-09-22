module SiteHelper
    def msg_jumbotron
        case params[:action]
        when 'index'
            "Last questions registrated..."
        when 'questions'
            "Results to the search \"#{sanitize params[:term]}\"..."
        when 'subject'
            "Results to the theme \"#{sanitize params[:subject]}\"..."   
        end 
    end
end

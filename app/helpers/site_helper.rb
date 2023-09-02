module SiteHelper
    def msg_jumbotron
        case params[:action]
        when 'index'
            "Last questions registrated..."
        when 'questions'
            "Results to the search \"#{params[:term]}\"..."
        when 'subject'
            "Results to the theme \"#{params[:subject]}\"..."   
        end 
    end
end

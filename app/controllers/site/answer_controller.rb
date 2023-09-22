class Site::AnswerController < SiteController
    def question
        # @answer = Answer.find(params[:answer_id])
        redis_answer = Rails.cache.read(params[:answer_id]).split("@@")
        @question_id = redis_answer.first
        @answer_id = params[:answer_id]
        @correct = ActiveModel::Type::Boolean.new.cast(redis_answer.last)

        UserStatistic.set_statistic(@correct, current_user)
    end
end

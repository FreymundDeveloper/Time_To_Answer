class Question < ApplicationRecord
  belongs_to :subject, inverse_of: :questions
  has_many :answers, dependent: :delete_all
  accepts_nested_attributes_for :answers, reject_if: :all_blank, allow_destroy: true

  paginates_per 5

  scope :_search_subject_, ->(page, subject_id){
    includes(:answers, :subject)
    .where(subject_id: subject_id)
    .page(page)
  }

  scope :_search_, ->(page, term){
    includes(:answers, :subject)
    .where("lower(description) LIKE ?", "%#{term.downcase}%")
    .page(page)
  }

  scope :last_question, ->(page){
    includes(:answers, :subject).order('created_at desc').page(page)
  }

  #def self.last_question(page) # Model Method Exemple
  # includes(:answers).order('created_at desc').page(page)
  #end
end

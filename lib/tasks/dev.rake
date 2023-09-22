namespace :dev do

  DEFAULT_PASS = 123456
  DEFAULT_FILES_PATH = File.join(Rails.root, 'lib', 'tmp')

  desc "Configura o ambiente DEV"
  task setup: :environment do
    if Rails.env.development?
      show_spinner("Apagando") { %x(rails db:drop:_unsafe) }
      show_spinner("Criando") { %x(rails db:create) }
      show_spinner("Migrando") { %x(rails db:migrate) }
    end

    show_spinner("Criandando o ADM") { %x(rails dev:add_default_admin) }
    show_spinner("Criandando mais ADMs") { %x(rails dev:add_extra_admins) }
    show_spinner("Criandando Usuário") { %x(rails dev:add_default_user) }
    show_spinner("Cadastrando Assuntos") { %x(rails dev:add_subjects) }
    show_spinner("Cadastrando Questões e Respostas") { %x(rails dev:add_answers_and_questions) }
    #else
      #puts "Ambiente DEV requerido."
    #end
  end

  desc "Adiciona o administrador padrão"
  task add_default_admin: :environment do
    Admin.create!(
      email: 'admin@admin.com',
      password: DEFAULT_PASS,
      password_confirmation: DEFAULT_PASS
    )
  end

  desc "Popula o armazenamento de administradores"
  task add_extra_admins: :environment do
    5.times do |i|
      Admin.create!(
        email: Faker::Internet.email,
        password: DEFAULT_PASS,
        password_confirmation: DEFAULT_PASS
      )
    end
  end

  desc "Adiciona o usuário padrão"
  task add_default_user: :environment do
    User.create!(
      email: 'user@user.com',
      password: DEFAULT_PASS,
      password_confirmation: DEFAULT_PASS
    )
  end

  desc "Adiciona assuntos padrões"
  task add_subjects: :environment do
    file_name = 'subjects.txt'
    file_path = File.join(DEFAULT_FILES_PATH, file_name)

    File.open(file_path, 'r').each do |line|
      Subject.create!(description: line.strip)
    end
  end

  desc "Adiciona perguntas e respostas"
  task add_answers_and_questions: :environment do
    Subject.all.each do |subject|
      rand(5..10).times do |i|
        params = create_question_params(subject)
        answers_array = params[:question][:answers_attributes]

        add_answers(answers_array)
        selected_answer(answers_array)

      Question.create!(params[:question])
      end
    end
  end

  desc "Reseta o contador de assuntos"
  task reset_subject_counter: :environment do
    show_spinner("Resetando Contador...") do
      Subject.all.each do |subject|
        Subject.reset_counters(subject.id, :questions)
      end
    end
  end

  desc "Integra os assuntos ao Redis"
  task add_answers_to_redis: :environment do
    show_spinner("Vinculando assuntos ao Redis...") do
      Answer.find_each do |answer|
        Rails.cache.write(answer.id, "#{answer.question_id}@@#{answer.correct}")
      end
    end
  end

  private

  def create_question_params(subject = Subject.all.sample)
    { question: {
        description: "#{Faker::Lorem.paragraph} #{Faker::Lorem.question}",
        subject: subject,
        answers_attributes: []
      }
    }
  end

  def add_answers(answers_array = [])
    rand(2..5).times do |j|
      answers_array.push(
        create_answers_params
      )
    end
  end

  def create_answers_params(correct = false)
    { description: Faker::Lorem.sentence, correct: correct }
  end

  def selected_answer(answers_array = [])
    selected_index = rand(answers_array.size)
    answers_array[selected_index] = create_answers_params(true)
  end
  
  def show_spinner(msg_start)
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
    spinner.auto_spin 
    yield
    spinner.success("Feito!")
  end

end
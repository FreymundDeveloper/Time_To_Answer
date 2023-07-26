namespace :dev do

  DEFAULT_PASS = 123456

  desc "Configura o ambiente DEV"
  task setup: :environment do
    if Rails.env.development?
      show_spinner("Apagando") { %x(rails db:drop:_unsafe) }
      show_spinner("Criando") { %x(rails db:create) }
      show_spinner("Migrando") { %x(rails db:migrate) }
      show_spinner("Criandando ADM") { %x(rails dev:add_default_admin) }
      show_spinner("Criandando Usuário") { %x(rails dev:add_default_user) }
    else
      puts "Ambiente DEV requerido."
    end
  end

  desc "Adiciona o administrador padrão"
  task add_default_admin: :environment do
    Admin.create!(
      email: 'admin@admin.com',
      password: DEFAULT_PASS,
      password_confirmation: DEFAULT_PASS
    )
  end

  desc "Adiciona o usuário padrão"
  task add_default_user: :environment do
    User.create!(
      email: 'user@user.com',
      password: DEFAULT_PASS,
      password_confirmation: DEFAULT_PASS
    )
  end

  private
  
  def show_spinner(msg_start)
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
    spinner.auto_spin 
    yield
    spinner.success("Feito!")
  end

end
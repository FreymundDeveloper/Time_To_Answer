# config valid for current version and patch releases of Capistrano
lock "~> 3.17.3"

set :application, "timetoanswer"
set :repo_url, "https://github.com/FreymundDeveloper/Time_To_Answer.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
set :branch, 'master'

set :stage, :production
set :rails_env, 'production'

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/var/www/timetoanswer"

# Default value for :format is :airbrussh.
set :format, :airbrussh

set :log_level, :debug

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Unicorn config - Disabled because the Dominion ans DNS Configs is not available.
after 'deploy:finished', 'deploy:restart'

namespace :deploy do
    desc 'Set Git safe directory'
    task :set_git_safe_directory do
        on roles(:app) do
            within release_path do
                execute :git, 'config --add safe.directory /var/www/timetoanswer/repo'
            end
        end
    end

    before 'git:upload', 'deploy:set_git_safe_directory'

    desc 'Install Node.js dependencies'
    task :install_node_dependencies do
        on roles(:app) do
            within release_path do
                execute :yarn, 'install --production' 
            end
        end
    end

    # Unicorn config - Disabled because the Dominion ans DNS Configs is not available.
    desc 'Restart Unicorn'
    task :restart do
        invoke 'unicorn:stop'
        invoke 'unicorn:start'
    end
  
    before 'deploy:assets:precompile', 'deploy:install_node_dependencies'
end
  

# Default value for :linked_files is []
# append :linked_files, "config/database.yml", 'config/master.key'
append :linked_files, "config/database.yml", 'config/master.key'

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "tmp/webpacker", "public/system", "vendor", "storage"
append :linked_dirs, "storage", "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system" #, "tmp/webpacker", "vendor"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

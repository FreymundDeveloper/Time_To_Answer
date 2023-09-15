# config valid for current version and patch releases of Capistrano
lock "~> 3.17.3"

set :application, "timetoanswer"
set :repo_url, "https://github.com/FreymundDeveloper/Time_To_Answer.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
set :branch, 'master'

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

namespace :deploy do
    desc 'Precompile assets'
    task :precompile do
        on roles(:web) do
            within release_path do
                with rails_env: fetch(:rails_env) do
                    execute :rake, 'assets:precompile'
                end
            end
        end
    end
end

before 'deploy:updated', 'deploy:precompile'
  

set :assets_roles, [:web, :app]

set :rails_assets_groups, :assets

set :assets_prefix, 'prepackaged-assets'

set :normalize_asset_timestamps, %w{public/images public/javascripts public/stylesheets}

set :assets_manifests, ['app/assets/config/manifest.js']

set :keep_assets, 2

# Default value for :linked_files is []
# append :linked_files, "config/database.yml", 'config/master.key'
append :linked_files, "config/database.yml", 'config/master.key'

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "tmp/webpacker", "public/system", "vendor", "storage"
# append :linked_dirs, "storage", "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system" #, "tmp/webpacker", "vendor"
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', '.bundle', 'public/system', 'public/uploads'

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

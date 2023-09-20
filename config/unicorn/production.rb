# Used to config the Unicorn tool

root = "/var/www/timetoanswer/current"
working_directory root

pid "#{root}/tmp/pids/unicorn.pid"

stdout_path "#{root}/log/unicorn.log"
stderr_path "#{root}/log/unicorn.log"

worker_processes 4
timeout 30
preload_app true

listen '/tmp/timetoanswer.sock', backlog: 64

# To make work:

# 1 -> Check the nginx config state(files:"/etc/nginx/nginx.conf" and "/etc/nginx/sites-enabled/default").

# 2 -> Check all points with the message "Unicorn config" are uncommented (Ex: Gemfile and config files).

# 3 -> Run from "vagrant@ubuntu-bionic:/vagrant/time_to_answer$":
# bundle install
# bundle exec cap production deploy
# sudo systemctl restart nginx
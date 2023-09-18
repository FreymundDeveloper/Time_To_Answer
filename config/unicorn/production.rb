# Unicorn config - Disabled because the Dominion ans DNS Configs is not available.

root = "var/www/timetoanswer/current"
working_directory root

pid "#{root}/tmp/pids/unicorn.pid"

stdout_path "#{root}/log/unicorn.log"
stderr_path "#{root}/log/unicorn.log"

worker_processes 4
timeout 30
preload_app true

listen '/tmp/timetoanswer.soak', backlog: 64

# If missing settings are made:

# 1 -> Remove the .example from this file.

# 2 -> All points with the messenger "Unicorn config - Disabled because the Dominion ans DNS Configs is not available." have to be uncomennt.

# 3 -> Run from "vagrant@ubuntu-bionic:/vagrant/time_to_answer$":
# bundle install
# bundle exec cap production deploy
# sudo systemctl restart nginx
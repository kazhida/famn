require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rbenv'  # for rbenv support. (http://rbenv.org)

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

set :domain, 'famn.mobi'
set :deploy_to, '/var/www/famn'
set :repository, 'https://github.com/kazhida/famn.git'
set :branch, 'master'
set :rails_env,  ENV['RAILS_ENV'] || 'production'

# Manually create these paths in shared/ (eg: shared/config/database.yml) in your server.
# They will be linked in the 'deploy:link_shared_paths' step.
set :shared_paths, ['config/database.yml', 'log']

# Optional settings:
set :user, 'kazhida'    # Username in the server to SSH to.

# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  queue %[source ~/.bashrc]

  # If you're using rbenv, use this to load the rbenv environment.
  # Be sure to commit your .rbenv-version to your repository.
  invoke :'rbenv:load'
end

# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.
task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/shared/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/log"]

  queue! %[mkdir -p "#{deploy_to}/shared/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/config"]

  #queue! %[touch "#{deploy_to}/shared/config/database.yml"]
  #queue  %[-----> Be sure to edit 'shared/config/database.yml'.]
end

desc 'Deploys the current version to the server.'
task :deploy => :environment do
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'

    to :launch do
      queue 'mkdir tmp'
      queue 'touch tmp/restart.txt'
    end
  end
end

task :restart => :environment do
  set :pid, '/tmp/unicorn_famn.pid'

  queue! %[test -s "#{pid}" && kill `cat #{pid}`]
  queue! %[cd #{deploy_to}/current]
  queue! %[bundle exec unicorn -D -E #{rails_env} -c config/unicorn.rb]

  run!
end

# For help in making your deploy script, see the Mina documentation:
#
#  - http://nadarei.co/mina
#  - http://nadarei.co/mina/tasks
#  - http://nadarei.co/mina/settings
#  - http://nadarei.co/mina/helpers


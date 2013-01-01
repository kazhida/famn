set :application, 'famn'
set :repository,  'git://github.com/kazhida/famn.git'
set :deploy_to,   '/home/kazhida/work/famn'

set :scm, :git
set :branch, :master
set :scm_verbose, true
set :use_sudo, false
set :rails_env, :production

role :web, 'famn.kazhida.jp'                    # Your HTTP server, Apache/etc
role :app, 'famn.kazhida.jp'                    # This may be the same as your `Web` server
role :db,  'famn.kazhida.jp', :primary => true  # This is where Rails migrations will run

after 'deploy:update_code', bundle_install

desc 'install the necessary prerequisites'
task :bundle_install, :roles => :app do
  run "cd #{release_path} && bundle install"
end


set :application, 'famn'
set :repository,  'kazhida@kazhida.jp/~/work/famn.git'
set :deploy_to,   '/home/kazhida/work/famn'

set :scm, :git
set :branch, :master
set :scm_verbose, true
set :use_sudo, false
set :rails_env, :production

role :web, 'famn.kazhida.jp'                    # Your HTTP server, Apache/etc
role :app, 'famn.kazhida.jp'                    # This may be the same as your `Web` server
role :db,  'famn.kazhida.jp', :primary => true  # This is where Rails migrations will run

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

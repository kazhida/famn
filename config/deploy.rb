set :application, 'famn'
set :repository,  'git://github.com/kazhida/famn.git'
set :deploy_to,   '/home/kazhida/rails_app/famn'

set :scm, :git
set :branch, :master
set :scm_verbose, true
set :use_sudo, false
set :rails_env, :production

role :web, 'famn.kazhida.jp'                    # Your HTTP server, Apache/etc
role :app, 'famn.kazhida.jp'                    # This may be the same as your `Web` server
role :db,  'famn.kazhida.jp', :primary => true  # This is where Rails migrations will run

require    'bundler/capistrano'

# rbenv configuration
set :default_environment, {
    :FAMN_DATABASE_PASSWORD => ENV['FAMN_DATABASE_PASSWORD'],
    :RBENV_ROOT => '$HOME/.rbenv',
    :PATH => '$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH'
}
set :bundle_flags, '--deployment --quiet --binstubs --shebang ruby-local-exec'
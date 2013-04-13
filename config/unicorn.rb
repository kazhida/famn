worker_processes 2

working_directory '/var/www/famn/current'

listen  '/tmp/unicorn_famn.sock'
pid     '/tmp/unicorn_famn.pid'
timeout 30

stderr_path File.expand_path('log/unicorn.stderr.log', ENV['RAILS_ROOT'])
stdout_path File.expand_path('log/unicorn.stdout.log', ENV['RAILS_ROOT'])

preload_app true

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!
  
  old_pid = "#{ server.config[:pid] }.oldbin"
  unless old_pid == server.pid
    begin
      Process.kill :QUIT, File.read(old_pid).to_i
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
end
  
after_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
end


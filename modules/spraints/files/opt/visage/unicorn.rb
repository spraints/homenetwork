preload_app true
worker_processes 4
pid "/var/run/visage-app-unicorn.pid"

before_fork do |server, worker|
  old_pid = "/var/run/visage-app-unicorn.pid.oldbin"
  if File.exists?(old_pid) && old_pid != server.pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
end

after_fork do |server, worker|
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end

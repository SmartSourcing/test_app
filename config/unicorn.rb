# config/unicorn.rb
# Set the current app's path for later reference. Rails.root isn't available at
# this point, so we have to point up a directory.
app_path = File.expand_path(File.dirname(__FILE__) + '/..')

app_path + '/log/unicorn.log'
app_path + '/tmp/unicorn.pid'

# set some bullshit
worker_processes Integer(ENV["WEB_CONCURRENCY"] || 3)
timeout 300
preload_app true

# Garbage collection settings.
GC.respond_to?(:copy_on_write_friendly=) &&
    GC.copy_on_write_friendly = true

before_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  defined?(ActiveRecord::Base) and
      ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end

  defined?(ActiveRecord::Base) and
      ActiveRecord::Base.establish_connection
end
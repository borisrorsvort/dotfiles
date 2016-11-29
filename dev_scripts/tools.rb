def dev_status
  %w(mysql redis mongod nginx).each do |service|
    puts ".."
    puts "#{service}\t "
    if send("#{service}_running?".to_sym)
      puts "\033[32m[Yes]\033[0m"
    else
      puts "\033[31m[NO]\033[0m"
    end
  end
end

def sudo(command = nil)
  `sudo echo 'need sudo'`
  system("sudo #{command}") if command
end

def start_dev_env
  # start_mysqls
  # start_mongod
  start_redis
  # start_nginx
end

def stop_dev_env
  # stop_mysql
  # stop_mongod
  stop_redis
  # stop_nginx
end

def start_if_not_running(service)
  puts "Starting #{service}"
  if eval("#{service}_running?")
    puts "\t already running"
    true
  else
    puts "\t starting..."
    yield
    started = false
    10.times do
      started = eval("#{service}_running?")
      break if started
      sleep(1)
    end
    puts started ? "\t Started" : "\t Could not start!"
    return started
  end
end

def stop_if_running(service)
  puts "Stopping #{service}"
  unless eval("#{service}_running?")
    puts "\t not running"
  else
    puts "\t stopping..."
    yield
    puts "\t stopped"
  end
end

def if_not_running(service)
  unless eval("#{service}_running?")
    yield
  end
end

#
# Nginx
#

# def nginx_running?
#   %x{ps aux | grep \`cat /usr/local/var/run/nginx.pid 2> /dev/null\` 2> /dev/null} =~ /nginx: master process nginx/
# end
#
# def start_nginx
#   start_if_not_running :nginx do
#     sudo "nginx"
#   end
# end

def stop_nginx
  stop_if_running :nginx do
    sudo "nginx -s stop 2> /dev/null"
  end
end

def reload_nginx
  sudo "nginx -s reload"
end

#
# Redis
#

def redis_running?
  sudo `redis-cli ping 2> /dev/null` =~ /PONG/
end

def start_redis
  start_if_not_running :redis do
    sudo "redis-server 2> /dev/null > /dev/null&"
  end
end

def stop_redis
  stop_if_running :redis do
    sudo "redis-cli shutdown 2> /dev/null"
  end
end

#
# Mongod
#

def mongod_running?
  `ps aux | grep \`cat /usr/local/var/mongodb/mongod.lock\` 2> /dev/null` =~ /mongod/
end

def start_mongod
  started = start_if_not_running :mongod do
    sudo "mongod --dbpath=/usr/local/var/mongodb --fork --logpath /usr/local/var/mongodb/mongodb.log --logappend  2> /dev/null > /dev/null"
  end
  unless started
    repair_mongod
    start_mongod
  end
end

def stop_mongod
  stop_if_running :mongod do
    sudo "kill -s SIGTERM \`cat /usr/local/var/mongodb/db/mongod.lock\` 2> /dev/null"
  end
end

def repair_mongod
  if_not_running :mongod do
    sudo "rm /data/db/mongod.lock 2> /dev/null"
    sudo "mongod --dbpath=/data/db/mongodb/ --repair"
  end
end

#
# Mysql
#

def mysql_running?
  `mysqladmin -u root ping 2> /dev/null` =~ /mysqld is alive/
end

def start_mysql
  start_if_not_running :mysql do
    system "mysqld_safe 2> /dev/null > /dev/null &"
    # sudo "ln -s /opt/local/var/run/mysql5/mysqld.sock /tmp/mysql.sock 2> /dev/null"
  end
end

def stop_mysql
  stop_if_running :mysql do
    system "mysqladmin -u root shutdown"
  end
end

def method_missing(*args, &block)
  method = args.shift
  case method
  when :start
    sudo
    start_dev_env
  when :stop
    sudo
    stop_dev_env
  else
    if %w(mysql redis mongod nginx).include? method.to_s
      eval "start_#{method}"
      dev_status
    else
      super(method, *args, &block)
    end
  end
end

if ARGV[0]
  eval ARGV[0]
else
  dev_status
end

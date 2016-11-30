#!/usr/bin/env ruby

class Service
  COMMANDS = {
    # postgresql: {
    #   start: 'pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start > /dev/null',
    #   stop:  'pg_ctl -D /usr/local/var/postgres stop > /dev/null',
    #   ping:  'pg_isready',
    #   pong:  'accepting connections',
    # },
    mongod: {
      start: 'mongod --dbpath=/usr/local/var/mongodb --fork --logpath /usr/local/var/mongodb/mongodb.log --logappend  2> /dev/null > /dev/null',
      stop: 'kill -s SIGTERM \`cat /usr/local/var/mongodb/db/mongod.lock\` 2> /dev/null',
      ping: 'ps aux | grep \`cat /usr/local/var/mongodb/mongod.lock\` 2> /dev/null',
      pong: 'mongod'
    },
    mysql: {
      start: 'mysqld_safe 2> /dev/null > /dev/null &',
      stop: 'mysqladmin -u root shutdown',
      ping: 'mysqladmin -u root ping 2> /dev/null',
      pong: 'mysqld is alive'
    },
    nginx: {
      start: 'nginx',
      stop: 'nginx -s stop 2> /dev/null',
      ping: 'sudo ps cax | grep -E nginx',
      pong: 'nginx: master process nginx'
    },
    redis: {
      start: 'redis-server > /dev/null &',
      stop:  'redis-cli shutdown > /dev/null',
      ping:  'redis-cli ping 2> /dev/null',
      pong:  'PONG'
    }
  }.freeze
  ICONS = { on: '🍺', off: '💀', wait: '💬' }.freeze

  def self.all
    COMMANDS.keys.map { |s| Service.new(s) }
  end

  def initialize(service_name)
    @service_name = service_name
  end

  def status_wait
    print "\r #{ICONS[:wait]}  #{@service_name}"
  end

  def status
    print "\r #{running? ? ICONS[:on] : ICONS[:off]}  #{@service_name}\n"
  end

  def action(action_name)
    status_wait
    public_send(action_name)
    status
  end

  def running?(running = true)
    is_running = `#{command(:ping)}` =~ /#{command(:pong)}/
    running ? is_running : !is_running
  end

  def start
    return if running?
    system command(:start)
    wait_until(running: true)
  end

  def stop
    return unless running?
    system command(:stop)
    wait_until(running: false)
  end

  private

  def command(command_name)
    COMMANDS[@service_name][command_name]
  end

  def wait_until(running: true, timeout: 10)
    timeout.times do
      break if running?(running)
      sleep(1)
    end
  end
end

case ARGV.count
when 0
  Service.all.each(&:status)
when 1
  Service.all.each { |s| s.action(ARGV[0].to_sym) }
else
  Service.new(ARGV[0].to_sym).action(ARGV[1].to_sym)
end

#!/usr/bin/env ruby

class Service
  COMMANDS = {
    postgresql: {
      start: 'pg_ctl start -D $HOME/.linuxbrew/var/postgres -l logfile > /dev/null',
      stop:  'pg_ctl stop -D $HOME/.linuxbrew/var/postgres 2> /dev/null; sudo pkill postgres 2> /dev/null',
      ping:  'pg_ctl status -D $HOME/.linuxbrew/var/postgres | grep "server is running"',
      pong:  'server is running'
    },
    # mongod: {
    #   start: 'brew services start mongodb > /dev/null',
    #   stop: 'brew services stop mongodb > /dev/null',
    #   ping: 'brew services list | grep -E "mongodb"',
    #   pong: 'started'
    # },
    # mysql: {
    #   start: 'brew services start mysql > /dev/null',
    #   stop: 'brew services stop mysql > /dev/null',
    #   ping: 'brew services list | grep -E "mysql"',
    #   pong: 'started'
    # },
    # nginx: {
    #   start: 'brew services start nginx > /dev/null',
    #   stop: 'brew services stop nginx > /dev/null',
    #   ping: 'brew services list | grep -E "nginx"',
    #   pong: 'started'
    # },
    redis: {
      start: 'redis-server --daemonize yes',
      stop: 'redis-cli shutdown',
      ping: 'ps aux | grep redis-server',
      pong: 'redis-server \*'
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
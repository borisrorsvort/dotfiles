#!/usr/bin/env ruby

class Service
  COMMANDS = {
    postgresql: {
      start: 'sudo service postgresql start > /dev/null',
      stop:  'sudo service postgresql stop > /dev/null',
      ping:  'sudo service postgresql status | grep "active"',
      pong:  'active'
    },
    # mongod: {
    #   start: 'brew services start mongodb > /dev/null',
    #   stop: 'brew services stop mongodb > /dev/null',
    #   ping: 'brew services list | grep -E "mongodb"',
    #   pong: 'started'
    # },
    mysql: {
      start: 'sudo service mysql start > /dev/null',
      stop: 'sudo service mysql stop > /dev/null',
      ping: 'sudo service mysql status | grep "active"',
      pong: 'active'
    },
    # nginx: {
    #   start: 'brew services start nginx > /dev/null',
    #   stop: 'brew services stop nginx > /dev/null',
    #   ping: 'brew services list | grep -E "nginx"',
    #   pong: 'started'
    # },
    redis: {
      start: 'sudo service redis-server start > /dev/null',
      stop: 'sudo service redis-server stop > /dev/null',
      ping: 'sudo service redis-server status | grep "active"',
      pong: 'active'
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

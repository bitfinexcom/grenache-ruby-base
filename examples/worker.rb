$:.unshift File.join(File.dirname(__FILE__), 'lib')
require 'grenache-ruby-base'
require 'pry'

EM.run {
  c = Grenache::Base.new

  c.announce("test",30000) do |cb|
    puts "announce sent: #{cb}"
  end

  EM.add_periodic_timer(1) do
    c.lookup('test') do |response|
      puts "services: #{response[2]}"
    end
  end

}

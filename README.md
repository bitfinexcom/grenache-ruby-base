# grenache-ruby-base

# Configuration

```ruby
Grenache::Base.configure do |conf|
    conf.grape_address = "ws://10.0.0.1:30002"
end
```

# Usage

## Announce a service

```ruby
c = Grenache::Base.new

c.announce("test",30000) do |response|
  #service code
  puts "announce sent: #{response}"
end
```


## lookup for a service

```ruby
c.lookup('test') do |response|
  puts "services: #{response[1]}"
end
```

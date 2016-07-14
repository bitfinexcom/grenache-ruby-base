module Grenache
  class Cache

    def initialize expiring=5
      @cache = {}
      @expiring = expiring
    end

    def has?(key)
      @cache[key][:val] if @cache.keys.include?(key) && @cache[key][:expire] < Time.now
    end

    def save(key, val)
      @cache[key] = { val: val, expire: Time.now+@expiring }
      val
    end

  end
end

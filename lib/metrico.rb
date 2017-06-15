require 'nats/io/client'
require 'metrico/version'

module Metrico
  require 'metrico/client'
  require 'metrico/config'
  require 'metrico/point'

  class << self
    attr_accessor :config

    def configure
      self.config ||= Config.new
      yield(config)
    end

    def client
      @client ||= Client.new
    end

    def push(name, fields, tags = {})
      point = Point.new(name, fields, tags)
      client.push(point)
    end
  end
end

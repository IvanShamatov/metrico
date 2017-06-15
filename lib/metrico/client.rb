module Metrico
  class Client
    attr_reader :transport

    def initialize
      @transport = NATS::IO::Client.new
      @transport.connect(
        servers: Metrico.config.nodes
      )
    end

    def push(point)
      transport.publish(Metrico.config.subject, point.to_s)
    end
  end
end

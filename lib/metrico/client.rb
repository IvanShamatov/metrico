module Metrico
  class Client
    attr_reader :transport

    def initialize
      @transport = NATS::IO::Client.new
      @transport.connect(Metrico.config.nats_connect_options)
      transport_callbacks
    end

    def push(point)
      transport.publish(Metrico.config.subject, point.to_s)
    end

    private def transport_callbacks
      %w[on_error on_reconnect on_disconnect on_close].each do |callback|
        if Metrico.config.send(callback)
          @transport.send(callback, &Metrico.config.send(callback))
        end
      end
    end
  end
end

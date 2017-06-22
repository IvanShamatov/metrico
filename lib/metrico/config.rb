module Metrico
  class Config
    attr_accessor(
      :enabled, :app_name, :hostname,
      :subject, :nats_connect_options,
      :on_error, :on_reconnect,
      :on_disconnect, :on_close
    )

    def initialize
      @subject = 'metrico'
    end
  end
end

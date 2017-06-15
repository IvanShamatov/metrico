module Metrico
  class Config
    attr_accessor :nodes,
                  :app_name,
                  :hostname,
                  :subject

    def initialize
      @subject = 'metrico'
    end
  end
end

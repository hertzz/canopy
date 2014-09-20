module Canopy
  class <<self

    attr_writer :config

    def config
      return Canopy::Configuration.new
    end

  end
end

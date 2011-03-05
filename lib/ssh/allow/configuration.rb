module SSH::Allow

  class Configuration
    attr_reader :rules, :error

    def initialize
      @rules = []
      @error = nil
    end

    def valid?
      error.nil?
    end

  end

end
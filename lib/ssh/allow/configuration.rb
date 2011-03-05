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

    def allow(cmd)
      rule = parse_command(cmd)
      @rules << rule
    end

    def reset!
      @rules = []
    end

    private

      def parse_command(cmd)
        SSH::Allow::Rule.parse(cmd)
      end
  end

end

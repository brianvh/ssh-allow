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

    def allow(cmd, &block)
      add_rule parse_command(cmd, block)
    end

    def reset!
      @rules.clear
    end

    private

      def add_rule(rule)
        rule.valid? ? @rules.push(rule) : false
      end

      def parse_command(cmd, &block)
        SSH::Allow::Rule.parse(cmd, block)
      end
  end

end

module SSH::Allow
  class Rule
    def initialize
      @command = []
      @options = []
      @args = []
    end

    def valid?
      !(@command.empty? || @options.empty? || @args.empty?)
    end

  end
end

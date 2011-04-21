module RuleSetHelpers
  def sample_rules
    %(
    allow!('foo') do
      puts 'foo'
    end
    allow!('bar') do
      puts 'bar'
    end
    ).gsub(/^ {4}/, '')
  end
end
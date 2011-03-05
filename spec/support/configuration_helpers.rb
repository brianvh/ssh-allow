module ConfigurationHelpers
  def mock_rule(name, valid=true)
    rule = mock(name)
    rule.should_receive(:valid?).once.and_return(valid)
    rule
  end

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
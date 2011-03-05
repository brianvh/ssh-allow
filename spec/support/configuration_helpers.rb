module ConfigurationHelpers
  def mock_rule(name, valid=true)
    rule = mock(name)
    rule.should_receive(:valid?).once.and_return(valid)
    rule
  end
end
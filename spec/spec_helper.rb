require File.dirname(__FILE__) + "/../lib/give4each"

# for version dependences
RSpec.configure do |c|
  # example ruby: 1.8 do # ..
  c.filter_run_excluding :ruby => lambda { |version|
    !(RUBY_VERSION.to_s =~ /^#{version.to_s}/)
  }
end
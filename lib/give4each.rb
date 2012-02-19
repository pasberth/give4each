$:.unshift File.dirname(__FILE__)

module Give4Each
  VERSION = "0.0.2"
end

require "give4each/private_helpers"
require "give4each/method_chain"
require "give4each/core_ext"
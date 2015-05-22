module Translator
  class NullStream
    def puts(o); end
    alias :write :puts
    alias :<< :puts
  end
end

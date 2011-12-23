# Fixes the stupid error: 
# /gems/rack-1.2.4/lib/rack/utils.rb:16: warning: regexp match /.../n against to UTF-8 string

module Rack
  module Utils
    def escape(s)
      CGI.escape(s.to_s)
    end
    def unescape(s)
      CGI.unescape(s)
    end
  end
end

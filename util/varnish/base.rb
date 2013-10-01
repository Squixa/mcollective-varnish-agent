module MCollective
  module Util
    module Varnish
      class Base
        attr_reader :initialized, :varnish_version
        alias initialized? initialized
        def initialize(*args)
          @initialized = true
        end


        def run(cmd)
          command_output = `#{cmd}`
          fail "Could not run command: #{cmd}." unless $?.success? 
          return command_output
        end
        
        def discover_varnish_version
          version_output = run("/usr/sbin/varnishd -V 2>&1")
          if version_output =~ /varnish-(\d)/ and [2,3].include?($1.to_i)
            @varnish_version = $1.to_i
          else 
            raise "Could not detect valid varnish version."
          end
        end

        def parse_url(url)
          parsed = URI.parse(url)
          unless parsed.scheme == "http"
            raise ArgumentError, "#parse_url require full http url as parameter"
          end 
          [parsed.host, parsed.request_uri]
        end
      end
    end
  end
end

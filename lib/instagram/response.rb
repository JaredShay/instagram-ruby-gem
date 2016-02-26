module Instagram
  module Response
    def self.create( response_hash, ratelimit_hash )
      # This ensures the response_hash is never nil.
      #
      # Nil is frozen in ruby 1.9+ so this is required to make this gem
      # work with any newer version of ruby.
      response_hash = {} unless response_hash

      data = response_hash.data.dup rescue response_hash
      data.extend( self )

      data.instance_exec do
        %w{pagination meta}.each do |k|
          response_hash.public_send(k).tap do |v|
            instance_variable_set("@#{k}", v) if v
          end
        end
        @ratelimit = ::Hashie::Mash.new(ratelimit_hash)
      end

      data
    end

    attr_reader :pagination
    attr_reader :meta
    attr_reader :ratelimit
  end
end

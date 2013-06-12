module Elasticsearch
  module Client
    module Transport
      module HTTP

        # Alternative HTTP transport implementation, using the [_Curb_](https://rubygems.org/gems/curb) client.
        #
        # @see Transport::Base
        #
        class Curb
          include Base

          # Performs the request by invoking {Transport::Base#perform_request} with a block.
          #
          # @return [Response]
          # @see    Transport::Base#perform_request
          #
          def perform_request(method, path, params={}, body=nil)
            super do |connection,url|
              connection.connection.url = url

              case method
                when 'HEAD', 'GET' then connection.connection.http method.downcase.to_sym
                when 'PUT'         then connection.connection.http_put serializer.dump(body)
                when 'DELETE'      then connection.connection.http_delete
                when 'POST'
                  connection.connection.post_body = __convert_to_json(body) if body
                  connection.connection.http_post
                else raise ArgumentError, "Unsupported HTTP method: #{method}"
              end

              Response.new connection.connection.response_code, connection.connection.body_str
            end
          end

          # Builds and returns a collection of connections.
          #
          # @return [Connections::Collection]
          #
          def __build_connections
            Connections::Collection.new \
              :connections => hosts.map { |host|
                host[:protocol] ||= DEFAULT_PROTOCOL
                host[:port]     ||= DEFAULT_PORT

                client = ::Curl::Easy.new
                client.resolve_mode = :ipv4
                client.headers      = {'Content-Type' => 'application/json'}
                client.url          = "#{host[:protocol]}://#{host[:host]}:#{host[:port]}"

                client.instance_eval &@block if @block

                Connections::Connection.new :host => host, :connection => client
              },
              :selector => options[:selector]
          end

          # Returns an array of implementation specific connection errors.
          #
          # @return [Array]
          #
          def host_unreachable_exceptions
            [::Curl::Err::HostResolutionError, ::Curl::Err::ConnectionFailedError]
          end
        end

      end
    end
  end
end

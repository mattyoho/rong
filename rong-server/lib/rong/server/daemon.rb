require 'socket'

module Rong
  module Server
    class Daemon
      attr_accessor :listener

      def run
        open_listening_socket
        puts "Server is running..."
        loop do
          wait_for_connections do |clients|
            Thread.new do
              Rong::Elements::Game.new(clients).start
            end
          end
        end
      end

      def open_listening_socket
        self.listener = Socket.new(Socket::AF_INET, Socket::SOCK_DGRAM)
        address  = Socket.pack_sockaddr_in(7664, Socket::INADDR_LOOPBACK)
        listener.bind(address)
        listener.listen(3)
      end

      def wait_for_connections
        clients = []
        until clients.count == 2
          client, addr = listener.accept
          clients << client
        end
        yield clients if block_given?
        clients
      end
    end
  end
end

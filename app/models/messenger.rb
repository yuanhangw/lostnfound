require 'SocketIO'

class Messenger
  def self.send_message!(name, args)
    puts "hello"
    begin
      SocketIO.connect("http://localhost:5000") do
        puts "connected"
        after_start do
          puts "emitting"
          emit(name, args)
          on_event('from_socket_io') { |data| puts data.first}
          disconnect
        end
      end
    rescue
    end
  end
end
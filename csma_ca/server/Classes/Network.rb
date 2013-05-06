# This class implement the Network layer of the server.

require         'socket'

Packet = Struct.new(:id, :content)
Client = Struct.new(:name, :room, :socket)

class           Network
  
  def           initialize(port)
    @id_users = 1
    @port = port
    # Used only in select()
    @fds = []
    # Used for the Protocol part
    # In order to ease the communication
    # Between each client
    @clients = Hash.new("Clients manager")
    @packets = Array.new
  end

  def           main_loop
    begin
      # Create a TCPServer. 0.0.0.0 => all IP address.
      acceptor = TCPServer.open('0.0.0.0', @port)
      # Initialize an array with server socket
      @fds << acceptor
      while (true)
        if socket_descriptors = select(@fds, [], [], 10)
          # socket_descriptors.first contain a collection of readable sockets
          readable(socket_descriptors.first, acceptor)
          write_packets
        end
      end
    rescue Interrupt
      puts "\nBye Bye !"
    ensure
      @fds.each {|c| c.close}
    end
  end

  private
  def           readable(reads, acceptor)
    src_id = "R2D2"
    reads.each do |client|
      @clients.each_key do |key|
        if (@clients[key][:socket].object_id.to_s == client.object_id.to_s)
          src_id = key
        end
      end
      # New client
      if client == acceptor
        new_client(acceptor)
      elsif client.eof?
        disconnect_client(client, src_id)
        # Readable socket
      else
        cmd = client.gets("\n").chop!
        handle_packet(cmd, src_id)
      end
    end
  end

  def write_packets
    if (@packets.empty? == false)
      @clients.each_key do |key|
        @packets.each_index do |i|
          if (@packets[i][:id].to_s == key.to_s)
            @clients[key][:socket].puts(@packets[i][:content])
            print "\033[32m[#{Time.now.inspect}]\033[0m "
            puts "To user #{@clients[key][:name]}: #{@packets[i][:content]}"
            @packets.delete_at(i)
          end
        end
      end
    end
  end

  def           new_client(acceptor)
    new_client = acceptor.accept
    print "\033[34m[#{Time.now.inspect}]\033[0m "
    puts "New client !"
    src_id = new_client.object_id.to_s
    @fds << new_client
    @clients[src_id] = Client.new("computer#{@id_users}", "all", new_client)
    @packets << Packet.new(src_id, @clients[src_id][:name])
    @id_users += 1
  end

  def           disconnect_client(client, src_id)
    @fds.delete(client)
    @clients.each_key do |key|
      if (key != src_id)
        @packets << Packet.new(key, "#{@clients[src_id][:name]} is disconnected !")
      end
    end
    @clients.delete(src_id)
    client.close
    print "\033[31m[#{Time.now.inspect}]\033[0m "
    puts "Client #{src_id} is disconnected !"
  end

  def           handle_packet(cmd, src_id)
    packet = cmd.split(" ")
    print "\033[32m[#{Time.now.inspect}]\033[0m "
    puts "Start of transmission"
    sleep(packet[1].to_f)
    print "\033[32m[#{Time.now.inspect}]\033[0m "
    puts "End of transmission"
    @clients.each_key do |key|
      if (@clients[key][:name] == packet[2])
        @packets << Packet.new(key, cmd)
        break
      end
    end
  end
end

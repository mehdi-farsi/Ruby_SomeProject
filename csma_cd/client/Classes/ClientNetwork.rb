# This class implement the Network layer of the server.

require         'socket'

Client = Struct.new(:name, :room)

class           ClientNetwork

  def             initialize(address, port)
    @delay = 0.5
    @socket_server
    @port = port
    @address = address
    @fds = []
  end
  
  def           launch_client
    @socket_server = TCPSocket.open(@address, @port)
    @client = Client.new("guest", "all")
    packet = @socket_server.gets
    @client[:name] = packet.split(/\.?\s+/).first
    puts "You are now connected on the medium with nick #{@client[:name]}"
    if (@client[:name] == "computer1")
      sleep(3)
      @socket_server.puts("computer2 computer1 ARP blabla none")
    end
    @fds << @socket_server
    @fds << STDIN
  end

  def           main_loop
    begin
      launch_client
      # Activation of real-time displaying
      while (true)
        if (socket_descriptors = select(@fds, [], []))
          readable(socket_descriptors.first)
        end
      end
      @socket_server.close
    rescue Interrupt
      @socket_server.close
      puts "\nBye Bye !"
    ensure
    end
  end

  private
  
  def             readable(reads)
    reads.each do |client|
      if (client.object_id.to_s == @socket_server.object_id.to_s)
        cmd = get_reply_server(client)
        handler_function(cmd)
      else
        cmd = STDIN.gets
        if (cmd.chomp.empty? == false)
        end
      end
    end
  end
  
  def           get_reply_server(client)
    data = client.gets
    if (data == nil)
      @socket_server.close
      puts "\n#{@address}:#{@port} brutally disconnected !"
      exit
    end
    return data
  end
  
  def           handler_function(cmd)

    packet = cmd.chop!.split(" ")
    if (packet[2] == "COLLISION")
      puts "\n********************"
      puts "COLLISON computer has to wait #{packet[3]}"
      puts "\n********************"
      sleep(packet[1].to_f)
    else
      puts "\n********************"
      puts "FRAME CONTENT:"
      puts "Dest. address: #{packet[0]}"
      puts "Source address: #{packet[1]}"
      puts "Type: #{packet[2]}"
      puts "Data: #{packet[3]}"
      puts "Sequence ctrl.: #{packet[4]}"
      puts "\n********************"
    end
    if (packet[0] == "computer1")
      @socket_server.puts("computer2 computer1 ARP blabla none")
    else
      @socket_server.puts("computer1 computer2 ARP blabla none")
    end
  end
  
end

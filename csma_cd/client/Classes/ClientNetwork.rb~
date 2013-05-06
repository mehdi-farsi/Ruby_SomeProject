# This class implement the Network layer of the server.


require         'socket'


Client = Struct.new(:name, :room)

class           ClientNetwork

  def             initialize(address, port)
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
      STDIN.gets("\n")
      @socket_server.puts("none 0.5 computer2 computer1 none rts")
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
    puts "\n********************"
    puts "FRAME CONTENT:"
    puts "Frame content: informations"
    puts "Duration: #{packet[1]}s"
    puts "Dest. address: #{packet[2]}"
    puts "Source address: #{packet[3]}"
    puts "Sequence ctrl.: #{packet[4]}"
    puts "CRC: #{packet[5]}"
    puts "\n********************"
    case packet[5].downcase
    when "rts"
      @socket_server.puts("none 0.5 #{packet[3]} #{packet[2]} #{packet[4]} cts")
    when "cts"
      @socket_server.puts("none 0.5 #{packet[3]} #{packet[2]} #{packet[4]} data")
    when "data"
      @socket_server.puts("none 0.5 #{packet[3]} #{packet[2]} #{packet[4]} ack")
    when "ack"
      @socket_server.puts("none 0.5 #{packet[3]} #{packet[2]} #{packet[4]} rts")
    end
  end
  
end

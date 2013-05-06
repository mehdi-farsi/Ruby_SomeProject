$LOAD_PATH << "/var/lib/gems/1.8/gems/awesome_print-1.1.0/lib/"
require "awesome_print"

Client = Struct.new(:pupi, :cid, :slot_number, :status)

def main
  clients = []
  last_active_picc = 2  

  nb_tag = ARGV[0].to_i
  nb_tag.times do |index|
    clients << Client.new(rand(4294967294), index + 2, index + 2, "IDLE")
  end

  puts "PCD is now turned on!"
  puts "#{nb_tag} tags detected on field!"
  clients.each do |client|
    puts "Polling command from PCD to client with cid[#{client[:cid]}]: WUPB\n\n"
  end
  ap clients, :multiline => false
  sleep(0.5)
  to_halt = false
  while true
    tmp = false
    i = 1
    while i <= nb_tag + 1
      
      clients.each do |client|
        if client[:cid] == last_active_picc && tmp == false
          case client[:status]
          when "IDLE"
            puts "PICC with cid [#{client[:cid]}] send ATQB with pupi[#{client[:pupi]}]"
            puts "PCD select the client with pupi[#{client[:pupi]}] with command ATTRIB"
            puts "Client with cid #{client[:cid]} is now ACTIVE"            
            client[:status] = "ACTIVE"
          when "ACTIVE"
            puts "PCD deselect the client with pupi[#{client[:pupi]}] with command HLTB"
            client[:status] = "HALT"
          end
          tmp = true
          sleep(0.5)
        end
      end
      if (i == 1)
        clients.each do |client|
          case client[:status]
          when "ACTIVE"
            puts "Any data transmission with CID[#{client[:cid]}]"
          end
        end
      else
        clients.each do |client|
          case client[:status]
          when "ACTIVE"

          end
        end
      end
      i = i+1
    end
    if to_halt == false
      last_active_picc = last_active_picc + 1
    end  
    if last_active_picc > nb_tag+1 || to_halt == true
      if (to_halt == false)
        p clients
      end
      to_halt = true
      last_active_picc = last_active_picc - 1
      if last_active_picc <= 0
        p clients
        return
      end
    end
    sleep(0.5)
  end
end

main




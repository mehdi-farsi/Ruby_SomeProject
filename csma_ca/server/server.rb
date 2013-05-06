require 'Classes/Network'

def main
  n = Network.new(4242)
  puts "  *** CSMA/CA 1.0 (Simulation of MEDIUM)  ***"
  puts "*** developed by Samy Baili && Mehdi Farsi  ***"
  n.main_loop
end

main

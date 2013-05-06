$LOAD_PATH << "/var/lib/gems/1.8/gems/awesome_print-1.1.0/lib/"
require "awesome_print"
require "digest"

Router = Struct.new(:r1, :k, :id)
Transmitter = Struct.new(:r2, :k, :id)

def ror(count1, count2)
  return (count1 >> count2) | (count1 << (32 - count2)) & 0xFFFFFFFF
end

def             main
  router = Router.new(rand(4294967294),
                      rand(4294967294),
                      rand(4294967294))

  transmitter = Transmitter.new(rand(4294967294),
                                router[:k],
                                router[:id])

  puts "Router send r1[#{router[:r1]}] to Transmitter"
  sleep(0.5)

  print "Transmitter side: g = SHA1(r1^r2^k) = "
  g = Digest::SHA1.hexdigest((router[:r1]^transmitter[:r2]^router[:k]).to_s)
  ap g
  sleep(0.5)
  print "Transmitter side: ID2 = rotate(ID, g) = "
  id2 = ror(transmitter[:id], g.to_i)
  puts "#{id2}"
  sleep(0.5)

  match_key_transmitter = "%08X" % (id2^g.to_i)
  puts "Transmitter send r2[#{transmitter[:r2]}] and LeftHalf(ID2^g) = #{match_key_transmitter[0..3]}"
  sleep(0.5)


  print "Router side: g = SHA1(r1^r2^k) = "
  g = Digest::SHA1.hexdigest((router[:r1]^transmitter[:r2]^router[:k]).to_s)
  ap g
  sleep(0.5)

  id2 = ror(router[:id], g.to_i)  
  puts "Router side: ID2 = rotate(ID, g) = #{id2}"
  sleep(0.5)

  match_key_router = "%08X" % (id2^g.to_i)
  puts "Router side: LeftHalf(ID2^g) = #{match_key_transmitter[0..3]} from Transmitter match with LeftHalf(ID2^g) = #{match_key_router[0..3] } from Router"

  sleep(0.5)
  puts "Router send RightHalf(ID2^g) = #{match_key_router[4..7]} to Transmitter"
  sleep(0.5)
  puts "Transmitter side: RightHalf(ID2^g) = #{match_key_transmitter[4..7]} from Transmitter match with RightHalf(ID2^g) = #{match_key_router[4..7]} from Router"
end

main

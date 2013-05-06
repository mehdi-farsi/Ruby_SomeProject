# Binary Exponential Backoff -- algorithm
# n == 2^C (C represent the number of collisions appeared)
# n1 == the sum of each number contained in n

n = (2**3)
n1 = 0
n.times do |i|
  n1 += (i)
end
e_collision = (1/n.to_f) * n1

puts "result: #{e_collision}"

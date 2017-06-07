def cut(m, n, num_bar)
  if num_bar >= n then
    return 0
  elsif num_bar <= m then
    return 1 + cut(m, n, 2*num_bar)
  elsif num_bar > m then
    return 1 + cut(m, n, num_bar + m)
  end
end

puts cut(3, 20, 1)
puts cut(5, 100, 1)

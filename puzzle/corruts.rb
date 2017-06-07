def corruts2(n, origin)
  while true do
    if n == origin then
      return 1
    elsif n == 1 then
      return 0
    elsif n%2 == 0 then
      n = n/2
    else n = n*3+1
    end
  end
end

result = 0
for num in 1..5000 do
  result += corruts2(2*num*3+1, 2*num)
end
puts result

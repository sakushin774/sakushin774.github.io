cards = Array.new(101, false)
for n in 2..100 do
  m = 0
  while n*(m+1) <= 100 do
    cards[n*(m+1)] = !cards[n*(m+1)]
    m +=1
  end
end
for i in 1..100 do
  if cards[i] == false then
    puts i
  end
end

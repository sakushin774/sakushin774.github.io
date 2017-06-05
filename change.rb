coins = [500, 100, 50, 10]

def change(input, c_index, num, coins)
  if input == 0 then
    return 1
  elsif c_index > 3 then
    return 0
  end
  result = 0
  c = coins[c_index]
  for c_num in 0..(input.div(c)) do
    if num + c_num > 15 then
      break
    end
    result += change(input - c * c_num, c_index + 1, num + c_num, coins)
  end
  return result
end

puts change(1000, 0, 0, coins)

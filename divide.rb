man = 20
woman = 10
man = man + 1
woman = woman + 1
ary = Array.new(man * woman, 0)
ary[0] = 1
man.times do |m|
  woman.times do |w|
    if m == w || woman - w == man - m then next end
    ary[m + man * w] += ary[m + man * w - 1] if m > 0
    ary[m + man * w] += ary[m + man * (w - 1)] if w > 0
  end
end

puts ary[-2] + ary[-1-man]

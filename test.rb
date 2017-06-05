#配列はオブジェクトへの参照なのでローカル変数的には使えない
#対策としては.dupが有効
#二次元配列なら中身を.dupしなければならない

t = 0
ary = [1, 2, 3, 4, 5]

def tes(num, ary)
  if num == 0 then
    #p ary
    #puts ""
    return 0
  end
  ary[num] += 1
  tes(num-1, ary)
  tes(num-1, ary)
end

tes(3, ary)

A = 3
B = 4
r = 0
B.times do |b|
  A.times do |a|
    if a == 0 then next end
    r += 1
  end
end

puts r

ary = ["1","2","3","4","5"]
puts ary.inject(){|res, i| res << i }

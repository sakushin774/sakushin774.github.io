#フィボナッチ数列のうち各桁の数の和で割り切れるものを小さい順にN個出力する。
#例) 21: 21/(2+1)=7,  144: 144/(1+4+4)=16

N = 20

def fib(x)
  str = x.to_s()
  ary = str.split("").map(&:to_i)
  sum = ary.inject(:+)
  if x%sum == 0 then
    puts x
    return true
  end
  return false
end

x1 = 1
x2 = 1
count = 0
while true do
  count += 1 if fib(x2)
  break if count == N
  tmp = x1
  x1 = x2
  x2 = tmp + x2
end

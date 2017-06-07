N = 12
field = Array.new(N*2+1)
for i in 0..N*2 do
  field[i] = Array.new(N*2+1, false)
end
field[N][N] = true

def robotPattern(field, steps, x, y)
  if field[y][x] && steps < N then
    return 0
  elsif steps === 0 then
    return 1
  end
  result = 0
  field[y][x] = true
  result += robotPattern(field, steps-1, x+1, y)
  result += robotPattern(field, steps-1, x, y+1)
  result += robotPattern(field, steps-1, x-1, y)
  result += robotPattern(field, steps-1, x, y-1)
  field[y][x] = false
  #trueにしたfieldをfalseに戻さないとそのままになる
  #Rubyでは配列はグローバル扱い？
  return result
end
puts robotPattern(field, N, N, N)

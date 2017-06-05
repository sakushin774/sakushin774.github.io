num = 1
while
  num += 1
  root = num ** 0.5
  str = root.to_s()
  #str.slice!(/\./) #整数を含む場合
  str.slice!(/.*\./) #整数を含まない場合
  str = str[0..9]
  if str.split("").uniq.length == 10 then
    puts num
    break
  end
end

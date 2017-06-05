#日付をYYYYMMDDの形式で表したものを2進数に変換し
#逆に並べて10進数に戻した日付が元の日付と一致するものを求める

require 'date'
start = Date.new(1964, 10, 10)
goal = Date.new(2020, 7, 24)

for date in start..goal do
  strDate = date.strftime("%Y%m%d")
  biDate = strDate.to_i(10).to_s(2)
  revDate = biDate.reverse().to_i(2).to_s(10)
  if strDate == revDate then
    puts strDate
  end
end

puts DateTime.new(1900, 1, 1, 0, 0) + 4294967296

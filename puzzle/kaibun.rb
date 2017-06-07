#2進数、8進数、10進数のすべてで回文となる10以上の最小の数を計算する
 num = 11
while true do
    if  num.to_s(10) == num.to_s(10).reverse &&
       num.to_s(2) == num.to_s(2).reverse &&
       num.to_s(8) == num.to_s(8).reverse then
        puts num
        break
    end
   num +=2  #2進数の回文は必ず奇数になのでを足す
end

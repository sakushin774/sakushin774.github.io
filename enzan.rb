#4桁の自然数を逆順にして演算子で繋いだ結果が元の数と一致する数を求める
opArray = ["+", "-", "*", "/", ""]
for num in 1000..9999 do
  str = num.to_s
  for op1 in 0..4 do
    for op2 in 0..4 do
      for op3 in 0..4 do
        val = str[3] + opArray[op3] + str[2] + opArray[op2] + str[1] + opArray[op1] + str[0]
        #rubyでは0から始まる数は八進数として扱われるので飛ばす
        if ((str[3] == "0" && opArray[op3] == "") ||
            (str[2] == "0" && opArray[op2] == "") ||
            (str[1] == "0" && opArray[op1] == "")) then
          next
        end
        #0での除算を飛ばす
        if (val.index("/0")) then
          next
        end
        if (eval(val) == num && val.length > 4) then
           puts val
        end
      end
    end
  end
end

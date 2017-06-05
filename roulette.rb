MAX_N =  36
European = [0,32,15,19,4,21,2,25,17,34,6,27,13,36,11,30,8,23,10,5,24,16,33,1,20,14,31,9,22,18,29,7,28,12,35,3,26]
American = [0,28,9,26,30,11,7,20,32,17,5,22,34,15,3,24,36,13,1,00,27,10,25,29,12,8,19,31,18,6,21,33,16,4,23,35,14,2]
count = 0
for n in 2..MAX_N
  maxSumE = 0
  maxSumA = 0
  for j in 0..American.length do
    sumE = 0
    sumA = 0
    for i in 0..n-1 do
      if i+j > 36 then
        sumE += European[i+j-37]
      else
        sumE += European[i+j]
      end
      if i+j > 37 then
        sumA += American[i+j-38]
      else
        sumA += American[i+j]
      end
    end
    maxSumE = sumE if maxSumE < sumE
    maxSumA = sumA if maxSumA < sumA
  end

  if maxSumE < maxSumA then
     count += 1
  end
end

puts count

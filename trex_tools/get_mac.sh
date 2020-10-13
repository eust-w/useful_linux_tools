a=(`ip a | grep ^[1-9] | awk -F: '{print $2}' | sed '1,2d'`)
for ((i=0;i<2;i++))
  do
    b[$i]=`ip link show ${a[$i]} |head -2|tail -1|awk '{print $2}'`
  done
  echo ${b[0]}'&'${b[1]}


#!/bin/bash
blocksize=5
blockrow=4
rowcount=10
pagecount=10
otpath='/ramdisk/otp.txt'
bookserial=`base64 /dev/random | tr -d '+/\r\n0-9a-z' | head -c 10`

fsram=`file -s /dev/ram1 | cut -f5 -d " "`
if [ "$fsram" != "ext2" ]; then
  mkfs -q /dev/ram1 1024
fi

if [ ! -d "/ramdisk/" ]; then
  mkdir -p /ramdisk
fi

findmnt --source "/dev/ram1" > /dev/null
status=$?
if test $status -ne 0; then
  mount /dev/ram1 /ramdisk
fi

if [ -f "$otpath" ]; then
  rm $otpath
fi

for ((x=1; x<=$pagecount; x++))
do  
  echo -n $bookserial >> $otpath;
  printf '%22s' $x"/"$pagecount >> $otpath;
  echo "" >> $otpath;
  for ((i=1; i<=$rowcount; i++))
  do
    for ((j=1; j<=$blockrow; j++))
    do
        randnum=`base64 /dev/random | tr -d '+/\r\n0-9a-z' | head -c $blocksize`
        echo -n $randnum >> $otpath;
        echo -n "  " >> $otpath;
    done
      echo "" >> $otpath;
  done
  echo "--------------------------------" >> $otpath
done

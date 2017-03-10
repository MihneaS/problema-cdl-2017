#!/bin/bash

executable=cdl.awk

tests[0]=tests/test0.log
tests[1]=tests/test1.log
tests[2]=tests/test2.log
tests[3]=tests/test3.log
tests[4]='tests/test4.log --interval 2'
tests[5]='tests/test5.log --interval 5'
tests[6]='tests/test6.log --interval 60'
tests[7]='tests/test7.log --interval 2 --start 2016-01-18T12:23'
tests[8]='tests/test8.log --interval 5 --end 2016-11-21T04:52'
tests[9]='tests/test9.log --interval 60 --start 2016-04-11T08:37 --end 2017-03-14T14:06'
tests[10]='tests/test10.log --interval 30 --success 20x,3xx,404i'

scor=0
echo nUUUUU
for i in tests; do
	awk -f $executable ${test[$i]} > "output/test$i.out"
    echo $i
    if diff output/test$i.out reference/test$i.ref >diffs/test$i.diff; then
        scor+=10;
        echo "test $i ... ... ... ... ... ... ... ... ... 10"
    else
        echo "test $i ... ... ... ... ... ... ... ... ...  0"
    fi
done

echo         "Total   ... ... ... ... ... ... ... ... ... $scor/110";



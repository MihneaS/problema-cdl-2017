#!/bin/bash

scor=0

awk -f cdl.awk tests/test0.log 2>/dev/null >output/test0.out 
if diff output/test0.out reference/test0.ref >diffs/test0.diff; then
    scor+=10
    echo "test  0 ... ... ... ... ... ... ... ... ... 10"
else
    echo "test  0 ... ... ... ... ... ... ... ... ...  0"
fi

awk -f cdl.awk tests/test1.log 2>/dev/null >output/test1.out 
if diff output/test1.out reference/test1.ref >diffs/test1.diff; then
    scor+=10
    echo "test  1 ... ... ... ... ... ... ... ... ... 10"
else
    echo "test  1 ... ... ... ... ... ... ... ... ...  0"
fi

awk -f cdl.awk tests/test2.log 2>/dev/null >output/test2.out 
if diff output/test2.out reference/test2.ref >diffs/test2.diff; then
    scor+=10
    echo "test  2 ... ... ... ... ... ... ... ... ... 10"
else
    echo "test  2 ... ... ... ... ... ... ... ... ...  0"
fi

awk -f cdl.awk tests/test3.log 2>/dev/null >output/test3.out 
if diff output/test3.out reference/test3.ref >diffs/test3.diff; then
    scor+=10
    echo "test  3 ... ... ... ... ... ... ... ... ... 10"
else
    echo "test  3 ... ... ... ... ... ... ... ... ...  0"
fi

awk -f cdl.awk tests/test4.log 2>/dev/null >output/test4.out 
if diff output/test4.out reference/test4.ref >diffs/test4.diff; then
    scor+=10
    echo "test  4 ... ... ... ... ... ... ... ... ... 10"
else
    echo "test  4 ... ... ... ... ... ... ... ... ...  0"
fi

awk -f cdl.awk tests/test5.log 2>/dev/null >output/test5.out 
if diff output/test5.out reference/test5.ref >diffs/test5.diff; then
    scor+=10
    echo "test  5 ... ... ... ... ... ... ... ... ... 10"
else
    echo "test  5 ... ... ... ... ... ... ... ... ...  0"
fi

awk -f cdl.awk tests/test6.log 2>/dev/null >output/test6.out 
if diff output/test6.out reference/test6.ref >diffs/test6.diff; then
    scor+=10
    echo "test  6 ... ... ... ... ... ... ... ... ... 10"
else
    echo "test  6 ... ... ... ... ... ... ... ... ...  0"
fi

awk -f cdl.awk tests/test7.log 2>/dev/null >output/test7.out 
if diff output/test7.out reference/test7.ref >diffs/test7.diff; then
    scor+=10
    echo "test  7 ... ... ... ... ... ... ... ... ... 10"
else
    echo "test  7 ... ... ... ... ... ... ... ... ...  0"
fi

awk -f cdl.awk tests/test8.log 2>/dev/null >output/test8.out 
if diff output/test8.out reference/test8.ref >diffs/test8.diff; then
    scor+=10
    echo "test  8 ... ... ... ... ... ... ... ... ... 10"
else
    echo "test  8 ... ... ... ... ... ... ... ... ...  0"
fi

awk -f cdl.awk tests/test9.log 2>/dev/null >output/test9.out 
if diff output/test9.out reference/test9.ref >diffs/test9.diff; then
    scor+=10
    echo "test  9 ... ... ... ... ... ... ... ... ... 10"
else
    echo "test  9 ... ... ... ... ... ... ... ... ...  0"
fi

awk -f cdl.awk tests/test10.log 2>/dev/null >output/test10.out 
if diff output/test10.out reference/test10.ref >diffs/test10.diff; then
    scor+=10
    echo "test 10 ... ... ... ... ... ... ... ... ... 10"
else
    echo "test 10 ... ... ... ... ... ... ... ... ...  0"
fi

echo         "Total   ... ... ... ... ... ... ... ... ... $scor/110";

#!/usr/bin/env bash

function test_solution()
{
    local PROBLEM=${1%*.swift}
    PROBLEM=${PROBLEM#day*}

    echo -n "day $PROBLEM: "
    $1 < input${PROBLEM}.txt > test.txt

     if [ -e test.txt ] && { diff expected-output${PROBLEM}.txt test.txt; }
    then
        echo "passed"
    fi

    rm -f test.txt
}

for solution in *day*.swift
do
    test_solution $solution
done

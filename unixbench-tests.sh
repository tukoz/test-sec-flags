#!/bin/bash

set -e

basedir=`pwd`
results="$basedir/unixbench-results.txt"

if [ ! -f 'unixbench-results.txt' ]
    then
        touch unixbench-results.txt
    else
        echo -e "Unixbench has already been cloned. Continuing..."
fi

unixbenchrepo=https://github.com/kdlucas/byte-unixbench.git
localdir=unixbench

if [ ! -d "$localdir" ]
    then
        echo -e "Cloning unixbench..."
        git clone --depth 1 "$unixbenchrepo" "$localdir"
    else
        echo -e "Unixbench has already been cloned. Continuing..."
fi

cd "$localdir"/UnixBench

# reset Makefile and patch CFLAGS to append project-specific flags
git checkout Makefile
sed 's/^CFLAGS =/CFLAGS +=/g' -i Makefile

echo -e "Compiling with -fstack-protector-strong, full relro, PIE"
make clean
CFLAGS='-Wl,-z,relro,-z,now -fstack-protector-strong -D_FORTIFY_SOURCE=2 -pie -fPIE' make
echo -e "Compilation finished, running test 5"
bash -c './Run' &>> $results
echo -e "Test 5 completed."


echo -e "Compiling with -fstack-protector-strong, full relro, PIE, -fstack-check"
make clean
CFLAGS='-Wl,-z,relro,-z,now -fstack-protector-strong -D_FORTIFY_SOURCE=2 -pie -fPIE -fstack-check' make
echo -e "Compilation finished, running test 6"
bash -c './Run' &>> $results
echo -e "Test 6 completed."


echo -e "Compiling with -fstack-protector-strong, full relro, PIE, -fno-plt"
make clean
CFLAGS='-Wl,-z,relro,-z,now -fstack-protector-strong -D_FORTIFY_SOURCE=2 -pie -fPIE -fno-plt' make
echo -e "Compilation finished, running test 7"
bash -c './Run' &>> $results
echo -e "Test 7 completed."


echo -e "Compiling with -fstack-protector-strong, full relro, PIE, -fno-plt, and -fstack-check"
make clean
CFLAGS='-Wl,-z,relro,-z,now -fstack-protector-strong -D_FORTIFY_SOURCE=2 -pie -fPIE -fno-plt -fstack-check' make
echo -e "Compilation finished, running test 8"
bash -c './Run' &>> $results
echo -e "Test 8 completed."

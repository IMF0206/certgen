#!/bin/sh

###
### test.sh — 证书生成工具
###
### Usage:
###   ./test.sh <主题信息> <证书名称前缀> <证书个数> <第一个证书数值>
###
### Options:
###   <主题信息>   比如：C=CN,O=SGCC,OU=JL,OU=SGEP,CN=
###   <证书名称前缀>  比如：190806_nr_jlsdsp
###   <证书个数>   证书个数与第一个证书数值相加不超过9999
###   <第一个证书数值> 填数值，不超过9999
###   -h        Show this message.
###   完整指令示例：./test.sh C=CN,O=SGCC,OU=JL,OU=SGEP,CN= 190806_nr_jlsdsp 10 1

help() {
    sed -rn 's/^### ?//;T;p' "$0"
}

if [[ $# == 0 ]] || [[ "$1" == "-h" ]]; then
    help
    exit 1
fi

date
echo "传递参数";
echo "地址信息=:$1";
echo "文件名前缀:$2"
echo "生成个数:$3";
echo "第一个文件数值:$4"
info=$1
prefix=$2
count=$3
num=$4

while [ $count -gt 0 ] ;
do
        #filename=AG_AJB_YCXZYAJXCGL_0000
        numstr=`echo $num | awk '{printf("%04d\n",$num)}'`
        filename=$prefix$numstr
        let num++
        let count--
        echo $filename
        houzhui=.csr
        dirname=dir
        dirname=$filename$dirname
        fileoutname=$filename$houzhui
        nrsecinput=$info$filename
        ./nrsec3000_epx $nrsecinput $fileoutname
        mkdir $dirname
        ./nrsec3000_epx -e
        mv $fileoutname $dirname/
        mv pubkey0.bin $dirname/
        mv prvkey0.bin $dirname/
done;
#tar -czvf csr.tar *dir
rm -rf csr.zip
zip -r csr.zip *dir
rm -rf $prefix*
date

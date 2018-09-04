#!/bin/sh

currentDir=`pwd`
echo "当前目录: $currentDir"

parentDir=`basename ${currentDir}`
echo ${parentDir}

if [ ${parentDir} = "bin" ] ; then
    echo "当前目录名为bin [校验通过]"
    echo "删除当前目录下所有文件... "
    rm *
else
    echo "应该在bin目录下执行 [校验不通过]"
    exit 0
fi

echo "clone 部署文件... "

git clone ssh://git@git.sankuai.com/wmsc/retail.deploy.git

mv retail.deploy/* .

rm -rf retail.deploy

echo "已经准备好部署文件[done]"

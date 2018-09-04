#!/bin/sh

k=1
HTTP_PORT=${HTTP_PORT}
CHECK_WAIT_SECONDS=${CHECK_WAIT_SECONDS}

# 依赖于用户设置的环境变量
app_key=${app_key}

if [ -z "${app_key}" ]; then
    app_key=${PLUS_RELEASE_NAME}
fi

if [ -z "${app_key}" ]; then
    echo "发生系统错误，PLUS_RELEASE_NAME和app_key均未设置."
    exit -1
fi

KEY="\s-Dapp.appkey=$app_key\s"

# 配置检测等待的时间
if [ -z "$CHECK_WAIT_SECONDS" ]; then
    CHECK_WAIT_SECONDS=60
fi

for k in $(seq 1 $CHECK_WAIT_SECONDS)
do
    sleep 1

    PID=`ps -ef | grep "$KEY" | grep -v grep | awk '{print $2}'`
    if [ "$PID" = "" ]; then
        echo "PID is null. retry check PID."
    else
        echo "PID is $PID, and sleep 3 to recheck."
        sleep 3
        NEW_PID=`ps -ef | grep "$KEY" | grep -v grep | awk '{print $2}'`
        if [ "$PID" = "$NEW_PID" ]; then
            echo "start success. PID is $PID."
            exit 0;
        else
            echo "process restart. continue check."
        fi
    fi
    if [ ${k} -eq ${CHECK_WAIT_SECONDS} ]; then
        echo "have tried $k times, no more try"
        echo "failed"
        exit -1
    fi
done
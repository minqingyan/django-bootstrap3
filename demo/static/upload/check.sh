#!/bin/sh

k=1
HTTP_PORT=${HTTP_PORT}
CHECK_WAIT_SECONDS=${CHECK_WAIT_SECONDS}


# 配置检测等待的时间
if [ -z "$CHECK_WAIT_SECONDS" ]; then
    CHECK_WAIT_SECONDS=60
fi

if [ -z "$HTTP_PORT" ]; then
    echo "需要配置HTTP_PORT环境变量."
    exit 0
fi

echo "check service......"
TEST_URL="127.0.0.1:$HTTP_PORT/static/alive.123456"
if [ -z ${TEST_URL} ]; then
    echo "Warning:Need a test_url!"
    exit 0
fi

for k in $(seq 1 $CHECK_WAIT_SECONDS)
do
    sleep 1
    STATUS_CODE=`curl -o /dev/null -s -w %{http_code} $TEST_URL`
    if [ "$STATUS_CODE" = "200" ]; then
        echo "request test_url:$TEST_URL succeeded!"
        echo "response code:$STATUS_CODE"
        exit 0;
    else
        echo "request test_url:$TEST_URL failed!"
        echo "response code: $STATUS_CODE"
        echo "try one more time:the $k time....."
    fi
    if [ ${k} -eq ${CHECK_WAIT_SECONDS} ]; then
        echo "have tried $k times, no more try"
        echo "failed"
        exit -1
    fi
done
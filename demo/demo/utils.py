# -*- coding: utf-8 -*-
from __future__ import unicode_literals
import json
import time

def transfer_to_json_format(raw_msg):
    """
    用于判断一个字符串是否符合Json格式
    :param self:
    :return:
    """
    if isinstance(raw_msg, str):       # 首先判断变量是否为字符串
        return json.loads(raw_msg, encoding='utf-8')
    elif isinstance(raw_msg, dict):
        return raw_msg
    elif isinstance(raw_msg, unicode):
        return json.loads(raw_msg.encode())
    else:
        raise ValueError

def get_local_time():
    now = time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(time.time()))
    return now

# -*- coding: utf-8 -*-
from __future__ import unicode_literals
import json

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
    else:
        raise ValueError

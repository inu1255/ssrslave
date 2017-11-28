#!/usr/bin/python
# -*- coding: UTF-8 -*-

from db_transfer import SsrSlave

slave = SsrSlave()
slave.load_cfg()
data = slave.request("/register",{"a":1})
if data is None:
	exit(1)
else:
	exit(0)

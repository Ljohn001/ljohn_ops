#!/bin/sh

#TOKEN=$(curl -s  'https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid=wxfd66912e6737f2de&corpsecret=FaE4Yg7vzs2mjCQCpYHCKut-_o6Nik9lWqxTmTjM6hCd2xxME_nEm0CjKsGCHhIC'|jq '.access_token'|sed 's/"//g')

curl -s -k --data-ascii "{\"touser\":\"@all\",\"msgtype\":\"text\",\"agentid\":\"1\",\"text\":{\"content\":\"$@\"},\"safe\":\"0\"}"  https://qyapi.weixin.qq.com/cgi-bin/message/send?access_token=rIIkfPA3LJt60PP0riGucm4onx1j98sjAcH_R2trDn6wthVYzJjpXuB6USOkQdJ3xomIYGchwutg2MYYgImln3hms33YaT-XkNxv8bx8Bz-cUq6YPvQkS2fcBon1JWtXdMOm7ROy1ADIrU8Rdh3NgGW9AkQc0oAomCJZ3I8xpiZ5euaOcb4AqrfttT20uv5wHQYESF9zuPdSpiU-G7te6TZivFP5lcXv0DD-cj-I574


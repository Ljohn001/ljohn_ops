#!/bin/bash
echo "初始化中....."
git pull origin master;
git add -A;
read -p "输入日志,按Enter键跳过 :" log
if  [ ! -n "$log" ] ;then
    git commit -m "自动生成";
else git commit -m "${log}";
fi;
git push origin master;
echo "远程推送完成"

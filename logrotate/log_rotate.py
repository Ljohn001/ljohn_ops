#!/usr/bin/env python
# author: Ljohn
# env:python2.6

import datetime,os,sys,shutil
log_path = '/var/log/nginx/'
log_file = 'access.log'
   
yesterday = (datetime.datetime.now() - datetime.timedelta(days = 1))
   
try:
    os.makedirs(log_path + yesterday.strftime('%Y') + os.sep + \
                yesterday.strftime('%m'))
   
except OSError,e:
    print
    print e
    sys.exit()
   
shutil.move(log_path + log_file,log_path \
            + yesterday.strftime('%Y') + os.sep \
            + yesterday.strftime('%m') + os.sep \
            + log_file + '_' + yesterday.strftime('%Y%m%d') + '.log')
   
os.popen("/etc/init.d/nginx restart")

# crontab -e 添加定时任务: 每天0点30分执行切割
# 30 0 * * * /usr/bin/python /server/scripts/log_rotate.py > /dev/null 2>&1

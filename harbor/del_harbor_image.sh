#!/bin/bash
# by ljohn
# time 2019 6.4
#later_date=$(date +%y%m%d%H%M)-3000000
later_date=`date -d "1 month ago" +%y%m%d%H%M`

jname=(
lp-ms-account
lp-ms-collaboration
lp-ms-coupon
lp-ms-payment-union
lp-ms-paymentcenter
lp-ms-union-admin
lp-ms-union-album
lp-ms-union-app
lp-ms-union-vbox
lp-ms-union-web
lp-ms-users-adapter
vp-admin-action
vp-b-admin
vp-b-bird
vp-b-cgi
vp-b-digital
vp-b-ding
vp-b-gallery
vp-b-galleryadmin
vp-b-miniapp
vp-b-monitor
vp-b-openzipkin
vp-b-photographer
vp-b-saas
vp-b-saas-foract
vp-b-stream
vp-b-tuan
vp-b-vbox
vp-b-vboxterminal
vp-b-wechatlistener
vp-ms-album
vp-ms-album-photo
vp-ms-albumcomment
vp-ms-ba-album
vp-ms-baconfig
vp-ms-baorder
vp-ms-bpm-flowable
vp-ms-digital-terminal
vp-ms-distributor
vp-ms-oss
vp-ms-photoio
vp-ms-photolib
vp-ms-product
vp-ms-settlement
vp-ms-shooting
vp-ms-shootorder
vp-ms-statistics
vp-ms-task-photo
vp-ms-tickets
vp-ms-token
vp-ms-usercenter
vp-ms-vbox
vp-ms-vbox-base
vp-ms-vbox-monitor
vp-ms-video-manager
vp-ms-video-monitor
vp-ms-video-oss
vp-ms-video-photoio
)

jname1=(
vp-ms-token
vp-ms-order
vp-b-saas
)

#startcounts=`curl -s  -u "admin:Harbor12345" -X GET -H "Content-Type: application/json" "https://dockerrepos.vphotos.cn/api/repositories?project_id=4&q" | wc -l`
declare -i sum=0
for i in ${jname[*]}
do
        a=`curl -s  -u "admin:Harbor12345" -X GET -H "Content-Type: application/json" "https://dockerrepos.vphotos.cn/api/repositories/vphoto%2F$i/tags/"| wc -l `
        let sum+=$a
done
startcounts=$sum
echo "删除前镜像数: $startcounts"


echo ">>>>>>>正在删除 $later_date 以前的镜像<<<<<<"
del_labels() {
for i in ${jname[*]}
do 
labels=`curl -s -u "admin:Harbor12345" -X GET -H "Content-Type: application/json" "https://dockerrepos.vphotos.cn/api/repositories/vphoto%2F$i/tags/" | grep "name"| sed -e  's/"//g' -e 's/,//g'| awk -F ':' '{print $2}'`
   for t in $labels
     do 
         if grep '^v' <<< $t ;then 
            echo "$t 忽略tag 版本..." 
         else
            if [ `echo $t | grep -Eo "[0-9]{10}"` -lt $later_date ];then
            echo "=======del image $i time $t=========="
            curl -u "admin:Harbor12345" -X DELETE -H "Content-Type: application/json" "https://dockerrepos.vphotos.cn/api/repositories/vphoto%2F$i/tags/$t"
	    #echo "delete $i $t"
               if [ $? -eq 0 ];then
                     echo "delete $i $t Sucssed" 
                  else 
                     echo "delete $i $t Failed"
               fi
            fi    
         fi
       #labels=`curl -s -u "admin:Harbor12345" -X GET -H "Content-Type: application/json" "https://dockerrepos.vphotos.cn/api/repositories/vphoto%2F$i/tags/" | grep "name"| sed -e  's/"//g' -e 's/,//g'| awk -F ':' '{print $2}' | awk -F ':' '{print $2}' | awk -F '-'  later_date="$later_date" '{$(NF-1) > later_date}'`
       #labels=`curl -s -u "admin:Harbor12345" -X GET -H "Content-Type: application/json" "https://dockerrepos.vphotos.cn/api/repositories/vphoto%2F$i/tags/" | grep "name"| sed -e  's/"//g' -e 's/,//g'| awk -F ':' '{print $2}' | awk -F ':' '{print $2}' | awk -F '-' -v later_date="$later_date" 'NR==FNR{if($(NF-1)>later_date) print $0}'`
     done
done
}
del_labels

declare -i sum2=0
for i in ${jname[*]}
do
        a=`curl -s  -u "admin:Harbor12345" -X GET -H "Content-Type: application/json" "https://dockerrepos.vphotos.cn/api/repositories/vphoto%2F$i/tags/"| wc -l `
        let sum2+=$a
done
endcounts=$sum2
echo "执时间为: $(date +%Y-%m-%d)"
echo "删除后镜像数: $endcounts"
echo "当前镜像数为: $endcounts" 
echo "本次总计清除镜像: `echo "$startcounts-$endcounts" | bc`" 

#crontab　每个月1号清理
#0 0 1 * * /root/del_harbor_image.sh 1> /tmp/del_image.log 2>&1 &
#0 0 3 * * /root/docker_rm_img.sh &>/dev/null


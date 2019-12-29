#!/usr/bin/awk -f
#
#  by ljohn 
#  2019.12.29
#
#  修改rsbackup html report,加入size字段
#

{
	print $0
	v[NR]=$0
	# 查询size
	if (v[NR-4] ~ "host" && v[NR-3] != "volume" && v[NR] ~ "bg.*201" ){
		print v[NR-4] v[NR-3] v[NR] |& "/usr/local/sbin/backsize"
		"/usr/local/sbin/backsize" |& getline results
		close("/usr/local/sbin/backsize")
		if (results != "wrong"){
			print results
		}
	}
	# 增加size列
	if (v[NR] ~ "Newest") {
		print "<th>Size</th>"
	}
}


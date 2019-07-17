#!/usr/bin/env python
# -*- coding: utf-8 -*-
# Rewrite by Wilson Luiz Prosdocimo
# Based on https://github.com/serialsito/Elasticsearch-zabbix
# change xianzheng.wang@vphotos.cn
# 20190220
# 增加自动发现nodename
#############

ES_HOST="127.0.0.1"
ES_HOST="10.3.16.110"
ES_PORT="9200"

#################
from elasticsearch import *
import sys
import json
# Define the fail message
def zbx_fail():
    print "ZBX_NOTSUPPORTED"
    sys.exit(2)
# Define groups of keys
searchkeys = ['query_total', 'fetch_time_in_millis', 'fetch_total', 'fetch_time', 'query_current', 'fetch_current', 'query_time_in_millis']
getkeys = ['missing_total', 'exists_total', 'current', 'time_in_millis', 'missing_time_in_millis', 'exists_time_in_millis', 'total']
docskeys = ['count', 'deleted']
indexingkeys = ['delete_time_in_millis', 'index_total', 'index_current', 'delete_total', 'index_time_in_millis', 'delete_current']
storekeys = ['size_in_bytes', 'throttle_time_in_millis']
cachekeys = ['filter_size_in_bytes', 'field_size_in_bytes', 'field_evictions']
jvmkeys = ['heap_used_percent']
cpukeys= ['percent']
clusterkeys = searchkeys + getkeys + docskeys + indexingkeys + storekeys

returnval = None
# __main__
# We need to have two command-line args:
# sys.argv[1]: The node name or "cluster"
# sys.argv[2]: The "key" (status, filter_size_in_bytes, etc)
if len(sys.argv) < 3:
    zbx_fail()
# Try to establish a connection to elasticsearch
try:
    conn = Elasticsearch(request_timeout=25)
    conn = Elasticsearch([{'host':ES_HOST,'port':ES_PORT,'request_timeout':'25'}])
except Exception, e:
    zbx_fail()
if sys.argv[1] == 'cluster':
    if sys.argv[2] in clusterkeys:
        nodestats = conn.nodes.stats()
        #print nodestats
        subtotal = 0
        for nodename in nodestats[u'nodes']:
            if sys.argv[2] in indexingkeys:
                indexstats = nodestats[u'nodes'][nodename][u'indices'][u'indexing']
            elif sys.argv[2] in storekeys:
                indexstats = nodestats[u'nodes'][nodename][u'indices'][u'store']
            elif sys.argv[2] in getkeys:
                indexstats = nodestats[u'nodes'][nodename][u'indices'][u'get']
            elif sys.argv[2] in docskeys:
                indexstats = nodestats[u'nodes'][nodename][u'indices'][u'docs']
            elif sys.argv[2] in searchkeys:
                indexstats = nodestats[u'nodes'][nodename][u'indices'][u'search']
            try:
                subtotal += indexstats[sys.argv[2]]
            except Exception, e:
                pass
        returnval = subtotal
    else:
        # Try to get a value to match the key provided
        try:
            returnval = conn.cluster.health()[unicode(sys.argv[2])]
        except Exception, e:
            zbx_fail()
        # If the key is "status" then we need to map that to an integer
        if sys.argv[2] == 'status':
            if returnval == 'green':
                returnval = 1
            elif returnval == 'yellow':
                returnval = 2
            elif returnval == 'red':
                returnval = 3
            else:
                zbx_fail()
# Mod to check if ES service is up
elif sys.argv[1] == 'service':
    if sys.argv[2] == 'status':
        try:
            conn.ping()
            returnval = 1
        except Exception, e:
            returnval = 0
#自动发现nodename
elif sys.argv[1] == 'discover_nodes':
    nodestats = conn.nodes.stats()
    #print nodestats
    #print nodestats[u'nodes']
    data={}
    nodes_list = []
    for nodename in nodestats[u'nodes']:
        NODENAME=nodestats[u'nodes'][nodename][u'name']
        node_dict = {}
        node_dict['{#NODENAME}'] = NODENAME
        nodes_list.append(node_dict)

    data['data'] = nodes_list
    jsonStr = json.dumps(data, sort_keys=True, indent=4)
    print jsonStr
    exit()
else: # Not clusterwide, check the next arg
    nodestats = conn.nodes.stats()
    for nodename in nodestats[u'nodes']:
        if sys.argv[1] in nodestats[u'nodes'][nodename][u'name']:
            if sys.argv[2] in indexingkeys:
                stats = nodestats[u'nodes'][nodename][u'indices'][u'indexing']
            elif sys.argv[2] in storekeys:
                stats = nodestats[u'nodes'][nodename][u'indices'][u'store']
            elif sys.argv[2] in getkeys:
                stats = nodestats[u'nodes'][nodename][u'indices'][u'get']
            elif sys.argv[2] in docskeys:
                stats = nodestats[u'nodes'][nodename][u'indices'][u'docs']
            elif sys.argv[2] in searchkeys:
                stats = nodestats[u'nodes'][nodename][u'indices'][u'search']
            elif sys.argv[2] in jvmkeys:
                stats = nodestats[u'nodes'][nodename][u'jvm'][u'mem']
	    elif sys.argv[2] in cpukeys:
                stats = nodestats[u'nodes'][nodename][u'os'][u'cpu']
            try:
                returnval = stats[unicode(sys.argv[2])]
            except Exception, e:
                pass
# If we somehow did not get a value here, that's a problem.  Send back the standard
# ZBX_NOTSUPPORTED
if returnval is None:
    zbx_fail()
else:
    print returnval

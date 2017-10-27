#!/bin/bash
#
BEGIN {
print "The lastest list of users and shells"
print " Userid          Shell"
print "--------         -------"
FS=":"
}

{
print  $1 "            "  $7
}

END {
print "This concludes the listing"
}


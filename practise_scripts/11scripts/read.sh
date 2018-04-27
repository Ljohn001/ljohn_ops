#!/bin/bash
read -t 5 -p "A compress ([bzip2|gzip|xz]): "  Com
[ -z $Com ] && Com=gzip
echo $Com

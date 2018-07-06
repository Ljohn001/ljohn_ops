#!/bin/bash
#
#  hmy@v.photo
#  根据参数,生成项目的dockerfile,pipeline,k8s 配置文件
#  
#
#
#  参数:
#  -n 项目名
#  -b 后端项目
#  -f 前端项目
#  -o 输出目录
#  -p 访问路径
#  -i apollo IDC 配置
#  == TODO ==
#  前端项目的配置文件


#配置文件压缩字符串, cat $youconffile |gzip|base64 -w0
JOBF="H4sIAOcK7FoAA61WW2/bNhR+z68wjAIBBphskrUbBlpN6ixthw4x6ibvFHUsM5ZIjaScpr9+h7qZkhI4TQsINsnznRvPjezdtzyb7MBYqdX8+IS8Pp6AEjqRKp0f33y9mv15/C46YutM388SWEslHSInRVamUs2n99psK9qdjs9PycnbaXQ0mTAuPMr6Ne6kJnegtlJZEmclaAFcEQtmJwUQyGNIEkjIeyRde9KNyS5ET0vHNTNg3UzmRXZ+Qs7Im2mtAXXEAfd1fAfCTUTGrZ1Pf1x7zf8JtXTyUUPOiwISJEdeDNUm5Up+55WjtNFAd8Usnjk08uT0DD9G91yBJJ3AwMjB/U4nBtZgMBIwnxJC229KO4fp2OPmuulL77sKHQ1ixxKwwsiiIu6KjXaa0fDMY7YAxSUUoBI0V4KN1jyzwOjo3IMLowswrtnigdA5SXhs/yu5QaNS6TIet9YLrRRU5pAP0n3m8aI7WNaCHrocqTln9Raz4w053WdHOuCOGB0dNZf3swY1cjZlYhFVhZosueE5OKyyyy7Efby/mha0x9ggaXoCFxuNsVyOOfYMyKKQimEDtWO0WofEMIyjoHYoUSmybZre8R0npZMZuTCGP9hX1d9nad00ZPMdoGWxzmAvmXEPHIAQVlOjy79vGW3WT0CuLr4egtwchiy/XD8OwbzvOU4bz4MI0B8NQT9mq0rrs2LmePriiGET4WXmbjmWdwULtk/58gzTXuyLTMSv8WX18QK/X+URo0/X20DWoepFUb2uxoI52RQBDou2JQtJ6h5lSTs8iSgsWRR2JfIr3F4GY2A0ZxGKc/b3trcxK/JWSWN0Kx07l29Sq8W/07BJnp+RP8jrfWvElraW6W39AohOfQMMD1pYifPjC+TawaKiP9KaQsU3A3gvrCVOQ2+JB0oSw/Yhkwp7a/7XPVep3UjcprSeN4kWWzBeJqNlOEW96digQTmJ8+ZTEvmp29wxOtEjjbPkObaiwqecZrHhSmzgwC28r1CrAsS4Ln7Dp4HFpBoWx6MmjgXh/B+YwBL9ARQY7mBVxpi6ZdaYXZr6ldJO5sPAVqTt6Ou0TbPMd/v9OwS+OVC2egS11YM52WWnL+sld5von6vx4ygg1/hMpht3D/43cqZEW8OTqtaSXikzrPM0xVyldeVJy+MMks7Tdn/E6OCJFf0PpHoTpfsKAAA="
DF="H4sIAFsA7FoAA4WOQUrDQBSG184pHhG6EJNXVxYXQjERXLSRtIKgLp7ppDN1MjPMTFroEbyCG72AWxHPo+ItbGgF3dTF43+L7//4T4t8ABNT3nHnuDU+mVthwipLjesXg6lLCodHM8d7MSkrNY/n3QPGBv2z4Xh1WQGVMzWomRGasV34eHl7v3/8enr9fHhm/TSFBCe8okaFZEEOsPEOlSlJbdy44LdkrccNTNYoZZJALpkuARkrLobgaohdtaVc5PkY9+Ca7UCnA41eSruF/j0onvyj/ZEqDbHXmxFekOO4NJpLXRnse0k4EqSngiQgD+XaF2TN2y4vhYG/0PEaa4lWw1h2eZ6PMuh1e112MkjhKlotISU1JV5E+xC5Rkc37Bv7no8AtQEAAA=="
JF="H4sIABsA7FoAA9VXTW8bRRg+27/i1cp0nTS7m92kTePKhUCCaFFbqUAPRCEa747XU+9XZsYObrISQnBAAqk3UIXggOgFAWf+Dwl/g3dmdl07dUSTtgcs27M7+z7v98dslke0badESMrtJThqAn48D07+ePr3X9/AIeFw8u3X/zz96uTJdye/f99sRLQPnMZMSD7JSEq7VpSHQ8o5LXLhjotBLnENM8uQFjx/RENpKM1TfNLUYoQkMQoPE0oye+mo2WiIAdg8hWVweN9uNspms1ETDWg4zEdS64iUEeNtWxAiDLARMwk9TrJw0AGrhRgLViDkNKKZZCQRt6MO2JIK+YhmQ5YJewVGPME9BL6DP5e5PTqcJCxzwzztJGwUscwzCn9E+ZiFVLhIZythyj/Pvjz96UeUg945efIbp2iEoCunv3xx+vOvpz/8efLkWUp5TBW5ssrWQGU0lXBVbzcaNBzkoJSF4xj9B84BOALAYVDx02SsD7vQehscegCrsHdTDmhm8Pe6rbYyPMnjGuGJIXP8INiAz3LOYrTBxPb4MAQnWTI4w/EeOBk9w7FBP0d+vrnpM73SRMzqa2U56GhYzYpIrZWBytRaIycDHxyn4FTKSbef85TIjvXWwMLNLHcKIsMB3LoFrutFtMdIpvyLwMWMkFDwEK1BkzgV+YhjRKoALQKaZLgwjNM0lxSc8csiy2k2Vrm/j/mT5tkbystRPjnw5iXNpKWyQgcJXWY5VuXdOZ1vvrHwIKEqSO+SYboUfC5cF+EwGzZjXhUwHbHLB+iQZLEYMLyNK6GmPdZBKlWXMy0tJUOK/bWSe7ahqSYj8ozwg1GPVhtotXVn6+HW/gf37+50vbyQ3qNoCPoi5iRKqLPu+l4PTTe3zzmAs62v3UEupIsWdAdSFh3P81fdNddf990g6Gyurq56msyb0qO/WNZdD+mNa5s3/E0/iNaC8DoNNsj164T2aXBtLdxY8zeurW0Quml6AlxcUT0E9LhxtvHf1QOjdXTn/rv797bu7pSacWkciN/pXMD07Y1YEum58EJE9Z5KFisd4iNwve37732488Cb4ayViogk4BTWS5JjE5cYYTEL0XVHszFqPS5wLeHWfzPACz7G7MAxWVAuGRXz/FgUIj/8L3WCvwK7MFoIhytXQCqvh+M+kCJPktzFezd+jOTI2qpd/nwUa3+DSetz3a5TGuc/Qvyu1TrCtbRcHHIJCWnb8qwV7E9Ls2RBReY/p9tKkra1u+ps7rnLekFUQlQxVlAzkBDUrSTMbfrdmuHcdmC2A9yeOqeYNg9tnZewnph1k6syc6H7UXsySqQiMPyqej9kcvCgOie1LVVsAqutdTR7diqtqta1C9Cs2yl6GLqVc12tSxvdMnOKKmelWytgLdLKMoN+ytItRmKgGJnMdGq/LJmq+l+pHcypraJnxAJPGZxR1Dtfh84Lznid7IJz2J0Lr9J62uCqWouwEPIJDG9UY2HRxPJUDoKWrkvN6DFfRO4yls4ucR7vGeeZYpjS6uO4ORi2Z7ah2wV7e+ehDUtHNYlalDwkCM6TtrvlfLp3FSVGdIzyKmQJ6iQJi2S8v/XxpWX0iXwpGZ+8gozRnIz6AIJdw1FdAaPjLYMXjdXVfp8lVNgzNPWDUCZ4Ysv6LPZaWppn7sDjeS49d4hjutqaws2puqEeIVwdtcyhArNMKV5CjK8TwryfwDHot4gz3b3GRviCoI5K/XlNa11aNWja0SYkTeD4eMqAFEUyuSi+ejdo1IldNv8FgdsBhXIOAAA="
K8SF="H4sIADMA7FoAA51Sy27CMBC8+yv8AybACflaKvXAAYmK++KswMIv2dtI/H3XIW0dkVP3YMU7Gs/MZu829FruMbn48BhIQLJnzMXGoCWkVLphc0GCrfB89kCghZQBPGo5JHVRPgZLMU/NksCMyC1SVD0OoiQ0lZJZwhooWm7G22CrxoctTH4crLfEyJqhgg4NNytJSg9kbge4oCvPhqyuXrQJfXJAOJEaq7XcjL/8AgtPTmuZGAhs4EH8sdRy7J+yHq6M9tHcMXPaWFbPMZSVCd3zs2u5ev9+VpnTQkFVzRdqnksxUyNe5X9NHRnTcrferRucKZklTHRafr4dRePq+OXcCU1GWoiT8VpGbPxdQikl7uNSnDAP1uBsI4bNbA/awS4N9R970uRW42UWlCBfkWb55/vy6kJ8A4RgaILjAgAA"

TYPE=b
PNAME=vphoto
OUTDIR=/tmp/
PPATH=/nofound
PPORT=8080
IDC=SHA
while getopts 'n:o:p:e:i:fb' opt;do
        case $opt in
        n)
        PNAME="$OPTARG";;
        e)
        PPORT="$OPTARG";;
        o)
        OUTDIR="$OPTARG";;
        i)
        IDC="$OPTARG";;
        p)
        PPATH="$OPTARG";;
        f)
        TYPE="f";;
        b)
        TYPE="b";;
        *)
        ;;
esac
done
mkdir -p ${OUTDIR}/DOCKER/vp-${TYPE}-${PNAME}
mkdir -p ${OUTDIR}/JF
mkdir -p ${OUTDIR}/k8s/{DEV,UAT,FAT}/vp-${TYPE}-${PNAME}/
if [ "x$TYPE" == "xb" ];then
    echo $DF|base64 -d|gunzip > ${OUTDIR}/DOCKER/vp-${TYPE}-${PNAME}/Dockerfile
    echo $JF|base64 -d |gunzip > ${OUTDIR}/JF/vp-${TYPE}-${PNAME}
    echo $JOBF|base64 -d |gunzip|sed -e "s/vp-b-test123123/vp-b-${PNAME}/g" -e "s/SHASHA/${IDC}/" > ${OUTDIR}/jenkinsjob.xml 
    echo $K8SF|base64 -d|gunzip|sed -e "s/vp-b-monitor/vp-b-${PNAME}/g" > ${OUTDIR}/k8s/DEV/vp-${TYPE}-${PNAME}/default.yaml
    echo $K8SF|base64 -d|gunzip|sed -e "s/vp-b-monitor/vp-b-${PNAME}/g" -e "s/vphoto-dev/vphoto-fat/" -e "s/regsecret-dev/regsecret-fat/" -e "s/DEV/FAT/"> ${OUTDIR}/k8s/FAT/vp-${TYPE}-${PNAME}/default.yaml
    echo $K8SF|base64 -d|gunzip|sed -e "s/vp-b-monitor/vp-b-${PNAME}/g" -e "s/vphoto-dev/vphoto-uat/" -e "s/regsecret-dev/regsecret-uat/" -e "s/DEV/FAT/"> ${OUTDIR}/k8s/UAT/vp-${TYPE}-${PNAME}/default.yaml
else
    echo "to do"
fi

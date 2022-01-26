#!/bin/bash
#
# Copyright © 2019 ExinPool <robin@exin.one>
#
# Distributed under terms of the MIT license.
#
# Desc: Akash snapshots script.
# User: Robin@ExinPool
# Date: 2022-01-26
# Time: 16:01:17

# load the config library functions
source config.shlib

# load configuration
service="$(config_get SERVICE)"
base_dir="$(config_get BASE_DIR)"
log_file="$(config_get LOG_FILE)"
address="$(config_get ADDRESS)"
lark_webhook_url="$(config_get LARK_WEBHOOK_URL)"

# rewards snapshots
akash query distribution rewards $address -o json | jq . | grep -w reward -A 4 | grep amount | awk -F':' '{print $2}' | sed "s/\"//g" | sed "s/\ //g" > ${base_dir}/rewards-`date '+%Y%m%d'`.log

# total snapshots
akash query distribution rewards $address -o json | jq . | grep -w total -A 4 | grep amount | awk -F':' '{print $2}' | sed "s/\"//g" | sed "s/\ //g" > ${base_dir}/total-`date '+%Y%m%d'`.log

log="时间: `date '+%Y-%m-%d %H:%M:%S'` UTC \n主机名: akash-mainnet \n节点: $service \n状态: 快照已完成。"
echo -e $log >> $log_file
curl -X POST -H "Content-Type: application/json" -d '{"msg_type":"text","content":{"text":"'"$log"'"}}' ${lark_webhook_url}
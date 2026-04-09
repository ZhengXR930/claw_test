#!/bin/bash
# 用法: ./fetch_feishu_doc.sh <wiki_token>

APP_ID="cli_a95d1f0ebd78dcd4"
APP_SECRET="J6wD6Y5X4Bqwypt2k8rK0cOVpYwr86N1"

# 获取 tenant_access_token
TOKEN=$(curl -s -X POST "https://open.feishu.cn/open-apis/auth/v3/tenant_access_token/internal" \
  -H "Content-Type: application/json" \
  -d "{\"app_id\":\"$APP_ID\",\"app_secret\":\"$APP_SECRET\"}" | python3 -c "import sys,json; print(json.load(sys.stdin).get('tenant_access_token',''))")

if [ -z "$TOKEN" ]; then
  echo "获取 token 失败"
  exit 1
fi

# 获取 wiki 节点信息，拿到 document obj_token
DOC_TOKEN=$(curl -s -X GET "https://open.feishu.cn/open-apis/wiki/v2/spaces/get_node?token=$1" \
  -H "Authorization: Bearer $TOKEN" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('data',{}).get('node',{}).get('obj_token',''))")

# 读取文档内容
curl -s -X GET "https://open.feishu.cn/open-apis/docx/v1/documents/$DOC_TOKEN/raw_content" \
  -H "Authorization: Bearer $TOKEN" | python3 -m json.tool

import os
import requests
import base64
import urllib.parse
import json
import random

def fetch_subscription(url):
    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
        "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7"
    }
    try:
        resp = requests.get(url, headers=headers, timeout=30)
        resp.raise_for_status()
        return resp.text
    except Exception as e:
        print(f"Error fetching subscription: {e}")
        return None

def parse_trojan(url):
    try:
        parsed = urllib.parse.urlparse(url)
        if parsed.scheme != 'trojan':
            return None
        
        params = urllib.parse.parse_qs(parsed.query)
        
        server = {
            "address": parsed.hostname,
            "port": parsed.port,
            "password": parsed.username,
        }
        
        stream_settings = {
            "network": "tcp",
            "security": "tls",
            "tlsSettings": {
                "allowInsecure": True
            }
        }
        
        if 'sni' in params:
            stream_settings["tlsSettings"]["serverName"] = params['sni'][0]
        
        if 'type' in params and params['type'][0] == 'ws':
             stream_settings['network'] = 'ws'
             ws_settings = {}
             if 'path' in params:
                 ws_settings['path'] = params['path'][0]
             if 'host' in params:
                 ws_settings['headers'] = {'Host': params['host'][0]}
             stream_settings['wsSettings'] = ws_settings

        node = {
            "protocol": "trojan",
            "settings": {
                "servers": [server]
            },
            "streamSettings": stream_settings
        }
             
        return node
    except Exception as e:
        print(f"Error parsing trojan link {url}: {e}")
        return None

def generate_xray_config(node):
    config = {
        "log": {
            "loglevel": "warning"
        },
        "inbounds": [
            {
                "port": 7890,
                "listen": "127.0.0.1",
                "protocol": "http",
                "settings": {
                    "timeout": 360
                }
            }
        ],
        "outbounds": [
            node,
            {
                "protocol": "freedom",
                "tag": "direct",
                "settings": {}
            }
        ]
    }
    return config

def main():
    sub_url = os.environ.get('SUB_URL')
    if not sub_url:
        print("No SUB_URL environment variable found.")
        return

    print(f"Fetching subscription from: {sub_url[:20]}...")
    content = fetch_subscription(sub_url)
    if not content:
        # 如果获取失败，生成一个空的 config 以免后续步骤报错找不到文件
        with open("proxy_config.json", "w", encoding="utf-8") as f:
            f.write("{}")
        return

    try:
        padding = len(content) % 4
        if padding:
            content += "=" * (4 - padding)
        decoded = base64.b64decode(content).decode('utf-8')
    except Exception as e:
        print(f"Base64 decode error: {e}")
        decoded = content

    nodes = []
    for line in decoded.splitlines():
        line = line.strip()
        if line.startswith("trojan://"):
            node = parse_trojan(line)
            if node:
                nodes.append(node)
    
    if not nodes:
        print("No valid trojan nodes found.")
        # 同上，生成空配置
        with open("proxy_config.json", "w", encoding="utf-8") as f:
            f.write("{}")
        return

    print(f"Found {len(nodes)} trojan nodes.")
    
    selected_node = random.choice(nodes)
    print(f"Selected node: {selected_node['settings']['servers'][0]['address']}")
    
    config = generate_xray_config(selected_node)
    
    # 注意：我们将代理配置保存为 proxy_config.json，避免覆盖项目的主配置 config.json
    with open("proxy_config.json", "w", encoding="utf-8") as f:
        json.dump(config, f, indent=2)
    
    print("Xray config generated: proxy_config.json")

if __name__ == "__main__":
    main()

import os
import requests
import base64
import urllib.parse
import json
import random

def fetch_subscription(url):
    try:
        resp = requests.get(url, timeout=30)
        resp.raise_for_status()
        return resp.text
    except Exception as e:
        print(f"Error fetching subscription: {e}")
        return None

def parse_trojan(url):
    # trojan://password@host:port?params#name
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
                "allowInsecure": True  # Default allow insecure for simplicity in scraping
            }
        }
        
        if 'sni' in params:
            stream_settings["tlsSettings"]["serverName"] = params['sni'][0]
        
        # Check for other transport types like ws if needed, but basic trojan is usually tcp+tls
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

def generate_v2ray_config(node):
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
        return

    # Try decoding base64
    try:
        # Pad base64 if needed
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
        return

    print(f"Found {len(nodes)} trojan nodes.")
    
    # 随机选择一个节点
    selected_node = random.choice(nodes)
    print(f"Selected node: {selected_node['settings']['servers'][0]['address']}")
    
    config = generate_v2ray_config(selected_node)
    
    with open("config.json", "w", encoding="utf-8") as f:
        json.dump(config, f, indent=2)
    
    print("v2ray config generated: config.json")

if __name__ == "__main__":
    main()

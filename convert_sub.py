import os
import requests
import base64
import yaml
import urllib.parse
import json

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
        
        node = {
            "name": urllib.parse.unquote(parsed.fragment) or parsed.hostname,
            "type": "trojan",
            "server": parsed.hostname,
            "port": parsed.port,
            "password": parsed.username,
            "udp": True,
            "skip-cert-verify": True
        }
        
        if 'sni' in params:
            node['sni'] = params['sni'][0]
        if 'allowInsecure' in params: #有时候参数名不一样
             node['skip-cert-verify'] = True
             
        return node
    except Exception as e:
        print(f"Error parsing trojan link {url}: {e}")
        return None

def generate_clash_config(nodes):
    proxy_names = [node['name'] for node in nodes]
    
    config = {
        "port": 7890,
        "socks-port": 7891,
        "allow-lan": False,
        "mode": "rule",
        "log-level": "info",
        "external-controller": "127.0.0.1:9090",
        "proxies": nodes,
        "proxy-groups": [
            {
                "name": "Proxy",
                "type": "url-test", # 自动选择延迟最低的节点
                "url": "http://www.gstatic.com/generate_204",
                "interval": 300,
                "tolerance": 50,
                "proxies": proxy_names
            }
        ],
        "rules": [
            "MATCH,Proxy"
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
        # Maybe it's not base64, try using raw content if it looks like a list
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
    
    config = generate_clash_config(nodes)
    
    with open("config.yaml", "w", encoding="utf-8") as f:
        yaml.dump(config, f, allow_unicode=True)
    
    print("Clash config generated: config.yaml")

if __name__ == "__main__":
    main()

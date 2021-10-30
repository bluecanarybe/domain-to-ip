#!/bin/bash
# Converter.sh by Blue Canary
# With this script, you can convert domain lists to resolved IP lists without duplicates.
# Usage: ./domain-to-ip.sh [domain-list-file]

echo -e "[+] Converter.sh by Blue Canary\n"
if [ -z "$1" ]; then
  echo "[!] Usage: ./domain-to-ip.sh [domain-list-file]"
  exit 1
fi
echo "[+] Resolving domains to IPs..."
while read d || [[ -n $d ]]; do
  ip=$(dig +short $d|grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b")
  ip2=${ip//$'\n'/','}
  echo $d - $ip2 >> fullmapping.txt
  if [ -n "$ip2" ]; then
    echo "[+] '$d' => $ip2"
    echo $ip2 >> output
  else
    echo "[!] '$d' => [RESOLVE ERROR]"
  fi
done < $1
echo -e "\n[+] Removing duplicates..."
sort output | uniq > output.new
mv output.new output
echo -e "\n[+] Sorting public /private addresses.."

cat output | egrep -v '^(172\.(1[6-9]\.|2[0-9]\.|3[0-1]\.)|192\.168\.|10\.|127\.)' > public.txt
cat output | egrep  '^(172\.(1[6-9]\.|2[0-9]\.|3[0-1]\.)|192\.168\.|10\.|127\.)' > private.txt

echo -e "\n[+] Done, IPs saved."

!#/bin/sh

echo "=== Domains ==="
cat domains.json | python3 -m json.tool | grep "\(name\|objectid\)"
echo "==="
echo
echo "=== Computers ==="
cat computers.json | python3 -m json.tool | grep "\(name\|objectid\)"
echo "==="
echo
echo "=== Groups ==="
cat groups.json | python3 -m json.tool | grep "\(name\|objectid\)"
echo "==="
echo
echo "=== Users ==="
cat users.json | python3 -m json.tool | grep "\(name\|objectid\)"
echo "==="

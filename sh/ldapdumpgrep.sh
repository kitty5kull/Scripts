grep '\"cn\"\: \[|\"info\"|\"description\"' -E -i -A 1 domain_users.json domain_computers.json | grep -v '^--$'


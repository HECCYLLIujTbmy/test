#!/bin/bash

python3 -m http.server &
/bin/ss -tulpn > /app/result.txt

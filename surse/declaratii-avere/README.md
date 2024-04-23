# Usage
```
./download-since.sh
# ^^-- start date is 1st January 2023
```

# Debugging
```
journalctl  -u download-declaratii-avere | grep "too many" | awk '{print $7}' | awk -F '.' '{print $3"-"$2"-"$1}' |  xargs -n 1 -I DATA date '+%d.%m.%Y' -d "DATA +1 day"
# ^^-- get a list of dates where there were more than 10k documents thus the script failed to download them
```
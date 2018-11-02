ifconfig | grep 'ens3' -A1 | grep "inet" | cut -d ":" -f2 | cut -d " " -f1

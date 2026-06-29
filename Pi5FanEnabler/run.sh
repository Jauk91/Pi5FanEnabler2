#! /usr/bin/with-contenv bash
whoami
id
echo $0

# Håll tillägget vid liv
nc -lk -p 8099 -e echo -e 'HTTP/1.1 200 OK\r\n\r\n' &

#! /usr/bin/with-contenv bash
echo "--- KONTROLL: LÄSER INNEHÅLLET I CONFIG.TXT ---"

# Vi vet nu att den ligger på mmcblk0p1
DEV="/dev/mmcblk0p1"
MOUNT_POINT="/tmp/check_config"

mkdir -p $MOUNT_POINT
mount $DEV $MOUNT_POINT 2>/dev/null

if [ -f $MOUNT_POINT/config.txt ]; then
    echo "Filen hittades. Innehåll:"
    echo "-----------------------------------"
    # Läs hela filen
    cat $MOUNT_POINT/config.txt
    echo "-----------------------------------"
    
    # Sök specifikt efter fläktraderna
    if grep -q "dtparam=fan_" $MOUNT_POINT/config.txt; then
        echo "VARNING: Fläktrader hittades fortfarande i filen!"
    else
        echo "BEKRÄFTAT: Inga fläktrader hittades. Filen är ren."
    fi
else
    echo "Kunde inte hitta config.txt för kontroll."
fi

umount $MOUNT_POINT 2>/dev/null
echo "--- KONTROLL KLAR ---"
sleep 99999

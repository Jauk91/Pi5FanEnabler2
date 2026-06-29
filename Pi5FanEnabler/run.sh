#! /usr/bin/with-contenv bash
echo "Startar slutgiltig rensning av fläkt-inställningar..."

# Montera boot-partitionen
mkdir -p /tmp/clean
mount /dev/mmcblk0p1 /tmp/clean 2>/dev/null

# Rensa bort precis allt som har med fläktstyrning att göra
if [ -f /tmp/clean/config.txt ]; then
    sed -i '/dtparam=fan_/d' /tmp/clean/config.txt
    echo "SUCCESS: config.txt rensad från fläkt-rader."
else
    echo "Hittade inte config.txt, kan inte rensa."
fi

# Avmontera
umount /tmp/clean 2>/dev/null
echo "STÄDNING KLAR. Avinstallera tillägget NU."

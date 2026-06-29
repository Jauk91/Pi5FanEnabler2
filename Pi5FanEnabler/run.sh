#! /usr/bin/with-contenv bash
whoami
id
echo $0

# Håll tillägget vid liv
nc -lk -p 8099 -e echo -e 'HTTP/1.1 200 OK\r\n\r\n' &

echo "--- ALLÄTAREN: Skannar alla diskar efter config.txt ---"

# Vi definierar en lista med alla tänkbara kandidater (precis som hans)
diskar=("/dev/sda1" "/dev/sda2" "/dev/sdb1" "/dev/mmcblk0p1" "/dev/mmcblk0p2" "/dev/nvme0n1p1")

for dev in "${diskar[@]}"; do
    if [ -b "$dev" ]; then
        echo "Testar $dev..."
        
        # Skapa en unik mapp för varje test
        mkdir -p /tmp/mount_$dev 2>/dev/null
        mount "$dev" /tmp/mount_$dev 2>/dev/null
        
        # Kolla om config.txt finns här
        if [ -f /tmp/mount_$dev/config.txt ]; then
            echo "!!! HITTA CONFIG.TXT PÅ $dev !!!"
            
            # Rensningen
            sed -i '/dtparam=fan_/d' /tmp/mount_$dev/config.txt
            echo "Rensning utförd på $dev"
        fi
        
        # Städa upp
        umount /tmp/mount_$dev 2>/dev/null
        rmdir /tmp/mount_$dev 2>/dev/null
    fi
done

echo "--- SKANNING KLAR. Avinstallera tillägget nu. ---"
# Håll liv i tillägget så loggen hinner läsas
sleep 99999

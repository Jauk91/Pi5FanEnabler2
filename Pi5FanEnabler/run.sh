#! /usr/bin/with-contenv bash
whoami
id

# Webbservern (behövs för att hålla tillägget vid liv)
nc -lk -p 8099 -e echo -e 'HTTP/1.1 200 OK\r\nServer: DeskPiPro\r\n\r\nCleaning fan config...\r\n' &

until false; do
  set +e
  
  removeFanConfig () {
    partition=$1
    if [ ! -e /dev/$partition ]; then
      echo "no $partition available"
      return
    fi

    umount /tmp/$partition 2>/dev/null
    mount /dev/$partition /tmp/$partition 2>/dev/null

    if [ -e /tmp/$partition/config.txt ]; then
      echo "Rensar fläkt-rader på $partition/config.txt"
      # Denna rad tar bort alla rader som börjar med dtparam=fan_
      sed -i '/^dtparam=fan_/d' /tmp/$partition/config.txt
    else
      echo "No config.txt found on $partition"
    fi
    umount /tmp/$partition 2>/dev/null
  }

  # Processa alla partitioner (den hittar mmcblk0p1)
  removeFanConfig sda1
  removeFanConfig sdb1
  removeFanConfig mmcblk0p1
  removeFanConfig nvme0n1p1

  echo "Rensning klar. Avinstallera tillägget nu."
  sleep 99999
done

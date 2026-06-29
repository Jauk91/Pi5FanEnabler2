#! /usr/bin/with-contenv bash
whoami
id
echo $0

# Håll tillägget vid liv
nc -lk -p 8099 -e echo -e 'HTTP/1.1 200 OK\r\n\r\n' &

until false; do
  set +e
  
  removeFanConfig () {
    partition=$1
    if [ ! -e /dev/$partition ]; then return; fi

    umount /tmp/$partition 2>/dev/null
    mount /dev/$partition /tmp/$partition 2>/dev/null

    if [ -e /tmp/$partition/config.txt ]; then
      echo "--- KONTROLLERAR $partition/config.txt ---"
      
      # Visa raderna INNAN rensning i loggen
      echo "Rader som hittades innan rensning:"
      grep 'dtparam=fan_' /tmp/$partition/config.txt || echo "(Inga fläktrader hittades)"
      
      # Utför rensningen
      sed -i '/dtparam=fan_/d' /tmp/$partition/config.txt
      
      # Visa raderna EFTER rensning i loggen
      echo "Rader efter rensning:"
      grep 'dtparam=fan_' /tmp/$partition/config.txt || echo "(Alla fläktrader borttagna!)"
      
      echo "------------------------------------------"
    else
      echo "No config.txt found on $partition"
    fi
    umount /tmp/$partition 2>/dev/null
  }

  removeFanConfig mmcblk0p1
  
  echo "Rensning klar. Avinstallera tillägget nu."
  sleep 99999
done

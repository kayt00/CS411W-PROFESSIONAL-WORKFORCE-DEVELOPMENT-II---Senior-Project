#!/bin/bash

# reset the DB for BlackBear Backend
# May need to grant this run access via `chmod +x [filename]`
# Run by being in folder with script an issue command `./[filename]`

docker-compose down
sleep 1
echo "Docker container down!"

docker-compose up -d
sleep 1
echo "Docker container back up!"

echo "Waiting 15 seconds before syncing because reasons!"

i=0
while [ $i -lt 15 ]
do
  if (( $i % 5 == 0 )) && (( $i != 0 )); then echo "Waited for $i seconds!"; fi
  sleep 1
  ((i++))
done

echo "Migrating the database!"
npm run migrate
sleep 1

echo "And starting the server \o/"
npm start

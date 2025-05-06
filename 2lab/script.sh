#!/bin/sh
rm -f /shared/*
ID=$(uuidgen)
seq=1
while true; do
	filename=$(
	flock -x 199
	N=1
while ( -e "/shared/$(printf "%03d" $N)" ); do
	N=$(expr $N + 1)
done
filename="/shared/$(printf "%03d" $N)"
touch "$filename"
echo "$filename"
) 199>/shared/lockfile
echo "identifier: $ID" > "$filename"
echo "sequence: $seq" >> "$filename"
echo "$(date '+%Y-%m-%d %H:%M:%S'): Created file $filename with ID $ID and sequence $seq"
seq=$(expr $seq + 1)
sleep 1
echo "$(date '+%Y-%m-%d %H:%M:%S'): Deleted file $filename"
rm "$filename"
done

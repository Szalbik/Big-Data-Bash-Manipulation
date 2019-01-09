#! /usr/local/bin/bash

function convertTextToCSV() {
  > $2
  while read -a LINE
  do
    if [ "$2" == "tracks.csv" ]
    then
      echo ${LINE[@]} | awk -F'<SEP>' '{print $2","$1","$3","$4}' >> $2
    else
      echo ${LINE[@]} | awk -F'<SEP>' '{print $1","$2","$3}' >> $2
    fi
  done < $1
}

function createDataCSV() {
  # echo "id,rok,miesiac,dzien" > date.csv
  # echo "id,id_org,name,author" > songs.csv
  while IFS=, read -r tstamp
  do
    date -r $tstamp +$tstamp,%Y,%m,%d >> date.csv
  done < sort_timestamps.csv
}

function createUserCSV() {
  id=0
  while IFS=, read -r user_id col2 col3 col4
  do
    echo "$id,$user_id" >> users.csv
    id=$((id+1))
  done < sort_users.csv
}

function createSongsCSV() {
  id=0
  while IFS=, read -r playedId songId artistName songName
  do
    echo "$id,$songId,$artistName,$songName" >> songs.csv
    id=$((id+1))
  done < unique_tracks.csv
}

function createListeningsCSV() {
  while IFS=, read -r trackId userId dateTstamp
  do
    awk '/TRMMMUT128F42646E8/' songs.csv
    myUserId=$(awk -v var="$userId" -F',' '{ if(($2 == var)) { print $1 } }' users.csv)
    myTrackId=$(awk -v var="$trackId" -F',' '{ if(($2 == var)) { print $1 } }' songs.csv)
    echo "$userId"
    echo "$myUserId,$myTrackId,$dateTstamp" >> listenings.csv
  done < samples.csv
}

function prepareData() {
  awk -F',' '{ print $3 }' samples.csv | sort | uniq  >> sort_timestamps.csv;
  awk -F',' '{ print $2 }' samples.csv | sort | uniq  >> sort_users.csv;
  # awk -F',' '{ print $1 }' tracks.csv | sort | uniq  >> sort_users.csv;
}

function clearAll() {
  > listenings.csv
  > date.csv
  > dates.csv
  # > samples.csv
  # > songs.csv
  > sort_date.csv
  > sort_samples.csv
  > sort_timestamps.csv
  # > tracks.csv
  > users.csv
  > sort_users.csv
}

uniqTracks='unique_tracks.txt'
tripSample='triplets_sample_20p.txt'

uniqTracksMod='mod_unique_tracks.txt'
tripSampleMod='mod_triplets_sample_20p.txt'

clearAll
# convertTextToCSV $uniqTracks tracks.csv
# convertTextToCSV $tripSampleMod samples.csv
prepareData
createDataCSV
createUserCSV
# createSongsCSV
createListeningsCSV


# awk '/SOQVRHI12A6D4FB2D7/' songs.csv





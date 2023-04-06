#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table -t -c"

if [[ -z $1 ]]
then
  echo -e "Please provide an element as an argument."
else
  #if atomic_number
  ATOMIC_NUMBER=$($PSQL "select atomic_number from elements where atomic_number=$1")
  if [[ -z $ATOMIC_NUMBER ]]
  then
    #check if it's a symbol
    echo robimy cos innego
  else
    #provide info to the user
    INFO=$($PSQL "
    select 
      e.atomic_number,e.symbol,e.name,p.atomic_mass,p.melting_point_celsius,p.boiling_point_celsius,t.type 
    from 
      elements e
      join properties p on p.atomic_number = e.atomic_number
      join types t on t.type_id = p.type_id
    where
      e.atomic_number = $ATOMIC_NUMBER
    ")
    echo "$INFO" | while read NUM BAR SYM BAR NAME BAR MASS BAR MPOINT BAR BPOINT BAR TYPE
    do
      echo "The element with atomic number $NUM is $NAME ($SYM). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MPOINT celsius and a boiling point of $BPOINT celsius."
    done
  fi
fi
#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

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
      e.symbol,e.name,p.atomic_mass,p.melting_point,p.boiling_point,t.type 
    from 
      elements e
      join properties p on p.atomic_mass = e.atomic_mass
      join types t on t.type_id = p.type_id
    where
      e.atomic_number = $ATOMIC_NUMBER
    ")
    echo $INFO | while read SYM BAR NAME BAR MASS BAR MPOINT BAR BPOINT BAR TYPE
    do
      echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYM). It's a $TYPE, with a mass of $MASS. $NAME has a melting point of $MPOINT celsius and a boiling point of $BPOINT celsius."
    done
  fi
fi
#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table -t -c"

if [[ -z $1 ]]
then
  echo -e "Please provide an element as an argument."
else
  #add check if integer
  if [[ ! $1 =~ ^[0-9]+$ ]]
  then
    #check if it's a symbol
    SYMBOL=$($PSQL "select symbol from elements where symbol='$1'")
    if [[ -z $SYMBOL ]]
    then
      NAME=$($PSQL "select name from elements where name='$1'")
      if [[ -z $NAME ]]
      then
        echo "I could not find that element in the database."
      else
        INFO=$($PSQL "
      select 
        e.atomic_number,e.symbol,e.name,p.atomic_mass,p.melting_point_celsius,p.boiling_point_celsius,t.type 
      from 
        elements e
        join properties p on p.atomic_number = e.atomic_number
        join types t on t.type_id = p.type_id
      where
        e.name = '$1'
      ")
      echo "$INFO" | while read NUM BAR SYM BAR NAME2 BAR MASS BAR MPOINT BAR BPOINT BAR TYPE
      do
        echo "The element with atomic number $NUM is $NAME2 ($SYM). It's a $TYPE, with a mass of $MASS amu. $NAME2 has a melting point of $MPOINT celsius and a boiling point of $BPOINT celsius."
      done
      fi
    else
      INFO=$($PSQL "
      select 
        e.atomic_number,e.symbol,e.name,p.atomic_mass,p.melting_point_celsius,p.boiling_point_celsius,t.type 
      from 
        elements e
        join properties p on p.atomic_number = e.atomic_number
        join types t on t.type_id = p.type_id
      where
        e.symbol = '$1'
      ")
      echo "$INFO" | while read NUM BAR SYM BAR NAME BAR MASS BAR MPOINT BAR BPOINT BAR TYPE
      do
        echo "The element with atomic number $NUM is $NAME ($SYM). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MPOINT celsius and a boiling point of $BPOINT celsius."
      done
    fi  
  else
    #check if atomic_number in database
    ATOMIC_NUMBER=$($PSQL "select atomic_number from elements where atomic_number=$1")
    if [[ -z $ATOMIC_NUMBER ]]
    then
      echo "I could not find that element in the database."
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
fi
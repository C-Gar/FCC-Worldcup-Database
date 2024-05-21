#!/bin/bash

if [[ $1 == "test" ]]; then
    PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
    PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# Empty the games and teams tables
echo $($PSQL "TRUNCATE TABLE games, teams;")

# Read and process the CSV file
tail -n +2 games.csv | while IFS="," read -r year round winner opponent winner_goals opponent_goals; do
    # Insert winner into teams table if not already exists
    winner_id=$($PSQL "SELECT team_id FROM teams WHERE name='$winner';")
    if [[ -z $winner_id ]]; then
        $PSQL "INSERT INTO teams (name) VALUES ('$winner');"
        winner_id=$($PSQL "SELECT team_id FROM teams WHERE name='$winner';")
    fi
    
    # Insert opponent into teams table if not already exists
    opponent_id=$($PSQL "SELECT team_id FROM teams WHERE name='$opponent';")
    if [[ -z $opponent_id ]]; then
        $PSQL "INSERT INTO teams (name) VALUES ('$opponent');"
        opponent_id=$($PSQL "SELECT team_id FROM teams WHERE name='$opponent';")
    fi
    
    # Insert game data into games table
    $PSQL "INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ('$year', '$round', '$winner_id', '$opponent_id', '$winner_goals', '$opponent_goals');"
done
#!/bin/bash

clear

# Funktion zum Erstellen eines zufälligen Fisches an einer bestimmten Position
create_fish() {
    local size=$((RANDOM % 3 + 1))
    local color=$((RANDOM % 6 + 1))
    local position=$1

    tput setaf $color
    tput cup $((RANDOM % $(tput lines))) $position
    echo -e "<><"
    tput cup $((RANDOM % $(tput lines))) $((position + 1))
    echo -e "(^_^)"
    tput sgr0
}

# Funktion zum Anzeigen einer zufälligen Anzahl von Fischen
show_fish_tank() {
    local num_fish=$((RANDOM % 10 + 5))
    local width=$(tput cols)
    local fish_positions=()

    # Erzeuge zufällige Anfangspositionen für die Fische
    for ((i=0; i<num_fish; i++)); do
        fish_positions+=( $((RANDOM % width)) )
    done

    while true; do
        # Lösche den alten Zustand des Tanks
        clear

        # Bewege jeden Fisch ein Stück nach rechts und erstelle ihn neu
        for ((i=0; i<num_fish; i++)); do
            fish_positions[i]=$(( (fish_positions[i] + 1) % width ))
            create_fish ${fish_positions[i]}
        done

        # Warte kurz, bevor der nächste Schritt erfolgt
        sleep 0.1
    done
}

# Hauptprogramm
show_fish_tank
#!/bin/bash

clear

# Funktion zum Erstellen eines zufälligen Fisches
create_fish() {
    local size=$((RANDOM % 3 + 1))
    local position=$((RANDOM % $(tput cols)))
    local color=$((RANDOM % 6 + 1))

    tput setaf $color
    tput cup $((RANDOM % $(tput lines))) $position
    echo -e "<><"
    tput cup $((RANDOM % $(tput lines))) $((position + 1))
    echo -e "(^_^)"
    tput sgr0
}

# Funktion zum Anzeigen einer zufälligen Anzahl von Fischen
show_fish_tank() {
    local num_fish=$((RANDOM % 10 + 5))

    for ((i=0; i<num_fish; i++)); do
        create_fish
    done
}

# Hauptprogramm
show_fish_tank

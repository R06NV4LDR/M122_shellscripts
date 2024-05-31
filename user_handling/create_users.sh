    #!/bin/bash

    #In aufg1.sh gespeichert!

    for user in $(cat $1); do
        useradd $user;
    done


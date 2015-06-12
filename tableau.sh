#!/usr/bin/env bash
#script de gestion des jobs en cours
function affiche {
printf "compteur : %s ; restant : %s" "$compteur" "$executions"
}
function detection_dernier_proc {
dernier=$(ls -tr PIDFILES/$NOM_PROC | egrep [0-9]+ | tail -1)
}
NOM_PROC=$1
while [ 1 ]
do
detection_dernier_proc
if [ -f PIDFILES/$NOM_PROC/$dernier/compteur_fork ];then
compteur=$(cat  PIDFILES/$NOM_PROC/$dernier/compteur_fork)
fi
if [ -f PIDFILES/$NOM_PROC/$dernier/execution ];then
executions=$(cat  PIDFILES/$NOM_PROC/$dernier/execution)
else 
executions=0
fi
taille=$(affiche)
affiche
eval printf '%.0s\\b' {1..${#taille}}
sleep 2
done

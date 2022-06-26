#!/bin/bash

HLDS=$(pwd)/hlds_run
GAME=cstrike
MAP=de_dust2
IP=0.0.0.0
PORT=27015

ARGS=("-game" "${GAME}" "-strictportbind" "-ip" "${IP}" "-port" "${PORT}" "+map" "${MAP}")

echo "Executing ${HLDS} ${ARGS[@]}"
exec "${HLDS}" "${ARGS[@]}"

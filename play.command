#!/bin/bash
cd `dirname "$BASH_SOURCE"`
cd ../../..
ls

echo "TASK: WARP/CREATE/ENTER/LEAVE/ ================================="
sleep 0.5; ruby nataniev.operator.rb paradise serve 36
sleep 0.5; ruby nataniev.operator.rb paradise serve 36 warp to 1
sleep 0.5; ruby nataniev.operator.rb paradise serve 36 create a benchmark tool
sleep 0.5; ruby nataniev.operator.rb paradise serve 36 enter the benchmark tool
sleep 0.5; ruby nataniev.operator.rb paradise serve 36 leave
sleep 0.5; ruby nataniev.operator.rb paradise serve 36 enter the benchmark tool

echo "TASK: NOTE/PROGRAM/SET ================================="
sleep 0.5; ruby nataniev.operator.rb paradise serve 36
sleep 0.5; ruby nataniev.operator.rb paradise serve 36 note benchmark note
sleep 0.5; ruby nataniev.operator.rb paradise serve 36 program create benchmark program
sleep 0.5; ruby nataniev.operator.rb paradise serve 36 cast the vanish spell on the benchmark note
sleep 0.5; ruby nataniev.operator.rb paradise serve 36 cast the petunia spell on the benchmark note

echo "TASK: TAKE/DROP/INSPECT/TRANSFORM ================================="
sleep 0.5; ruby nataniev.operator.rb paradise serve 36
sleep 0.5; ruby nataniev.operator.rb paradise serve 36 create a tiny quazar
sleep 0.5; ruby nataniev.operator.rb paradise serve 36 take the tiny quazar
sleep 0.5; ruby nataniev.operator.rb paradise serve 36 drop the tiny quazar
sleep 0.5; ruby nataniev.operator.rb paradise serve 36 inspect the tiny quazar
sleep 0.5; ruby nataniev.operator.rb paradise serve 36 transform into a benchmark vessel

echo "TASK: HELP ================================="
sleep 0.5; ruby nataniev.operator.rb paradise serve 36
sleep 0.5; ruby nataniev.operator.rb paradise serve 36 help
sleep 0.5; ruby nataniev.operator.rb paradise serve 36 help with wildcards
sleep 0.5; ruby nataniev.operator.rb paradise serve 36 help with attributes
sleep 0.5; ruby nataniev.operator.rb paradise serve 36 help with spells
sleep 0.5; ruby nataniev.operator.rb paradise serve 36 help with basic
sleep 0.5; ruby nataniev.operator.rb paradise serve 36 help with movement
sleep 0.5; ruby nataniev.operator.rb paradise serve 36 help with communication
sleep 0.5; ruby nataniev.operator.rb paradise serve 36 help with narrative
sleep 0.5; ruby nataniev.operator.rb paradise serve 36 help with programming

echo "TASK: SAY/EMOTE/SIGNAL ================================="
sleep 0.5; ruby nataniev.operator.rb paradise serve 36
sleep 0.5; ruby nataniev.operator.rb paradise serve 36 say hello
sleep 0.5; ruby nataniev.operator.rb paradise serve 36 emote acts like a word
sleep 0.5; ruby nataniev.operator.rb paradise serve 36 signal

echo "TASK: LIMITS ================================="
sleep 0.5; ruby nataniev.operator.rb paradise serve 36
sleep 0.5; ruby nataniev.operator.rb paradise serve 36 warp to 0
sleep 0.5; ruby nataniev.operator.rb paradise serve 36 warp to -1
sleep 0.5; ruby nataniev.operator.rb paradise serve 36 warp to 99999999999
sleep 0.5; ruby nataniev.operator.rb paradise serve 36 warp to the apple tree
sleep 0.5; ruby nataniev.operator.rb paradise serve 36 warp to the quazar
sleep 0.5; ruby nataniev.operator.rb paradise serve 36 warp to haven

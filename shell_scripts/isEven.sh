#!/bin/bash

parity=(even odd) # parity[0]='even' parity[1]='odd'
read -p "enter a number: " a
echo "the number is "${parity[$((a%2))]}

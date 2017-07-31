#!/bin/bash

sed -i 's/^M$//; s/\x0D$//' $1
echo "DOS to LNX Conversion over"

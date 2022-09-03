#!/bin/bash

grep "SidTypeUser" lookupsid.txt | grep -oE '\\.+ ' | sed 's/\\//g' | sed 's/ //g'


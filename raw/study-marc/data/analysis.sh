#!/bin/bash
grep -R threshold | sed -E -e 's/\/BLOCK/ /g' -e 's/-none-none-/ /g' -e 's/.m:threshold = \[/ /' -e 's/];//g' | column -t | sort -k1,1 -k2,1 -k3,1

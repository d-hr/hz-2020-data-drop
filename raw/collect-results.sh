#!/bin/bash

grep -R threshold | \
  sed -e '/threshold_/ d' \
      -e 's|data/||g' \
      -e 's|BLOCK||g' \
      -e 's|none| |g' \
      -e 's|- - -| |g' \
      -e 's|:threshold = \[| |g' \
      -e 's|\];||g' \
      -e 's|\.m||g' | \
  tr '/' ' ' | \
  awk '{gsub(/\-/, " ", $3); print $2, $1, $3, $4, $5}' | \
  sort -k2,3  | \
  column -t


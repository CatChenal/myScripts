#!/bin/sh
# Cat Chenal 2011-07-07
#
cd cl000
  rem-cl-not-in-run.sh "46[5|6|7]"
cd ../cl001
  rem-cl-not-in-run.sh "46[5|6]"
cd ../cl010
  rem-cl-not-in-run.sh "46[5|7]"
cd ../cl011
  rem-cl-not-in-run.sh "465"
cd ../cl100
  rem-cl-not-in-run.sh "46[6|7]"
cd ../cl101
  rem-cl-not-in-run.sh "466"
cd ../cl110
  rem-cl-not-in-run.sh "467"
cd ../cl000
  rem-cl-not-in-run.sh "46[5|6|7]"
cd ../
echo "Removal2 over!"


echo \#!/bin/bash
echo rspec=\"ls -1\"
cat ~/work/freemyapps/ci/travis.sh \
  | grep -v "^then" \
  | grep -v "^elif" \
  | grep -v "^  export" \
  | grep -v "^[^ ]" \
  | grep -v "^$" \
  | grep -v "^  sh" \




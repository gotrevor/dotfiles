#!/bin/bash
BRANCH=`git pwb`
CMD="bundle exec cap HOSTS=staging-fma-script-02.freemyapps.com -S branch=$BRANCH staging deploy_with_chef"
echo $CMD
$CMD

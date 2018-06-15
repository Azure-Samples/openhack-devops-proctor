#!/bin/sh

grep -l 'devopsoh2subproc1fun' src/environments/*.ts | xargs sed -i.bak -e "s|devopsoh2subproc1fun|$FUNCTION_NAME|g" 


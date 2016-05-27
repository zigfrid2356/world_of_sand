#!/bin/bash  
git pull
git init
git add .
git commit -a -m 'magic out info'
git remote add origin git@github.com:username/reponame.git
git push -u origin master

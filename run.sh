#!/bin/bash  
git pull
git init
git add .
git commit -a -m 'utf8 text'
git remote add origin git@github.com:username/reponame.git
git push -u origin master

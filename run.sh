#!/bin/bash  
git pull
git init
git add .
git commit -a -m 'борьба с мешком'
git remote add origin git@github.com:username/reponame.git
git push -u origin master

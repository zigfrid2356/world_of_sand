
#!/bin/bash 
mdate=" $(date +%d-%m-%Y\ %H:%M:%S) "
git pull
git init
git add .
git commit -a -m mdate
git remote add origin git@github.com:username/reponame.git
git push -u origin master

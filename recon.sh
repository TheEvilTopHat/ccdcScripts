#Getting Server Info
printf "---Server Information---\n" > reconReport.txt
uname -a >> reconReport.txt

#Checking in use ports
printf "---In use ports---\n" >> reconReport.txt
netstat -tulpn | grep LISTEN >> reconReport.txt

#Getting all users
printf "---All Users---" >> reconReport.txt
less /etc/passwd >> reconReport.txt

#Getting all programs currently running
ps >> reconReport.txt


#Getting Server Info
echo "---Server Information---" > reconReport.txt
uname -a >> reconReport.txt
echo ""

#Checking in use ports
echo "---In use ports---" >> reconReport.txt
netstat -tulpn | grep LISTEN >> reconReport.txt
echo ""

#Getting all users
echo "---All Users---" >> reconReport.txt
less /etc/passwd >> reconReport.txt
echo ""

#Getting all programs currently running
ps >> reconReport.txt


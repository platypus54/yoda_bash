#!/bin/bash

# test variable for while loops; 0: loop runs 1: loop breaks. 
test=0



# asks for a group name while checking if duplicate
# if it group name doesn't exit, then it creates it
# if not, it asks for again for a valid group name

while [ $test -eq 0 ] 

do
	echo -n "Enter a group to make:"
	read GROUP
	grep -q "^$GROUP" /etc/group

if [ $? -eq 0 ]
then
	echo " $GROUP group exists, try a different name"
else
	sudo addgroup "$GROUP"
	test=1
fi

done


#upate test condition
test=0

# repeats until a vaild username is selected
while [ $test  -eq 0 ]

do
	echo -n "Enter a user to make:"
	read USER

	grep -q "^$USER" /etc/passwd

# checks existence of user
# if it does, try again
# it not, create user, set permissions, and change ownership.
if [ $? -eq 0 ]
then
	echo " $USER already exists, try a different name."
else
	echo " Creating $USER"
	sudo useradd -m -d /$USER -g $GROUP -s /bin/bash $USER
	echo " creating home directory /$USER"
	echo " adding to group $GROUP" 
	echo " /bin/bash shell selected "
	sudo passwd $USER
	sudo chown "$USER":"$GROUP" /"$USER"
	sudo chmod 1770 /"$USER"
	test=1
fi

done

echo -e "\a"

#log files to keep track of users and groups added
grep "^$USER" /etc/passwd >>  ~/yoda_bash/log/yoda_user.log
grep  "^$GROUP" /etc/group  >> ~/yoda_bash/log/yoda_group.log



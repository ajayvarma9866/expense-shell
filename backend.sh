#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
echo "Please enter DB password:"
read -s mysql_root_password

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2...$R FAILURE" $N
        exit 1
    else
        echo -e "$2...$G SUCCESS" $N
    fi
}

if [ $USERID -ne 0 ] 
then 
    echo "please run this script with root access."
    exit 1
else
    echo "you are super user."
fi

dnf module disable nodejs -y &>>$LOGFILE
VALIDATE $? "Disabling nodejs"

dnf module enable nodejs:20 -y &>>$LOGFILE
VALIDATE $? "Enabling nodejs:20 version"

dnf install nodejs -y &>>$LOGFILE
VALIDATE $? "Installing nodejs"

id expense &>>$LOGFILE
if[ $? -ne 0 ]
then
    useradd expense &>>$LOGFILE
    VALIDATE $? "craeting user"
else
    echo -e "expense user already created... $Y SKIPPING $N"

mkdir -p /app &>>$LOGFILE
VALIDATE $? "craeting a directory"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOGFILE
VALIDATE $? "downloading backend content"

cd /app
rm -rf /app/*
unzip /tmp/backend.zip &>>$LOGFILE
VALIDATE $? "unzipping the backend content"

npm install &>>$LOGFILE
VALIDATE $? "downloading nodejs dependencies"

cp /home/ec2-user/expense-shell/backend.service /etc/systemd/system/backend.service &>>$LOGFILE
VALIDATE $? "copying backend.service file"

systemctl daemon-reload &>>$LOGFILE
VALIDATE $? "service daemon reload"

systemctl enable backend &>>$LOGFILE
VALIDATE $? "enabling backend service"

systemctl start backend &>>$LOGFILE
VALIDATE $? "starting backend service"

dnf install mysql -y &>>$LOGFILE
VALIDATE $? "Installation of mysql"

mysql -h db.devops9866.online -uroot -p${mysql_root_password} < /app/schema/backend.sql &>>$LOGFILE
VALIDATE $? "loading schema"

systemctl restart backend &>>$LOGFILE
VALIDATE $? "Restarting backend service"
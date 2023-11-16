
log_file=/tmp/expense.log
colour="\e[36m"

if [ -z "$1" ]; then
  echo password input missing
  exit
fi
MYSQL_ROOT_PASSWORD=$1

status_check(){
  if [ $? -eq 0 ]; then
    echo -e "\e[32m SUCCESS \e[0m"
  else
    echo -e "\e[31m FAILURE \e[0m"
  fi
}
echo -e "${colour} disable nodejs default version \e[0m"
dnf module disable nodejs -y &>>$log_file
status_check

echo -e "${colour} enable nodejs 18 version \e[0m"
dnf module enable nodejs:18 -y &>>$log_file
status_check

echo -e "${colour} install nodejs \e[0m"
dnf install nodejs -y &>>$log_file
status_check

echo -e "${colour} copy backend service file \e[0m"
cp backend.service /etc/systemd/system/backend.service &>>$log_file
status_check

id expense &>>$log_file
if [ $? -ne 0 ]; then
  echo -e "${colour} add application user \e[0m"
  useradd expense &>>$log_file
  status_check
fi

if [ ! -d /app ]; then
  echo -e "${colour} create application directory \e[0m"
  mkdir /app &>>$log_file
  status_check
fi

echo -e "${colour} delete old application content \e[0m"
rm -rf /app/* &>>$log_file
status_check

echo -e "${colour} download application content \e[0m"
curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/backend.zip &>>$log_file
status_check

echo -e "${colour} extract application content \e[0m"
cd /app
unzip /tmp/backend.zip &>>$log_file
status_check

echo -e "${colour} download nodejs dependencies \e[0m"
npm install &>>$log_file
status_check

echo -e "${colour} install mysql client to load schema \e[0m"
dnf install mysql -y &>>$log_file
status_check

echo -e "${colour} load schema \e[0m"
mysql -h mysql-dev.devops9866.online -uroot -p${MYSQL_ROOT_PASSWORD} < /app/schema/backend.sql &>>$log_file
status_check

echo -e "${colour} starting backend service \e[0m"
systemctl daemon-reload &>>$log_file
systemctl enable backend &>>$log_file
systemctl restart backend &>>$log_file
status_check

log_file=/tmp/expense.log
colour="\e[36m"

echo -e "${colour} disable nodejs default version \e[0m"
dnf module disable nodejs -y &>>$log_file
echo $?

echo -e "${colour} enable nodejs 18 version \e[0m"
dnf module enable nodejs:18 -y &>>$log_file
echo $?

echo -e "${colour} install nodejs \e[0m"
dnf install nodejs -y &>>$log_file
echo $?

echo -e "${colour} copy backend service file \e[0m"
cp backend.service /etc/systemd/system/backend.service &>>$log_file
echo $?

echo -e "${colour} add application user \e[0m"
useradd expense &>>$log_file
echo $?

echo -e "${colour} create application directory \e[0m"
mkdir /app &>>$log_file
echo $?

echo -e "${colour} download application content \e[0m"
curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/backend.zip &>>$log_file
echo $?

echo -e "${colour} extract application content \e[0m"
cd /app
unzip /tmp/backend.zip &>>$log_file
echo $?

echo -e "${colour} download nodejs dependencies \e[0m"
npm install &>>$log_file
echo $?

echo -e "${colour} install mysql client to load schema \e[0m"
dnf install mysql -y &>>$log_file
echo $?

echo -e "${colour} load schema \e[0m"
mysql -h mysql-dev.devops9866.online -uroot -pExpenseApp@1 < /app/schema/backend.sql &>>$log_file
echo $?

echo -e "${colour} starting backend service \e[0m"
systemctl daemon-reload &>>$log_file
systemctl enable backend &>>$log_file
systemctl restart backend &>>$log_file
echo $?

source common.sh

if [ -z "$1" ]; then
  echo password input missing
  exit
fi
MYSQL_ROOT_PASSWORD=$1

echo -e "${colour} disable mysql default version \e[0m"
dnf module disable mysql -y &>>$log_file
status_check

echo -e "${colour} copy mysql repo file \e[0m"
cp mysql.repo /etc/yum.repos.d/mysql.repo &>>$log_file
status_check

echo -e "${colour} install mysql server \e[0m"
dnf install mysql-community-server -y &>>$log_file
status_check

echo -e "${colour} start mysql server \e[0m"
systemctl enable mysqld &>>$log_file
systemctl start mysqld &>>$log_file
status_check

echo -e "${colour} set mysql password \e[0m"
mysql_secure_installation --set-root-pass ${MYSQL_ROOT_PASSWORD} &>>$log_file
status_check
log_file=/tmp/expense.log
colour="\e[36m"

echo -e "${colour} disable mysql default version \e[0m"
dnf module disable mysql -y &>>$log_file
echo $?

echo -e "${colour} copy mysql repo file \e[0m"
cp mysql.repo /etc/yum.repos.d/mysql.repo &>>$log_file
echo $?

echo -e "${colour} install mysql server \e[0m"
dnf install mysql-community-server -y &>>$log_file
echo $?

echo -e "${colour} start mysql server \e[0m"
systemctl enable mysqld &>>$log_file
systemctl start mysqld &>>$log_file
echo $?

echo -e "${colour} set mysql password \e[0m"
mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$log_file
echo $?
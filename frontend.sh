log_file=/tmp/expense.log
colour="\e[36m"

echo -e "${colour} installing nginx \e[0m"
dnf install nginx -y &>>$log_file
echo $?

echo -e "${colour} adding configuration file \e[0m"
cp expense.conf /etc/nginx/default.d/expense.conf &>>log_file
echo $?

echo -e "${colour} removing default data \e[0m"
rm -rf /usr/share/nginx/html/* &>>log_file
echo $?

echo -e "${colour} download frontend application code \e[0m"
curl -o /tmp/frontend.zip https://expense-artifacts.s3.amazonaws.com/frontend.zip &>>log_file
echo $?

echo -e "${colour} extracting downloaded content \e[0m"
cd /usr/share/nginx/html &>>log_file
unzip /tmp/frontend.zip &>>log_file
echo $?

echo -e "${colour} starting nginx service \e[0m"
systemctl enable nginx &>>log_file
systemctl restart nginx &>>log_file
echo $?
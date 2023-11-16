echo -e "\e[36m installing nginx \e[0m"
dnf install nginx -y &>> /tmp/expense.log

echo -e "\e[36m adding configuration file \e[0m"
cp expense.conf /etc/nginx/default.d/expense.conf &>> /tmp/expense.log

echo -e "\e[36m removing default data \e[0m"
rm -rf /usr/share/nginx/html/* &>> /tmp/expense.log

echo -e "\e[36m download frontend application code \e[0m"
curl -o /tmp/frontend.zip https://expense-artifacts.s3.amazonaws.com/frontend.zip &>> /tmp/expense.log

echo -e "\e[36m extracting downloaded content \e[0m"
cd /usr/share/nginx/html &>> /tmp/expense.log
unzip /tmp/frontend.zip &>> /tmp/expense.log

echo -e "\e[36m starting nginx service \e[0m"
systemctl enable nginx &>> /tmp/expense.log
systemctl restart nginx &>> /tmp/expense.log
dnf install nginx -y

rm-rf /usr/share/nginx/html/*

cp expense.conf /etc/nginx/default.d/expense.conf

curl -o /tmp/frontend.zip https://expense-artifacts.s3.amazonaws.com/frontend.zip

cd /usr/share/nginx/html
unzip /temp/frontend.zip

systemctl enable nginx
systemctl restart nginx



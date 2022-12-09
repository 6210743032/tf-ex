# sleep จนกว่า instance จะเริ่ม
until [[ -f /var/lib/cloud/instance/boot-finished ]]; 
do
   sleep 1
done

# install nginx
apt-get update
apt-get -y install nginx

# nginx is started
service nginx start
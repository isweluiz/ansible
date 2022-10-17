# Nginx ProxyPass for RunDeck 3.3.10

![nginx_proxy](https://i.imgur.com/kUwtSta.jpg)

RunDeck’s web GUI always run on port 4440. If we want to make it run on 80 then we need to do a custom installation. Since that’ll be a long process and its not applicable for existing RunDeck servers. In this blog, we are configuring nginx proxypass for Rundeck to make RunDeck web access on port 80.

### Install Nginx

Case you are using RHEL or CentOS you can use the command bellow:

```bash
yum install nginx -y 
of
dnf install nginx -y
```

### Configure ProxyPass:

Create a new config file on /etc/nginx/conf.d/

vim /etc/nginx/conf.d/rundeck.conf

```nginx
 server {
     listen 80;
     server_name myhost;
  
  
     error_log   /var/log/nginx/rundeck.error.log;
     access_log  /var/log/nginx/rundeck.access.log;
  
      location / {
      proxy_ignore_client_abort on;
      proxy_pass http://localhost:4440;
      proxy_set_header X-Forwarded-Host $host:$server_port;
      proxy_set_header X-Forwarded-server $host;
      proxy_set_header  X-Forwarded-For $proxy_add_x_forwarded_for;

    }
  }
```

### Change the Server URL in runeck config file:

Edit the rundeck-config.properties file.

```bash
vim /etc/rundeck/rundeck-config.properties

grails.serverURL=http://myhost:80
```

### Restart RunDeck & Nginx

```bash
systemctl restart nginx ; systemctl restart rundeckd
```
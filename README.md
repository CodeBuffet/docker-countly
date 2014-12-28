#Countly Docker Image

I made my own docker image for Countly because the ones already existing simply didnt meet my needs.
This image is a lot lighter because it links to another MonogDB instance, so if you already have MongoDB (docker image, see: https://registry.hub.docker.com/_/mongo/) then you dont have to run another DB.

This docker image is officialy supported by CodeBuffet. Leave any questions and I try to respond as soon as possible ;)

##Steps

- Install MongoDB if you havent done already (see the mongodb link)
- Pull my image: `docker pull peterwilli/countly`
- Run the docker image: `docker run -d --name YOUR_COUNTLY_NAME -p 6001:6001 -p 3001:3001 --link YOUR_MONGO_INSTANCE_NAME:MONGO -t peterwilli/countly`
   - Where `YOUR_COUNTLY_NAME` can be any name you like (I have just 'countly')
   - Where `YOUR_MONGO_INSTANCE_NAME` is the name of your currently running mongodb instance.


#NGINX configuration

Now we got our countly running, add it to your NGINX server.
Use a config like this:

- where `YOUR_COUNTLY_SERVER_NAME` is the hostname of your countly server. (like countly.codebuffet.co)
  
    server {
        server_name YOUR_COUNTLY_SERVER_NAME;
    
        access_log  off;
    
        location = /i {
            proxy_pass http://127.0.0.1:3001;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Real-IP $remote_addr;
        }
    
        location ^~ /i/ {
            proxy_pass http://127.0.0.1:3001;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Real-IP $remote_addr;
        }
    
        location = /o {
            proxy_pass http://127.0.0.1:3001;
        }
    
        location ^~ /o/ {
            proxy_pass http://127.0.0.1:3001;
        }
    
        location / {
            proxy_pass http://127.0.0.1:6001;
            proxy_set_header Host $http_host;
        }
    }

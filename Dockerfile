## This file is to create an image of the service and run it i.e create a container.
## This file is used by the docker build command for instructions on how to build the image
## Use docker run command to run the image i.e. create container.

FROM node:8

# Will create a new directory inside '/' i.e. /apiGateway and cd to it as well IN the docker image. Do not confuse with the pwd of local app where dockerfile exist and pwd inside docker image.
WORKDIR apiGateway

# Copy package.json first and not do 'Copy . .' because that will take time and npm run will try to run.

# /apiGateway is a absolute path, could also have done --> COPY package.json .
COPY package.json /apiGateway

RUN npm install && sleep 5

# Copying everything from the local folder where the Dockerfile exist to the docker's '/apiGateway'
COPY . /apiGateway

# Note the above 'COPY . /apiGateway' could be achieved using relative path '.', since we are already in the apiGateway as we did WORKDIR above and did not change path after that.
# COPY . .

CMD npm run postinstall && DEBUG=express-mysql-session* node server/index.js
# depends on in docker-compose just depends on the container start and does not make sure that database is created and all that. Because of this reason, it was giving error and table was unable to create. Adding delay of 3 sec by doing sleep 3 gives ample time to setup db container before it starts the gateway container that uses and fills in the db.

# Two things 1) EXPOSE and 2) using -p in the docker run cmd for publish.
# EXPOSE is used for inter dockers communication. Publishing is important when the service needs to be accessed from outside e.g localhost.

# It is not needed when doing -p because it will expose too. But still good to have for later when -p is not used for outside access and just want to allow container <-> container communication.

EXPOSE 9000


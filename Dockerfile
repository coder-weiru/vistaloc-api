# Dockerfile for vistaloc-api

# Build Docker image
# docker build -t vistaloc-api https://github.com/coder-weiru/vistaloc-api.git
# docker build -t vistaloc-api .

# Run Docker image
# docker run --rm -it -p 8100:8100 -p 35729:35729 vistaloc-api

# # once you're running inside the Docker container
# aws configure  # make sure to choose us-east-1 as the region
# cd ./api
# gulp deploy
# gulp bootstrap
# cd ../app
# ionic serve
# use http://localhost:8100 to browse and test app

# q to quit Ionic
# exit to exit the Docker container

#=========================================================================


FROM library/ubuntu:16.04
MAINTAINER chris.ru@gmail.com
WORKDIR /home/
ENV DIRPATH /home/vistaloc-api

# update apt repository packages
RUN apt-get update

# install the AWS CLI and Python pip dependency
RUN apt-get install -y python-pip
RUN pip install awscli

# install Node.js
RUN apt-get install -y python-software-properties
RUN apt-get install -y curl
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install -y nodejs

# set the Node.js npm logger level for build visibility (logging minimized by default)
# RUN npm config set loglevel info

# install git and pull down source code
RUN apt-get install -y git
RUN git clone https://github.com/coder-weiru/vistaloc-api.git
RUN DIRPATH=$(pwd)/vistaloc-api

# install the latest Gulp CLI tools globally (you will need a newer version of Gulp CLI which supports Gulp v4)
RUN npm install gulpjs/gulp-cli -g

# install the Node modules for the bootstrapping process
WORKDIR $DIRPATH
RUN npm install

# install the Node modules for the Lambda run-time
WORKDIR $DIRPATH/lambda
RUN npm install

# change prompt color
RUN echo 'export PS1="\[\033[0;33m\][Docker container (vistaloc-api): \w]  \[\033[0m\]"' >> /root/.bashrc

# start new shell with new prompt color
RUN bash

# ENTRYPOINT aws configure && (gulp deploy) && (gulp generate_sample_users) && (gulp generate_sample_data) && (gulp undeploy)

FROM node:carbon

# Create app directory
RUN mkdir -p /usr/src/sample-service
WORKDIR /usr/src/sample-service

# Install app dependencies
COPY package.json /usr/src/sample-service/
RUN npm install

# Bundle app source
COPY . /usr/src/sample-service

EXPOSE 8089
CMD [ "npm", "start" ]


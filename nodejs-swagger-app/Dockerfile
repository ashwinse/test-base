FROM node:carbon

# Create app directory
RUN mkdir -p /usr/src/services
WORKDIR /usr/src/services

# Install app dependencies
COPY package.json /usr/src/services/
RUN npm install

# Bundle app source
COPY . /usr/src/services

EXPOSE 8089
CMD [ "npm", "start" ]


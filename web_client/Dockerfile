FROM node:6.9.5

RUN mkdir /code
WORKDIR /code

ADD package.json /code/package.json
RUN npm install

ADD . /code

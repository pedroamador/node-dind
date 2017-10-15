# node-dind

_Node image with docker in docker strategy used as base image._

_Supported tags and respective `Dockerfile` links:_
[`test`, `latest`, `1.0.0`](Dockerfile)


## Versions

- node `v8.5.0`
- npm `v5.5.1`
- docker `v17.10.0-ce-rc2`
- docker-compose `v1.16.1`
- git `v2.13.5`

## Example Dockerfile for your own Node.js project

```Dockerfile
FROM redpandaci/node-dind:latest

WORKDIR /app

ADD . .

RUN npm install --production

EXPOSE 3000


CMD ["node", "index.js"]
```


## How to develop?

- run `npm install`
- upgrade Dockerfile
- run `npm test` or `bin/test.sh`
- commit your changes
- publish new image

## Considerations

_This project only uses `npm` to do [commit validations](https://github.com/willsoto/validate-commit) and verify [Dockerfile coding style](https://github.com/redcoolbeans/dockerlint)._
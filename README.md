docker build -t silent-proxy:1.0 .
docker run -d -p 8089:8089 silent-proxy:1.0

# Mule App on Docker

Dockerization of Mule 4.3 runtime with a test.jar app

## Installation

To build the image.

```bash
docker build --tag="mule-test:4.3.0" .
```

To make a container and run the app

```bash
docker run -it --name Mule-Test -p:9001:8081 mule-test:4.3.0
```

## Usage

Make a request using Postman or ARC to http://ip-docker:9001/hello
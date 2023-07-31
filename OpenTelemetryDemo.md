# Opentelemetry Demo
This Demo instruments the microservices springboot application using opentelemetry and collects the associated traces to Jaeger and metrics to Prometheus which can be further visualized in grafana dashboard.

Here we are using opentelemetry blackbox instrumentation mechanism as mentioned in this [blog](https://community.aws/tutorials/instrumenting-java-apps-using-opentelemetry#introduction).

## Deploy Jaeger, prometheus, grafana, opentelemetry-collector 

- Run the docker-compose file to bring up Jaeger, prometheus, grafana, opentelemetry-collector containers.

```
podman-compose up
or
docker compose up
```
wait for containers to come up

## Build and run the microservices application with opentelemetry instrumentation 

Run the shell script to build and bring up the microservices with opentelemetry agent that is downloaded from [here](https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/latest/download/opentelemetry-javaagent.jar).


On one another tab run the following
```
./opentelemetry_demo.sh
```

## Run Payload

```
./load.sh
```

You can browse the applications at following endpoints:

Jaeger UI: http://localhost:9090/
prometheus: http://localhost:8888/
grafana dashboard: http://localhost:3000/
Demo application: http://localhost:8080/api/v1/names/random

To access the metrics follow the below steps:
- Go to grafana dashboard and select explore tab.
- Select prometheus in the dropdown.
- You can query the available metrics.





```
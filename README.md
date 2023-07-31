
This repository contains two demos related to Jaeger and opentelemetry:

The source blog for demo application can be found here[Jaeger Integration With Spring Boot Application](https://medium.com/xebia-engineering/jaeger-integration-with-spring-boot-application-3c6ec4a96a6f).
[Github Repo](git@github.com:himankbatra/opentracing-microservices-example.git)

1. Jaeger Dependency Demo
The main motive behind this demo is to setup an environment with 3 springboot microservices instrumented to report trace data to jaeger. This demonstrates a very useful feature provided by jaeger which involves retrieving dependencies of a microservice as a request propogates through an ecosystem. This data can be further utilized by the Kruize project to optimize the pathway of the requests(microservices) by providing insightful reccomendations.
[JaegerDependencyDemo.md](JaegerDependencyDemo.md)

2. OpenTelemetry Demo
This Demo instruments the microservices springboot application using opentelemetry and collects the associated traces to Jaeger and metrics to Prometheus which can be further visualized in grafana dashboard.
[OpenTelemetryDemo.md](OpenTelemetryDemo.md)
# Jaeger Demo
This demo instruments a microservices springboot application using Jaeger to fetch the dependecies using Jaeger [API](https://www.jaegertracing.io/docs/1.23/apis/#service-dependencies-graph-internal).

# How to build the demo application docker images?  
- Clone the microservices application.

```
git clone git@github.com:himankbatra/opentracing-microservices-example.git
```
- Navigate to cloned directory

```
cd opentracing-microservices-example
```  

## Update the application.properties

We need to navigate to each of the 3 services folders and change the value of the property called *opentracing.jaeger.udp-sender.host* present in application.properties file.

navigate to: 
- animal-name-service/src/main/resources
- scientist-name-service/src/main/resources/
- name-generator-service/src/main/resources/

and update the application.properties file as below

Update the property to:
opentracing.jaeger.udp-sender.host=${UDP_HOST}

And add the following property according to services(this is required for Jaeger UI)
spring.application.name= <Name of the microservice>

for example if the microservice is name-generator-service then the property will be:

spring.application.name=name-generator-service

We populate ${UDP_HOST} variable through yaml files in kubernetes resources folder.

Once we save the changes to all these files we will build the image for all three services one by one.

## Build image for name-generator-service

- Navigate to name-generator-service

```
cd name-generator-service
```

- Build the project

```
mvn clean package
```

- Build the docker file

```
docker build -t name-generator-service:v1 .
```

- Tag the image
```
docker tag name-generator-service:v1 quay.io/<quay username>/name-generator-service
```

(you should be logged in your quay account)
- Push the image
```
docker push quay.io/<quay username>/name-generator-service;
```

you can use the name of the images pushed in various yaml files provided(can change the image name to your image).

Repeate the build process for all the remaining services.(just need to change the name of services in the above command)

**NOTE**- Building this docker images is a one time setup.

# What setup is required?
Install minikube and kubectl.


# Deploying the Jaeger and demo microservices on minikube.

- Deploy Jaeger all in one image and microservices application into minikube:

```
kubectl apply -f kubernetes-resources    
```

# How to access the Jaeger API dependencies.

- Get the minikube ip
```
minikube ip
```

- We can find all associated nodeports using the following command:
```
kubectl get svc
```

First access the application endpoint:
```
http://<minikube ip>:<node port assigned to name generator service>/api/v1/names/random

ex:http://192.168.49.2:31190/api/v1/names/random
```

To browse the jaeger UI:
```
<minikube ip>:<node port assigned to jaeger 16686>/search

ex:http://192.168.49.2:30580/
```

To see the dependencies:
```
<minikube ip>:<node port assigned to jaeger 16686>/api/dependencies?endTs=<current time stamp>&lookback=604800000

example: http://192.168.49.2:30580/api/dependencies?endTs=1690274788249&lookback=604800000
```

Best way to see the results without calculations would be to open Jaeger UI using the link mentioned above. Open the network tab from developertools and see the API call to watch the usage of API.

*endTs*=1690189974936
*Value*: 1690189974936
Unit: This value represents present moment or current timestamp in milliseconds since January 1, 1970 (Unix timestamp in milliseconds).

*lookback*=604800000

*Value*: 604800000
Unit: This value represents a duration in milliseconds. The lookback parameter is used to specify the time range for which the dependencies graph will be fetched. In this case, the value 604800000 corresponds to a lookback period of 604,800,000 milliseconds, which is equivalent to 7 days.

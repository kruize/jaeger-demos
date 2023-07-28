# Jaeger Minikube Dependency Demo
This demo is a small setup which connectes jaeger with a demo application and prints out dependencies of mircoservices in kruize log.

# Clone demo application and build docker images  
"one time setup"
- we will first clone the demo repository.

```
git clone git@github.com:himankbatra/opentracing-microservices-example.git
```
- Navigate to cloned directory

```
cd opentracing-microservices-example
```  

## Changing the application.properties

We need to navigate to each of the 3 services folders and change the variable called *opentracing.jaeger.udp-sender.host* present in application.properties file.

navigate to: 
- animal-name-service/src/main/resources
- scientist-name-service/src/main/resources/
- name-generator-service/src/main/resources/

and open the application.properties file

Change the variable to:
opentracing.jaeger.udp-sender.host=${UDP_HOST}

And add the following variable according to services(this is required for Jaeger UI)
spring.application.name=name-generator-service/scientist-name-service/name-generator-service


We populate this variable through yaml files 

Once we saved the changes to all these files we will build the image for all three services one by one.

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

# Minikube setup
- Start minikube with 

```
minikube start 
```

- In the current directory apply all the files to deploy setup:

```
kubectl apply -f minikube-resources    
```

# Resuts

- Get the minikube ip
```
minikube ip
```

- We can find all associated nodeports using the follwoing command:
```
kubectl get svc
```

To browse the jaeger UI:
```
<minikube ip>:<node port assigned to jaeger 16686>/search

ex:http://192.168.49.2:30580/
```

To Access the application:
```
http://<minikube ip>:<node port assigned to name generator service>/api/v1/names/random

ex:http://192.168.49.2:31190/api/v1/names/random
```

To see the dependencies:
```
<minikube ip>:<node port assigned to jaeger 16686>/api/dependencies?endTs=<current time stamp>&lookback=604800000

example: http://192.168.49.2:30580/api/dependencies?endTs=1690274788249&lookback=604800000
```

Best way to see the results without calculations would be to open Jaeger Ui from above given steps and the open dependencies. open the network tab from developertools and see the api call to watch the usage of api.

*endTs*=1690189974936
*Value*: 1690189974936
Unit: This value represents present moment or current timestamp in milliseconds since January 1, 1970 (Unix timestamp in milliseconds).

*lookback*=604800000

*Value*: 604800000
Unit: This value represents a duration in milliseconds. The lookback parameter is used to specify the time range for which the dependencies graph will be fetched. In this case, the value 604800000 corresponds to a lookback period of 604,800,000 milliseconds, which is equivalent to 7 days.

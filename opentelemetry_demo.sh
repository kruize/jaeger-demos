#!/bin/bash
#
# Copyright (c) 2020, 2023 Red Hat, IBM Corporation and others.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#	http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#


AGENT_FILE=opentelemetry-javaagent.jar

mkdir demo-source

git clone git@github.com:himankbatra/opentracing-microservices-example.git demo-source

pushd demo-source
rm -rf images/ docker-compose.yml docker-setup.sh LICENSE README.md
popd

if [ ! -f "${AGENT_FILE}" ]; then
  curl -O -L https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/latest/download/opentelemetry-javaagent.jar --output ${AGENT_FILE}
fi

directories=("animal-name-service" "scientist-name-service" "name-generator-service")

export OTEL_TRACES_EXPORTER=otlp
export OTEL_METRICS_EXPORTER=otlp
export OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:5555
export OTEL_RESOURCE_ATTRIBUTES=service.name=name-generator-service,service.version=1.0


pids=()


kill_processes() {
  for pid in "${pids[@]}"; do
    echo "Killing process with PID: $pid"
    kill "$pid"
  done
}


kill_agent() {
  agent_pid=$(pgrep -f "opentelemetry-javaagent-all.jar")
  if [ -n "$agent_pid" ]; then
    echo "Killing agent process with PID: $agent_pid"
    kill "$agent_pid"
  fi
}


trap 'kill_processes; kill_agent' EXIT

for dir in "${directories[@]}"
do
    cd "demo-source/$dir"
    pushd src/main/resources 
    echo -e "\nspring.application.name=${dir}" >> application.properties
    popd
    
    mvn clean package -Dmaven.test.skip=true
    java -javaagent:../../${AGENT_FILE} -jar target/${dir}-0.0.1-SNAPSHOT.jar &
    # Store the PID of the background process
    pids+=($!)
    cd ../..
done

read -rp "Press any key to exit..."
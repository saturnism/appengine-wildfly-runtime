#!/bin/bash
#
# Copyright 2014 Google Inc. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Script that starts Jetty and sets Jetty specific system properties based on
# environment variables set for all runtime implementations.
if [ -z "$RUNTIME_DIR" ]; then
  echo "Error: Required environment variable RUNTIME_DIR is not set."
  exit 1
fi
HEAP_SIZE_FRAC=0.8
RAM_RESERVED_MB=150
HEAP_SIZE=$(awk -v frac=$HEAP_SIZE_FRAC -v res=$RAM_RESERVED_MB /MemTotal/'{
  print int($2/1024*frac-res) "M" } ' /proc/meminfo)
echo "Info: Limiting Java heap size to: $HEAP_SIZE"

# Increase initial permsize.
PERM_SIZE=64M  # Default = 21757952 (20.75M)
MAX_PERM_SIZE=166M  # Default = 174063616 (166M)

DBG_AGENT=

if [[ "$GAE_PARTITION" = "dev" ]]; then
  if [[ -n "$DBG_ENABLE" ]]; then
    echo "Running locally and DBG_ENABLE is set, enabling standard Java debugger agent"
    DBG_PORT=${DBG_PORT:-5005}
    DBG_AGENT="-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=${DBG_PORT}"
  fi
else
  # Get OAuth token from metadata service.
  TOKEN_URL="http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/token"
  METADATA_HEADER="Metadata-Flavor: Google"
  OAUTH_TOKEN="$( wget -q -O - "$@" --no-cookies --header "${METADATA_HEADER}" "${TOKEN_URL}" | \
                  sed -e 's/.*"access_token"\ *:\ *"\([^"]*\)".*$/\1/g' )"

  # Download the agent
  CDBG_REF_URL="http://metadata.google.internal/0.1/meta-data/attributes/gae_debugger_filename"
  if [[ -z "${CDBG_AGENT_URL}" ]]; then
    CDBG_AGENT_URL="https://storage.googleapis.com/vm-config.${GAE_LONG_APP_ID}.appspot.com/"
    CDBG_AGENT_URL+="$( wget -q -O - "$@" --no-cookies --header "${METADATA_HEADER}" "${CDBG_REF_URL}" )"
  fi

  echo "Downloading Cloud Debugger agent from ${CDBG_AGENT_URL}"
  AUTH_HEADER="Authorization: Bearer ${OAUTH_TOKEN}"
  wget -O cdbg_java_agent.tar.gz -nv --no-cookies -t 3 --header "${AUTH_HEADER}" "${CDBG_AGENT_URL}"

  # Extract the agent and format the command line arguments.
  mkdir -p cdbg ; tar xzf cdbg_java_agent.tar.gz -C cdbg
  DBG_AGENT="$( cdbg/format-env-appengine-vm.sh )"
fi

WILDFLY_HOME=${RUNTIME_DIR}
JAVA_OPTS="-server -Xms${HEAP_SIZE} -Xmx${HEAP_SIZE} -XX:PermSize=${PERM_SIZE} -XX:MaxPermSize=${MAX_PERM_SIZE} -Djava.net.preferIPv4Stack=true -Djboss.modules.system.pkgs=org.jboss.byteman -Djava.awt.headless=true -Djboss.server.log.dir=/var/log/app_engine/custom_logs/ ${JAVA_OPTS} ${DBG_AGENT}" $WILDFLY_HOME/bin/standalone.sh -b=0.0.0.0 -bmanagement=0.0.0.0 -c standalone-appengine.xml

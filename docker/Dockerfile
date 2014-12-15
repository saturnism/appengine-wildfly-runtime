# Copyright 2014 Google Inc.
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

FROM google/debian:wheezy
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -q update && \
  apt-get install --no-install-recommends -y -q ca-certificates curl openjdk-7-jre-headless && \
  apt-get clean && \
  rm /var/lib/apt/lists/*_*

ENV WILDFLY_VERSION 8.2.0.Final
RUN mkdir -p /var/lib/wildfly && (curl -0 http://download.jboss.org/wildfly/${WILDFLY_VERSION}/wildfly-${WILDFLY_VERSION}.tar.gz | tar -C /var/lib/wildfly --strip-components=1 -zx)

ENV APPENGINE_VERSION 1.9.17
ENV JETTY_VERSION 9.2.6.v20141205
ENV JGROUPS_VERSION 3.5.1.Final

RUN cd /tmp/ && curl -0 \
    -O http://repo1.maven.org/maven2/com/google/appengine/appengine-api-1.0-sdk/${APPENGINE_VERSION}/appengine-api-1.0-sdk-${APPENGINE_VERSION}.jar \
    -O https://oss.sonatype.org/content/repositories/google-releases/com/google/appengine/appengine-managed-runtime/${APPENGINE_VERSION}/appengine-managed-runtime-${APPENGINE_VERSION}.jar \
    -O http://repo1.maven.org/maven2/org/eclipse/jetty/jetty-util/${JETTY_VERSION}/jetty-util-${JETTY_VERSION}.jar \
    -O https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-xml/${JETTY_VERSION}/jetty-xml-${JETTY_VERSION}.jar \
    -O https://repository.jboss.org/nexus/content/groups/public-jboss/org/jgroups/jgroups/${JGROUPS_VERSION}/jgroups-${JGROUPS_VERSION}.jar

ADD . /var/lib/wildfly/

RUN mv /tmp/appengine-*.jar /var/lib/wildfly/modules/com/google/appengine/main/
RUN sed -i "s/\$APPENGINE_VERSION/${APPENGINE_VERSION}/g" /var/lib/wildfly/modules/com/google/appengine/main/module.xml

RUN mv /tmp/jetty-*.jar /var/lib/wildfly/modules/org/eclipse/jetty/main/
RUN sed -i "s/\$JETTY_VERSION/${JETTY_VERSION}/g" /var/lib/wildfly/modules/org/eclipse/jetty/main/module.xml

RUN mv /tmp/jgroups-*.jar /var/lib/wildfly/modules/system/layers/base/org/jgroups/main/
RUN sed -i "s/\$JGROUPS_VERSION/${JGROUPS_VERSION}/g" /var/lib/wildfly/modules/system/layers/base/org/jgroups/main/module.xml

RUN ln -s /var/lib/wildfly/standalone/deployments /deployments
WORKDIR /deployments

# Wildfly HTTP port number
EXPOSE 8080

# Wildfly HTTP Admin port number
EXPOSE 9990

# Java VM debug port number
EXPOSE 5005

# Env variable used by the jetty_run.sh script
ENV RUNTIME_DIR /var/lib/wildfly

# Clean any CMD that might be inherited from previous image, because that
# will pollute our ENTRYPOINT, see
# http://docs.docker.io/en/latest/reference/builder/#entrypoint.
CMD []
VOLUME ["/var/log/app_engine"] 
ENTRYPOINT ["/var/lib/wildfly/wildfly_run.sh"]

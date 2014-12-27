Google App Engine Managed VM Wildfly Runtime Example
====================================================

This is an example [App Engine Managed VM](https://cloud.google.com/appengine/docs/managed-vms/) custom runtime for the [Wildfly Application Server](http://wildfly.org/).  The runtime example can be used to deploy Java EE 7 applications.

This example clusters WildFly instances using JGroups GOOGLE_PING.

This is not an official Google product.

What is AppEngine Managed VM?
-----------------------------
Google AppEngine is a scalable platform-as-a-service that runs your application within Google's infrastructure.  AppEngine Managed VM lets you run your application with custom runtimes, such as NodeJS, Ruby, or, in this case, Java EE 7 with Wildfly.

Prepare for GOOGLE_PING
-----------------------
JGroups GOOLGE_PING uses Google Cloud Storage to share information about clustered instances.

 1. Create a bucket: `gsutil mb gs://${PROJECT_ID}-appengine-wildfly-jgroups
 1. In the console, navigate to `Storage` > `Cloud Storage` > `Project dashboard`
 1. Enable Interoperable Access by clicking on the `Make this my default project for interoperable storage access` button.
 1. Navigate to `Interoperable Access`, and either use ane existing Access Key / Secret, or generate a new one.

To pass the information to Google App Engine, this example uses project metadata:

    $ gcloud compute project-info add-metadata --metadata GOOGLE_PING_ACCESS=${ACCESS_KEY} GOOGLE_PING_SECRET=${SECRET} GOOGLE_PING_BUCKET=${PROJECT_ID}-appengine-wildfly-jgroups

Wildfly Custom Runtime
----------------------
The Wildfly custom runtime is stored in the docker/ directory.  To build the custom runtime, run:

    $ cd docker/
    $ docker build -t appengine-wildfly-runtime-ha .

Running Java EE 7 Applications
------------------------------
An example JavaEE7 application is stored in the javaee7-example/ directory.  It was created from a [Wildfly Java EE 7 Web Application Maven archetype](http://mvnrepository.com/artifact/org.wildfly.archetype/wildfly-javaee7-webapp-archetype).

To run this application locally on http://localhost:8080:

    $ cd javaee7-example/
    $ mvn gcloud:run

To deploy this application to a Google Cloud Platform project:

    $ cd javaee7-example/
    $ mvn gcloud:deploy -Dgcloud.project=YOUR_PROJECT_ID

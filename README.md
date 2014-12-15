AppEngine Managed VM Wildfly Runtime Example
============================================

This is an example [AppEngine Managed VM](https://cloud.google.com/appengine/docs/managed-vms/) custom runtime for the [Wildfly Application Server](http://wildfly.org/).  The runtime example can be used to deploy Java EE 7 applications.

This is not an official Google product.

What is AppEngine Managed VM?
-----------------------------
Google AppEngine is a scalable platform-as-a-service that runs your application within Google's infrastructure.  AppEngine Managed VM lets you run your application with custom runtimes, such as NodeJS, Ruby, or, in this case, Java EE 7 with Wildfly.

Wildfly Custom Runtime
----------------------
The Wildfly custom runtime is stored in the docker/ directory.  To build the custom runtime, run:

    $ cd docker/
    $ docker build -t appengine-wildfly-runtime .

Running Java EE 7 Applications
------------------------------
An example JavaEE7 application is stored in the javaee7-example/ directory.  It was created from a [Wildfly Java EE 7 Web Application Maven archetype](http://mvnrepository.com/artifact/org.wildfly.archetype/wildfly-javaee7-webapp-archetype).

To run this application locally on http://localhost:8080:

    $ cd javaee7-example/
    $ mvn gcloud:run

To deploy this application to a Google Cloud Platform project:

    $ cd javaee7-example/
    $ mvn gcloud:deploy -Dgcloud.project=YOUR_PROJECT_ID

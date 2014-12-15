What is it?
-----------

This is an example Java EE 7 application is stored in the jee7-example/ directory.  It was created from a [Wildfly Java EE 7 Web Application Maven archetype](http://mvnrepository.com/artifact/org.wildfly.archetype/wildfly-javaee7-webapp-archetype).

Pre-requisite
-------------

_NOTE: The following build command assumes you have configured your Maven user settings. If you have not, you must include Maven setting arguments on the command line. See [Build and Deploy the Quickstarts](../README.md#buildanddeploy) for complete instructions and additional options._

_NOTE: It also assumes that you already have a Google Cloud Platform project, as well as [Google Cloud SDK](https://cloud.google.com/sdk/) installed.

_NOTE: Lastly, you will need to make sure you have Docker installed, as well as the Google AppEngine Managed VM base runtimes installas as well.


Running Locally
---------------
To run this application locally on http://localhost:8080:

    $ mvn gcloud:run

Deploy it to Google Cloud Platform
----------------------------------

    $ mvn gcloud:deploy -Dgcloud.project=YOUR_PROJECT_ID

@echo off
set RMIDRIVER=%J2EE_HOME%\lib\cloudscape\rmijdbc.jar;%J2EE_HOME%\lib\cloudscape\client.jar
java -classpath %classpath%;%J2EE_HOME%\lib\system\cloudscape.jar;%J2EE_HOME%\lib\system\cloudview.jar;%J2EE_HOME%\lib\system\jh.jar;%J2EE_HOME%\lib\system\cloudutil.jar;%RMIDRIVER% COM.cloudscape.tools.cview

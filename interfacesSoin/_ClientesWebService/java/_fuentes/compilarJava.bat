@echo off
set path=%PATH%;C:\oracle\ora92\jdk\bin;
set classpath=%CLASSPATH%;C:\java\jConnect-5_5\classes\jconn2.jar;.;.\java;
del interfazToSoinJava.jar
del *.class
del java\com\soin\interfaces\*.class
echo on
javac -deprecation interfazToSoin.java
copy /Y interfazToSoin.class java\com\soin\interfaces
javac -deprecation interfazToSoinJava.java
copy /Y interfazToSoinJava.class java\com\soin\interfaces

jar cfv0 interfazToSoinJava.jar -C java com
pause
del *.class

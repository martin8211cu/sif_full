@echo off
set path=%PATH%;C:\oracle\ora92\jdk\bin;
set classpath=%CLASSPATH%;C:\sybase\jConnect-5_5\classes\jconn2.jar;.;
del interfazToSoin.class
echo on
javac -deprecation interfazToSoin.java
pause


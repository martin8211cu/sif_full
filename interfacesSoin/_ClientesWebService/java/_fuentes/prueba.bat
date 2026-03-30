set path=%PATH%;C:\oracle\ora92\jdk\bin;
set classpath=%CLASSPATH%;C:\sybase\jConnect-5_5\classes\jconn2.jar;C:\axis-1_2_1\lib\xerces.jar;.;.\interfazToSoinJava.jar;.;
javac -deprecation prueba.java
java prueba
pause
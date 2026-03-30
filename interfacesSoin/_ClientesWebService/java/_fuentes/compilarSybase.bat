@echo off
set path=%PATH%;C:\oracle\ora92\jdk\bin;
set classpath=%CLASSPATH%;C:\sybase\jConnect-5_5\classes\jconn2.jar;.;.\sybase;
del *.class
del sybase\com\soin\interfaces\*.class
echo on
javac -deprecation interfazToSoin.java
copy /Y interfazToSoin.class sybase\com\soin\interfaces
javac -deprecation interfazToSoinSQLcol.java
copy /Y interfazToSoinSQLcol.class sybase\com\soin\interfaces
javac -deprecation interfazToSoinSQL.java
copy /Y interfazToSoinSQL.class sybase\com\soin\interfaces
javac -deprecation interfazToSoinSybase.java
copy /Y interfazToSoinSybase.class sybase\com\soin\interfaces
del interfazToSoinSybase.jar
jar cfv0 interfazToSoinSybase.jar -C sybase com
pause
del *.class

rem cd ..\..\_fuentes

rem set path=%PATH%;C:\oracle\ora92\jdk\bin;
rem set classpath=%CLASSPATH%;C:\sybase\jConnect-5_5\classes\jconn2.jar
rem del interfazToSoinSybase.class
rem javac -deprecation interfazToSoinSybase.java
rem del interfazToSoinSybase.jar
rem jar cfv0 interfazToSoinSybase.jar interfazToSoinSybase.class

rem cd M:\SIF_EP\Modelo\scripts\webService\Sybase\utils

copy ..\..\_fuentes\interfazToSoinSybase.jar /y
isql -Usa -P -Sconectividad -Doscar -iinterfazToSoinSybaseDrop.sql
instjava -finterfazToSoinSybase.jar -jinterfazToSoinSybase -Usa -P -Sconectividad -Doscar
isql -Usa -P -Sconectividad -Doscar -iinterfazToSoinSybase.sql
pause
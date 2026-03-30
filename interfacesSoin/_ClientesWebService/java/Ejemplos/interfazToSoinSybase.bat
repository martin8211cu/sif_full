rem set path=%PATH%;C:\jdk1.3.1_03\bin;
rem set classpath=%CLASSPATH%;C:\j2sdk1.4.2_04\sybase\jConnect-5_5\classes\jconn2.jar
rem del interfazToSoinSybase.class
rem javac -deprecation interfazToSoinSybase.java
rem del interfazToSoinSybase.jar
rem jar cfv0 interfazToSoinSybase.jar interfazToSoinSybase.class
isql -Uobonilla66 -Sdesarrollo -Dsif_interfaces -iinterfazToSoinSybaseDrop.sql
instjava -finterfazToSoinSybase.jar -jinterfazToSoinSybase -Uobonilla66 -Sdesarrollo -Dsif_interfaces
isql -Uobonilla66 -Sdesarrollo -Dsif_interfaces -iinterfazToSoinSybase.sql
pause
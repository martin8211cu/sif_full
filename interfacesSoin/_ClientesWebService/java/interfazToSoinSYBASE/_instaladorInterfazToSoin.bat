@echo off
echo Sustituya primero los valores de "-U[uid] -P[pwd] -S[server] -D[database]"
echo y elimine los "rem" para instalar el InterfazToSoinSybase.jar
rem isql -U<uid> -P<pwd> -S<server> -D<database> -iinterfazToSoinSybaseDrop.sql
rem instjava -finterfazToSoinSybase.jar -jinterfazToSoinSybase -U<uid> -P<pwd> -S<server> -D<database>
rem isql -U<uid> -P<pwd> -S<server> -D<database> -iinterfazToSoinSybase.sql
echo on
pause
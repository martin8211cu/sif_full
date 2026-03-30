echo off
sqlplus <ESQUEMA_SISTEMA>/<PWD>@<SERVIDOR> <interfazToSoinOracle.sql
echo .
echo .
echo RECORDAR DARLE PRIVILEGIOS A CADA USUARIO ORACLE CON:
echo .
echo call dbms_java.grant_permission('USUARIO_ORACLE', 'java.net.SocketPermission', 'IP_SERVIDOR_WEB', 'accept, connect, listen, resolve'); 
echo .
echo .
echo PROBAR FUNCION CON:
echo .
echo select interfazToSoin('http://SERVIDOR_WEB/cfmx/interfacesSoin/webService/interfaz-service.cfm','CLIENTE_EMPRESARIAL','EcodigoSDC','UID_SIF','PWD_SIF','1','1') as MSG from dual;
echo .
echo .
pause
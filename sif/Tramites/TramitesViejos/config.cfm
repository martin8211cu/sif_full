<cfset uriPasaporte= 'http://127.0.0.1/SoinSoap/rpcServer'>
<cfset bancoEjbUri= 'iiop://127.0.0.1:9000'>
<!--- <cfset bancoEjbUri= 'iiop://10.7.7.24:9000'> --->
<cfset bancoEjbUser = 'guest'>
<cfset bancoEjbPass = 'guest'>
<cfset bancoEjbFactory = 'com.sybase.ejb.InitialContextFactory'>
<!---
<cfset bancoEjbJndi = 'Facturacion/BancoBCR'>
--->
<cfset bancoEjbJndi = 'ServiciosFacturacion/OperacionesBancarias'>

<!---//////////////////// Creación de usuario /////////////////////////----->								
<!---Insertado en datos personales---->
<!--- Inserta el usuario, le asocia la direccion y los datos personales --->
<!---<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">--->
<!---Creacion de usuario---->
<!---<cfset usuario = sec.crearUsuario(cuenta.identity, direccion.identity, rsDatos.datos_personales, idioma, '', '*', 1)>--->
<!---Asignacion de rol(SIF/RH) al usuario---->	
<!---
<cfset sec.insUsuarioRol(usuario, empresa.identity, 'RH', 'ADM')>
<cfset sec.insUsuarioRol(usuario, empresa.identity, 'SIF', 'ADM')>
--->
<!----/-*/-*/-*/-*/-*/-*/-*/-*/-*/-*/-*/-*/-*/-*/-*/-*/-*/-*/-*/-*/-*/-*/-*/-*/---->
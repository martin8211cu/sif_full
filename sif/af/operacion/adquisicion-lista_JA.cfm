<!--- 
	Este fuente permite al Jefe administrativo aplicar las adquisiciones. Se usa session para no dejar abierta la posibilidad que el usuario manipule la variable por url.
 --->
<cfset session.LvarJA = 'true'>
<cfinclude template="adquisicion-lista.cfm">
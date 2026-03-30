<!--- 
	Este fuente NO permite al Auxiliar administrativo aplicar las adquisiciones. Se usa session para no dejar abierta la posibilidad que el usuario manipule la variable por url.
 --->
<cfset session.LvarJA = 'false'>
<cfinclude template="adquisicion-lista.cfm">
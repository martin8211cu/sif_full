<link href="migrar_cuentas.css" rel="stylesheet" type="text/css" />
<cfoutput>stopped at #Now()#</cfoutput>
<cfset Server.migracion.stop = true>
<cfabort>

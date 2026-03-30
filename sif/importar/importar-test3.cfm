<cf_sifimportar EIcodigo="CG01" mode="out" exec="yes" html="yes">
	<cf_sifimportarparam name="IDcontable" value="2500000000002495">
</cf_sifimportar>
<cfsetting enablecfoutputonly="yes">
<!---
Guardar en archivo temporal
El archivo no se debe borrar, porque entonces el correo no se podría enviar
--->
<cfloop from="1" to="1000" index="i">
	<cfset temp = GetTempDirectory() & "mail - " & Int(rand() * 100000000) & ".txt">
	<cfif not FileExists(temp)><cfbreak></cfif>
</cfloop>
<cfif FileExists(temp)>
	<cf_errorCode	code = "50382" msg = "Archivo ya existe">
</cfif>
<cffile action="write" file="#temp#" output="#kk#" addnewline="no">

<!--- enviar email --->
<cfmail from="danim@soin.co.cr" to="danim@soin.co.cr"
	subject="Prueba de coldfusion" type="html">

Archivo adjunto: #temp#

<cfmailparam file="#temp#" type="text" >
</cfmail>
<cfoutput>
Correo enviado
</cfoutput>


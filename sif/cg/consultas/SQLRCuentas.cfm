<cfset paramsuri = ArrayNew (1)>
<cfif isdefined("url.Cformato1") and len(trim(url.Cformato1)) gt 0 >
	<cfset ArrayAppend(paramsuri, 'Cformato1='         & URLEncodedFormat(url.Cformato1))>
</cfif>
<cfif isdefined("url.Cformato2") and len(trim(url.Cformato2)) gt 0 >
	<cfset ArrayAppend(paramsuri, 'Cformato2='             & URLEncodedFormat(url.Cformato2))>
</cfif>
<cfif isdefined("url.Cmayor_Ccuenta1") and len(trim(url.Cmayor_Ccuenta1)) gt 0 >
	<cfset ArrayAppend(paramsuri, 'Cmayor_Ccuenta1='         & URLEncodedFormat(url.Cmayor_Ccuenta1))>
</cfif>
<cfif isdefined("url.Cmayor_Ccuenta2") and len(trim(url.Cmayor_Ccuenta2)) gt 0 >
	<cfset ArrayAppend(paramsuri, 'Cmayor_Ccuenta2='             & URLEncodedFormat(url.Cmayor_Ccuenta2))>
</cfif>
<!--- <cf_rhimprime datos="/sif/cg/consultas/formRCuentas.cfm" paramsuri="&#ArrayToList(paramsuri,'&')#" regresar="/cfmx/sif/cg/consultas/RCuentas.cfm"> --->
<cfinclude template="formRCuentas.cfm" >

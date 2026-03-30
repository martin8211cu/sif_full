<!---
<cf_navegacion name="CFid" navegacion="">
<cf_navegacion name="fecha" navegacion="">
--->

<!---
<cfset paramsuri = ArrayNew (1)>
<cfset ArrayAppend(paramsuri, 'CFpk='         & URLEncodedFormat(form.CFpk))>
<cfset ArrayAppend(paramsuri, 'fecha='             & URLEncodedFormat(form.fecha))>
--->
<cfif isdefined("url.CFpk") and not isdefined("form.CFpk")>
	<cfset form.CFpk = url.CFpk >
</cfif>
<cfif isdefined("url.fecha") and not isdefined("form.fecha")>
	<cfset form.fecha = url.fecha >
</cfif>
<cfif isdefined("url.ordenamiento") and not isdefined("form.ordenamiento")>
	<cfset form.ordenamiento = url.ordenamiento >
</cfif>
<cfif isdefined("url.mostrarcomo") and not isdefined("form.mostrarcomo")>
	<cfset form.mostrarcomo = url.mostrarcomo >
</cfif>
<cfset paramsuri = "?CFpk=#form.CFpk#&fecha=#form.fecha#&ordenamiento=#form.ordenamiento#&mostrarcomo=#form.mostrarcomo#" >
<cf_rhimprime datos="/rh/nomina/consultas/cesantia-form.cfm" objetosform="false" paramsuri="#paramsuri#">
<cfinclude template="cesantia-form.cfm">
<cfset paramsuri='&imprime=1'>
<cfif isdefined("Form.usucodigo")>
	<cfset paramsuri = paramsuri & '&usucodigo=#form.usucodigo#'>
</cfif>
<cfif isdefined("Form.modulo")>
	<cfset paramsuri = paramsuri & '&modulo=#form.modulo#'>
</cfif>
<cfif isdefined("Form.empresa")>
	<cfset paramsuri = paramsuri & '&empresa=#form.empresa#'>
</cfif>
<cfif isdefined("Form.nombre")>
	<cfset paramsuri = paramsuri & '&nombre=#form.nombre#'>
</cfif>

<cfif not isdefined('form.btnDownload')>
                <cf_templatecss>
</cfif> 
<cfset FileName = "RptUsuPAuxiliar">
<cfset FileName = FileName & Session.Usucodigo & DateFormat(Now(),'yyyymmdd') & TimeFormat(Now(),'hhmmss') & '.xls'>
<cf_htmlreportsheaders title="Reporte Usuarios por Auxiliar" 
	filename="#FileName#" 
	ira="CPUsuAux.cfm?1=1#paramsuri#">

<cfflush interval="256">	
<cfinclude template="formCPUsuAuxR.cfm"> 

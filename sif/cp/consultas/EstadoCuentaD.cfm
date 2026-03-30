<cfset paramsuri='&imprime=1'>
<cfif isdefined("Form.fecha1")>
	<cfset paramsuri = paramsuri & '&fecha1=#form.fecha1#'>
</cfif>
<cfif isdefined("Form.fecha2")>
	<cfset paramsuri = paramsuri & '&fecha2=#form.fecha2#'>
</cfif>
<cfif isdefined("Form.SNnumero1")>
	<cfset paramsuri = paramsuri & '&SNnumero1=#form.SNnumero1#'>
</cfif>
<cfif isdefined("Form.SNnumero2")>
	<cfset paramsuri = paramsuri & '&SNnumero2=#form.SNnumero2#'>
</cfif>

<cf_templatecss>

<cfset FileName = "IntegracionSalgosD">
<cfset FileName = FileName & Session.Usucodigo & DateFormat(Now(),'yyyymmdd') & TimeFormat(Now(),'hhmmss') & '.xls'>
<cf_htmlreportsheaders title="Integración de Saldos por Documento" 
	filename="#FileName#" 
	ira="EstadoCuenta.cfm?1=1#paramsuri#">

<cfflush interval="256">
<cfinclude template="formEstadoCuentaD.cfm"> 


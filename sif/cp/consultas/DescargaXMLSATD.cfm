<cfset paramsuri='&imprime=1'>
<cfif isdefined("Form.fecha1")>
	<cfset paramsuri = paramsuri & '&fecha1=#form.fecha1#'>
</cfif>
<cfif isdefined("Form.fecha2")>
	<cfset paramsuri = paramsuri & '&fecha2=#form.fecha2#'>
</cfif>
<cfif isdefined("Form.tipoC")>
	<cfset paramsuri = paramsuri & '&tipoC=#form.tipoC#'>
</cfif>

<cfif isdefined("Form.Asociados")>
	<cfset paramsuri = paramsuri & '&Asociados=#form.Asociados#'>
</cfif>

<cf_templatecss>

<cfset FileName = "DescargaDocumentosSAT">
<cfset FileName = FileName & Session.Usucodigo & DateFormat(Now(),'yyyymmdd') & TimeFormat(Now(),'hhmmss') & '.xls'>
<cf_htmlreportsheaders title="Descarga De Documentos del SAT" 
	filename="#FileName#" 
	ira="DescargaXMLSAT.cfm?1=1#paramsuri#">

<cfflush interval="256">


<cfinclude template="formDescargaXMLSATD.cfm"> 

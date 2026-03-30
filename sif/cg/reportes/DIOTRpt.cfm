<cfset paramsuri='&imprime=1'>

<cfif isdefined('Form.sncodigo') and len(trim('Form.sncodigo'))>
	<cfset paramsuri = replace("#Form.sncodigo#", ",","")>	
</cfif>

<cfif isdefined('Form.mesd')>
	<cfset paramsuri = paramsuri & '&mesd=#Form.mesd#'>
</cfif>

<cfif isdefined("Form.periodod")>
	<cfset paramsuri = paramsuri & '&periodod=#Form.periodod#'>
</cfif>
<cfif isdefined("Form.mesh")>
	<cfset paramsuri = paramsuri & '&mesh=#Form.mesh#'>
</cfif>
<cfif isdefined("Form.periodoh")>
	<cfset paramsuri = paramsuri & '&periodoh=#Form.periodoh#'>
</cfif>


<cfif not isdefined('form.btnDownload')>
                <cf_templatecss>
</cfif> 
<cfset FileName = "Reporte DIOT">
<cfset FileName = FileName & Session.Usucodigo & DateFormat(Now(),'yyyymmdd') & TimeFormat(Now(),'hhmmss') & '.xls'>
<cf_htmlreportsheaders title="Reporte DIOT" 
	filename="#FileName#" 
	ira="RpteDIOT.cfm?#paramsuri#">
	<!---ira="RpteDIOT.cfm?1=1#paramsuri#"> --->
		

<cfflush interval="256">	
<cfinclude template="RpteDIOTform.cfm"> 

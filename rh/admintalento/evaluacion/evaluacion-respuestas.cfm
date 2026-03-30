<cfif isdefined("url.RHRSEid") and not isdefined("form.RHRSEid")>
	<cfset form.RHRSEid = url.RHRSEid >
</cfif>

<cfif isdefined("url.tipo") and not isdefined("form.tipo")>
	<cfset form.tipo = url.tipo >
</cfif>
<title>
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Titulo"
		Default="Evaluaci&oacute;n"
		returnvariable="Titulo"/>
		<cfoutput>#Titulo#</cfoutput>
</title>	
<cfset LvarFileName = "Gestion_Talento_#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
<cf_htmlReportsHeaders 
	title="#Titulo#" 
	close="true"
	back="no"
	download="no"
	filename="#LvarFileName#"
	irA="BalGeneral.cfm" 
	>
<cf_templatecss>
<table width="100%" align="center" cellpadding="0" cellspacing="0">
	<tr><td><cfinclude template="evaluar_des-form.cfm"></td></tr>
	<tr><td><cfinclude template="evaluacion.cfm"></td></tr> 
	<tr><td align="center">------ <cf_translate key="LB_Fin_del_reporte">Fin del reporte</cf_translate>------</td></tr>
</table>
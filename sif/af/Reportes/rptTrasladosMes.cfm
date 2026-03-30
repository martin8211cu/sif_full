<!---
*******************************************************
*******Sistema Financiero Integral*********************
*******Activos Fijos***********************************
*******Reporte de Traslados de Activos por Periodo Mes*
*******Fecha de Creación: 2/06/2006********************
*******Desarrollado por: Dorian Abarca Gómez***********
*******************************************************
*******Registro de Cambios Realizados******************
*******Modificación No:********************************
*******Realizada por:**********************************
*******Detalle de la Modificación:*********************
*******************************************************
*******Se crea Variable pNavegacion para***************
*******obtener variables con datos del proceso*********
*******como nombre para utilizarlo en titulos**********
*******aquí se crea nav__SPdescripcion*****************
*******************************************************
--->
<cfset Regresar = "/sif/af/MenuConsultasAF.cfm">
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>

<cfif isdefined('url.Periodo') and not isdefined('form.Periodo')>
	<cfset form.Periodo = url.Periodo>
</cfif>
<cfif isdefined('url.Mes') and not isdefined('form.Mes')>
	<cfset form.Mes = url.Mes>
</cfif>
<cfif isdefined('url.ACcodigodesde') and not isdefined('form.ACcodigodesde')>
	<cfset form.ACcodigodesde = url.ACcodigodesde>
</cfif>
<cfif isdefined('url.ACcodigohasta') and not isdefined('form.ACcodigohasta')>
	<cfset form.ACcodigohasta = url.ACcodigohasta>
</cfif>

<cfif isdefined("url.chkArchivo")>
	 <cfcontent type="application/msexcel">
		<cfheader name="Content-Disposition"  
			value="attachment;filename=Traslados_#session.Usulogin##LSDateFormat(now(),'yyyymmdd')#.xls" >
	<cfinclude template="repTraslado-form-arch.cfm">
	
<cfelse>
	<cf_templateheader title="#nav__SPdescripcion#">
		<cfoutput>#pNavegacion#</cfoutput>
		<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
			<cfif isdefined("form.Periodo") and len(trim(form.Periodo)) gt 0 and form.Periodo gt 0
				and isdefined("form.Mes") and len(trim(form.Mes)) gt 0 and form.Mes gt 0>

				<cfset navegacion = "">
				<cfset navegacion = navegacion & "&Periodo="&form.Periodo>
				<cfset navegacion = navegacion & "&Mes="&form.Mes>
								
				<cfif isdefined('form.ACcodigodesde') and len(trim(form.ACcodigodesde)) gt 0 and form.ACcodigodesde gt 0>
					<cfset navegacion = navegacion & "&ACcodigodesde="&form.ACcodigodesde>
				</cfif>
				<cfif isdefined('form.ACcodigohasta') and len(trim(form.ACcodigohasta)) gt 0 and form.ACcodigohasta gt 0>
					<cfset navegacion = navegacion & "&ACcodigohasta="&form.ACcodigohasta>
				</cfif>
				<!--- <cf_rhimprime datos="/sif/af/Reportes/repTraslado-form.cfm" paramsuri="#navegacion#" regresar="/cfmx/sif/af/Reportes/rptTrasladosMes.cfm">--->
				<cfset LvarReporte = "TrasladoMes">
				<cfinclude template="repTraslado-form.cfm">
			<cfelse>
				<cfinclude template="formTrasladosMes.cfm">					
			</cfif>
		<cf_web_portlet_end>
	<cf_templatefooter>
</cfif> 
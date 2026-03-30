<!---*******************************************
*******Sistema Financiero Integral*********************
*******Activos Fijos**********************
*******Reporte de Depreciaciones de Activos por Periodo Mes*
*******Fecha de Creación: 5/06/2006*******
*******Desarrollado por: Dorian Abarca Gómez**************
********************************************--->
<!---*******************************************
*******Registro de Cambios Realizados***********
*******Modificación No:*************************
*******Realizada por:***************************
*******Detalle de la Modificación:**************
********************************************--->
<!---*******************************************
*******Se crea Variable pNavegacion para********
*******obtener variables con datos del proceso**
*******como nombre para utilizarlo en titulos***
*******aquí se crea nav__SPdescripcion**********
********************************************--->
<cfset Regresar = "/sif/af/MenuConsultasAF.cfm">
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
		<cf_templateheader title="#nav__SPdescripcion#">
			<cfoutput>#pNavegacion#</cfoutput>
		<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
			
			<cfset navegacion = "">
			<cfset Strvar_Resumido = "">
			<cfif isdefined('url.Resumido') and len(trim(url.Resumido)) gt 0 and url.Resumido gt 0>
				<cfset navegacion = navegacion & "&Resumido="&url.Resumido>
				<cfset Strvar_Resumido = "Resumido">
			</cfif>
			<cfif (isdefined("url.Periodo") and len(trim(url.Periodo)) gt 0 and url.Periodo gt 0)
				and (isdefined("url.Mes") and len(trim(url.Mes)) gt 0 and url.Mes gt 0)
				and not (isdefined("url.Archivo"))>
				<cfset navegacion = navegacion & "&Periodo="&url.Periodo>
				<cfset navegacion = navegacion & "&Mes="&url.Mes>				
				<cfif isdefined('url.ACcodigodesde') and len(trim(url.ACcodigodesde)) gt 0 and url.ACcodigodesde gt 0>
					<cfset navegacion = navegacion & "&ACcodigodesde="&url.ACcodigodesde>
				</cfif>
				<cfif isdefined('url.ACcodigohasta') and len(trim(url.ACcodigohasta)) gt 0 and url.ACcodigohasta gt 0>
					<cfset navegacion = navegacion & "&ACcodigohasta="&url.ACcodigohasta>
				</cfif>
				<cfif isdefined('url.Ocodigodesde') and len(trim(url.Ocodigodesde)) gt 0 and url.Ocodigodesde gt 0>
					<cfset navegacion = navegacion & "&Ocodigodesde="&url.Ocodigodesde>
				</cfif>
				<cfif isdefined('url.Ocodigohasta') and len(trim(url.Ocodigohasta)) gt 0 and url.Ocodigohasta gt 0>
					<cfset navegacion = navegacion & "&Ocodigohasta="&url.Ocodigohasta>
				</cfif>
				<cf_rhimprime datos="/sif/af/Reportes/rptDepreciacionesMes#Strvar_Resumido#-sql.cfm" paramsuri="#navegacion#" regresar="/cfmx/sif/af/Reportes/rptDepreciacionesMes.cfm">
				<cfinclude template="rptDepreciacionesMes#Strvar_Resumido#-sql.cfm">
			<cfelseif (isdefined("url.Periodo") and len(trim(url.Periodo)) gt 0 and url.Periodo gt 0)
				and (isdefined("url.Mes") and len(trim(url.Mes)) gt 0 and url.Mes gt 0)
				and (isdefined("url.Archivo"))>
				<cfinclude template="rptDepreciacionesMes#Strvar_Resumido#-query.cfm">
				<cftry>
					<cfflush interval="16000">
					<cf_jdbcquery_open name="data" datasource="#session.DSN#">
						<cfoutput>#preservesinglequotes(consulta_reporte)#</cfoutput>
					</cf_jdbcquery_open>
					<cf_exportQueryToFile query="#data#" separador="#chr(9)#" filename="#session.Usucodigo##LSDateFormat(Now(),'dd/mm/yyyy')##LSTimeFormat(Now(),'hh:mm:ss')#.txt" jdbc="true">
					<cfcatch type="any">
						<cf_jdbcquery_close>
						<cfrethrow>
					</cfcatch>
				</cftry>
				<cf_jdbcquery_close>
			<cfelse>
				<cfinclude template="rptDepreciacionesMes-form.cfm">
			</cfif>
		<cf_web_portlet_end>
	<cf_templatefooter>


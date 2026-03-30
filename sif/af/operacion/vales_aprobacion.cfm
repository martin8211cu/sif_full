<cfif isdefined("url.DEid") and len(trim(url.DEid))><cfset form.DEid = url.DEid></cfif>
<cfif isdefined("url.AFAid") and len(trim(url.AFAid))><cfset form.AFAid = url.AFAid></cfif>
<cfset currentPage = GetFileFromPath(GetTemplatePath())>
<cf_templateheader title="Activos Fijos">
		<cf_web_portlet_start titulo='Aprobaci&oacute;n de Adquisici&oacute;n de Activos Fijos con Vale'>
			<table width="98%" align="center"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td>
						<br>
						<cfif isDefined("form.DEid") and len(trim(form.DEid))>
									<cfinclude template="/sif/portlets/pEmpleado.cfm">
									<cfif isdefined("form.AFAid") and len(trim(form.AFAid))>
												<cfquery name="rsVale" datasource="#session.dsn#">
													select AFAid, Ecodigo, DEid, Aid, ACcodigo, ACid, AFMid, AFMMid, CFid, 
														SNcodigo, AFAdescripcion, AFAserie, AFAplaca, AFAdocumento, AFAmonto, 
														AFAfechainidep, AFAfechainirev, Usucodigo, Ulocalizacion, AFAstatus, 
														AFAfechaalta,	BMUsucodigo, ts_rversion
													from AFAdquisicion 
													where AFAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFAid#">
													and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
													and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
												</cfquery>
												<cfinclude template="vales_adquisicion_consulta.cfm">
												<cfoutput>
												<form name="f" action="vales_aprobacion.cfm?DEid=#form.DEid#" method="post">
													<cf_botones values="Regresar">
												</form>
												</cfoutput>
									<cfelse>
												<cfinclude template="vales_aprobacion_form.cfm">
									</cfif>
						<cfelse>
									<cfinclude template="/rh/beneficios/operacion/frame-Empleados.cfm">
						</cfif>
						<br>
					</td>
				</tr>
			</table>
	  <cf_web_portlet_end>
	<cf_templatefooter>
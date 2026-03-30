<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_NecesidadesdeCapacitacion"
	Default="Necesidades de Capacitaci&oacute;n"
	returnvariable="LB_NecesidadesdeCapacitacion"/> 
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	returnvariable="LB_RecursosHumanos"/> 	
<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title"><cfoutput>#LB_RecursosHumanos#</cfoutput></cf_templatearea>
	
	<cf_templatearea name="body">
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr><td>
				<cf_web_portlet border="true" skin="#session.preferences.skin#" titulo="#LB_NecesidadesdeCapacitacion#">
					<form name="form1" method="get" style="margin:0; " >
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
						<tr><td colspan="4"><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
						<tr><td colspan="4">&nbsp;</td></tr>
						<tr><td colspan="4">
							<cfif isdefined("url.resumido") and url.resumido eq 'R'>
								<cfset parametros = '' >
								<cfif isdefined("url.Brecha") and len(trim(url.Brecha))>
									<cfset parametros = parametros & '&Brecha=#url.Brecha#' >
								</cfif>
								<cfif isdefined("url.CFid") and len(trim(url.CFid))>
									<cfset parametros = parametros & '&CFid=#url.CFid#' >
								</cfif>
								<cfif isdefined("url.RHPcodigo") and len(trim(url.RHPcodigo))>
									<cfset parametros = parametros & '&RHPcodigo=#url.RHPcodigo#' >
								</cfif>
								<cfif isdefined("url.DEid") and len(trim(url.DEid))>
									<cfset parametros = parametros & '&DEid=#url.DEid#' >
								</cfif>
								<cfif isdefined("url.tipo") and len(trim(url.tipo))>
									<cfset parametros = parametros & '&tipo=#url.tipo#' >
								</cfif>
								<cfif isdefined("url.RHHid") and len(trim(url.RHHid))>
									<cfset parametros = parametros & '&RHHid=#url.RHHid#' >
								</cfif>
								<cfif isdefined("url.RHCid") and len(trim(url.RHCid))>
									<cfset parametros = parametros & '&RHCid=#url.RHCid#' >
								</cfif>
								<cfif isdefined("url.dependencias") and len(trim(url.dependencias))>
									<cfset parametros = parametros & '&dependencias=#url.dependencias#' >
								</cfif>
								
								<cf_rhimprime datos="/rh/capacitacion/consultas/brechas-capacitacion-form.cfm" paramsuri="#parametros#"> 
								<cfinclude template="brechas-capacitacion-form.cfm">
							<cfelse>	
								<cfinclude template="brechas-detalle.cfm">
							</cfif>
						</td></tr>
					</table>
					</form>
				</cf_web_portlet>
			</td></tr>
		</table>
	</cf_templatearea>
</cf_template>
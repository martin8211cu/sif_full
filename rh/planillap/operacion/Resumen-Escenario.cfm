<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Resumen Calculo del Escenario</title>
</head>
<body>	
<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		Recursos Humanos
	</cf_templatearea>	
		<cf_templatearea name="body">
			<cf_web_portlet_start skin="#Session.Preferences.Skin#" titulo="Escenarios">
				<cfinclude template="/rh/portlets/pNavegacion.cfm">				
				<cfset parametro = ''>
				<cfif isdefined("form.RHEid") and len(trim(form.RHEid))>
					<cfset parametro = "?RHEid=#form.RHEid#">
				<cfelseif isdefined("url.RHEid") and len(trim(url.RHEid))>
					<cfset parametro = "?RHEid=#url.RHEid#">
				</cfif>	
				<cfif isdefined("form.opt_visualiza") and len(trim(form.opt_visualiza))>
					<cfset parametro = "?opt_visualiza=#form.opt_visualiza#">
				<cfelseif isdefined("url.opt_visualiza") and len(trim(url.opt_visualiza))>
					<cfset parametro = "?opt_visualiza=#url.opt_visualiza#">
				</cfif>							
				<table width="98%" cellpadding="0" cellspacing="0">
					<tr>
						<td align="right">
							<cf_rhimprime datos="/rh/planillap/operacion/Resumen-CalculoEscenario.cfm" paramsuri=#parametro#> 
						</td>
					</tr>	
					<tr>
						<td>
							<cfinclude template="Resumen-CalculoEscenario.cfm">
						</td>
					</tr>
				</table>
			<cf_web_portlet_end>
		</cf_templatearea>	
	</cf_template>
</body>
</html>

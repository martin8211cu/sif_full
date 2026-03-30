<!---*******************************--->
<!--- Pantalla principal            --->
<!--- mantenimientos de             --->
<!--- Plan de Suseción              --->
<!---*******************************--->

<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/rh/portlets/pNavegacion.cfm">
</cfsavecontent>
<cf_templateheader title="Plan de Sucesi&oacute;n">
	<script language="javascript" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js">//utiles</script>
		<cf_web_portlet_start titulo="<cfoutput>Plan de Sucesi&oacute;n</cfoutput>">
			<cfoutput>#pNavegacion#</cfoutput>
<!---***********************************--->
<!--- agrega archivo de configuración   --->
<!--- y archivo de selecion de SQL      --->
<!---***********************************--->
		<cfif isdefined("url.paso")>
			<cfset Form.paso = url.paso>
		</cfif>

			 <cfinclude template="PlanSucesion-config.cfm">
			 <cfinclude template="PlanSucesion-update.cfm">
			
		<cfif isdefined("url.flag")>
			<cfset Form.flag = url.flag>
		</cfif>
		<cfif isdefined("url.TipoConcursante") and not isdefined("form.TipoConcursante")>
			<cfset form.TipoConcursante = url.TipoConcursante>
		</cfif>
			<br>
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td width="1%">&nbsp;</td>
				<td valign="top">
					<table width="100%"  border="0" cellspacing="0" cellpadding="0">
					  <tr>
						<td>&nbsp;</td>
						<td>
<!---*********************************************--->
<!--- agrega archivo de cfm que indica el paso    --->
<!--- y archivo de encabezado                     --->
<!---*********************************************--->
							<cf_web_portlet_start titulo='#Gdescpasos[Gpaso+1]#'>
								<br>
								<cfinclude template="PlanSucesion-header.cfm">
								<cfinclude template="PlanSucesion-paso#Gpaso#.cfm">
								<br> 
							
							<cf_web_portlet_end>
						</td>
						<td>&nbsp;</td>
					  </tr>
					</table>
				</td>
<!---*********************************************--->
<!--- agrega archivo de cfm de proceso de pasos   --->
<!--- y archivo de ayuda                          --->
<!---*********************************************--->
				<td valign="top" width="1%">
					 <cfinclude template="PlanSucesion-progreso.cfm"><br>
					 <cfinclude template="PlanSucesion-ayuda.cfm">
				</td>
				<td width="1%">&nbsp;</td>
			  </tr>
			</table>
		 <br>
		 <cf_web_portlet_end>
<cf_templatefooter>
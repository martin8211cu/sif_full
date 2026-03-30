<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		Reporte de Transacciones
	</cf_templatearea>
	
	<cf_templatearea name="body">
		
	
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
		            <cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Reporte de Transacciones #Form.titulo#'>
						<table width="100%" cellpadding="0" cellspacing="0">
							<tr><td><cfinclude template="../../portlets/pNavegacion.cfm"></td></tr>
							<tr><td>
								<cfset parametros = ''>
								<cfif Form.tipo EQ "CO">
									<cfset parametros = '&tipo=CO'>
								<cfelseif Form.tipo EQ "CR">
									<cfset parametros = '&tipo=CR'>
								<cfelseif Form.tipo EQ "NC">
									<cfset parametros = '&tipo=NC'>
								<cfelseif Form.tipo EQ "AN">
									<cfset parametros = '&tipo=AN'>
								</cfif>
								<cf_rhimprime datos="/sif/fa/consultas/formrepTransacciones.cfm" paramsuri="#parametros#" >
							</td></tr>
						</table>
	
		
		  <cfif isdefined("Form.Consultar")>
		  		<cfif Form.tipo EQ "">	
					<cfinclude template="formrepTransacciones.cfm">
				<cfelseif Form.tipo EQ "CO">
					<cfinclude template="formrepTransacciones.cfm">
				<cfelseif Form.tipo EQ "CR">
					<cfinclude template="formrepTransacciones.cfm">
				<cfelseif Form.tipo EQ "NC">
					<cfinclude template="formrepTransacciones.cfm">
				<cfelseif Form.tipo EQ "AN">
					<cfinclude template="formrepTransacciones.cfm">
		  		</cfif>
		  </cfif> 
            	
		            </cf_web_portlet>
				</td>	
			</tr>
		</table>	
	</cf_templatearea>
</cf_template>
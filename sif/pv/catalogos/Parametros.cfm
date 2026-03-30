<cf_templateheader title="Punto de Venta - Par&aacute;metros">
	
	
	<script language="JavaScript1.2" src="/cfmx/sif/js/utilesMonto.js"></script>	
	
	<script language="JavaScript" type="text/javascript">
		function tab_set_current (n){
			gotoTab(n)
		}
	</script>
	
	<!--- Verificar Si existen parametros para saber en que modo entra --->
	<cfquery datasource="#session.DSN#" name="rsVerificaParam">
		Select Ecodigo
		 from FAP000
		where Ecodigo = #session.Ecodigo# 								
	</cfquery>
								
	<cfif rsVerificaParam.recordcount eq 0>
		<cfset modo = 'ALTA'>
	<cfelse>
		<cfset modo = 'CAMBIO'>
	</cfif>

	<cfif modo eq 'ALTA'>
		<cfinclude template="../../portlets/pNavegacion.cfm">	
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">		        
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td>								
								<cfif not isdefined("paso") or paso eq 1><cfinclude template="PV_ParametrosAlta.cfm"></cfif>
								<cfif paso eq 2><cfinclude template="PV_VariosAlta.cfm"></cfif>
								<cfif paso eq 3><cfinclude template="PV_FormasdePagoAlta.cfm"></cfif>
								<cfif paso eq 4><cfinclude template="PV_OtrosAlta.cfm"></cfif>								
							</td>
						</tr>
					</table>
				</td> 
			</tr>
		</table>
					
	<cfelse>	
	     <cfinclude template="../../portlets/pNavegacion.cfm">
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">		        
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  					<tr>
							<td>
								<cfinclude template="frame_Parametros.cfm">
							</td>
						</tr>
						<tr>
							<td>
								<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#tabNames[tabChoice]#'>
									<br>
									<cf_tabs width="100%">
										 <cf_tab text=#tabNames[1]# selected="#tabChoice eq 1#">
											<cfif tabChoice eq 1>
												<cfset paso=1>
												<cfinclude template="PV_Parametros.cfm">
											</cfif>
										</cf_tab>
										<cf_tab text=#tabNames[2]# selected="#tabChoice eq 2#">
											<cfif tabChoice eq 2>
												<cfset paso=2>
												<cfinclude template="PV_Varios.cfm">
											</cfif>
										</cf_tab>
										<cf_tab text=#tabNames[3]# selected="#tabChoice eq 3#">
											<cfif tabChoice eq 3>
												<cfset paso=3>
												<cfinclude template="PV_FormasdePago.cfm">
											</cfif>
										</cf_tab>
										<cf_tab text=#tabNames[4]# selected="#tabChoice eq 4#">
											<cfif tabChoice eq 4>
												<cfset paso=4>
												<cfinclude template="PV_Otros.cfm">
											</cfif>
										</cf_tab>
										
									</cf_tabs>	
								
								<cf_web_portlet_end>
							</td>
						</tr>
					</table>
				</td> 
			</tr>
		</table>
	</cfif>
<cf_templatefooter>
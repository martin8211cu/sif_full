<cf_templateheader title="Compras - Consulta Items de Embarque">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Consulta Items de Trackings'>
			
			<cfoutput>
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr><td width="27%"><cfinclude template="../../portlets/pNavegacionCM.cfm"></td></tr>						
						<tr><td>&nbsp;</td></tr>
						
						<cfset parametros = "">
						
						<cfif isdefined("url.ETidtracking_move1") and len(trim(url.ETidtracking_move1))>
							<cfset parametros = parametros & "&ETidtracking_move1=" & url.ETidtracking_move1 >
						</cfif>							
						
						<cfif isdefined ("url.pantalla")>
							<cfset pantalla = pantalla>
						</cfif>
						
						<tr><td><cf_rhimprime datos="/sif/cm/proveedor/seguimientoTrackingItems-imprime.cfm" paramsuri="#parametros#" formato="flashPAPER"></td></tr>
						<tr><td><cfinclude template="seguimientoTrackingItems-imprime.cfm"></td></tr>	 	
						<tr><td><DIV align="center"><input name="btnRegresar" type="button" value="Regresar" 
													onClick="javascript:location.href='seguimientoTracking.cfm?ETidtracking_move1=#url.ETidtracking_move1#<cfif isdefined("pantalla")>&pantalla=#pantalla#</cfif>'" ></DIV></td></tr>
						<tr><td>&nbsp;</td></tr>
					</table>						
			</cfoutput>			
		<cf_web_portlet_end>
	<cf_templatefooter>

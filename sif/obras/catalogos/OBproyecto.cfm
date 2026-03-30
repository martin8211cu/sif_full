<cf_templateheader title="Mantenimiento de Proyectos">
	<cf_web_portlet_start titulo="Mantenimiento de Proyectos">

		<cf_navegacion name="Ecodigo" default="" navegacion="">
		<cfif isdefined("btnNuevo")>
			<cf_navegacion name="OBPid" value="" navegacion="" session="tabs">
		<cfelse>
			<cf_navegacion name="OBPid" default="" navegacion="" session="tabs">
		</cfif>
		<cfset form.Ecodigo = session.Ecodigo>
		
		<table width="100%" align="center">
			<tr>
				<td align="center">
					<cf_navegacion name="tab" default="1" session="tabs" navegacion>
					<cf_tabs width="99%" onclick="fnCambioTab">
						<cf_tab text="Lista Proyectos" selected="no" id=0>
							<cfinclude template="OBproyecto_list.cfm"> 
						</cf_tab>
					<cfif isdefined("btnNuevo")>
						<cf_tab text="Datos Proyecto" selected="yes">
							<cfinclude template="OBproyecto_form.cfm"> 
						</cf_tab>
					<cfelseif NOT isdefined("url._") AND form.OBPid NEQ "" AND form.OBPid NEQ "-1">
						<cfset session.obras.OBPid = form.OBPid>
						<cf_tab text="Datos Proyecto" selected="#form.tab eq 1#">
							<cfinclude template="OBproyecto_form.cfm"> 
						</cf_tab>
						<cf_tab text="Oficinas del Proyecto" selected="#form.tab eq 2#">
							<cf_navegacion name="Ecodigo" default="" navegacion="">
							<cf_navegacion name="Ocodigo" default="" navegacion="">
							<table>
								<tr>
									<td width="48%" valign="top">
										<cfinclude template="OBproyectoOficinas_list.cfm">
									</td>
									<td width="4%">&nbsp;</td>
									<td width="48%" valign="top">
										<cfinclude template="OBproyectoOficinas_form.cfm">
									</td>
								</tr>
							</table>
						</cf_tab>
						<cf_tab text="Reglas de Cuentas" selected="#form.tab eq 3#">
							<cf_navegacion name="OBPRid" default="" navegacion="">
							<table>
								<td width="48%" valign="top">
									<cfinclude template="OBproyectoReglas_list.cfm">
								</td>
								<td width="4%">&nbsp;</td>
								<td width="48%" valign="top">
									<cfinclude template="OBproyectoReglas_form.cfm">
								</td>
							</table>
						</cf_tab>
					</cfif>
					</cf_tabs>
				</td>
			</tr>
		</table>
		<iframe name="ifr_tab_" id="ifr_tab_" width="0" height="0">
		</iframe>
		<cfoutput>
		<script language="javascript">
			function fnCambioTab(tab_id)
			{
				tab_set_current (tab_id);
				if (tab_id != 0)
					document.getElementById("ifr_tab_").src = "/cfmx/sif/Utiles/tabid.cfm?tabidname=tab&tabid=" + tab_id;
				else
					document.getElementById("ifr_tab_").src = "/cfmx/sif/Utiles/tabid.cfm?tabidname=tab&tabid=1";
			}
		</script>
		</cfoutput>
	<cf_web_portlet_end>
<cf_templatefooter>


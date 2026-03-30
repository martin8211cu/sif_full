<cf_templateheader title="Mantenimiento de Obra">
	<cf_web_portlet_start titulo="Mantenimiento de Obra">

		<cf_navegacion name="OBOid" default="" navegacion="">
		<cf_navegacion name="OP" default="" navegacion="">
		<cfif isdefined("NuevoObra") or isdefined("form.cboOBPid")>
			<cfset form.OBOid = "">
		</cfif>

		<table width="100%" align="center">
			<tr>
				<td align="center">
				<cfif isdefined("url._") OR (form.OBOid EQ '' AND NOT isdefined("NuevoObra") AND NOT isdefined("btnNueva_Obra"))>
					<cf_navegacion name="tab" value="1" session="tabs" navegacion>

					<cf_tabs width="99%" onclick="fnCambioTab">
						<cf_tab text="Lista Obras" selected="no" id=0>
							<cfinclude template="OBobra_list.cfm"> 
						</cf_tab>
					</cf_tabs>	
				<cfelse>
					<cf_navegacion name="tab" default="1" session="tabs" navegacion>

					<cf_tabs width="99%" onclick="fnCambioTab">
						<cf_tab text="Lista Obras" selected="no" id=0>
							<cfinclude template="OBobra_list.cfm"> 
						</cf_tab>
						<cf_tab text="Datos Obra" selected="#form.tab eq 1#">
							<cfinclude template="OBobra_form.cfm"> 
						</cf_tab>
					<cfif form.OBOid NEQ ''>
						<cf_tab text="Etapas" selected="#form.tab eq 2#">
							<cf_navegacion name="OBEid" default="" navegacion="">
							<cf_navegacion name="CFformato" default="" navegacion="">
					
							<table width="100%" align="center">
								<tr>
									<td width="48%" valign="top">
										<cfinclude template="OBetapa_list.cfm">
									</td>
									<td width="4%">&nbsp;</td>
									<td width="48%" valign="top">
										<cfinclude template="OBetapa_form.cfm">
									</td>
								</tr>
							</table>
						</cf_tab>
						<cfquery name="rsSQL" datasource="#session.dsn#">
							select om.OBCliquidacion, tp.OBTPtipoCtaLiquidacion
							  from OBobra o
								inner join OBproyecto p
									inner join OBtipoProyecto tp
										inner join OBctasMayor om
										   on om.Ecodigo = tp.Ecodigo
										  and om.Cmayor = tp.Cmayor
									   on tp.OBTPid = p.OBTPid
								   on p.OBPid = o.OBPid
							 where o.OBOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBOid#">
						</cfquery>						
						<cfif rsSQL.OBCliquidacion EQ 1>
							<cf_tab text="Datos Liquidacion" selected="#form.tab eq 3#">
								<cf_navegacion name="OBEid" default="" navegacion="">
								<cf_navegacion name="OBOid" default="" navegacion="">
								<cf_navegacion name="OBOLid" default="" navegacion="">
						
							<cfif rsSQL.OBTPtipoCtaLiquidacion EQ "99">
								<div  style="text-align:center;color:#FF0000;">
									<strong  style="text-align:center">Error de Parametrización: La Cuenta Mayor tiene parametrizado que se va a ejecutar la Liquidación en el Sistema,<BR>pero en el Tipo de Proyecto se parametrizó que la Liquidación es Externa</strong>
								</div>
							<cfelseif OBOLid NEQ "" or isdefined("btnNuevo") or isdefined("btnNuevo")>
								<cfinclude template="../liquidacion/OBobraLiquidacion_form.cfm">
							<cfelse>
								<cfinclude template="../liquidacion/OBobraLiquidacion_list.cfm">
							</cfif>
							</cf_tab>
						</cfif>
					</cfif>
					</cf_tabs>
				</cfif>
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


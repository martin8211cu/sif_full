<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>

	<cf_templateheader title="#LB_RecursosHumanos#">
	<cf_templatecss>

	<table width="100%" cellpadding="0" cellspacing="0">
		<tr>
			<td>
				<cf_web_portlet_start border="true" titulo="Programas por Centro Funcional" skin="#Session.Preferences.Skin#">
					<cfinclude template="/rh/portlets/pNavegacion.cfm">
					<table width="100%" cellpadding="0" cellspacing="0">
						<tr>
							<td width="50%" valign="top"><cfinclude template="arbolCFuncional.cfm"></td>
							<cfif isdefined("url.CFpk") and len(trim(url.CFpk))>
								<cfquery name="lista" datasource="#session.DSN#">
									select gmcf.RHGMid, gm.RHGMcodigo, gm.Descripcion, gmcf.CFid as CFpk 
									from RHGrupoMateriaCF gmcf
									
									inner join RHGrupoMaterias gm
									on gmcf.Ecodigo=gm.Ecodigo
									and gmcf.RHGMid=gm.RHGMid
									
									where gmcf.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
									and gmcf.CFid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFpk#">
								</cfquery>
								<cfset tiene = valuelist(lista.RHGMid) >
								<td width="50%" valign="top" align="center">
									<table width="100%" align="center" cellpadding="0" cellspacing="0">
										<tr><td><cfinclude template="programas-cf-form.cfm"></td></tr>
										<tr><td>&nbsp;</td></tr>
										<tr><td align="center" bgcolor="#CCCCCC" style="padding:3px;"><strong>Programas asociados al centro funcional</strong></td></tr>
										<tr><td>
											<cfinvoke component="rh.Componentes.pListas" method="pListaQuery"
												query="#lista#"
												desplegar="RHGMcodigo, Descripcion"
												etiquetas="C&oacute;digo, Descripci&oacute;n"
												formatos="S,S"
												align="left,left"
												ira="programas-cf.cfm"
												form_method="get"
												keys="RHGMid,CFpk"
												showemptylistmsg="true"
											/>		
										</td></tr>
									</table>
								</td>
							<cfelse>
								<td width="50%" align="center" valign="top"><strong>---- Debe seleccionar un Centro Funcional ----</strong></td>
							</cfif>
						</tr>
					</table>
				<cf_web_portlet_end>
			</td>
		</tr>
	</table>
<cf_templatefooter>

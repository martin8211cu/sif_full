<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<script  language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>

<cfinclude template="Funciones.cfm">
<cfset venc1 = Trim(get_val(310).Pvalor)>
<cfset venc2 = Trim(get_val(320).Pvalor)>
<cfset venc3 = Trim(get_val(330).Pvalor)>
<cfset venc4 = Trim(get_val(340).Pvalor)>

<cfif not isdefined("Form.SNcodigo")>
	<cfif isdefined("Url.SNcodigo")>
		<cfparam name="Form.SNcodigo" default="#Url.SNcodigo#">
	<cfelse>
		<cfparam name="Form.SNcodigo" default="-1">
	</cfif>
</cfif>

<cfif not isdefined("Form.Ocodigo")>
	<cfif isdefined("Url.Ocodigo")>
		<cfparam name="Form.Ocodigo" default="#Url.Ocodigo#">
	<cfelse>
		<cfparam name="Form.Ocodigo" default="-1">
	</cfif>
</cfif>
<cfset LB_TituloH = t.Translate('LB_TituloH','Consultas Administrativas','AntigSaldosCxC.xml')>
<cfset LB_Titulo = t.Translate('LB_Titulo','An&aacute;lisis de Antig&uuml;edad de Saldos de Cuentas por Pagar')>

<cf_templateheader title="#LB_TituloH#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Titulo#'>
	
							<style type="text/css">
								.encabReporte {
									background-color: #006699;
									font-weight: bold;
									color: #FFFFFF;
									padding-top: 5px;
									padding-bottom: 5px;
									padding-left: 5px;
									padding-right: 5px;
								}
								.tbline {
									border-width: 1px;
									border-style: solid;
									border-color: #CCCCCC;
								}
							</style>
							<cfquery name="rsSocios" datasource="#Session.DSN#">
								select * from SNegocios 
								where Ecodigo =  #Session.Ecodigo# 
								and SNtiposocio in ('A', 'P')
								order by SNnombre
							</cfquery>

							<cfset LB_Fisica = t.Translate('LB_Fisica','Física','AntigSaldosCxC.xml')>
                            <cfset LB_Juridica = t.Translate('LB_Juridica','Jurídica','AntigSaldosCxC.xml')>
                            <cfset LB_Extranjero = t.Translate('LB_Extranjero','Extranjero','AntigSaldosCxC.xml')>
                            <cfset LB_NoTiene = t.Translate('LB_NoTiene','No Tiene','AntigSaldosCxC.xml')>


							<cfif isdefined("Form.SNcodigo") and Form.SNcodigo NEQ -1>
								<cfquery name="rsSocioDatos" datasource="#Session.DSN#">
									select Coalesce(SNnombre,'') as SNnombre,
										   Coalesce(SNidentificacion, '') as SNidentificacion,
										   Coalesce(SNdireccion, '#LB_NoTiene#') as SNdireccion,
										   Coalesce(SNtelefono, '#LB_NoTiene#') as SNtelefono,
										   Coalesce(SNFax, '#LB_NoTiene#') as SNFax,
										   Coalesce(SNemail, '#LB_NoTiene#') as SNemail,
										   (case SNtipo when 'F' then '#LB_Fisica#' when 'J' then '#LB_Juridica#' when 'E' then '#LB_Extranjero#' else '???' end) as SNtipo
									from SNegocios 
									where Ecodigo =  #Session.Ecodigo# 
									and SNtiposocio in ('A', 'P')
									and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
									order by SNnombre
								</cfquery>
							</cfif>
			
							<cfquery name="rsOficinas" datasource="#Session.DSN#">
								select * from Oficinas 
								where Ecodigo =  #Session.Ecodigo# 
								order by Odescripcion
							</cfquery>
						
							<cfinvoke component="sif.Componentes.AD_AntigSaldosCxP" method="ReporteSaldosSocio" returnvariable="rsGrafico">
								<cfinvokeargument name="Conexion" value="#Session.DSN#"/>
								<cfinvokeargument name="Ecodigo"  value="#session.Ecodigo#"/>
								<cfinvokeargument name="vencSel"  value="-1"/>
								<cfinvokeargument name="SNcodigo" value="#Form.SNcodigo#"/>
								<cfinvokeargument name="Ocodigo"  value="#Form.Ocodigo#"/>
								<cfinvokeargument name="venc1"    value="#venc1#"/>
								<cfinvokeargument name="venc2"    value="#venc2#"/>
								<cfinvokeargument name="venc3"    value="#venc3#"/>
								<cfinvokeargument name="venc4"    value="#venc4#"/>
								<cfinvokeargument name="Resumido" value="true"/>
							</cfinvoke>
							
							<cfquery name="rsValores" dbtype="query">
							  select min(monto) as minimo, max(monto) as maximo from rsGrafico 
							</cfquery>
							<cfset minimo = 0>
							<cfset maximo = rsValores.maximo>

							<cfif isdefined("Session.modulo") and Session.modulo EQ "Admin">
								<cfinclude template="../../portlets/pNavegacionAdmin.cfm">
							<cfelseif isdefined("Session.modulo") and Session.modulo EQ "CP">
								<cfinclude template="../../portlets/pNavegacionCP.cfm">
							</cfif>

							<form action="AntigSaldosCxP.cfm" method="post" name="form1">
							<cfset LB_PROVEEDOR = t.Translate('LB_PROVEEDOR','Proveedor','/sif/generales.xml')>
                            <cfset Oficina = t.Translate('Oficina','Oficina','/sif/generales.xml')>
                            <cfset LB_Todas = t.Translate('LB_Todas','Todas','/sif/generales.xml')>
							<cfset LB_Vencimiento = t.Translate('LB_Vencimiento','Vencimiento','AntigSaldosCxC.xml')>
                            <cfset LB_Saldo = t.Translate('LB_Saldo','Saldo','AntigSaldosCxC.xml')>
							  <table width="100%" border="0">
								<tr> 
								  <td colspan="5" nowrap> 
									<table width="100%" border="0" cellspacing="0" cellpadding="0">
									  <tr> 
										<td colspan="5" align="right" style="padding-right: 5px">&nbsp;</td>
									  </tr>
									  <tr> 
										<td align="right" style="padding-right: 5px"><cfoutput>#LB_PROVEEDOR#</cfoutput></td>
										<td> 
										  <select name="SNcodigo" onChange="javascript: this.form.submit();">
											<option value="-1" <cfif Form.SNcodigo EQ -1>selected</cfif>>Todos</option>
											<cfoutput query="rsSocios"> 
											  <option value="#rsSocios.SNcodigo#" <cfif Form.SNcodigo EQ rsSocios.SNcodigo>selected</cfif>>#rsSocios.SNnombre#</option>
											</cfoutput> 
										  </select>
										</td>
										<td align="right" style="padding-left: 5px; padding-right: 5px"><cfoutput>#Oficina#</cfoutput></td>
										<td> 
										  <select name="Ocodigo" onChange="javascript: this.form.submit();">
											<option value="-1" <cfif Form.Ocodigo EQ -1>selected</cfif>><cfoutput>#LB_Todas#</cfoutput></option>
											<cfoutput query="rsOficinas"> 
											  <option value="#rsOficinas.Ocodigo#" <cfif Form.Ocodigo EQ rsOficinas.Ocodigo>selected</cfif>>#rsOficinas.Odescripcion#</option>
											</cfoutput> 
										  </select>
										</td>
										<td width="50%">&nbsp;</td>
									  </tr>
									</table>
								  </td>
								</tr>
								<tr>
								  <td colspan="5">&nbsp;</td>
								</tr>
								<cfif isdefined("Form.SNcodigo") and Form.SNcodigo NEQ -1>
								<tr> 
								  <td colspan="5">
                                    <cfset LB_Identificacion = t.Translate('LB_Identificacion','Identificaci&oacute;n','/sif/generales.xml')>
                                    <cfset LB_Persona = t.Translate('LB_Persona','Persona','AntigSaldosCxC.xml')>
                                    <cfset LB_Direccion = t.Translate('LB_Direccion','Direcci&oacute;n','/sif/generales.xml','AntigSaldosCxC.xml')>
                                    <cfset LB_Telefono = t.Translate('LB_Telefono','Tel&eacute;fono','/sif/generales.xml','AntigSaldosCxC.xml')>

									<cfoutput query="rsSocioDatos">
										<table width="100%" border="0" cellspacing="0" cellpadding="0">
										  <tr align="center"> 
											<td class="tituloAlterno" colspan="6">#SNnombre#</td>
										  </tr>
										  <tr> 
											<td style="padding-left: 5px; font-weight: bold;">#LB_Identificacion#:</td>
											<td style="padding-left: 5px;">#SNidentificacion#</td>
											<td style="padding-left: 5px; font-weight: bold;">#LB_Persona#:</td>
											<td style="padding-left: 5px;">#SNtipo#</td>
											<td style="padding-left: 5px; font-weight: bold;">Email:</td>
											<td style="padding-left: 5px;">#SNemail#</td>
										  </tr>
										  <tr> 
											<td style="padding-left: 5px; font-weight: bold;">#LB_Direccion#:</td>
											<td style="padding-left: 5px;">#SNdireccion#</td>
											<td style="padding-left: 5px; font-weight: bold;">#LB_Telefono#:</td>
											<td style="padding-left: 5px;">#SNtelefono#</td>
											<td style="padding-left: 5px; font-weight: bold;">Fax:</td>
											<td style="padding-left: 5px;">#SNfax#</td>
										  </tr>
										</table>
									</cfoutput>
									</td>
								</tr>
								<tr>
									<td colspan="5">&nbsp;</td>
								</tr>
								</cfif>
								<tr valign="top"> 
								  <td width="5%">&nbsp; </td>
								  <td align="center"> 
									<table width="100%" border="0" cellpadding="2" cellspacing="0" class="tbline">
									  <tr>
                                      <cfoutput> 
										<td class="encabReporte" align="center">#LB_Vencimiento#</td>
										<td class="encabReporte" align="right">#LB_Saldo#</td>
                                      </cfoutput>
									  </tr>
									  <cfloop query="rsGrafico">
										<cfoutput> 
										  <tr> 
											<td align="center" <cfif rsGrafico.CurrentRow MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif>><a href="AntigSaldosDetCxP.cfm?SNcodigo=#Form.SNcodigo#&Ocodigo=#Form.Ocodigo#&venc=#venc#">#venc#</a></td>
											<td align="right" <cfif rsGrafico.CurrentRow MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif>><a href="AntigSaldosDetCxP.cfm?SNcodigo=#Form.SNcodigo#&Ocodigo=#Form.Ocodigo#&venc=#venc#">#LSCurrencyFormat(monto,'none')#</a></td>
										  </tr>
										</cfoutput> 
									  </cfloop>
									</table>
								  </td>
								  <td width="5%">&nbsp;</td>
								  <td align="center"> 
									<table width="100%" border="0" dwcopytype="CopyTableCell">
									  <tr> 
										<td valign="top" nowrap> 
										<cfset LB_xaxistitle = t.Translate('LB_xaxistitle','Vencimiento en días','AntigSaldosCxC.xml')>
                                        <cfset LB_yaxistitle = t.Translate('LB_yaxistitle','Total por Vencimiento','AntigSaldosCxC.xml')>
										  <cfchart gridlines="5"
													 xaxistitle="#LB_xaxistitle#" 
													 yaxistitle="#LB_yaxistitle#" 
													 scalefrom="1" 
													 scaleto="#venc4#" 
													 show3d="yes" 
													 showborder="no" 
													 showlegend="yes"
													 chartwidth="450"
													 url="AntigSaldosDetCxP.cfm?SNcodigo=#Form.SNcodigo#&Ocodigo=#Form.Ocodigo#&venc=$ITEMLABEL$"> 
										  <cfchartseries 
												type="bar" 
												query="rsGrafico" 
												valuecolumn="monto" 
												serieslabel="" 
												itemcolumn="venc">
										  </cfchart>
										</td>
									  </tr>
									</table>
								  </td>
								</tr>
							  </table>
							</form>
	<cf_web_portlet_end>
<cf_templatefooter>
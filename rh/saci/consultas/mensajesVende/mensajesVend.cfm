<cf_templateheader title="Consulta de Mensajes del Vendedor">
	<cf_web_portlet_start titulo="Consulta de Mensajes del Vendedor">
	
		<script language="javascript" type="text/javascript">
			function consultando(){
				document.form1.action = "mensajesVend.cfm";
				document.form1.consulta.value = 1;
				if(validaFiltros(document.form1))
					document.form1.submit();
			}
			function exportar(){
				document.form1.action = "exportarMsjVend-sql.cfm";
				document.form1.consulta.value = 2;
				if(validaFiltros(document.form1))
					document.form1.submit();
			}			
			function validaFiltros(f){
				if(f.fechaIni.value != '' && f.fechaFin.value != ''){
					if(!rangoFechas(f.fechaIni.value,f.fechaFin.value)){
						return false;
					}
				}
				
				return true;
			}
		</script>

		<cfoutput>
			<script language="javascript" type="text/javascript" src="../../../sif/js/utilesMonto.js">//</script>
			<form method="get" name="form1" action="mensajesVend-sql.cfm" onSubmit="javascript: return validaFiltros(this);">
				<input type="hidden" name="consulta" value="0">
				
				<table width="94%" border="0" cellspacing="0" cellpadding="0" align="center">
					<tr>
						<td valign="top">
							<table width="100%"  border="0" cellspacing="2" cellpadding="0">
							  <tr>
								<td width="25%" align="right">
									<strong>Agente</strong>:
								</td>
								<td width="23%" nowrap>
									<cfif Len(session.saci.agente.id) is 0 or session.saci.agente.id is 0>
										<cfset idPquien = "">
										<cfif isdefined('url.Pquien') and url.Pquien NEQ ''>
											<cfset idPquien = url.Pquien>
										</cfif>
										<cf_identificacion 
											soloAgentes="true"
											ocultarPersoneria="true"
											editable="false"
											pintaEtiq="false"
											id="#idPquien#">											
									<cfelse>
										<cfquery name="infoAgente" datasource="#session.DSN#">
											select 
													p.Pquien, 
													ag.AGid, 
													p.Pid, 													
													(p.Pnombre || ' ' || p.Papellido || ' ' || p.Papellido2) as nombreAgente
													
											from ISBagente ag
												inner join ISBpersona p
													on p.Ecodigo=ag.Ecodigo
														and p.Pquien=ag.Pquien
											
											where ag.AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.saci.agente.id#">
												and ag.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
										</cfquery>

										<cfif isdefined('infoAgente') and infoAgente.recordCount GT 0>
											<input type="hidden" name="AGidp" value="#infoAgente.AGid#">
											(#infoAgente.Pid#)  - #infoAgente.nombreAgente#
										</cfif>
									</cfif>
								</td>
								<td width="20%" align="right"><strong>Fecha Inicial:</strong></td>
								<td width="32%">
									<cfif isdefined("url.fechaIni") and len(trim(url.fechaIni))>								
										<cfset vfechaIni = LSDateFormat(url.fechaIni,'dd/mm/yyyy')>
									<cfelse>
										<cfset vfechaIni = ''>
									</cfif>									
									<cf_sifcalendario  tabindex="1" form="form1" name="fechaIni" value="#vfechaIni#">								
								</td>
							  </tr>				
							  <tr>
								<td align="right"><strong>Login:</strong></td>
								<td><input type="text" name="LGlogin" value="<cfif isdefined('url.LGlogin') and url.LGlogin NEQ ''>#url.LGlogin#</cfif>"></td>
								<td align="right"><strong>Fecha Final:</strong></td>
								<td>
									<cfif isdefined("url.fechaFin") and len(trim(url.fechaFin))>								
										<cfset vfechaFin = LSDateFormat(url.fechaFin,'dd/mm/yyyy')>
									<cfelse>
										<cfset vfechaFin = ''>
									</cfif>									
									<cf_sifcalendario  tabindex="1" form="form1" name="fechaFin" value="#vfechaFin#">									
								</td>
							  </tr>
							  <tr>
								<td align="right"><strong>Tarea:</strong></td>
								<td><select name="MSoperacion">
                                  <option value="-1" <cfif isdefined('url.MSoperacion') and url.MSoperacion EQ '-1'> selected</cfif>>-- Todas --</option>
                                  <option value="L" <cfif isdefined('url.MSoperacion') and url.MSoperacion EQ 'L'> selected</cfif>>Bloquear</option>
                                  <option value="D" <cfif isdefined('url.MSoperacion') and url.MSoperacion EQ 'D'> selected</cfif>>Desbloquear</option>
                                  <option value="B" <cfif isdefined('url.MSoperacion') and url.MSoperacion EQ 'B'> selected</cfif>>Borrar</option>
                                  <option value="P" <cfif isdefined('url.MSoperacion') and url.MSoperacion EQ 'P'> selected</cfif>>Programar (activar)</option>
                                  <option value="O" <cfif isdefined('url.MSoperacion') and url.MSoperacion EQ 'O'> selected</cfif>>Moroso</option>
                                  <option value="I" <cfif isdefined('url.MSoperacion') and url.MSoperacion EQ 'I'> selected</cfif>>Informativo</option>
                                </select></td>
								<td align="right"><strong>Estado:</strong></td>
								<td><select name="MSrevAgente">
                                  <option value="-1" <cfif isdefined('url.MSrevAgente') and url.MSrevAgente EQ '-1'> selected</cfif>>-- Todas --</option>
                                  <option value="N" <cfif isdefined('url.MSrevAgente') and url.MSrevAgente EQ 'N'> selected</cfif>>Sin Revisar</option>
                                  <option value="L" <cfif isdefined('url.MSrevAgente') and url.MSrevAgente EQ 'L'> selected</cfif>>Revisadas</option>
                                  <option value="B" <cfif isdefined('url.MSrevAgente') and url.MSrevAgente EQ 'B'> selected</cfif>>Anulada</option>
                                </select></td>
							  </tr>
							  <tr>
								<td align="right"><strong>Formato:</strong></td>
								<td><select name="formato">
                                  <option value="1">Flash Paper</option>
                                  <option value="2">Adobe PDF</option>
                                  <option value="3">Microsoft Excel</option>
                                </select></td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
							  </tr>
							  <tr>
								<td></td>
							  </tr>
							  <tr>
								<td colspan="4" align="center">
									<input type="button" onClick="javascript: consultando();" value="Consultar" name="Consultar">
									<input type="submit" value="Reporte" name="Reporte">				
									<input type="button" onClick="javascript: exportar();" value="Exportar" name="Exportar">
								</td>
							  </tr>
							</table>
					  </td>
					</tr>
				</table>
			</form>
		</cfoutput>
		<cfif isdefined('url.consulta') and url.consulta EQ '1'>
			<hr>
			<cfinclude template="mensajesVende-lista.cfm">
		</cfif>			
	<cf_web_portlet_end> 
<cf_templatefooter>

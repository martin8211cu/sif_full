<cf_templateheader title="Reporte Actividades">
	<cf_web_portlet_start titulo="Reporte Actividades Mayorista de Red">
	
		<script language="javascript" type="text/javascript">
			function consultando(){
				document.form1.action = "reporteactividades.cfm";
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
			<form method="get" name="form1" action="reporteactividades-sql.cfm" onSubmit="javascript: return validaFiltros(this);">
				<input type="hidden" name="consulta" value="0">
				
				<table width="94%" border="0" cellspacing="0" cellpadding="0" align="center">
					<tr>
						<td valign="top">
							<table width="100%"  border="0" cellspacing="2" cellpadding="0">
							  <tr>
								<td width="25%" align="right">
									<strong>Mayorista de Red</strong>:
								</td>
								<td width="23%" nowrap>									
									<cfif Len(session.saci.agente.id) is 0 or  session.saci.agente.id is 0>										
										<cfquery name="Mayorista" datasource="#session.DSN#">
										Select MRidMayorista,
												MRcodigoInterfaz,
												MRnombre from ISBmayoristaRed
										</cfquery>
										<select name="opt_mayorista">
										<option value="T" selected>-- Todas --</option>
										<cfloop query="Mayorista" startrow="1">
												<option value="#Mayorista.MRcodigoInterfaz#" <cfif isdefined('url.opt_mayorista') and url.opt_mayorista EQ #Mayorista.MRcodigoInterfaz#> selected</cfif>>#Mayorista.MRnombre#</option>
                                		
										</cfloop>	
										</select>												
									<cfelse>									
										<!---<cfquery name="infoAgente" datasource="#session.DSN#">
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
										</cfquery>--->
										<cfquery name="Mayorista" datasource="#session.DSN#">
										Select distinct  d.MRidMayorista,MRcodigoInterfaz,MRnombre 
 											from ISBagente a
    											inner join ISBagenteOferta b
        											on a.AGid = b.AGid
    											inner join ISBpaquete c
        											on b.PQcodigo = c.PQcodigo
    											inner join ISBmayoristaRed d
        											on c.MRidMayorista = d.MRidMayorista    
												Where  a.AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.saci.agente.id#">
													and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
										</cfquery>			
													
										<cfif isdefined('Mayorista') and Mayorista.recordCount GT 0>
											<input type="hidden" name="opt_mayorista" value="#Mayorista.MRcodigoInterfaz#">
											(#Mayorista.MRcodigoInterfaz#)  - #Mayorista.MRnombre#
										<cfelse>
											<input type="hidden" name="opt_mayorista" value="-1">
											Atenci&oacute; : Agente (#session.saci.agente.id#) no es Mayorista de Red
										</cfif>
									</cfif>
								</td>
							  </tr>
							  <tr>
								<td align="right"><strong>Fecha Inicial:</strong></td>
								<td>
									<cfif isdefined("url.fechaIni") and len(trim(url.fechaIni))>								
										<cfset vfechaIni = LSDateFormat(url.fechaIni,'dd/mm/yyyy')>
									<cfelse>
										<cfset vfechaIni = ''>
									</cfif>									
									<cf_sifcalendario  tabindex="1" form="form1" name="fechaIni" value="#vfechaIni#">								
								</td>
							  	<td align="right"><strong>Tipo Actividad:</strong></td>
								<td><select name="TipActividad">
                                  <option value="T" <cfif isdefined('url.TipActividad') and url.TipActividad EQ '-1'> selected</cfif>>-- Todas --</option>
                                  <option value="C" <cfif isdefined('url.TipActividad') and url.TipActividad EQ 'C'> selected</cfif>>Cambio Cuenta</option>
                                  <option value="L" <cfif isdefined('url.TipActividad') and url.TipActividad EQ 'L'> selected</cfif>>Cambio Login</option>
                                  <option value="I" <cfif isdefined('url.TipActividad') and url.TipActividad EQ 'I'> selected</cfif>>Cambio Inte</option>
                                  <option value="Q" <cfif isdefined('url.TipActividad') and url.TipActividad EQ 'Q'> selected</cfif>>Cambio Paquete</option>
                                  <option value="N" <cfif isdefined('url.TipActividad') and url.TipActividad EQ 'N'> selected</cfif>>Nuevo Inte</option>
                                </select></td>
							  </tr>				
							  <tr>
								<td width="20%" align="right"><strong>Fecha Final:</strong></td>
								<td>
									<cfif isdefined("url.fechaFin") and len(trim(url.fechaFin))>								
										<cfset vfechaFin = LSDateFormat(url.fechaFin,'dd/mm/yyyy')>
									<cfelse>
										<cfset vfechaFin = ''>
									</cfif>									
									<cf_sifcalendario  tabindex="1" form="form1" name="fechaFin" value="#vfechaFin#">									
								</td>
						      	<td>&nbsp;</td>
								<td>&nbsp;</td>
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
									<!---<input type="button" onClick="javascript: exportar();" value="Exportar" name="Exportar">--->
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
			<cfinclude template="reporteactividades-lista.cfm">
		</cfif>			
	<cf_web_portlet_end> 
<cf_templatefooter>

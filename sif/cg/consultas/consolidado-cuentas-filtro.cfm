	<cf_templateheader title="Contabilidad General - Consolidado de Empresas">
	
		<cfquery name="periodo_actual" datasource="#session.DSN#">
			select p.Pvalor
			from Parametros p
			where p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and p.Pcodigo = 30
		</cfquery>	

		<cfquery name="mes_actual" datasource="#session.DSN#">
			select p.Pvalor
			from Parametros p
			where p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and p.Pcodigo = 40
		</cfquery>

		<cfquery name="periodo_pres" datasource="#session.DSN#">
			select max(CPPanoMesHasta) as CPCano
			  from CPresupuestoPeriodo
			 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			   and CPPestado = 1
		</cfquery>	

		<!--- Monedas --->
		<cfquery name="rsMonedaLocal" datasource="#session.dsn#">
			select m.Mcodigo, m.Miso4217, m.Mnombre
			  from Empresas e
				inner join Monedas m
					on m.Mcodigo = e.Mcodigo
			 where e.Ecodigo = #session.Ecodigo# 
		</cfquery>
		<cf_dbfunction name="op_concat" returnVariable="_CAT">
		<cfquery name="rsB15_0" datasource="#Session.DSN#">
			select m.Mcodigo, m.Miso4217, m.Mnombre
			  from Parametros p
				inner join Monedas m
					on m.Mcodigo = <cf_dbfunction name="to_number" args="'0' #_CAT# p.Pvalor">
			 where p.Pcodigo = 660
			   and p.Ecodigo = #session.Ecodigo#
		</cfquery>
		<cfif rsB15_0.Mcodigo EQ "">
			<cfset rsB15_0 = rsMonedaLocal>
		</cfif>
		<cfquery name="rsB15_1" datasource="#Session.DSN#">
			select m.Mcodigo, m.Miso4217, m.Mnombre
			  from Parametros p
				inner join Monedas m
					on m.Mcodigo = <cf_dbfunction name="to_number" args="'0' #_CAT# p.Pvalor">
			 where p.Pcodigo = 3810
			   and p.Ecodigo = #session.Ecodigo#
		</cfquery>
		<cfif rsB15_1.Mcodigo EQ "">
			<cfset rsB15_1 = rsMonedaLocal>
		</cfif>
		<cfquery name="rsB15_2" datasource="#Session.DSN#">
			select m.Mcodigo, m.Miso4217, m.Mnombre
			  from Parametros p
				inner join Monedas m
					on m.Mcodigo = <cf_dbfunction name="to_number" args="'0' #_CAT# p.Pvalor">
			 where p.Pcodigo = 3900
			   and p.Ecodigo = #session.Ecodigo#
		</cfquery>
		<cfif rsB15_2.Mcodigo EQ "">
			<cfset rsB15_2 = rsMonedaLocal>
		</cfif>
		
		<script language="JavaScript1.2" type="text/javascript" src="/sif/js/sinbotones.js"></script>
		<cf_web_portlet_start border="true" skin="#session.preferences.skin#" tituloalign="center" titulo="Consolidado de Empresas">
			<cfinclude template="/sif/portlets/pNavegacion.cfm">
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td width="50%" valign="top">
						<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
						  <tr>
							<td>&nbsp;</td>
						  </tr>
						  <tr>
							<td>
								<cf_web_portlet_start border="true" titulo="Consolidado de Empresas" skin="info1">
									<table width="95%" border="0" cellpadding="2" cellspacing="0" align="center">
									  <tr>
										<td>
											<div align="justify" style="font-size:12px;">
												<br />
												En &eacute;ste reporte se muestra un consolidado de Empresas.
												Seleccione los par&aacute;metros necesarios para aumentar así 
												su utilidad y eficiencia en el traslado de datos.
												<br />
												<br />
											</div>
										</td>
									  </tr>
									</table>
								<cf_web_portlet_end>
							</td>
						  </tr>
						</table>
					</td>
					<td width="50%" valign="top">
						<cfoutput>
						<form name="form1" method="post" action="consolidado-cuentas.cfm" style="margin:0;" onSubmit="return sinbotones(); validar(this); ">
<script language="javascript">
	function fnBodyOnFocus ()
	{
		var LvarPres=(document.form1.tipo.value==10); 
		document.form1.CPCtipo.disabled=!LvarPres;
		document.form1.CPCsaldo.disabled=!LvarPres;
		document.form1.CPCcalculoControl.disabled=!LvarPres;
		document.form1.cboB15.value=document.form1.Mcodigo.selectedIndex;
	}
	if (!window.Event)
		window.setTimeout("fnBodyOnFocus()",30);
</script>
						<table border="0" align="center" cellpadding="3" cellspacing="0">
							<tr><td colspan="2" nowrap="nowrap"><strong>Grupo de Empresas</strong></td>
							</tr>
							<tr><td colspan="2">
                            	<cfif not isdefined("form.GEid")>
                                	<cfquery name="anexoDef" datasource="#session.DSN#">
                                        select min(GEid) as GEid
                                        from AnexoGEmpresa
                                        where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
                                    </cfquery>	
                                    <cfset varGEid = anexoDef.GEid>
                                <cfelse>
                                	<cfset varGEid = form.GEid>
                                </cfif>
								<cfquery name="anexos" datasource="#session.DSN#">
									select GEid, GEcodigo, GEnombre 
									from AnexoGEmpresa
									where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
									order by GEcodigo
								</cfquery>
								<select name="GEid" onchange="submit();">
									<!--- <option value="">-seleccionar-</option> --->
									<cfloop query="anexos">
										<option value="#anexos.GEid#" <cfif anexos.GEid EQ varGEid>selected</cfif>>#trim(anexos.GEnombre)# - #anexos.GEnombre#</option>
									</cfloop>
								</select>
							</td>
							</tr>
							<tr><td nowrap="nowrap"><strong>Per&iacute;odo</strong></td>
							  <td nowrap="nowrap"><strong>Mes</strong></td>
							</tr>
                            <!--- Busca el primer periodo existente en el grupo de empresas--->
                            <cfquery datasource="#session.dsn#" name="rs_GrupoE">
                            	select coalesce(max(BCperiodo),0) as UPeriodo, coalesce(min(BCperiodo),0) as PPeriodo
                                from BitacoraCierres
                                where Ecodigo in 
                                (select Ecodigo 
                                 from AnexoGEmpresaDet
                                 where GEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varGEid#">)
                            </cfquery>
                            
							<cfif rs_GrupoE.UPeriodo GT 0 AND rs_GrupoE.UPeriodo GTE periodo_actual.Pvalor>
                            	<cfset varUPeriodo = rs_GrupoE.UPeriodo> 
                            <cfelse>
                            	<cfset varUPeriodo =  periodo_actual.Pvalor> 
                            </cfif>
                            <cfif rs_GrupoE.PPeriodo EQ 0>
                            	<cfset varPPeriodo = varUPeriodo>
                            <cfelse>
                            	<cfset varPPeriodo = rs_GrupoE.PPeriodo>
                            </cfif>
                            
							<tr><td>
								<select name="periodo">
									<option value="#periodo_actual.Pvalor#">#varUPeriodo#</option>
                                    <cfloop step="-1" from="#varUPeriodo-1#" to="#varPPeriodo#" index="i"  >
										<option value="#i#" >#i#</option>
									</cfloop>
									<cfif periodo_pres.CPCano NEQ "" AND #left(periodo_pres.CPCano,4)# GT periodo_actual.Pvalor>
										<option disabled>Sólo para Presupuesto:</option>
										<cfloop step="1" from="#periodo_actual.Pvalor+1#" to="#left(periodo_pres.CPCano,4)#" index="i"  >
											<option value="#i#" >#i#</option>
										</cfloop>
									</cfif>
								</select>
							</td>
							  <td><select name="mes">
								 <!---  <option value="">-seleccionar-</option> --->
								  <option value="1" >Enero</option>
								  <option value="2" >Febrero</option>
								  <option value="3" >Marzo</option>
								  <option value="4" >Abril</option>
								  <option value="5" >Mayo</option>
								  <option value="6" >Junio</option>
								  <option value="7" >Julio</option>
								  <option value="8" >Agosto</option>
								  <option value="9" >Setiembre</option>
								  <option value="10" >Octubre</option>
								  <option value="11" >Noviembre</option>
								  <option value="12" >Diciembre</option>
								</select></td>
							</tr>
							<tr><td nowrap="nowrap"><strong>Moneda</strong></td>
							  <td nowrap="nowrap"><strong>Nivel</strong></td>
							</tr>
                            </cfoutput>
							<tr>
								<td>
                                    <select name="Mcodigo" tabindex="1" onchange="this.form.cboB15.value=this.selectedIndex;">
                                      	<cfoutput>
									        <option value="#rsB15_0.Mcodigo#">
                                                Moneda Conversión Corp. #rsB15_0.Miso4217#
                                            </option>
                                            <option value="#rsB15_1.Mcodigo#">
												Moneda Funcional B15 #rsB15_1.Miso4217#
                                            </option>
                                            <option value="#rsB15_2.Mcodigo#">
												Moneda Expresion B15 #rsB15_2.Miso4217#
                                            </option>
                                      	</cfoutput>
                                    </select>
									<input type="hidden" name="cboB15" value="0">
                                </td>
								<td>
								  <select name="nivel">
									<option value="0">0</option>
									<option value="1">1</option>
									<option value="2">2</option>
									<option value="3">3</option>
								  </select>
								  <cfparam name="session.Conta.balances.nivelSeleccionado" default="false">
								  <input type="checkbox" name="chkNivelSeleccionado" value="1" <cfif session.Conta.balances.nivelSeleccionado>checked</cfif>/>&nbsp;<cfoutput>Mostrar solo nivel seleccionado</cfoutput>
								</td>
							</tr>
                            <tr>
                            	<td nowrap="nowrap"><strong>Tipo</strong></td>
                            </tr>
							<tr>
								<td>
									<select name="tipo" onchange="var LvarPres=(this.value==10); this.form.CPCtipo.disabled=!LvarPres;this.form.CPCsaldo.disabled=!LvarPres;this.form.CPCcalculoControl.disabled=!LvarPres;">
										<option value="1">Balance General</option>
										<option value="2">Estado de Resultados</option>
										<option value="3">Estado de Resultados sólo Movimientos del Mes</option>
										<option value="0">Saldos Contables</option>
										<option value="10">Presupuesto</option>
									</select>									
								</td>
								<td>
									<select name="CPCtipo" disabled="disabled">
										<option value="1">Cuentas de Balance</option>
										<option value="2">Cuentas de Resultados</option>
										<option value="0">Todas las Cuentas</option>
									</select>									
								</td>
                            </tr>
                            <tr>
								<td>&nbsp;</td>
								<td>
									<select name="CPCsaldo" disabled="disabled">
										<option value="[A]" 	>[A]  = Aprobación Presupuesto Ordinario</option>
										<option value="[M]" 	>[M]  = Modificación Presupuesto Extraordinario</option>
										<option value="[*PF]" 	>[*PF]:PRESUPUESTO FORMULADO</option>
										<option value="[T]" 	>[T]  = Traslados de Presupuesto Internos</option>
										<option value="[TE]" 	>[TE] = Traslados con Autorización Externa</option>
										<option value="[VC]" 	>[VC] = Variación Cambiaria</option>
										<option value="[*PP]" 	>[*PP]:PRESUPUESTO PLANEADO</option>
										<option value="[ME]"	>[ME] = Modificación por Excesos Autorizados</option>
										<option value="[*PA]" 	>[*PA]:PRESUPUESTO AUTORIZADO</option>
										<option value="[RA]" 	>[RA] = Presupuesto Reservado Período Anterior</option>
										<option value="[CA]" 	>[CA] = Presupuesto Comprometido Período Anterior</option>
										<option value="[RC]" 	>[RC] = Presupuesto Reservado</option>
										<option value="[CC]" 	>[CC] = Presupuesto Comprometido</option>
										<option value="[E]" 	>[E]  = Presupuesto Ejecutado</option>
										<option value="[*PCA]" 	>[*PCA]:CONSUMO DE AUXILIARES Y CONTABILIDAD</option>
										<option value="[RP]" 	>[RP] = Provisiones Presupuestarias</option>
										<option value="[*PC]" 	>[*PC]:PRESUPUESTO CONSUMIDO</option>
										<option value="[NP]" 	>[NP] = Rechazos Aprobados Pendientes de Aplicar</option>
										<option value="[*DN]" 	>[*DN]:DISPONIBLE NETO</option>
										<cfquery name="rsSQL" datasource="#session.dsn#">
											select Pvalor
											  from Parametros
											 where Ecodigo = #session.Ecodigo#
											   and Pcodigo = 1140
										</cfquery>
										<cfif rsSQL.Pvalor EQ "S">
											<option value="[E1]" 	>[E1] = Devengado no pagado</option>
											<option value="[EJ]" 	>[EJ] = Ejercido Total</option>
											<option value="[E2]" 	>[E2] = Ejercido no Pagado</option>
											<option value="[P]" 	>[P]  = Pagado</option>
										<cfelse>
											<option value="[PA]" 	>[PA] = Pagado por Anticipado</option>
											<option value="[P]" 	>[P]  = Presupuesto Pagado</option>
										</cfif>
									</select>									
								</td>
                            </tr>
                            <tr>
								<td>&nbsp;</td>
								<td>
									<select name="CPCcalculoControl">
										<option value="1">Mensual</option>
										<option value="2">Acumulado</option>
										<option value="3">Total</option>
									</select>									
								</td>
                            </tr>
                            <tr>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
							</tr>
                            <input type="hidden" name="CtrlConsulta" id="CtrlConsulta" value="0" />
							<tr><td colspan="2" align="center"><input type="submit" id="Consultar" value="Consultar" name="Consultar" onclick="Consulta();"></td>
							</tr>
							<tr>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
							</tr>
						</table> 
						</form>
						
					</td>
				</tr>
			</table>
		<cf_web_portlet_end>

		<script language="javascript1.2" type="text/javascript">
			function validar(f){
				var mensaje = '';
				if ( document.form1.GEid.value == '' ){
					mensaje += ' - El campo Grupo de Empresas es requerido.\n';
				}
				if ( document.form1.mes.value == '' ){
					mensaje += ' - El campo Mes es requerido.\n';
				}

				if ( mensaje != '' ){
					alert('Se presentaron los siguientes errores:\n' + mensaje)
					return false;
				}
				return true;
			}
			
			function Consulta(){
				document.getElementById("CtrlConsulta").value = 1;
			}
		</script>


	<cf_templatefooter>

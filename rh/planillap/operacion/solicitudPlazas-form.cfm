<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<!--- Usa estructura salarial --->
<cfset usa_es = false >
<cfquery name="usaES" datasource="#session.DSN#">
	select CSusatabla
	from ComponentesSalariales 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	and  CSsalariobase = 1
</cfquery>
<cfif usaES.CSusatabla eq 1 >
	<cfset usa_es = true >
</cfif>

<cfif isdefined("Form.RHSPid") and Len(Trim(Form.RHSPid)) GT 0>
	<cfset modo="CAMBIO">
<cfelse>
	<cfset modo="ALTA">
</cfif>
<cfif modulo EQ 'pp' or usa_es>
	<cfquery name="rsCategorias" datasource="#Session.DSN#">
		Select RHCid,RHCcodigo,RHCdescripcion
		from RHCategoria
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and RHCidpadre is not null
		order by RHCcodigo,RHCdescripcion
	</cfquery>
</cfif>			
<cfquery name="rsTabla" datasource="#Session.DSN#">
	Select RHTTid,RHTTcodigo,RHTTdescripcion
	from RHTTablaSalarial
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	order by RHTTcodigo,RHTTdescripcion
</cfquery>
<cfset varEstado = 0>
<cfquery name="empleado" datasource="#session.DSN#">
	select coalesce(llave, '0') as DEid 
	from UsuarioReferencia
	where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
	  and STabla = 'DatosEmpleado'
	  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoSDC#">
</cfquery>
<cfset filtro = ''>
<cfif empleado.RecordCount>
	<cfset filtro = 'and t.DEid=#empleado.DEid#'>
</cfif>
<cfset form.DEid= #empleado.DEid#>

<cfif modo NEQ 'ALTA'>
	<cfquery name="rsForm" datasource="#Session.DSN#">
		select RHSPid
			, RHSPconsecutivo
			, sp.RHCid
			, RHTTid
			, Mcodigo
			, salarioref
			, salariomax
			, Observaciones
			, RHSPestado
			, sp.CFid
			, RHSPcantidad
			, sp.RHMPPid 
			, mp.RHMPPcodigo
			, RHMPPdescripcion
			, sp.RHPcodigo
			, RHPdescpuesto
			, RHSPfdesde
			, RHSPfhasta
			, CFdescripcion
			, sp.ts_rversion
			, sp.RHMPnegociado
            , sp.RHSPcodigo
		from RHSolicitudPlaza sp
				inner join CFuncional cf
				on cf.Ecodigo=sp.Ecodigo
					and cf.CFid=sp.CFid
						
			left outer join RHMaestroPuestoP mp
				on mp.RHMPPid=sp.RHMPPid
					and mp.Ecodigo=sp.Ecodigo
		
			left outer join RHPuestos p
				on p.RHPcodigo=sp.RHPcodigo
					and p.Ecodigo=sp.Ecodigo
		where sp.RHSPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHSPid#">
	</cfquery>

	<cfif isdefined('rsForm') and rsForm.RHCid NEQ ''>
		<cfquery name="rsCategoria" datasource="#session.DSN#">
			select RHCid,RHCcodigo,RHCdescripcion
			from RHCategoria
			where RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.RHCid#">
		</cfquery>
	</cfif>
	
	<cfif isdefined('rsForm') and rsForm.RecordCount NEQ ''>
		<cfquery name="rsDatos" datasource="#session.DSN#">
			select 	a.RHCid, b.RHCcodigo, b.RHCdescripcion,
					c.RHTTid, c.RHTTcodigo,	c.RHTTdescripcion,
					d.RHMPPid, d.RHMPPcodigo, d.RHMPPdescripcion
			from RHSolicitudPlaza a
				left outer join RHCategoria b
					on a.RHCid = b.RHCid
				left outer join RHTTablaSalarial c
					on a.RHTTid = c.RHTTid				
				left outer join RHMaestroPuestoP d
					on a.RHMPPid = d.RHMPPid		
			where a.RHSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHSPid#">
		</cfquery>

	</cfif>
	
	<cfif isdefined('rsForm') and rsForm.CFid NEQ ''>
		<cfquery name="rsCFuncional" datasource="#session.DSN#">
			select CFid, CFcodigo, CFdescripcion
			from CFuncional
			where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.CFid#">
		</cfquery>	
	</cfif>
	<cfset varEstado = rsForm.RHSPestado>
</cfif>

<SCRIPT SRC="/cfmx/rh/js/utilesMonto.js"></SCRIPT>
<SCRIPT SRC="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</SCRIPT>
<style type="text/css">
<!--
.style1 {
	font-size: 14px;
	font-weight: bold;
}
-->
</style>

<cfoutput>
<form method="post" name="form1" action="/cfmx/rh/planillap/operacion/solicitudPlazas-sql.cfm" onSubmit="javascript: return valida();">
<input type="hidden" name="cambio_negociado" value="" />
	<table width="100%"  border="0" cellspacing="2" cellpadding="2">
      	<tr>
	  		<td colspan="3">
				<fieldset>
				<cfinclude template="/rh/portlets/pEmpleado.cfm">
				</fieldset>
			</td>
	  	</tr>
		<tr><td colspan="3"><hr /></td></tr>
      	<tr>
			<td width="9%">&nbsp;</td>
        	<td valign="top" width="41%">
				<table width="100%"  border="0" cellspacing="3" cellpadding="0">
					<cfif modo neq 'ALTA'>
					<tr>
						<td width="34%" align="left" nowrap><strong><cf_translate key="LB_Numero">N&uacute;mero:</cf_translate></strong>&nbsp;
						#rsForm.RHSPconsecutivo#</td>
					</tr>
					<cfelse>
					<tr><td>&nbsp;</td></tr>
					</cfif>
					<!---Puestos/Categorias--->
					<tr>
						<!--- Verifica la definición del salario base, si es por tabla entonces debe de tomar en cuenta la categoria --->
						<cfquery name="valTab" datasource="#session.dsn#">
							select count(1) as cantidad from ComponentesSalariales where CSsalariobase=1 and CSusatabla=1
							and Ecodigo=#session.Ecodigo#
						</cfquery>							
						<cfif valtab.cantidad  eq 1>
							<td align="left" colspan="4">
								<cfif modo NEQ "ALTA">
									<cf_rhcategoriapuesto form="form1" incluyeTabla="false" incluyeHiddens="true" query="#rsDatos#" align="left" tabindex="1" div="true">
								<cfelse>
									<cf_rhcategoriapuesto form="form1" incluyeTabla="false" incluyeHiddens="true" align="left" tabindex="1" div="true">
								</cfif>	
							</td>
						<cfelse>
							<td align="left"  colspan="2"><strong><cf_translate key="LB_Puesto">Puesto:</cf_translate></strong>&nbsp;		
								<cfif modo NEQ 'ALTA'>
									<cfquery name="rsPuesto" datasource="#Session.DSN#">
										select RHPcodigo, RHPdescpuesto, coalesce(RHPcodigoext,RHPcodigo) as RHPcodigoext
										from RHPuestos
										where RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsForm.RHPcodigo#">
										and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
									</cfquery>
									<cf_rhpuesto tabindex="1" query="#rsPuesto#">			
								<cfelse>
									<cf_rhpuesto tabindex="1">
								</cfif>							
							</td>
						</cfif>					
					</tr>
					
					<!---Fechas--->
					<tr>
						<td>
							<table width="100%" border="0" cellpadding="0" cellspacing="0">
								<tr>						
									<td align="left"><strong><cf_translate key="LB_FechaDesde">Fecha Desde</cf_translate></strong>&nbsp;</td>
									<td>&nbsp;&nbsp;&nbsp;</td>
									<td width="16%" align="left" nowrap><strong><cf_translate key="LB_FechaHasta">Fecha Hasta</cf_translate></strong>&nbsp;&nbsp;</td>
								</tr>				
								<tr>
									<td>
										<cfif modo NEQ "ALTA">
											<cf_sifcalendario tabindex="1" name="RHSPfdesde" value="#LSDateFormat(rsForm.RHSPfdesde,'dd/mm/yyyy')#">
										<cfelse>
											<cf_sifcalendario tabindex="1" name="RHSPfdesde" value="">
										</cfif>
									</td>
									<td>&nbsp;&nbsp;&nbsp;</td>
									<td width="84%">
										<cfif MODO NEQ "ALTA">
											<cf_sifcalendario tabindex="1" name="RHSPfhasta" value="#LSDateFormat(rsForm.RHSPfhasta,'dd/mm/yyyy')#">
										<cfelse>
											<cf_sifcalendario tabindex="1" name="RHSPfhasta" value="">
										</cfif>					
									</td>
								</tr>	
							</table>			
						</td>
					</tr>
					<!---Salario Referencia--->
					<cfif modulo NEQ 'pp'>
					<tr>
						<td width="16%" align="left" nowrap>
							<strong><cf_translate key="LB_SalarioDeReferencia">Salario de Referencia</cf_translate></strong>&nbsp;
						</td>
					</tr>
					<tr>
						<td width="84%">
							<input name="salarioref" type="text" id="salarioref" size="18" maxlength="15" tabindex="1"
								onFocus="this.value=qf(this); this.select();" 
								onBlur="javascript: fm(this,2);"  
								onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
								style="text-align: right;" 
								value="<cfif modo NEQ "ALTA">#LSCurrencyFormat(rsForm.salarioref, 'none')#<cfelse>0.00</cfif>" >
						</td>
					</tr>			
					</cfif>
					<!---Salario negociado--->		
					<cfif isdefined ('valTab') and valTab.cantidad eq 0><tr><td>&nbsp;</td></tr></cfif>
				</table>	
		  </td>					
					
			<td width="50%" valign="top">		
				<table width="79%"  border="0" cellspacing="3" cellpadding="0">
						<tr><td>&nbsp;&nbsp;</td></tr>
						
						<!---Centro Funcional--->					
						<tr>
							<td width="34%" align="left" nowrap><strong><cf_translate key="LB_CentroFuncional">Centro Funcional</cf_translate></strong>&nbsp;</td>			
						</tr>
						<tr>	
							<td align="left">					
							<cfset LvarUsuCodigos = "= #session.Usucodigo#">
							<cfset hoy=now()>
							<cfset valuesArraySN = ArrayNew(1)>
							<cfif isdefined("rsForm.CFid") and len(trim(rsForm.CFid))>
								<cfquery datasource="#Session.DSN#" name="rsSN">
									select 
									CFid,
									CFcodigo,
									CFdescripcion
									from CFuncional			
									where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
									and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.CFid#">
								</cfquery>
								
								<cfset ArrayAppend(valuesArraySN, rsSN.CFid)>
								<cfset ArrayAppend(valuesArraySN, rsSN.CFcodigo)>
								<cfset ArrayAppend(valuesArraySN, rsSN.CFdescripcion)>
								
							</cfif>   
							<cf_conlis
							Campos="CFid,CFcodigo,CFdescripcion"
							valuesArray="#valuesArraySN#"
							Desplegables="N,S,S"
							Modificables="N,S,N"
							Size="0,10,40"
							tabindex="5"
							Title="Lista de Centros Funcionales"
							Tabla="LineaTiempo t 
								inner join RHPlazas p
									inner join CFuncional c
										inner join Oficinas o 
										on o.Ecodigo=c.Ecodigo 
										and o.Ocodigo=c.Ocodigo
									on c.CFid=p.CFid
								on p.RHPid=t.RHPid"
							Columnas="distinct c.CFid,c.CFcodigo,c.CFdescripcion #LvarCNCT# ' (Oficina: ' #LvarCNCT# rtrim(o.Oficodigo) #LvarCNCT# ')' as CFdescripcion"
							Filtro="c.Ecodigo = #Session.Ecodigo# and #hoy# between LTdesde and LThasta #filtro# order by c.CFcodigo"
							Desplegar="CFcodigo,CFdescripcion"
							Etiquetas="Codigo,Descripcion"
							filtrar_por="c.CFcodigo,c.CFdescripcion"
							Formatos="S,S"
							Align="left,left"
							form="form1"
							Asignar="CFid,CFcodigo,CFdescripcion"
							Asignarformatos="S,S,S,S"
							/> 
							</td>
						</tr>
						<!---cantidad solicitada--->
						<tr>
							<td width="16%" align="left" nowrap><strong><cf_translate key="LB_CantidadSolicitada">Cantidad Solicitada</cf_translate></strong>&nbsp;&nbsp;</td>
						</tr>
						<tr>
							<td width="84%">
								<input name="RHSPcantidad" type="text" id="RHSPcantidad" size="18" maxlength="9" tabindex="1"
									onfocus="this.value=qf(this); this.select();" 
									onblur="javascript: fm(this,-1); fnVisibilidadCodigo(this.value)"  
									onkeyup="if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}" 
									style="text-align: right;" 
									value="<cfif modo NEQ "ALTA">#LSNumberFormat(rsForm.RHSPcantidad,'___,__9')#<cfelse>0</cfif>" >
							</td>
						</tr>	
						<tr>
							<td width="16%" align="left"><strong><cf_translate key="LB_Moneda">Moneda</cf_translate></strong>&nbsp;&nbsp;</td>
						</tr>
						<tr>
							<td width="84%">
								<cfif modo NEQ "ALTA">
									<cfquery name="rsMoneda" datasource="#session.dsn#">
										select Mcodigo, Mnombre 
										from Monedas 
										where Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.Mcodigo#"> 
										  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
									</cfquery>
									<cf_sifmonedas query="#rsMoneda#" tabindex="1">
								<cfelse>
									<cf_sifmonedas tabindex="1">
								</cfif>			
							</td>
						</tr>
					<!---Salario Referencia--->	
					<cfif modulo EQ 'pp'>
						<tr>
							<td width="16%" align="left" nowrap>
								<strong><cf_translate key="LB_SalarioDeReferencia">Salario de Referencia</cf_translate></strong>&nbsp;&nbsp;		
							</td>
						</tr>
						<tr>
							<td width="84%">
								<input name="salarioref" type="text" id="salarioref" size="18" maxlength="15" tabindex="1"
									onFocus="this.value=qf(this); this.select();" 
									onBlur="javascript: fm(this,2);"  
									onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
									style="text-align: right;" 
									value="<cfif modo NEQ "ALTA">#LSCurrencyFormat(rsForm.salarioref, 'none')#<cfelse>0.00</cfif>" >
							</td>
						</tr>	
					</cfif>			
						<tr>
							<td align="left" nowrap><strong><cf_translate key="LB_SalarioMaximo">Salario M&aacute;ximo</cf_translate></strong>&nbsp;&nbsp;</td>
						</tr>
						<tr>
							<td>
								<input name="salariomax" type="text" id="salariomax" size="18" maxlength="15" tabindex="1"
									onFocus="this.value=qf(this); this.select();" 
									onBlur="javascript: fm(this,2);"  
									onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
									style="text-align: right;" 
									value="<cfif modo NEQ "ALTA">#LSCurrencyFormat(rsForm.salariomax, 'none')#<cfelse>0.00</cfif>" >
							</td>
						</tr>
                        <tr>
                        	<td id="tdCodigo">
                            	<table width="100%" border="0" cellpadding="0" cellspacing="0">
                                	<tr>
                                    	<td align="left" id="Etiqueta" nowrap><strong><cf_translate key="LB_Codigo">C&oacute;digo</cf_translate></strong>&nbsp;&nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <input name="RHSPcodigo" type="text" id="RHSPcodigo" size="15" maxlength="10" tabindex="1" value="<cfif modo NEQ "ALTA">#rsForm.RHSPcodigo#</cfif>" >
                                        </td>
                                    </tr>	
                                </table>
                            </td>
						</tr>	  			      
       		  </table>
		  </td>			
      	</tr>
      	<tr>
        	<td colspan="6" valign="top">
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			  		<tr>
						<td width="201">&nbsp;</td>
						<td align="left" width="1005" valign="top"><strong>
					  <cf_translate key="LB_Observaciones">Observaciones</cf_translate></strong>&nbsp;&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td>
							<textarea name="Observaciones" tabindex="1" id="Observaciones" rows="4" cols="125" ><cfif modo NEQ "ALTA">#HTMLEditFormat(trim(rsForm.Observaciones))#</cfif></textarea>
						</td>
			  		</tr>
				</table>
			</td>
	  	</tr>	 	  
		<tr><td>&nbsp;</td></tr>
		<cfif modo neq 'ALTA' and modulo eq 'pp'  >
			<cfquery name="rsComponentes" datasource="#session.DSN#">
				select ltc.RHCSid, 
					   ltc.CSid, 
					   cs.CScodigo, 
					   cs.CSdescripcion, 
		
					   <!---case when cs.CSsalariobase = 1 then ( case when ltc.Monto = 0 then ltp.salarioref else ltc.Monto end ) else ltc.Monto end as MontoRes, --->
					   ltc.Monto as MontoRes,
					   0 as MontoBase,
					   cs.CSusatabla, 
					   ltc.RHSPid, 
					   ltc.Cantidad,
					   ltc.ts_rversion,
					   coalesce(cs.CIid, -1) as CIid,
					   cs.CSusatabla,
					   cs.CSsalariobase,
					   coalesce(c.RHMCcomportamiento, 1) as RHMCcomportamiento,
					   c.RHMCvalor as valor
				
				from RHCSolicitud ltc
				
				inner join RHSolicitudPlaza ltp
				on ltp.RHSPid=ltc.RHSPid
				and ltp.RHSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHSPid#">
			
				inner join ComponentesSalariales cs
				on cs.CSid=ltc.CSid
				
				 left outer join RHMetodosCalculo c
				 on c.Ecodigo = cs.Ecodigo
				 and c.CSid = cs.CSid
				 and ltp.RHSPfdesde between c.RHMCfecharige and c.RHMCfechahasta
				 and c.RHMCestadometodo = 1
		
		
				where ltc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and ltc.RHSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHSPid#">
				order by cs.CSorden, cs.CScodigo, cs.CSdescripcion
			</cfquery>
			
			<cfquery name="rsTotal" datasource="#session.DSN#">
				select coalesce(sum(Monto),0) as monto
				from RHCSolicitud
				where RHSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHSPid#">
			</cfquery>
			
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_ComponentesSalariales"
				Default="Componentes Salariales"
				returnvariable="LB_ComponentesSalariales"/>
			<cfif rsComponentes.recordcount gt 0>
				<tr>
					<td colspan="3" align="center">
						<table width="80%%" cellpadding="0" cellspacing="0">
							<tr>
								<td>
									<cf_web_portlet_start skin="#Session.Preferences.Skin#" titulo="#LB_ComponentesSalariales#">
										<table width="100%">
											<tr>
												<td>
													<cfinvoke component="sif.Componentes.Translate"
														method="Translate"
														Key="MSG_DeseaBorrarElComponenteSalarial"
														Default="Desea borrar el Componente Salarial?"
														returnvariable="MSG_DeseaBorrarElComponenteSalarial"/>
													<script language="javascript1.2" type="text/javascript">
														function funcEliminar(id){
															if ( confirm('<cfoutput>#MSG_DeseaBorrarElComponenteSalarial#</cfoutput>') ){
																document.form1.CSid_Borrar.value = id;
																return true
															}
															return false;
														}
													</script> 
												
													<cfinvoke component="rh.Componentes.RH_CompSalarial" method="pComponentes" returnvariable="result">
														<cfinvokeargument name="id" value="#rsForm.RHSPid#">
														<cfinvokeargument name="query" value="#rsComponentes#">
														<cfinvokeargument name="totalComponentes" value="#rsTotal.Monto#">
														<cfinvokeargument name="sql" value="3">
														<cfinvokeargument name="readonly" value="false">
														<cfinvokeargument name="permiteAgregar" value="1">
														<cfinvokeargument name="negociado" value="#rsForm.RHMPnegociado is 'N'#">
														<cfinvokeargument name="linea" value="RHCSid">
														<cfinvokeargument name="unidades" value="Cantidad">
														<cfinvokeargument name="montobase" value="MontoBase">
														<cfinvokeargument name="montores" value="MontoRes">
														<cfinvokeargument name="funcionEliminar" value="funcEliminar">
													</cfinvoke>
												</td>
											</tr>
										</table>
									<cf_web_portlet_end>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			<cfelse>
				<tr>
					<td colspan="3" align="center">
						<table width="80%%" cellpadding="0" cellspacing="0">
							<tr>
								<td>
									<cf_web_portlet_start skin="#Session.Preferences.Skin#" titulo="#LB_ComponentesSalariales#">
										<table width="100%" class="ayuda">
											<tr>
												<td>
													<cf_translate key="MSG_NoSeExistenComponentesSalarialesAsociadosALaSolicitud">No se existen Componentes Salariales asociados a la Solicitud</cf_translate>.
												</td>
											</tr>
											<!--- <tr>
												<td>
													<cf_translate key="MSG_ParaAgregarComponentesALaSolicitudDebeSeleccionarLaTablaSalarialPuestoCategoriaLuegoDebeModificarLaSolicitudODarleClickAlCheckDeSalarioNegociado">Para agregar componentes a la Solicitud, debe seleccionar la Tabla Salarial, Puesto, Categor&iacute;a,
														luego debe modificar la Solicitud &oacute; darle click al check de Salario Negociado</cf_translate>.
												</td>
											</tr> --->
										</table>
									<cf_web_portlet_end>	
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</cfif>
		</cfif>
	  	<tr><td colspan="3">&nbsp;</td></tr>	  
      	<tr>
        	<td colspan="3" align="center">
				<cfif isdefined ('rsform.RHSPestado') and rsform.RHSPestado neq 30 or not isdefined ('rsform.RHSPestado')>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Aplicar"
						Default="Aplicar"
						XmlFile="/rh/generales.xml"
						returnvariable="BTN_Aplicar"/>
					<cfif modulo EQ 'pp'>
						<cfif modo NEQ "ALTA">
							<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="BTN_Rechazar"
								Default="Rechazar"
								XmlFile="/rh/generales.xml"
								returnvariable="BTN_Rechazar"/>
							<cf_botones modo='#modo#' include="#BTN_Aplicar#,#BTN_Rechazar#" tabindex="1">	
						<cfelse>
							<cf_botones modo='#modo#' tabindex="1">	
						</cfif>
					<cfelse>
						<cfif modo NEQ "ALTA">
							<cf_botones modo='#modo#' include="#BTN_Aplicar#" tabindex="1">	
						<cfelse>
							<cf_botones modo='#modo#' tabindex="1">	
						</cfif>
					</cfif>	
				</cfif>
			</td>
      	</tr>	  
    </table>

	<input type="hidden" name="RHSPid" value="<cfif modo NEQ "ALTA">#rsForm.RHSPid#</cfif>">
	<cfset ts = "">
	<cfif modo NEQ "ALTA">
		<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#rsForm.ts_rversion#" returnvariable="ts">
		</cfinvoke>
	</cfif>
	<input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA">#ts#</cfif>">	
	<input type="hidden" name="modulo" value="#modulo#">		
	<input type="hidden" name="estado" value="#varEstado#">
	<input type="hidden" name="CSid_Borrar" value="" />
	
</form>
<!--- Variables de la Traduccion --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_CentroFuncional"
	Default="Centro Funcional"
	returnvariable="MSG_CentroFuncional"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Cantidad"
	Default="Cantidad"
	returnvariable="MSG_Cantidad"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Moneda"
	Default="Moneda"
	returnvariable="MSG_Moneda"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_FechaDesde"
	Default="Fecha desde"
	returnvariable="MSG_FechaDesde"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_PuestoSolicitado"
	Default="Puesto Solicitado"
	returnvariable="MSG_PuestoSolicitado"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_TablaSalarial"
	Default="Tabla Salarial"
	returnvariable="MSG_TablaSalarial"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_PuestoPresupuestario"
	Default="Puesto Presupuestario"
	returnvariable="MSG_PuestoPresupuestario"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Categoria"
	Default="Categoría"
	returnvariable="MSG_Categoria"/>
</cfoutput>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ErrorDebeSeleccionarLaFechaDeInicio"
	Default="Error, debe seleccionar la fecha de inicio"
	returnvariable="MSG_ErrorDebeSeleccionarLaFechaDeInicio"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ErrorLaFechaDeInicioNoPuedeSerMayorQueLaFechaFinal"
	Default="Error, la fecha de inicio no puede ser mayor que la fecha final"
	returnvariable="MSG_ErrorLaFechaDeInicioNoPuedeSerMayorQueLaFechaFinal"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ErrorLaCantidadDebeSerMayorACero"
	Default="Error, la cantidad debe ser mayor a cero"
	returnvariable="MSG_ErrorLaCantidadDebeSerMayorACero"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_AplicarLaSolicitud"
	Default="¿ Aplicar la Solicitud ?"
	returnvariable="MSG_AplicarLaSolicitud"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DeseaRechazarLaSolicitudDePlazas"
	Default="Desea rechazar la Solicitud de Plazas?"
	returnvariable="MSG_DeseaRechazarLaSolicitudDePlazas"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_AlModificarEsteCampoVaARegenerarLosComponentesSalarialesAsociadosALaSolicitudDeseaContinuar"
	Default="Al modificar este campo, va a regenerar los Componentes Salariales asociados a la Solicitud. Desea continuar?"
	returnvariable="MSG_AlModificarEsteCampoVaARegenerarLosComponentesSalarialesAsociadosALaSolicitudDeseaContinuar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ElCampoTablaSalarialEsRequerido"
	Default="El campo Tabla Salarial es requerido"
	returnvariable="MSG_ElCampoTablaSalarialEsRequerido"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ElCampoPuestoPresupuestarioEsRequerido"
	Default="El campo Puesto Presupuestario es requerido"
	returnvariable="MSG_ElCampoPuestoPresupuestarioEsRequerido"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ElCampoCategoriaEsRequerido"
	Default="El campo Categoría es requerido"
	returnvariable="MSG_ElCampoCategoriaEsRequerido"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_SePresentaronLosSiguientesErrores"
	Default="Se presentaron los siguientes errores"
	returnvariable="MSG_SePresentaronLosSiguientesErrores"/>
	
<SCRIPT LANGUAGE="JavaScript">
	qFormAPI.errorColor = "#F5FAA0";
	objForm = new qForm("form1");
<cfoutput>
	objForm.CFcodigo.required = true;
	objForm.CFcodigo.description="#MSG_CentroFuncional#";
	objForm.RHSPcantidad.required = true;
	objForm.RHSPcantidad.description="#MSG_Cantidad#";
	objForm.Mcodigo.required = true;
	objForm.Mcodigo.description="#MSG_Moneda#";
	objForm.RHSPfdesde.required = true;
	objForm.RHSPfdesde.description="#MSG_FechaDesde#";
	
	
	<cfif valtab.cantidad eq 1>
	//	objForm.RHPcodigo.required = true;
		//objForm.RHPcodigo.description="#MSG_PuestoSolicitado#";		

		objForm.RHTTid.required = true;
		objForm.RHTTid.description="#MSG_TablaSalarial#";		

		objForm.RHMPPid.required = true;
		objForm.RHMPPid.description="#MSG_PuestoPresupuestario#";


	</cfif>
</cfoutput>
	function deshabilitarValidacion(){
		objForm.CFcodigo.required = false;
		objForm.RHSPcantidad.required = false;
		objForm.Mcodigo.required = false;
		objForm.RHSPfdesde.required = false;
		<cfif valtab.cantidad eq 1>
			objForm.RHTTid.required = false;
			objForm.RHMPPid.required = false;				
			objForm.RHCid.required = false;
		</cfif>		
		
		<cfif valtab.cantidad eq 1>
			//objForm.RHPcodigo.required = false;	
		</cfif>
	}

	function habilitarValidacion(){
		objForm.CFcodigo.required = true;
		objForm.RHSPcantidad.required = true;
		objForm.Mcodigo.required = true;
		
		<cfif valtab.cantidad eq 1>
			<cfoutput>
			objForm.RHTTid.required = true;
			objForm.RHTTid.description="#MSG_TablaSalarial#";					
			objForm.RHMPPid.required = true;
			objForm.RHMPPid.description="#MSG_PuestoPresupuestario#";			
			objForm.RHCid.required = true;
			objForm.RHCid.description="#MSG_Categoria#";			
			</cfoutput>
		</cfif>
		
		<cfif isdefined ('valTab') and valTab.cantidad gt 0>
			<cfoutput>
			objForm.RHTTid.required = true;
			objForm.RHTTid.description="#MSG_TablaSalarial#";					
			objForm.RHMPPid.required = true;
			objForm.RHMPPid.description="#MSG_PuestoPresupuestario#";
			</cfoutput>
		</cfif>
		
		<cfif  isdefined ('valTab') and valTab.cantidad eq 0>
			<cfoutput>
				objForm.RHPcodigo.required= true;
				objForm.RHPcodigo.description="Puesto";
			</cfoutput>
		</cfif>
		if(document.form1.RHSPcantidad.value > 0){
			objForm.RHSPcodigo.required = true;
			objForm.RHSPcodigo.description="Código de la Plaza";	
		}else{
			objForm.RHSPcodigo.required = false;
			objForm.RHSPcodigo.description="Código de la Plaza";	
		}
	}	
	
	function funcNuevo() {
		deshabilitarValidacion();
	}
	
	function limpiar() {
		objForm.reset();
	}

	function VALIDAFECHAS(INICIO,FIN){
		var valorINICIO=0
		var valorFIN=0
		INICIO = INICIO.substring(6,10) + INICIO.substring(3,5) + INICIO.substring(0,2)
		FIN = FIN.substring(6,10) + FIN.substring(3,5) + FIN.substring(0,2)
		valorINICIO = parseInt(INICIO)
		valorFIN = parseInt(FIN)
		if (valorINICIO > valorFIN)
		   return false;
		return true;
	}				
	function valida(){
		
		if((document.form1.botonSel.value != 'Nuevo')&&(document.form1.botonSel.value != 'Baja')&&(document.form1.botonSel.value != 'Rechazar')){
			if(document.form1.RHSPfhasta.value != '' && document.form1.RHSPfdesde.value == ''){
				alert("<cfoutput>#MSG_ErrorDebeSeleccionarLaFechaDeInicio#</cfoutput>");
				return false;
			}
		
			if(document.form1.RHSPfdesde.value != '' && document.form1.RHSPfhasta.value != ''){
				if(!VALIDAFECHAS(document.form1.RHSPfdesde.value,document.form1.RHSPfhasta.value)){
					alert("<cfoutput>#MSG_ErrorLaFechaDeInicioNoPuedeSerMayorQueLaFechaFinal#</cfoutput>");
					return false;			
				}		
			}
			
			document.form1.RHSPcantidad.value = qf(document.form1.RHSPcantidad);
			document.form1.salarioref.value = qf(document.form1.salarioref);		
			document.form1.salariomax.value = qf(document.form1.salariomax);
			
			if(document.form1.RHSPcantidad.value <= 0){
				alert('<cfoutput>#MSG_ErrorLaCantidadDebeSerMayorACero#</cfoutput>');
				document.form1.RHSPcantidad.focus();
				return false;
			}
			
			if((document.form1.RHSPfdesde.value != '') && (document.form1.RHSPfhasta.value == '')){
				document.form1.RHSPfhasta.value = '01/01/6100';
			}
			
			if(document.form1.botonSel.value == 'Aplicar'){
				if(!confirm("<cfoutput>#MSG_AplicarLaSolicitud#</cfoutput>"))
					return false;
			}
			<!--- document.form1.LvarPuesto.disabled=false
			document.form1.LvarCat.disabled=false
			document.form1.LvarPid.disabled=false
			document.form1.LvarCid.disabled=false --->
		}
		return true;
	}
	
	function funcRechazar(){
		deshabilitarValidacion();
		return confirm('<cfoutput>#MSG_DeseaRechazarLaSolicitudDePlazas#</cfoutput>');
	}
	
	<!--- Limpia el puesto maestro --->
	function funcRHTTid() {
		<!--- Se limpia el puesto maestro si la categoría ha cambiado --->							
		if (document.form1.RHTTid.value != document.form1.RHTTid_ant.value) {
			document.form1.RHMPPid.value = '';
			document.form1.RHMPPcodigo.value = '';
			document.form1.RHMPPdescripcion.value = '';
			document.form1.RHTTid_ant.value = document.form1.RHTTid.value;
			
			<cfif valtab.cantidad eq 1>
			document.form1.RHCid.value = '';
			document.form1.RHCcodigo.value = '';
			document.form1.RHCdescripcion.value = '';
			</cfif>
		}							
	}
	
	<!--- Limpia el puesto maestro --->
	function funcRHMPPcodigo() {
		<cfif valtab.cantidad eq 1>
			document.form1.RHCid.value = '';
			document.form1.RHCcodigo.value = '';
			document.form1.RHCdescripcion.value = '';
		</cfif>  
	}

	function limpiar_puesto(){
		document.form1.RHMPPid.value = '';
		document.form1.RHMPPcodigo.value = '';
		document.form1.RHMPPdescripcion.value = '';				
	}
		
	function negociado(obj){
		
		if ( confirm('<cfoutput>#MSG_AlModificarEsteCampoVaARegenerarLosComponentesSalarialesAsociadosALaSolicitudDeseaContinuar#</cfoutput>') ){
			var error = '';
			if ( document.form1.RHTTid.value == '' ){
				error += ' - <cfoutput>#MSG_ElCampoTablaSalarialEsRequerido#</cfoutput>.\n';
			}
			if ( document.form1.RHMPPid.value == '' ){
				error += ' - <cfoutput>#MSG_ElCampoPuestoPresupuestarioEsRequerido#</cfoutput>.\n';
			}
			if ( document.form1.RHCid.value == '' ){
				error += ' - <cfoutput>El campo categoría es requerido</cfoutput>.\n';
			}
			/*if ( document.form1.RHCid.value == '' ){
				error += ' - <cfoutput>#MSG_ElCampoCategoriaEsRequerido#</cfoutput>.\n';
			}*/
			if (error != '' ){
				alert(' <cfoutput>#MSG_SePresentaronLosSiguientesErrores#</cfoutput>:\n ' + error);
				return;
			}
			
			document.form1.cambio_negociado.value = ( obj.checked ) ? 'N' : 'T';
			document.form1.submit();
		}
	}
	
	function fnVisibilidadCodigo(v){
		if(v == 1){
			document.getElementById("Etiqueta").innerHTML = "<strong>Código</strong>";
			document.getElementById("tdCodigo").style.display = "";
			document.form1.RHSPcodigo.maxLength = 10;
		}else if(v > 1){
			document.getElementById("Etiqueta").innerHTML = "<strong>Prefijo</strong>";
			document.getElementById("tdCodigo").style.display = "";
			document.form1.RHSPcodigo.maxLength = 7;
		}else{
			document.getElementById("tdCodigo").style.display = "none";
			document.form1.RHSPcodigo.maxLength = 10;
		}
		document.form1.RHSPcodigo.value = "";
	}
	fnVisibilidadCodigo(document.form1.RHSPcantidad.value);
</SCRIPT>

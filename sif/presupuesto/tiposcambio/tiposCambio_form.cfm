<script language="javascript" type="text/javascript" src="../../js/utilesMonto.js"></script>
<cfparam name="form.CPPid" default="-1">
<cfparam name="form.Mcodigo" default="-1">

<!--- Obtiene la Moneda de la Empresa --->
<cfquery name="rsSQL" datasource="#session.dsn#">
	select e.Mcodigo, m.Mnombre
	from Empresas e, Monedas m
	where e.Ecodigo = #session.ecodigo#
	  and m.Ecodigo = e.Ecodigo
	  and m.Mcodigo = e.Mcodigo
</cfquery>
<cfif find(",",rsSQL.Mnombre) GT 0>
	<cfset LvarMnombreEmpresa = trim(mid(rsSQL.Mnombre,find(",",rsSQL.Mnombre)+1,100))>
<cfelse>	
	<cfset LvarMnombreEmpresa = rsSQL.Mnombre>
</cfif>

<cfquery name="rsPeriodo" datasource="#session.dsn#">
	select CPPid, CPPestado
	  from CPresupuestoPeriodo
	 where Ecodigo = #session.ecodigo#
	 <cfif form.CPPid NEQ -1>
	   and CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPPid#">
	 </cfif>
</cfquery>
<cfif rsPeriodo.recordCount EQ 0>
	<cf_errorCode	code = "50542" msg = "No existen Períodos de Presupuesto definidos">
<cfelseif form.CPPid EQ -1>
	<cfset form.CPPid = rsPeriodo.CPPid>
</cfif>
<cfif form.Mcodigo EQ -1>
	<cfquery name="rsMonedas" datasource="#session.dsn#">
		select Mcodigo
		  from Monedas m
		 where Ecodigo = #session.ecodigo#
		   and not exists(select 1 from Empresas where Ecodigo = m.Ecodigo and Mcodigo = m.Mcodigo)
		order by Mnombre
	</cfquery>

	<cfif rsMonedas.recordCount EQ 0>
		<cf_errorCode	code = "50543" msg = "No existen Monedas definidas">
	</cfif>
	<cfset form.Mcodigo = rsMonedas.Mcodigo>
</cfif>

<!--- Obtiene la Moneda Escogida --->
<cfquery name="rsSQL" datasource="#session.dsn#">
	select m.Mcodigo, m.Mnombre
	from Monedas m
	where m.Ecodigo = #session.ecodigo#
	  and m.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
</cfquery>
<cfset LvarMnombre = rsSQL.Mnombre>

<cfquery name="rsSQL" datasource="#session.dsn#">
	select Pvalor
	  from Parametros
	 where Ecodigo = #session.ecodigo#
	   and Pcodigo = 50
</cfquery>
<cfset LvarAuxAno = rsSQL.Pvalor>
<cfquery name="rsSQL" datasource="#session.dsn#">
	select Pvalor
	  from Parametros
	 where Ecodigo = #session.ecodigo#
	   and Pcodigo = 60
</cfquery>
<cfset LvarAuxMes = rsSQL.Pvalor>
<cfset LvarAuxAnoMes = LvarAuxAno*100+LvarAuxMes>
<cfif not isnumeric(form.Mcodigo)>
	<cfthrow message="El valor de la varibla Mcodigo no es numérico">
</cfif>
<cfif not isnumeric(form.CPPid)>
	<cfthrow message="El valor de la varibla Mcodigo no es numérico">
</cfif>

<cfquery name="qry_lista" datasource="#session.dsn#">
 	select 	#form.Mcodigo# 	as Mcodigo, 
			#form.CPPid# 		as CPPid, 
			m.CPCano, m.CPCmes, 
			case m.CPCmes
				when 1 then 'Enero'
				when 2 then 'Febrero'
				when 3 then 'Marzo'
				when 4 then 'Abril'
				when 5 then 'Mayo'
				when 6 then 'Junio'
				when 7 then 'Julio'
				when 8 then 'Agosto'
				when 9 then 'Septiembre'
				when 10 then 'Octubre'
				when 11 then 'Noviembre'
				when 12 then 'Diciembre'
			end as Mes,
			p.CPTipoCambioCompra,
			p.CPTipoCambioVenta,
			p.CPTipoCambioCompraTmp,
			p.CPTipoCambioVentaTmp
	<cfif rsPeriodo.CPPestado NEQ 0>
			, coalesce((
				select sum(CPCMpresupuestado+CPCMmodificado)
				  from CPControlMoneda cm
				  	inner join CPresupuesto cp
						inner join CtasMayor my
							on my.Ecodigo = cp.Ecodigo
							and my.Cmayor = cp.Cmayor
							and my.Ctipo in ('A','G')
						on cp.CPcuenta = cm.CPcuenta
				 where cm.Ecodigo 	= m.Ecodigo
				   and cm.CPPid		= m.CPPid
				   and cm.CPCano	= m.CPCano
				   and cm.CPCmes	= m.CPCmes
				   and cm.Mcodigo	= #form.Mcodigo#
			  ),0) as AutorizadoVenta
			, coalesce((
				select sum(CPCMpresupuestado+CPCMmodificado)
				  from CPControlMoneda cm
				  	inner join CPresupuesto cp
						inner join CtasMayor my
							on my.Ecodigo = cp.Ecodigo
							and my.Cmayor = cp.Cmayor
							and my.Ctipo not in ('A','G')
						on cp.CPcuenta = cm.CPcuenta
				 where cm.Ecodigo 	= m.Ecodigo
				   and cm.CPPid		= m.CPPid
				   and cm.CPCano	= m.CPCano
				   and cm.CPCmes	= m.CPCmes
				   and cm.Mcodigo	= #form.Mcodigo#
			  ),0) as AutorizadoCompra
	</cfif>
	from CPmeses m
		left outer join CPTipoCambioProyectadoMes p
			on p.Ecodigo = m.Ecodigo
		   and p.CPCano  = m.CPCano
		   and p.CPCmes  = m.CPCmes
		   and p.Mcodigo = #form.Mcodigo#
	where m.Ecodigo 	= #session.ecodigo#
	  and m.CPPid 		= #form.CPPid#
	order by m.CPCano, m.CPCmes
</cfquery>

<cfif rsPeriodo.CPPestado NEQ 0>
	<cfquery name="qry_variacion" datasource="#session.dsn#">
		select 	cm.Mcodigo, 
				m.Mnombre, 
				sum((CPCMpresupuestado+CPCMmodificado) *
						case 
							when my.Ctipo in ('A','G') 
								then (p.CPTipoCambioVentaTmp - p.CPTipoCambioVenta)
								else (p.CPTipoCambioCompraTmp - p.CPTipoCambioCompra)
						end 
				  ) 
				as MontoVariacion
		  from CPControlMoneda cm
			inner join CPresupuesto cp
				inner join CtasMayor my
					on my.Ecodigo = cp.Ecodigo
					and my.Cmayor = cp.Cmayor
				on cp.CPcuenta = cm.CPcuenta
			inner join Monedas m
				on m.Mcodigo = cm.Mcodigo
			inner join CPTipoCambioProyectadoMes p
				on p.Ecodigo = cm.Ecodigo
			   and p.CPCano  = cm.CPCano
			   and p.CPCmes  = cm.CPCmes
			   and p.Mcodigo = cm.Mcodigo
		 where cm.Ecodigo 	= #session.ecodigo#
		   and cm.CPPid 	= #form.CPPid#
		   and not exists(select 1 from Empresas where Ecodigo = cm.Ecodigo and Mcodigo = cm.Mcodigo)
		   and cm.CPCano*100+cm.CPCmes >= #LvarAuxAnoMes#
		group by cm.Mcodigo, p.Mcodigo, m.Mnombre
	</cfquery>
	<cfquery name="qry_variacionTotal" dbtype="query">
		select 	sum(MontoVariacion) as MontoVariacion
		  from qry_variacion
		 where Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
	</cfquery>
	<cfif qry_variacionTotal.MontoVariacion EQ "">
		<cfset LvarVariacionTotal = 0>
	<cfelse>
		<cfset LvarVariacionTotal = qry_variacionTotal.MontoVariacion>
	</cfif>
<cfelse>
	<cfset LvarVariacionTotal = 0>
</cfif>
<form name="form1" action="tiposCambio.cfm" method="post">
<table>
	<tr>
		<td>
			Período Presupuestario:
		</td>
		<td>
			<cf_cboCPPid value="#form.CPPid#" CPPestado="0,1" onChange="javascript: this.form.submit();">
		</td>
	</tr>
	<tr>
		<td>
			Moneda:
		</td>
		<td>
			<cf_sifmonedas value="#form.Mcodigo#" onChange="javascript: this.form.submit();" ExcluirLocal="true">
		</td>
	</tr>
</table>

</form>
<form name="form2" action="tiposCambio_sql.cfm" method="post">
<table width="99%"align="center" border="0" cellspacing="0" cellpadding="0" summary="Control de Versiones de Presupuesto">
	<tr>
		<td class="subTitulo" align="center" width="50%">Tipos de Cambio Proyectados por Mes</td>
		<td>&nbsp;</td>
<cfif rsPeriodo.CPPestado NEQ 0>
		<td class="subTitulo" align="center" nowrap  width="30%">Variación Presupuestaria Requerida por Moneda</td>
<cfelse>
		<td class="subTitulo" align="center" nowrap  width="30%">&nbsp;</td>
</cfif>
	</tr>
	<tr>
		<td>
	<cfoutput>
		<input type="hidden" name="CPPid" id="CPPid" value="#form.CPPid#">
		<input type="hidden" name="Mcodigo" id="Mcodigo" value="#form.Mcodigo#">
			<table align="center" width="50%" cellpadding="0" cellspacing="0">
				<tr>
					<td class="tituloListas" rowspan="2">
						<strong>Año</strong>
					</td>
					<td class="tituloListas" rowspan="2">
						<strong>Mes</strong>
					</td>
					<td class="tituloListas" align="center" colspan="2">
						<strong>Tipo de Cambio Aplicado</strong>
					</td>
					<td class="tituloListas" align="center" colspan="2"> 
						<strong>Tipo de Cambio a Cambiar </strong>
					</td>
				<cfif rsPeriodo.CPPestado NEQ 0>
					<td class="tituloListas" align="center" colspan="2"> 
						<strong>Total Presupuesto Autorizado<BR><cfoutput>#LvarMnombre#</cfoutput></strong>
					</td>
					<td class="tituloListas" align="center" rowspan="2" colspan="2"> 
						<strong>Variación Presupuestaria Requerida<BR><cfoutput>#LvarMnombreEmpresa#</cfoutput></strong>
					</td>
				</cfif>
				</tr>
				<tr>
					<td class="tituloListas" align="right">
						<strong>&nbsp;&nbsp;&nbsp;Compra</strong>
					</td>
					<td class="tituloListas" align="right">
						<strong>&nbsp;&nbsp;&nbsp;Venta</strong>
					</td>
					<td class="tituloListas" align="right">
						<strong>&nbsp;&nbsp;&nbsp;Compra</strong>
					</td>
					<td class="tituloListas" align="right">
						<strong>&nbsp;&nbsp;&nbsp;Venta</strong>
					</td>
				<cfif rsPeriodo.CPPestado NEQ 0>
					<td class="tituloListas" align="right">
						<strong>&nbsp;&nbsp;&nbsp;Compra</strong>
					</td>
					<td class="tituloListas" align="right">
						<strong>&nbsp;&nbsp;&nbsp;Venta</strong>
					</td>
				</cfif>
				</tr>
			</cfoutput>
				<cfset LvarAplicar = false>
				<cfoutput query="qry_lista">
				<cfif CPTipoCambioCompra NEQ CPTipoCambioCompraTmp OR CPTipoCambioVenta NEQ CPTipoCambioVentaTmp>
					<cfset LvarAplicar = true>
				</cfif>
				<tr <cfif qry_lista.currentRow mod 2 EQ 0>class="listaPar"<cfelse>class="listaNon"</cfif>>
					<td <cfif CPTipoCambioCompra NEQ CPTipoCambioCompraTmp OR CPTipoCambioVenta NEQ CPTipoCambioVentaTmp>style="color:##FF0000"</cfif>>
						#CPCano#
					</td>
					<td <cfif CPTipoCambioCompra NEQ CPTipoCambioCompraTmp OR CPTipoCambioVenta NEQ CPTipoCambioVentaTmp>style="color:##FF0000"</cfif>>
						#Mes#
					</td>
					<td align="right" <cfif CPTipoCambioCompra NEQ CPTipoCambioCompraTmp>style="color:##FF0000"</cfif>>
						#lsCurrencyformat(CPTipoCambioCompra,'none')#
					</td>
					<td align="right" <cfif CPTipoCambioVenta NEQ CPTipoCambioVentaTmp>style="color:##FF0000"</cfif>>
						#lsCurrencyformat(CPTipoCambioVenta,'none')#
					</td>
					<td align="right">
						<cfif LvarAuxAnoMes LTE CPCano*100+CPCmes>
							<input 	type="text" name="Compra_#CPCano#_#CPCmes#" id="Compra_#CPCano#_#CPCmes#" 
									value="#lsCurrencyformat(CPTipoCambioCompraTmp,'none')#"
									style="text-align:right;" 
									onFocus="this.value=qf(this); this.select();" 
									onBlur="javascript: fm(this,2); sbCalcular(#CPCano#,#CPCmes#);"  
									size="10"
									onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
							>
						<cfelse>
							<input 	type="text" name="Compra_#CPCano#_#CPCmes#" id="Compra_#CPCano#_#CPCmes#" 
									value="#lsCurrencyformat(CPTipoCambioCompra,'none')#"
									readonly="yes" style="text-align:right; border:none;" 
									tabindex="-1"
									size="10"
									<cfif qry_lista.currentRow mod 2 EQ 0>class="listaPar"<cfelse>class="listaNon"</cfif>
							>
						</cfif>
					</td>
					<td align="right">
						<cfif LvarAuxAnoMes LTE CPCano*100+CPCmes>
							<input 	type="text" name="Venta_#CPCano#_#CPCmes#" id="Venta_#CPCano#_#CPCmes#" 
									value="#lsCurrencyformat(CPTipoCambioVentaTmp,'none')#"
									style="text-align:right;" 
									onFocus="this.value=qf(this); this.select();" 
									onBlur="javascript: fm(this,2); sbCalcular(#CPCano#,#CPCmes#);"  
									size="10"
									onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
							>
						<cfelse>
							<input 	type="text" name="Venta_#CPCano#_#CPCmes#" id="Venta_#CPCano#_#CPCmes#" 
									value="#lsCurrencyformat(CPTipoCambioVenta,'none')#"
									readonly="yes" style="text-align:right; border:none;" 
									tabindex="-1"
									size="10"
									<cfif qry_lista.currentRow mod 2 EQ 0>class="listaPar"<cfelse>class="listaNon"</cfif>
							>
						</cfif>
					</td>
				<cfif rsPeriodo.CPPestado NEQ 0>
					<cfif LvarAuxAnoMes GT CPCano*100+CPCmes>
						<cfset LvarVariacion = 0>
					<cfelseif CPTipoCambioVentaTmp EQ "" OR CPTipoCambioVenta EQ "" OR AutorizadoVenta  EQ "" OR CPTipoCambioCompraTmp EQ "" OR CPTipoCambioCompra EQ "" OR AutorizadoCompra EQ "">
						<cfset LvarVariacion = 0>
					<cfelse>
						<cfset LvarVariacion = (CPTipoCambioVentaTmp-CPTipoCambioVenta)*AutorizadoVenta + (CPTipoCambioCompraTmp-CPTipoCambioCompra)*AutorizadoCompra>
						<cfset LvarVariacion = round(LvarVariacion * 100)/100>
					</cfif>
					<td align="right" <cfif LvarVariacion NEQ 0 AND CPTipoCambioCompra NEQ CPTipoCambioCompraTmp>style="color:##FF0000"</cfif>>
						#lsCurrencyformat(AutorizadoCompra,'none')#
					</td>
					<td align="right" <cfif LvarVariacion NEQ 0 AND CPTipoCambioVenta NEQ CPTipoCambioVentaTmp>style="color:##FF0000"</cfif>>
						#lsCurrencyformat(AutorizadoVenta,'none')#
					</td>
					<td align="right" <cfif LvarVariacion NEQ 0>style="color:##FF0000"</cfif>>
						#lsCurrencyformat(LvarVariacion,'none')#
					</td>
					</cfif>
				</tr>
				</cfoutput>
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td align="center" colspan="10">
					<cfif LvarVariacionTotal EQ 0>
						<cfif LvarAplicar>
							<cf_botones values="Guardar, Aplicar, Restaurar">
						<cfelse>
							<cf_botones values="Guardar">
						</cfif>
					<cfelse>
						<cfif LvarAplicar>
							<cf_botones values="Guardar, Restaurar">
						<cfelse>
							<cf_botones values="Guardar">
						</cfif>
					</cfif>
					</td>
				</tr>
			</table>
		</td>
		<td>&nbsp;</td>
		<td valign="top">
<cfif rsPeriodo.CPPestado NEQ 0>
			<table align="center" width="100%" cellpadding="0" cellspacing="0">
				<tr>
					<td>
						<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="PListaRet">
							<cfinvokeargument name="query" value="#qry_variacion#">
							<cfinvokeargument name="desplegar" value="Mnombre,MontoVariacion"/>
							<cfinvokeargument name="etiquetas" value="Moneda, Monto Variacion<BR>#LvarMnombreEmpresa#"/>
							<cfinvokeargument name="formatos" value="S, M"/>
							<cfinvokeargument name="align" value="left, right"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
							<cfinvokeargument name="maxrows" value="10"/>
							<cfinvokeargument name="linearoja" value="MontoVariacion NEQ 0"/>
							<cfinvokeargument name="incluyeForm" value="false"/>
							<cfinvokeargument name="showLink" value="false"/>
						</cfinvoke>							
					</td>
				</tr>
				<tr>
					<td>&nbsp;
						
					</td>
				</tr>
				<tr>
					<td align="center">
						<cfif LvarVariacionTotal NEQ 0>
							<input type="submit" name="btnAplicar_Variacion" value="Aplicar Modificación Presupuesto Extraordinario"
								 onClick="
									if (confirm('¿Desea Aplicar la Modificacion Presupuestaria por Variación de tipo de cambio proyectado?'))
										return true;
									else
										return false;
										"
							>
						</cfif>
					</td>
				</tr>
			</table>
			<BR><BR>
</cfif>
			<table width="100%" border="1" cellspacing="0" cellpadding="2">
				<tr>
					<td align="center">
						<table width="80%" border="0" cellspacing="0" cellpadding="2">
							<tr>
								<td align="center" colspan="2"><strong>Proyectar Tipos Cambio a Futuro</strong></td>
							</tr>
							<tr>
								<td colspan="2">&nbsp;</td>
							</tr>
							<tr>
								<td>
									<select name="tipoProyeccion">
										<option value="1">Aumentar Monto</option>
										<option value="2">Aumentar Porcentaje</option>
									</select>
								</td>
								<td nowrap>
									<input type="text" name="montoProyeccion"  size="6" maxlength="6"> por mes
								</td>
							</tr>
							<tr>
								<td>
									A partir de:
								</td>
								<td nowrap>
									<select name="mesesProyeccion">
									<cfoutput query="qry_lista">
										<cfif LvarAuxAnoMes LTE CPCano*100+CPCmes>
										<option value="#CPCano#,#CPCmes#">#CPCano# #Mes#</option>
										</cfif>
									</cfoutput>
									</select>
										
								</td>
							</tr>
							<tr>
								<td colspan="2">&nbsp;
									
								</td>
							</tr>
							<tr>
								<td colspan="2" align="center">
								<input type="submit" name="btnProyectar" value="Proyectar"
									 onClick="
										if (document.form2.montoProyeccion.value == '')
											alert('Debe digitar el Monto o el Porcentaje a aumentar');
										else if (document.form2.mesesProyeccion.value == '')
											alert('Debe digitar el número de meses a Proyectar');
										else
											return true;
										return false;
											"
								>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</form>
<script language="javascript">
	function sbCalcular (ano, mes)
	{
		if (window.form2.btnAplicar) window.form2.btnAplicar.disabled = true;
		if (window.form2.btnAplicar_Variacion) window.form2.btnAplicar_Variacion.disabled = true;
		if (window.form2.btnProyectar) window.form2.btnProyectar.disabled = true;
	}
</script>


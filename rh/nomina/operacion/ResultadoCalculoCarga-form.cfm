<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="MSG_Informacion_de_Carga" Default="Informaci&oacute;n de Carga" returnvariable="MSG_Informacion_de_Carga" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Conceptos_a_Rebajar" Default="Conceptos a Rebajar" returnvariable="MSG_Conceptos_a_Rebajar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Otras_Rebajas" Default="Otras Rebajas" returnvariable="MSG_Otras_Rebajas" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_ConceptosDePagoPatronalesARebajarProvisiones" Default="Conceptos de Pago Patronales a Rebajar (Provisiones)" returnvariable="MSG_ConceptosDePagoPatronalesARebajarProvisiones" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Panorama_Mensual" Default="Panorama Mensual" returnvariable="MSG_Panorama_Mensual" component="sif.Componentes.Translate" method="Translate"/>

<!--- FIN VARIABLES DE TRADUCCION --->
<cfset checked = "<img src=''/cfmx/rh/imagenes/checked.gif'' border=''0''>">
<cfset unchecked = "<img src=''/cfmx/rh/imagenes/unchecked.gif'' border=''0''>">
<cfquery name="rsCargaCalculoEmpleado" datasource="#session.dsn#">
	select
		e.ECcodigo, e.ECdescripcion, case e.ECauto when 1 then '#checked#' else '#unchecked#' end as Ley,
		d.DCcodigo, d.DCdescripcion,
		coalesce(ce.CEvaloremp, d.DCvaloremp) as CEvaloremp,
		coalesce(ce.CEvalorpat, d.DCvalorpat) as CEvalorpat,
		coalesce(d.DCrangomax,0) as vTopeMax,
		coalesce(d.DCtiporango,0) as tipoRango,
		e.ECauto as cargadeley,
		case when d.DCmetodo = 1 then 'Porcentual' else 'Monto' end as metodo,
		cc.CCSalarioBaseEmpleado as SalarioBaseEmpleado,
		cc.CCSalarioBase as SalarioBasePatrono,
		cc.CCvaloremp as MontoEmpleado, cc.CCvalorpat as MontoPatrono,
		cc.CCSalarioBase - (select coalesce(sum(c.ICmontores),0.00)
												from DCargas a,
													DCTDeduccionExcluir b,
													IncidenciasCalculo c,
													CIncidentes ci
												where a.DClinea = cc.DClinea
													and b.DClinea = a.DClinea
													and c.RCNid = cc.RCNid
													and c.CIid = b.CIid
													and c.DEid = cc.DEid
													and ci.CIid = c.CIid
													and ci.CInocargas = 0
													and ci.CInocargasley = 0) as SalarioBExcep,
		cc.CCSalarioBaseEmpleado - (select coalesce(sum(c.ICmontores),0.00)
												from DCargas a,
													DCTDeduccionExcluir b,
													IncidenciasCalculo c,
													CIncidentes ci
												where a.DClinea = cc.DClinea
													and b.DClinea = a.DClinea
													and c.RCNid = cc.RCNid
													and c.CIid = b.CIid
													and c.DEid = cc.DEid
													and ci.CIid = c.CIid
													and ci.CInocargas = 0
													and ci.CInocargasley = 0) as SalarioBEmpleadoExcep
	from CargasCalculo cc
		inner join DCargas d
		on d.DClinea = cc.DClinea
		inner join ECargas e
		on e.ECid = d.ECid
		inner join CargasEmpleado ce
		on ce.DEid = cc.DEid
		and ce.DClinea = cc.DClinea
	where cc.DClinea=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DClinea#">	<!--- --- Detalle de carga --->
	  and cc.DEid	=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">		<!--- --- Empleado --->
	  and cc.RCNid	=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">		<!--- --- Relacion --->
</cfquery>

<!--- calcular salario bruto del empleado para nominas historicas, solo si el rango es mensual --->
<cfset vSalarioHistoria = 0 >
<cfif rsCargaCalculoEmpleado.tipoRango eq 2 >
	<cfquery name="rs_nomina" datasource="#session.DSN#">
		select CPperiodo, CPmes
		from CalendarioPagos
		where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">
	</cfquery>

	<cfquery name="rs_salariobruto" datasource="#session.DSN#"	>
		select sum(SEsalariobruto) as bruto
		from HSalarioEmpleado a, CalendarioPagos cp
		where a.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
		and cp.CPid=a.RCNid
		and cp.CPmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_nomina.CPmes#">
		and cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_nomina.CPperiodo#">
		and cp.CPtipo = 0
	</cfquery>
	<cfset vBruto = 0 >
	<cfif len(trim(rs_salariobruto.bruto))>
		<cfset vBruto = rs_salariobruto.bruto >
	</cfif>

	<!--- calcular incidencias que afectan cargas en nominas historicas --->
	<cfquery name="rs_incidencias" datasource="#session.DSN#">
		select sum(a.ICmontores) as incidencias
		from HIncidenciasCalculo a, HRCalculoNomina b, CalendarioPagos cp, CIncidentes ci
		where b.RCNid=a.RCNid
		and cp.CPid=b.RCNid
		and ci.CIid=a.CIid
		and cp.CPmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_nomina.CPmes#">
		and cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_nomina.CPperiodo#">
		and a.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
		and cp.CPtipo=0
		<cfif rsCargaCalculoEmpleado.cargadeley eq 1 >
			and ci.CInocargasley = 0	<!---cargadeley--->
		<cfelse>
			and ci.CInocargas = 0
		</cfif>
	<!--- falta poner que el concepto incidente no este en la tabl ad eexcepciones de carga--->
	</cfquery>
	<cfset vIncidencias = 0 >
	<cfif len(trim(rs_incidencias.incidencias))>
		<cfset vIncidencias = rs_incidencias.incidencias >
	</cfif>

	<!--- salario acumulado en la historia para el periodo y mes de nomina en proceso --->
	<cfset vSalarioHistoria = vBruto + vIncidencias >
</cfif>

<table width="97%" align="center" border="0" cellpadding="0" cellspacing="0">
<tr>
<td nowrap>
<cf_web_portlet_start titulo="#MSG_Informacion_de_Carga# #rsCargaCalculoEmpleado.ECcodigo#" tipo="normal">
		<table width="100%" align="center" border="0" cellpadding="0" cellspacing="0">
		<cfoutput query="rsCargaCalculoEmpleado">
			<tr>
			<td nowrap>
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td nowrap class="TituloListas"><strong><cf_translate key="LB_Carga">Carga</cf_translate></strong>:</td><td nowrap  class="TituloListas">#ECcodigo# #ECdescripcion#</td>
						<td nowrap  class="TituloListas"><strong><cf_translate key="LB_Ley">Ley</cf_translate>:</strong></td><td nowrap class="TituloListas">#Ley#</td>
					</tr>
				</table>
			</td>
			</tr>
			<tr>
				<td nowrap>
				<cf_web_portlet_start titulo="Detalle de Carga" tipo="box">
				<table width="100%" align="left" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td nowrap class="fileLabel">#DCcodigo# #DCdescripcion#</td>
						<td nowrap>&nbsp;</td>
						<td nowrap class="fileLabel"><cf_translate key="LB_Metodo">M&eacute;todo</cf_translate>:</td>
						<td nowrap>#metodo#</td>
					</tr>
					<tr>
						<td nowrap class="fileLabel"><cf_translate key="LB_Valor_Empleado">Valor Empleado</cf_translate>:</td>
						<td nowrap>#LSCurrencyFormat(CEvaloremp,'none')#</td>
						<td nowrap class="fileLabel"><cf_translate key="LB_Valor_Patrono">Valor Patrono</cf_translate>:</td>
						<td nowrap>#LSCurrencyFormat(CEvalorpat,'none')#</td>
					</tr>
					<tr>

					</tr>
				</table>
				<cf_web_portlet_end>
				</td>
			</tr>
			<tr>
				<td nowrap>
				<cfset vMontoPatronoE = round((SalarioBExcep * (CEvalorpat/100))*100)/100>
				<cfset vMontoEmpleadoE = round((SalarioBEmpleadoExcep * (CEvaloremp/100))*100)/100>

				<cfif vMontoEmpleadoE NEQ MontoEmpleado>
					<cfset SalarioBEmpleado = SalarioBaseEmpleado>
				<cfelse>
					<cfset SalarioBEmpleado = SalarioBEmpleadoExcep>
				</cfif>

				<cf_web_portlet_start titulo="Salarios/Monto" tipo="box">
					<table width="100%" align="left" border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td nowrap class="tituloListas">&nbsp;</td>
							<td nowrap align="right" class="tituloListas"><cf_translate key="LB_Empleado">Empleado</cf_translate></td>
							<td nowrap align="right" class="tituloListas"><cf_translate key="LB_Patrono">Patrono</cf_translate></td>
						</tr>
						<tr>
							<td nowrap class="fileLabel"><cf_translate key="LB_SalarioBase">Salario Base</cf_translate></td>
							<td nowrap align="right">#LSCurrencyFormat(SalarioBEmpleado,'none')#	<!--- #LSCurrencyFormat(SalarioBaseEmpleado,'none')# ---></td>
							<td nowrap align="right"><cfif vMontoPatronoE NEQ MontoPatrono>#LSCurrencyFormat(SalarioBasePatrono,'none')#<cfelse>#LSCurrencyFormat(SalarioBExcep,'none')#</cfif></td>
						</tr>
						<tr>
							<td nowrap class="fileLabel"><cf_translate key="LB_Monto_Carga">Monto Carga</cf_translate></td>
							<td nowrap align="right">#LSCurrencyFormat(MontoEmpleado,'none')#</td>
							<td nowrap align="right">#LSCurrencyFormat(MontoPatrono,'none')#</td>
						</tr>
					</table>
				<cf_web_portlet_end>
				</td>
			</tr>
		<tr>
		<td valign="top" align="center">

			<cfset vTopeMax = rsCargaCalculoEmpleado.vTopeMax>

			<!--- =0 : primer nomina del mes .Carol RS--->
			<cfif vSalarioHistoria EQ 0>
				<cfset vPendiente = SalarioBEmpleado>

			<!--- GT vTopeMax : ya se pago el maximo en carga permitido .Carol RS--->
			<cfelseif vSalarioHistoria GT vTopeMax>
				<cfset vPendiente = 0>

			<!--- Calcular el pendiente de cargas a pagar.Carol RS--->
			<cfelse>
				<cfset vPendiente = vTopeMax - vSalarioHistoria >
			</cfif>

			<cf_web_portlet_start titulo="#MSG_Panorama_Mensual#" tipo="mini">
				<table width="100%" align="left" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td nowrap class="tituloListas">&nbsp;</td>
					<td nowrap align="right" class="tituloListas" style="text-align:left"><cf_translate key="LB_Empleado">Empleado</cf_translate></td>
				</tr>
				<tr>
					<td nowrap class="fileLabel"><cf_translate key="LB_MonoPagadoMes">Monto Pagado Al Mes</cf_translate></td>
					<td nowrap>#LSCurrencyFormat(vSalarioHistoria,'none')#</td>
				</tr>
				<tr>
					<td nowrap class="fileLabel"><cf_translate key="LB_MonoPagadoMes">Monto Maximo Carga</cf_translate></td>
					<td nowrap>#LSCurrencyFormat(vTopeMax,'none')#</td>
				</tr>
				<tr>
					<td nowrap class="fileLabel"><cf_translate key="LB_MonoPagadoMes">Monto Afecta Carga</cf_translate></td>
					<td nowrap>#LSCurrencyFormat(vPendiente,'none')#</td>
				</tr>
				<tr>
					<td nowrap class="fileLabel"><cf_translate key="LB_MonoPagadoMes">Monto Carga</cf_translate></td>
					<td nowrap>#LSCurrencyFormat(MontoEmpleado,'none')#</td>
				</tr>
				</table>
			<cf_web_portlet_end>
		</td>
		</tr>
		</cfoutput>
		<tr>
		<td valign="top" align="center">
			<cf_web_portlet_start titulo="#MSG_Conceptos_a_Rebajar#" tipo="mini">
				<cfquery name="rsCargasRebajar" datasource="#session.dsn#">
						select dc2.DCcodigo, dc2.DCdescripcion, cc2.CCvaloremp, cc2.CCvalorpat, re.RHCRporc_pat, re.RHCRporc_emp
						from CargasCalculo
							inner join DCargas dc
							on dc.DClinea = CargasCalculo.DClinea

							inner join ECargas ec
							on ec.ECid = dc.ECid

							inner join RHCargasRebajar re
							on re.ECid = ec.ECid

							inner join DCargas dc2
							on dc2.ECid = re.ECidreb

							<!--- tuve que quitar el anidamiento porque da el error de que no puede unirse
							 con CargasCalculo porque no esta dentro del alcance. entonces mejor quite los
							 demas para que la lectura del query sea consistente.
							 --->
							inner join CargasCalculo cc2
							on cc2.DEid = CargasCalculo.DEid
							and cc2.RCNid = CargasCalculo.RCNid
							and cc2.DClinea = dc2.DClinea

						where CargasCalculo.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">
							and CargasCalculo.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
							and CargasCalculo.DClinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DClinea#">
							and CargasCalculo.CCSalarioBase > 0.00
						order by ec.ECprioridad desc
					</cfquery>
						<table width="100%" align="left" border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td nowrap class="TituloListas"><cf_translate key="LB_Codigo">C&oacute;digo</cf_translate></td>
							<td nowrap class="TituloListas"><cf_translate key="LB_Descripcion">Descripci&oacute;n</cf_translate></td>
							<td nowrap align="right" class="TituloListas"><cf_translate key="LB_Valor_Empleado_Rebajar">Valor Empleado Rebajar</cf_translate></td>
							<td nowrap align="right" class="TituloListas"><cf_translate key="LB_Porcentaje_Empleado_Aplicar">% Empleado Aplicar</cf_translate></td>
							<td nowrap align="right" class="TituloListas"><cf_translate key="LB_Valor_Patrono_Rebajar">Valor Patrono Rebajar</cf_translate></td>
							<td nowrap align="right" class="TituloListas"><cf_translate key="LB_Porcentaje_Patrono_Aplicar">% Patrono Aplicar</cf_translate></td>
						</tr>
						<cfif rsCargasRebajar.recordcount>
						<cfoutput query="rsCargasRebajar">
						<tr>
							<td nowrap>#DCcodigo#</td>
							<td nowrap>#DCdescripcion#</td>
							<td nowrap align="right">#LSCurrencyFormat(CCvaloremp,'none')#</td>
							<td nowrap align="right">#LSNumberFormat(RHCRporc_emp,'____.__')#</td>
							<td nowrap align="right">#LSCurrencyFormat(CCvalorpat,'none')#</td>
							<td nowrap align="right">#LSNumberFormat(RHCRporc_pat,'____.__')#</td>
						</tr>
						</cfoutput>
						<cfelse>
						<tr>
							<td colspan="6" align="center">--<cf_translate key="MSG_No_se_encontraron_registros">No se encontraron registros</cf_translate>--</td>
						</tr>
						</cfif>
						</table>
			<cf_web_portlet_end>
		</td>
		</tr>
		<tr>
		<td valign="top" align="center">
			<cf_web_portlet_start titulo="#MSG_Otras_Rebajas#" tipo="mini">
				<cfquery name="rsOtrasRebajas" datasource="#session.dsn#">
						select PEXTcodigo, PEXTdescripcion, PEXfechaPago, PEXmonto
						from CargasCalculo
							inner join DCargas dc
							on dc.DClinea = CargasCalculo.DClinea

							inner join ECargas ec
							on ec.ECid = dc.ECid

							inner join RHCargasRebajar re
							on re.ECid = ec.ECid

							inner join DCargas dc2
							on dc2.ECid = re.ECidreb

							inner join RHPagosExternosTipo pet
							on pet.DClinea = dc2.DClinea

							<!--- tuve que quitar el anidamiento porque da el error de que no puede unirse
							 con CargasCalculo porque no esta dentro del alcance. entonces mejor quite los
							 demas para que la lectura del query sea consistente.
							 --->
							inner join RHPagosExternosCalculo rhpe
							on rhpe.DEid = CargasCalculo.DEid
							and rhpe.RCNid = CargasCalculo.RCNid
							and rhpe.PEXTid = pet.PEXTid

						where CargasCalculo.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">
							and CargasCalculo.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
							and CargasCalculo.DClinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DClinea#">
							and CargasCalculo.CCSalarioBase > 0.00
						order by ec.ECprioridad desc
					</cfquery>
					<table width="100%" align="left" border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td nowrap class="TituloListas"><cf_translate key="LB_Codigo">C&oacute;digo</cf_translate></td>
							<td nowrap class="TituloListas"><cf_translate key="LB_Descripcion">Descripci&oacute;n</cf_translate></td>
							<td nowrap class="TituloListas"><cf_translate key="LB_Fecha">Fecha</cf_translate></td>
							<td nowrap class="TituloListas" align="right"><cf_translate key="LB_Monto">Monto</cf_translate></td>
						</tr>
						<cfif rsOtrasRebajas.recordcount>
						<cfoutput query="rsOtrasRebajas">
						<tr>
							<td nowrap>#PEXTcodigo#</td>
							<td nowrap>#PEXTdescripcion#</td>
							<td nowrap>#LSDateFormat(PEXfechaPago,'dd/mm/yyyy')#</td>
							<td nowrap align="right">#LSCurrencyFormat(PEXmonto,'none')#</td>
						</tr>
						</cfoutput>
						<cfelse>
						<tr>
							<td colspan="4" align="center">--<cf_translate key="MSG_No_se_encontraron_registros">No se encontraron registros</cf_translate>--</td>
						</tr>
						</cfif>
					</table>

			<cf_web_portlet_end>
		</td>
		</tr>
		<cfif vMontoPatronoE EQ rsCargaCalculoEmpleado.MontoPatrono>
			<cfquery name="rsConceptosP" datasource="#session.DSN#">
				select d.CIdescripcion, c.ICmontores, c.ICfecha
				from DCargas a
				inner join DCTDeduccionExcluir b
					on b.DClinea = a.DClinea
				inner join IncidenciasCalculo c
					on c.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">
					and c.CIid = b.CIid
					and c.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
				inner join CIncidentes d
					on c.CIid = d.CIid
				where a.DClinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DClinea#">
			</cfquery>
			<tr>
				<td>
					<cf_web_portlet_start titulo="#MSG_ConceptosDePagoPatronalesARebajarProvisiones#" tipo="mini">
						<table width="100%" align="left" border="0" cellpadding="0" cellspacing="0">
							<tr>
								<td nowrap class="TituloListas"><cf_translate key="LB_Fecha">Fecha</cf_translate></td>
								<td nowrap class="TituloListas"><cf_translate key="LB_Concepto">Concepto</cf_translate></td>
								<td nowrap class="TituloListas" align="right"><cf_translate key="LB_Monto">Monto</cf_translate></td>
							</tr>
							<cfif rsConceptosP.RecordCount>
								<cfoutput query="rsConceptosP">
								<tr>
									<td nowrap>#LSDateFormat(	ICfecha,'dd/mm/yyyy')#</td>
									<td nowrap>#CIdescripcion#</td>
									<td nowrap align="right">#LSCurrencyFormat(ICmontores,'none')#</td>
								</tr>
								</cfoutput>
							</cfif>
						</table>
					<cf_web_portlet_end>
				</td>
			</tr>
		</cfif>
	</table>
<cf_web_portlet_end>
</td>
</tr>
</table>

<style type="text/css">
	.topline {
		border-top-width: 1px;
		border-top-style: solid;
		border-right-style: none;
		border-bottom-style: none;
		border-left-style: none;
		border-top-color: #CCCCCC;
	}
	.bottomline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-right-style: none;
		border-top-style: none;
		border-left-style: none;
		border-bottom-color: #CCCCCC;
	}
</style>
<cfif isdefined("url.CPid") and not isdefined("form.CPid")>
	<cfset form.CPid = url.CPid >
</cfif>
<cfif isdefined("url.Tcodigo") and not isdefined("form.Tcodigo")>
	<cfset form.Tcodigo = url.Tcodigo >
</cfif>
<cfif isdefined("url.CPdescripcion") and not isdefined("form.CPdescripcion")>
	<cfset form.CPdescripcion = url.CPdescripcion >
</cfif>
 <cfinclude template="../../Utiles/sifConcat.cfm">
 <cfquery name="rsRHExcluirDeduccion" datasource="#session.DSN#">
	select c.Dmonto as Total,  c.Dsaldo as Saldo, c.Dfechaini, c.Dreferencia,
		a.PPprincipal + a.PPinteres as Cuota, 
		a.PPprincipal, a.PPinteres,
		d.DEidentificacion, d.DEapellido1 #_Cat# '  ' #_Cat# d.DEapellido2 #_Cat#  ' , '  #_Cat# d.DEnombre as nombre, d.Tcodigo,
		e.TDdescripcion
	from DeduccionesEmpleadoPlan a
	  inner join CalendarioPagos b
		on <cf_dbfunction name="to_date00"	args="a.PPfecha_pago"> between <cf_dbfunction name="to_date00"	args="b.CPdesde"> and <cf_dbfunction name="to_date00"	args="b.CPhasta">
	  inner join  DeduccionesEmpleado c
		on a.Did = c.Did
	  inner join DatosEmpleado d
		on c.DEid = d.DEid
	  inner join TDeduccion e
		on   e.TDid = c.TDid
		and e.Ecodigo = c.Ecodigo
	where a.Ecodigo =  #Session.Ecodigo# 
	  and b.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
	  and a.PPfecha_pago is not null
	  and a.DEPextraordinario = 0
	order by e.TDcodigo, d.DEidentificacion, c.Dreferencia
</cfquery>

<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion from Empresas
 	where Ecodigo =  #Session.Ecodigo# 
</cfquery>

<cfquery name="rsTiposNomina" datasource="#Session.DSN#">
	select Tdescripcion
	from TiposNomina
	where Ecodigo =  #Session.Ecodigo# 
	  and ltrim(rtrim(Tcodigo))  = rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Tcodigo#">))
</cfquery>
<cfif isdefined("rsTiposNomina") and rsTiposNomina.RecordCount NEQ 0>
	<cfset TipoNom = rsTiposNomina.Tdescripcion >
<cfelse>
	<cfset TipoNom = 'No definida'>
</cfif>
<SCRIPT src="/cfmx/sif/js/utilesMonto.js"></SCRIPT>
<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");

	function Lista() {
		history.back();
	}
	//-->
</SCRIPT>

<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
		<tr>
		<cfif  isdefined("rsRHExcluirDeduccion") and rsRHExcluirDeduccion.recordCount eq 0>
			<td align="center"><h2><strong>No existen registros para esta busqueda.</strong></h2></td>
		<cfelse>
			<td>
			<table width="100%" border="0" cellpadding="0" cellspacing="0" align="center">
				<tr> 
					<td colspan="8" align="right">
						Fecha: #LSDateFormat(Now(),"dd/mm/yyyy")#
					</td>
				</tr>
			<cfif isdefined("rsEmpresa") and (rsEmpresa.RecordCount EQ 1)>
				<tr>
					<td colspan="8" align="center"><font size="5">
							<strong>#rsEmpresa.Edescripcion#</strong>
					</font></td>
				</tr>
			</cfif>
				<tr> 
      				<td colspan="8" align="center">
						<font size="4"><strong>
						Rebajos Aplicados
						</strong></font>
					</td>
				</tr>
				<tr> <!--- donde --->
					<td colspan="8" align="center"><font size="2">
						<strong>Tipo de Nomina:</strong>#TipoNom#
						<strong>#Form.CPdescripcion#</strong></font>
					</td>
				</tr>
				<cfset TipoDeduc = ''>
				<!--- totales por empleado--->
				<cfset vMontoTotal   = 0 >
				<cfset vMontoPagado1 = 0 >
				<cfset vMontoPagado2 = 0 >
				<cfset vSaldo        = 0 >
			
				<!--- totales generales --->
				<cfset vMontoTotalGeneral   = 0 >
				<cfset vMontoPagadoGeneral1 = 0 >
				<cfset vMontoPagadoGeneral2 = 0 >
				<cfset vSaldoGeneral        = 0 >
				<cfloop query="rsRHExcluirDeduccion">
					<cfif TipoDeduc NEQ rsRHExcluirDeduccion.TDdescripcion >
						<cfif rsRHExcluirDeduccion.CurrentRow neq 1>
							<tr>
								<td class="topLine"><strong>Total</strong></td>
								<td class="topLine" colspan="4" align="right"><strong>#LSNumberFormat(vMontoTotal,',9.00')#</strong></td>
								<td class="topLine" align="right"><strong>#LSNumberFormat(vMontoPagado1,',9.00')#</strong></td>
								<td class="topLine" align="right"><strong>#LSNumberFormat(vMontoPagado2,',9.00')#</strong></td>
								<td class="topLine" align="right"><strong>#LSNumberFormat(vSaldo,',9.00')#</strong></td>
							</tr>
							<tr><td colspan="8">&nbsp;</td></tr>
						</cfif>
						<tr><td colspan="8">&nbsp;</td></tr>
						<tr><td colspan="8" align="left"><font size="2"><em><strong>#rsRHExcluirDeduccion.TDdescripcion#</strong></em></font></td></tr>
						<tr>
							<td class="tituloListas"><div align="left">Identificaci&oacute;n</div></td>
							<td class="tituloListas"><div align="left">Empleado</div></td>
							<td class="tituloListas" nowrap><div align="left">Documento</div></td>
							<td class="tituloListas"><div align="right">Fecha Inicio Deduc</div></td>
							<td class="tituloListas" nowrap><div align="right">Monto Total</div></td>
							<td class="tituloListas" nowrap><div align="right">Amortizaci&oacute;n</div></td>
							<td class="tituloListas" nowrap><div align="right">Inter&eacute;s</div></td>
							<td class="tituloListas" nowrap><div align="right">Saldo</div></td>
						</tr>
						<cfset TipoDeduc = rsRHExcluirDeduccion.TDdescripcion>
						<!--- totales por empleado--->
						<cfset vMontoTotal   = 0 >
						<cfset vMontoPagado1 = 0 >
						<cfset vMontoPagado2 = 0 >
						<cfset vSaldo        = 0 >
					</cfif>
					<tr>
						<td> <div align="left">#rsRHExcluirDeduccion.DEidentificacion#</div></td>
						<td ><div align="left">#rsRHExcluirDeduccion.nombre#</div></td>
						<td nowrap><div align="left">#rsRHExcluirDeduccion.Dreferencia#</div></td>
						<td ><div align="right">#LSDateFormat(rsRHExcluirDeduccion.Dfechaini,"dd/mm/yyyy")#</div></td>
						<td nowrap><div align="right">#LSNumberFormat(rsRHExcluirDeduccion.Total,',9.00')#</div></td>
						<td nowrap><div align="right">#LSNumberFormat(rsRHExcluirDeduccion.PPprincipal,',9.00')#</div></td>
						<td nowrap><div align="right">#LSNumberFormat(rsRHExcluirDeduccion.PPinteres,',9.00')#</div></td>
						<td nowrap><div align="right">#LSNumberFormat(rsRHExcluirDeduccion.Saldo,',9.00')#</div></td>
					</tr>
					<!--- totales por empleado --->
					<cfset vMontoTotal  = vMontoTotal + rsRHExcluirDeduccion.Total >
					<cfset vMontoPagado1 = vMontoPagado1 + rsRHExcluirDeduccion.PPprincipal >
					<cfset vMontoPagado2 = vMontoPagado2 + rsRHExcluirDeduccion.PPinteres >
					<cfset vSaldo = vSaldo + rsRHExcluirDeduccion.Saldo >
			
					<!--- totales generales --->
					<cfset vMontoTotalGeneral   = vMontoTotalGeneral + rsRHExcluirDeduccion.Total>
					<cfset vMontoPagadoGeneral1 = vMontoPagadoGeneral1 + rsRHExcluirDeduccion.PPprincipal>
					<cfset vMontoPagadoGeneral2 = vMontoPagadoGeneral2 + rsRHExcluirDeduccion.PPinteres>
					<cfset vSaldoGeneral        = vSaldoGeneral + rsRHExcluirDeduccion.Saldo>
				</cfloop>
				<!--- pinta el ultimo total --->
				<tr>
					<td class="topLine"><strong>Total</strong></td>
					<td class="topLine" colspan="4" align="right" nowrap><strong>#LSNumberFormat(vMontoTotal,',9.00')#</strong></td>
					<td class="topLine" align="right" nowrap><strong>#LSNumberFormat(vMontoPagado1,',9.00')#</strong></td>
					<td class="topLine" align="right" nowrap><strong>#LSNumberFormat(vMontoPagado2,',9.00')#</strong></td>
					<td class="topLine" align="right" nowrap><strong>#LSNumberFormat(vSaldo,',9.00')#</strong></td>
				</tr>
		
				<!--- Total general --->
				<tr><td colspan="8">&nbsp;</td></tr>
				<tr><td colspan="8">&nbsp;</td></tr>
				<tr>
					<td class="topLine"><strong>Totales generales</strong></td>
					<td class="topLine" colspan="4" align="right"><strong>#LSNumberFormat(vMontoTotalGeneral,',9.00')#</strong></td>
					<td class="topLine" align="right"><strong>#LSNumberFormat(vMontoPagadoGeneral1,',9.00')#</strong></td>
					<td class="topLine" align="right"><strong>#LSNumberFormat(vMontoPagadoGeneral2,',9.00')#</strong></td>
					<td class="topLine" align="right"><strong>#LSNumberFormat(vSaldoGeneral,',9.00')#</strong></td>
				</tr>
			</table>
			</td>
		</tr>
		</cfif>
		<cfif isdefined('url.imprimir')>
			<tr> 
				<td colspan="8" align="center">
					<strong>
					------------------------------
					Fin del Reporte
					--------------------------------------
					</strong>
					&nbsp;
				</td>
			</tr>
		<cfelse>
			<tr><td colspan="8">&nbsp;</td></tr>
			<tr><td colspan="8">&nbsp;</td></tr>
			<tr> 
				<td colspan="8" align="center">
					<input type="button" name="Regresar" value="Regresar" tabindex="1" onClick="javascript:Lista();">
				</td>
			</tr>								
		</cfif>
	</table>
</cfoutput>	
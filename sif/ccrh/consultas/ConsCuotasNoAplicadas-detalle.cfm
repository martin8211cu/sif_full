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
	select   c.Dmonto as Total,  c.Dmonto - c.Dsaldo as Saldo, c.Dfechaini, c.Dreferencia,
		a.PPprincipal + a.PPinteres as Cuota, 
		d.DEidentificacion, d.DEapellido1 #_Cat# '  ' #_Cat# d.DEapellido2 #_Cat#  ' , '  #_Cat# d.DEnombre as nombre, d.Tcodigo,
		e.TDdescripcion   , a.Did, a.PPnumero 
	from DeduccionesEmpleadoPlan a
		
		inner join BDeduccionesEmpleadoPlan z
		on z.Did = a.Did
		and z.PPnumero = a.PPnumero 
			
		inner join  DeduccionesEmpleado c
		on a.Did = c.Did
	  	
		inner join DatosEmpleado d
		on c.DEid = d.DEid
	  	
		inner join TDeduccion e
		on   e.TDid = c.TDid
		and e.Ecodigo = c.Ecodigo
	
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  	and z.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#"> 
		and z.PPnumero = (select min(PPnumero) from  BDeduccionesEmpleadoPlan x where x.Did = z.Did)

	order by e.TDcodigo, d.DEidentificacion, c.Dreferencia, z.BMfecha
</cfquery>


<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion from Empresas
 	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cfquery name="rsTiposNomina" datasource="#Session.DSN#">
	select Tdescripcion
	from TiposNomina
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
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
	
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
		<tr>
			<td>
		<cfif  isdefined("rsRHExcluirDeduccion") and rsRHExcluirDeduccion.recordCount eq 0>
			<td align="center" ><h2><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">No existen registros para esta busqueda.</strong></h2></td>
		<cfelse>
			<table width="100%" border="0" cellpadding="0" cellspacing="0" align="center">
				<tr> 
					<td colspan="8" align="right">
						<cfoutput>Fecha: #LSDateFormat(Now(),"dd/mm/yyyy")#</cfoutput>
					</td>
				</tr>

			<cfif isdefined("rsEmpresa") and (rsEmpresa.RecordCount EQ 1)>
				<tr>
					<td colspan="8" align="center"><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">
							<strong><cfoutput>#rsEmpresa.Edescripcion#</cfoutput></strong>
					</td>
				</tr>
			</cfif>
				<tr> 
      				<td colspan="8" align="center">
						<strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">
						Cuotas no Pagadas por N&oacute;mina
						</strong>
					</td>
				</tr>
				<tr> <!--- donde --->
					<td colspan="8" align="center"><font size="2">
						<strong><cfoutput>Tipo de Nomina: </cfoutput></strong><cfoutput>#TipoNom#</cfoutput>
						<strong><cfoutput>#Form.CPdescripcion#</cfoutput></strong></font>
					</td>
				</tr>
				<cfset TipoDeduc = ''>
				<!--- totales por empleado--->
				<cfset vMontoTotal  = 0 >
				<cfset vMontoPagado = 0 >
				<cfset vSaldo       = 0 >
			
				<!--- totales generales --->
				<cfset vMontoTotalGeneral  = 0 >
				<cfset vMontoPagadoGeneral = 0 >
				<cfset vSaldoGeneral       = 0 >
				<cfoutput query="rsRHExcluirDeduccion">
					<cfif TipoDeduc NEQ rsRHExcluirDeduccion.TDdescripcion >
						<cfif rsRHExcluirDeduccion.CurrentRow neq 1>
							<tr>
								<td class="topLine"><strong>Total</strong></td>
								<td class="topLine" colspan="4" align="right"><strong>#LSNumberFormat(vMontoTotal,',9.00')#</strong></td>
								<td class="topLine" align="right"><strong>#LSNumberFormat(vMontoPagado,',9.00')#</strong></td>
								<td class="topLine" align="right"><strong>#LSNumberFormat(vSaldo,',9.00')#</strong></td>
							</tr>
							<tr><td>&nbsp;</td></tr>
							<tr><td>&nbsp;</td></tr>
						</cfif>
						<tr><td colspan="8">&nbsp;</td></tr>
						<tr><td colspan="8">&nbsp;</td></tr>
						<tr><td colspan="8" align="left"><font size="2"><em><strong>#rsRHExcluirDeduccion.TDdescripcion#</strong></em></font></td></tr>
						<tr>
								<td class="tituloListas"><div align="left">Identificaci&oacute;n</div></td>
								<td class="tituloListas"><div align="left">Empleado</div></td>
							
								<td class="tituloListas" nowrap><div align="left">Documento</div></td>
								<td class="tituloListas"><div align="right">Fecha Inicio Deduc</div></td>
								<td class="tituloListas" nowrap><div align="right">Monto Total</div></td>
								<td class="tituloListas" nowrap><div align="right">Monto Cuota</div></td>
								<td class="tituloListas" nowrap colspan="2"><div align="right">Saldo</div></td>

						</tr>
						<cfset TipoDeduc = rsRHExcluirDeduccion.TDdescripcion>
						<!--- totales por empleado--->
						<cfset vMontoTotal  = 0 >
						<cfset vMontoPagado = 0 >
						<cfset vSaldo       = 0 >
					</cfif>
					<tr>
						<td> <div align="left">#rsRHExcluirDeduccion.DEidentificacion#</div></td>
						<td ><div align="left">#rsRHExcluirDeduccion.nombre#</div></td>
						<td nowrap><div align="left">#rsRHExcluirDeduccion.Dreferencia#</div></td>
						<td ><div align="right">#LSDateFormat(rsRHExcluirDeduccion.Dfechaini,"dd/mm/yyyy")#</div></td>
						<td nowrap><div align="right">#LSNumberFormat(rsRHExcluirDeduccion.Total,',9.00')#</div></td>
						<td nowrap><div align="right">#LSNumberFormat(rsRHExcluirDeduccion.Cuota,',9.00')#</div></td>
						<td nowrap colspan="2"><div align="right">#LSNumberFormat(rsRHExcluirDeduccion.Saldo,',9.00')#</div></td>
					</tr>
					<!--- totales por empleado --->
					<cfset vMontoTotal  = vMontoTotal + rsRHExcluirDeduccion.Total >
					<cfset vMontoPagado = vMontoPagado + rsRHExcluirDeduccion.Cuota >
					<cfset vSaldo = vSaldo + rsRHExcluirDeduccion.Saldo >
			
					<!--- totales generales --->
					<cfset vMontoTotalGeneral  = vMontoTotalGeneral + rsRHExcluirDeduccion.Total>
					<cfset vMontoPagadoGeneral = vMontoPagadoGeneral + rsRHExcluirDeduccion.Cuota>
					<cfset vSaldoGeneral       = vSaldoGeneral + rsRHExcluirDeduccion.Saldo>
				</cfoutput>
				<cfoutput>
					<!--- pinta el ultimo total --->
					<tr>
						<td class="topLine"><strong>Total</strong></td>
						<td class="topLine" colspan="4" align="right" nowrap><strong>#LSNumberFormat(vMontoTotal,',9.00')#</strong></td>
						<td class="topLine" align="right" nowrap><strong>#LSNumberFormat(vMontoPagado,',9.00')#</strong></td>
						<td class="topLine" align="right" nowrap><strong>#LSNumberFormat(vSaldo,',9.00')#</strong></td>
					</tr>
			
					<!--- Total general --->
					<tr><td>&nbsp;</td></tr>
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td class="topLine"><strong>Totales generales</strong></td>
						<td class="topLine" colspan="4" align="right"><strong>#LSNumberFormat(vMontoTotalGeneral,',9.00')#</strong></td>
						<td class="topLine" align="right"><strong>#LSNumberFormat(vMontoPagadoGeneral,',9.00')#</strong></td>
						<td class="topLine" align="right"><strong>#LSNumberFormat(vSaldoGeneral,',9.00')#</strong></td>
					</tr>
				</cfoutput>
			</table>
			</cfif>
			<cfif isdefined('url.imprimir')>
				<tr > 
					<td colspan="2" align="center">
						<strong>
						------------------------------
						Fin del Reporte
						--------------------------------------
						</strong>	&nbsp;
					</td>
				</tr>
			<cfelse>
				<tr><td colspan="2">&nbsp;</td></tr>
				<tr><td colspan="2">&nbsp;</td></tr>
				<tr> 
					<td colspan="2" align="center">
						<input type="button" name="Regresar" value="Regresar" tabindex="1" onClick="javascript:Lista();">
					</td>
				</tr>								
			</cfif>
		</td>
	</tr>
</table>
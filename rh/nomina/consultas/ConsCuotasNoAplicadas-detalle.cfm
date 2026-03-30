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


 <cfquery name="rsRHExcluirDeduccion" datasource="#session.DSN#">
 	select distinct e.Tcodigo,
	f.TDdescripcion, d.Dreferencia, 
	d.Dfechaini, d.Dmonto, d.Dsaldo, d.Dmonto - d.Dsaldo as Dmontopagado,
	c.PPpagoprincipal, c.PPpagointeres, c.PPdocumento,
	e.DEidentificacion, e.DEapellido1 || '  ' || e.DEapellido2 ||  ' , '  || e.DEnombre as nombre
	  from HRCalculoNomina a 
		inner join  HSalarioEmpleado b
		  on a.RCNid = b.RCNid
		inner join   DeduccionesEmpleado d
		  on b.DEid = d.DEid
	   	inner join RHExcluirDeduccion g
		  on g.TDid = d.TDid
		inner join TDeduccion f
		  on f.TDid = d.TDid
		  and f.Ecodigo = d.Ecodigo
		inner join DatosEmpleado e
		  on d.DEid = e.DEid
	   	inner join  DeduccionesEmpleadoPlan c
		  on c.Did = d.Did
	      --  and a.RChasta =  c.PPfecha_vence
		  --  and c.PPpagado = 0
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and g.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
			and d.Dsaldo > 0
		order by f.TDcodigo, e.DEidentificacion, d.Dreferencia
</cfquery>
<!--- <cfif isdefined("rsRHExcluirDeduccion")>
	<cfdump var="#rsRHExcluirDeduccion#">
	<cfabort>
</cfif> --->

<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion from Empresas
 	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cfquery name="rsTiposNomina" datasource="#Session.DSN#">
	select Tdescripcion
	from TiposNomina
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and ltrim(rtrim(Tcodigo))  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Tcodigo#">
</cfquery>
<cfif isdefined("rsTiposNomina") and rsTiposNomina.RecordCount NEQ 0>
	<cfset TipoNom = rsTiposNomina.Tdescripcion >
<cfelse>
	<cfset TipoNom = 'No definida'>
</cfif>
<SCRIPT src="/cfmx/rh/js/utilesMonto.js"></SCRIPT>
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
			<td align="center"><h2><strong>No existen registros para esta busqueda.</strong></h2></td>
		<cfelse>
			<table width="100%" border="0" cellpadding="0" cellspacing="0" align="center">
				<tr> 
					<td colspan="8" align="right">
						<cfoutput>Fecha: #LSDateFormat(Now(),"dd/mm/yyyy")#</cfoutput>
					</td>
				</tr>

			<cfif isdefined("rsEmpresa") and (rsEmpresa.RecordCount EQ 1)>
				<tr>
					<td colspan="8" align="center"><font size="5">
							<strong style="font-family:'Times New Roman', Times, serif; font-size:14pt; font-variant:small-caps; font-weight:bolder; padding-left:20px"><cfoutput>#rsEmpresa.Edescripcion#</cfoutput></strong>
					</font></td>
				</tr>
			</cfif>
				<tr> 
      				<td colspan="8" align="center" >
						<strong style="font-family:'Times New Roman', Times, serif; font-size:14pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">
							Cuotas no Aplicadas por N&oacute;mina
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
					</cfif>
					<tr>
						<td> <div align="left">#rsRHExcluirDeduccion.DEidentificacion#</div></td>
						<td ><div align="left">#rsRHExcluirDeduccion.nombre#</div></td>
						<td nowrap><div align="left">#rsRHExcluirDeduccion.Dreferencia#</div></td>
						<td ><div align="right">#LSDateFormat(rsRHExcluirDeduccion.Dfechaini,"dd/mm/yyyy")#</div></td>
						<td nowrap><div align="right">#LSNumberFormat(rsRHExcluirDeduccion.Dmonto,',9.00')#</div></td>
						<td nowrap><div align="right">#LSNumberFormat(rsRHExcluirDeduccion.Dmontopagado,',9.00')#</div></td>
						<td nowrap nowrap colspan="2"><div align="right">#LSNumberFormat(rsRHExcluirDeduccion.Dsaldo,',9.00')#</div></td>
					</tr>
					<!--- totales por empleado --->
					<cfset vMontoTotal  = vMontoTotal + rsRHExcluirDeduccion.Dmonto >
					<cfset vMontoPagado = vMontoPagado + rsRHExcluirDeduccion.Dmontopagado >
					<cfset vSaldo = vSaldo + rsRHExcluirDeduccion.Dsaldo >
			
					<!--- totales generales --->
					<cfset vMontoTotalGeneral  = vMontoTotalGeneral + rsRHExcluirDeduccion.Dmonto>
					<cfset vMontoPagadoGeneral = vMontoPagadoGeneral + rsRHExcluirDeduccion.Dmontopagado>
					<cfset vSaldoGeneral       = vSaldoGeneral + rsRHExcluirDeduccion.Dsaldo>
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
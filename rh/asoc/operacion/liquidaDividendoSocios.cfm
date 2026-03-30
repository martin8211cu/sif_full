<!---=============== TRADUCCION =================--->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Liquidar"
	Default="Distribuir excedentes"
	returnvariable="BTN_Liquidar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_LiquidacionDividendos"
	Default="Liquidaci&oacute;n de Dividendos"
	returnvariable="LB_LiquidacionDividendos"/>
<cfinvoke component="sif.Componentes.TranslateDB"
	method="Translate"
	VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
	Default="Distribuci&oacute;n de Excedentes Solidaristas"
	VSgrupo="103"
	returnvariable="nombre_proceso"/>
<!---===========================================---->	

<SCRIPT src="/cfmx/rh/js/utilesMonto.js"></SCRIPT>	

<!--- query para determinar el periodo, que en el orden sigue por aplicar --->
<cfquery name="rs_periodo" datasource="#session.DSN#">
	select min(ACDDEperiodo) as periodo
	from ACDistribucionDividendosE
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and ACDDEestado in (0, 1)
</cfquery>
<cfif len(trim(rs_periodo.periodo)) eq 0>
	<cfquery name="rs_periodo" datasource="#session.DSN#">
		select Pvalor as periodo
		from ACParametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Pcodigo = 10
	</cfquery>
</cfif>

<!--- query para determinar si ya se realizo el calculo --->
<cfquery name="rs_calculado" datasource="#session.DSN#">
	select count(1) as total
	from ACDistribucionDividendosE a, ACDistribucionDividendos b
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and a.ACDDEperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rs_periodo.periodo#">
	  and b.Ecodigo = a.Ecodigo
	  and b.ACDDEperiodo = a.ACDDEperiodo
</cfquery>
<cfif rs_calculado.total gt 0 >
	<cflocation url="liquidaDividendoSocios-listado.cfm?periodo=#rs_periodo.periodo#">
</cfif>

<cf_templateheader title="Recursos Humanos">
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td valign="top">
				<cfoutput>
				<cf_web_portlet_start titulo="#nombre_proceso#">
					<cfinclude template="/rh/portlets/pNavegacion.cfm">
					<form name="form1" method="url" action="liquidaDividendoSocios-sql.cfm" onsubmit="javascript: return validar();">
						<table width="98%" border="0" cellspacing="0" cellpadding="3" align="center">
							<tr>
								<td width="45%" align="center">
									<table width="30%" align="center" border="0" cellpadding="2" cellspacing="0" >
										<tr><td colspan="2" align="center" nowrap="nowrap"><strong>Proceso de Distribuci&oacute;n de Excedentes Solidaristas</strong></td></tr>
										<tr>
											<td nowrap="nowrap" width="10%" ><strong>Per&iacute;odo:</strong></td>
											<td> #rs_periodo.periodo#</td>
										</tr>
										<tr><td colspan="2" nowrap="nowrap" ><strong>Digite el monto correspondiente a excedentes:</strong></td></tr>
										<tr>
											<td colspan="2">
												<input type="text" name="monto" value="" onfocus="this.value=qf(this); this.select();" onblur="javascript: fm(this,2);"  onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;">
											</td>	
										</tr>
										<tr>
											<td colspan="2" align="center" >
												<input type="submit" class="btnAplicar" name="liquidar" value="#BTN_Liquidar#">
												<input type="hidden" name="periodo" value="#rs_periodo.periodo#">
											</td>									
										</tr>
									</table>
								</td>								
							</tr>
						</table>
					</form>
				<cf_web_portlet_end>
				</cfoutput>
			</td>	
		</tr>
	</table>	
	<script type="text/javascript" language="javascript1.2">
		function validar(){
			var msj = 'Se presentaron los siguientes errores:\n';
			if ( document.form1.monto.value == '' ){
				alert(msj + ' - El monto por distribuir es requerido.');
				return false;
			}

			if ( parseFloat(qf(document.form1.monto.value)) == 0 ){
				alert(msj + ' - El monto por distribuir debe ser mayor a cero.');
				return false;				
			}
			return true;
		}
	</script>
<cf_templatefooter>





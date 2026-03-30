<!---
		Creado por: Miguel González (APH)
		Fecha: 24-Enero-2018.
		Tipo: Nuevo reporte pintado en HTML.
		Solicitado por: Marcos Diaz (Funcional) para Cliente Proconsa
 --->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_Titulo 	= t.Translate('LB_Titulo','Pron&oacute;stico de Pagos','/sif/rptPronosticosPagos.xml')>
<cfset LB_SocioNegocioDesde = t.Translate('LB_Socio_de_Negocio_Desde','Socio de Negocio Desde','/sif/rptPronosticosPagos.xml')>
<cfset LB_SocioNegocioHasta = t.Translate('LB_SocioNegocioHasta','Socio de Negocio Hasta','/sif/rptPronosticosPagos.xml')>
<cfset LB_Moneda = t.Translate('LB_Moneda','Moneda','/sif/rptPronosticosPagos.xml')>
<cfset LB_Periodo = t.Translate('LB_Periodo','Periodo','/sif/rptPronosticosPagos.xml')>
<cfset LB_SemanasNat = t.Translate('LB_SemanasNat','Semanas naturales','/sif/rptPronosticosPagos.xml')>
<cfset LB_SInicial = t.Translate('LB_SInicial','Semana Inicial','/sif/rptPronosticosPagos.xml')>
<cfset LB_SFinal = t.Translate('LB_SFinal','Semana Final','/sif/rptPronosticosPagos.xml')>
<cfset LB_DetalleDocs = t.Translate('LB_DetalleDocs','Mostrar documentos','/sif/rptPronosticosPagos.xml')>
<cfset LB_Transaccion = t.Translate('LB_Transaccion','Transacci&oacute;n','/sif/rptPronosticosPagos.xml')>
<cfset LB_SaldosResumidos = t.Translate('LB_SaldosResumidos','Saldos Vencidos','/sif/rptPronosticosPagos.xml')>
<cfset LB_Detalle = t.Translate('LB_Detalle','Detallado','/sif/rptPronosticosPagos.xml')>

<!--- SEMANA ACTUAL --->
<cfset lVarSemanaActual = WEEK(NOW())>

<!--- Se obtienen Monedas --->
<cfquery name="rsGetMonedas" datasource="#session.DSN#">
	SELECT Mcodigo, Mnombre
	FROM Monedas
	WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<!--- Obtiene las transacciones de CxP --->
<cfquery name="rsGetTransacciones" datasource="#session.DSN#">
	SELECT RTRIM(LTRIM(COALESCE(CPTcodigo, ''))) AS CPTcodigo,
	       RTRIM(LTRIM(COALESCE(CPTdescripcion, ''))) AS CPTdescripcion
	FROM CPTransacciones
	WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  AND CPTtipo = 'C'
	ORDER BY CPTcodigo
</cfquery>

<cf_templateheader title="#LB_Titulo#">
	<cf_web_portlet_start _start titulo="#LB_Titulo#">
		<cfoutput>
			<form name="form1" id="form1" method="post" action="rptPronosticosPagos_sql.cfm">
				<table width="60%" cellpadding="2" cellspacing="0" border="0" align="center">
					<tr><td colspan="3">&nbsp;</td></tr>
					<tr>
						<td nowrap align="right" width="35%"><strong>#LB_SocioNegocioDesde#:&nbsp;</strong></td>
						<td colspan="3" width="20%">
							<cfif isdefined("form.SNcodigo1") and len(trim(form.SNcodigo1))>
								<cf_sifsociosnegocios2 Proveedores="SI" SNcodigo="SNcodigo1" SNnombre="SNnombre1" SNnumero="SNnumero1" tabindex="1" idquery="#form.SNcodigo1#">
							<cfelse>
								<cf_sifsociosnegocios2 Proveedores="SI" SNcodigo="SNcodigo1" SNnombre="SNnombre1" SNnumero="SNnumero1" tabindex="1">
							</cfif>
						</td>
						<td rowspan="6" width="35%" align="right">&nbsp;&nbsp;<input class="btnGuardar" name="btnGenerar" type="button" id="btnGenerar"onclick="validaFiltro();" value="Generar">&nbsp;</td>
					</tr>
					<tr>
						<td nowrap align="right" width="35%"><strong>#LB_SocioNegocioHasta#:&nbsp;</strong></td>
						<td colspan="3">
							<cfif isdefined("form.SNcodigo2") and len(trim(form.SNcodigo2))>
								<cf_sifsociosnegocios2 Proveedores="SI" SNcodigo="SNcodigo2" SNnombre="SNnombre2" SNnumero="SNnumero2" tabindex="1" idquery="#form.SNcodigo2#">
							<cfelse>
								<cf_sifsociosnegocios2 Proveedores="SI" SNcodigo="SNcodigo2" SNnombre="SNnombre2" SNnumero="SNnumero2" tabindex="1">
							</cfif>
						</td>
					</tr>
					<tr>
						<td align="right"><strong>#LB_Transaccion#:&nbsp;</strong></td>
						  <td align="left">
							  <select id="cboTransaccion" name="cboTransaccion" default="-1">
								  <option value="-1">--- Seleccione ---</option>
								  <cfloop query="#rsGetTransacciones#">
									  <cfoutput>
										  <cfif isDefined("form.cboTransaccion") AND #form.cboTransaccion# eq #rsGetTransacciones.CPTcodigo#>
											  <option value="#rsGetTransacciones.CPTcodigo#" selected="true">#rsGetTransacciones.CPTcodigo# - #rsGetTransacciones.CPTdescripcion#</option>
										  <cfelse>
										  	  <option value="#rsGetTransacciones.CPTcodigo#">#rsGetTransacciones.CPTcodigo# - #rsGetTransacciones.CPTdescripcion#</option>
										  </cfif>
								      </cfoutput>
								  </cfloop>
							  </select>
	                      </td>
					</tr>
					<tr>
						<td nowrap align="right" width="35%"><strong>#LB_SInicial#:&nbsp;</strong></td>
						<td>
							<select id="cboSInicial" name="cboSInicial" default="-1">
								<option value="-1">--- Seleccione ---</option>
								<cfloop from="1" to="54" index="i" step="1">
									<cfif isDefined("form.cboSInicial") AND #form.cboSInicial# eq #i#>
										<option value="#i#" selected="true">#i#</option>
									<cfelseif isDefined("lVarSemanaActual") AND #lVarSemanaActual# eq #i#>
										<option value="#i#" selected="true">#i#</option>
									<cfelse>
									    <option value="#i#">#i#</option>
									</cfif>
								</cfloop>
							</select>
						</td>
						<td nowrap align="right" width="35%"><strong>#LB_SFinal#:&nbsp;</strong></td>
						<td>
							<select id="cboSFinal" name="cboSFinal" default="-1">
								<option value="-1">--- Seleccione ---</option>
								<cfloop from="1" to="54" index="i" step="1">
									<cfif isDefined("form.cboSFinal") AND #form.cboSFinal# eq #i#>
										<option value="#i#" selected="true">#i#</option>
									<cfelse>
									    <option value="#i#">#i#</option>
									</cfif>
								</cfloop>
							</select>
						</td>
					</tr>
					<tr>
						<td nowrap align="right" width="35%"><strong>#LB_Moneda#:&nbsp;</strong></td>
						<td colspan="1">
							<select id="cboMoneda" name="cboMoneda" default="-1">
								<option value="-1">--- Seleccione ---</option>
								<cfloop query="#rsGetMonedas#">
									<cfoutput>
										<cfif isDefined("form.cboMoneda") AND #form.cboMoneda# eq #rsGetMonedas.Mcodigo#>
											<option value="#rsGetMonedas.Mcodigo#" selected="true">#rsGetMonedas.Mnombre#</option>
										<cfelse>
										    <option value="#rsGetMonedas.Mcodigo#">#rsGetMonedas.Mnombre#</option>
										</cfif>
									</cfoutput>
								</cfloop>
							</select>
						</td>
						<td nowrap align="right" width="35%"><strong>#LB_Periodo#:&nbsp;</strong></td>
						<td colspan="1">
							<select id="cboPeriodo" name="cboPeriodo" default="-1">
								<option value="-1">--- Seleccione ---</option>
								<option value="#Year(now())+2#">#Year(now())+2#</option>
								<option value="#Year(now())+1#">#Year(now())+1#</option>
								<option value="#Year(now())#">#Year(now())#</option>
								<cfloop from="1" to="10" index="i" step="1">
									<option value="#Year(now())-i#">#Year(now())-i#</option>
								</cfloop>
							</select>
						</td>
					</tr>
					<tr>
						<td align="right"><input type="checkbox" name="chkSemNat" <cfif isdefined('form.chkSemNat')>checked</cfif>   value="1" tabindex="5">&nbsp;</td>
						<td colspan="1" align="left">
							<strong>#LB_SemanasNat#</strong>
						</td>
						<td align="right"><input type="checkbox" name="chkSalRes" <cfif isdefined('form.chkSalRes')>checked</cfif>   value="1" tabindex="5">&nbsp;</td>
						<td colspan="1" align="left">
							<strong>#LB_SaldosResumidos#</strong>
						</td>
					</tr>
					<tr>
						<td align="right">&nbsp;</td>
						<td colspan="1" align="left">
							&nbsp;
						</td>
						<td align="right"><input type="checkbox" name="chkDetalle" <cfif isdefined('form.chkDetalle')>checked</cfif>   value="1" tabindex="5">&nbsp;</td>
						<td colspan="1" align="left">
							<strong>#LB_Detalle#</strong>
						</td>
					</tr>
					<tr id="imgLoading2" style="visibility: hidden"><td colspan="5">&nbsp;</td></tr>
					<tr id="imgLoading" style="visibility: hidden"><td colspan="5" align="center">&nbsp;<img src="/cfmx/sif/imagenes/large-loading.gif" title="Espere..."  alt="Generando reporte..."></td></tr>
					<tr><td colspan="5">&nbsp;</td></tr>
				</table>
			</form>
		</cfoutput>

	<cf_web_portlet_end>
<cf_templatefooter>

<!--- VALIDACIONES JAVASCRIPT --->
<script language="javascript1.2" type="text/javascript">
	function validaFiltro(){
		var semIni = document.getElementById('cboSInicial').value;
		var semFin = document.getElementById('cboSFinal').value;

		if((semIni != -1 && semFin != -1) && parseInt(semFin) < parseInt(semIni)){
			alert('La semana inicial no puede ser superior a la final!')
		} else {
			document.getElementById('imgLoading').style.visibility = "visible";
			document.getElementById('imgLoading2').style.visibility = "visible";
			document.getElementById('form1').submit();
		}
	}
</script>
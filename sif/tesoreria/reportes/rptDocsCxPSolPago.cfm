<cfinvoke key="LB_Titulo" default="Reporte de Documentos de CxP por Solicitud de Pago"	returnvariable="LB_Titulo" method="Translate" component="sif.Componentes.Translate"  xmlfile="rptDocsCxPSolPago.xml"/>
<cfinvoke key="LB_SocioNegocio" default="Socio de Negocio" returnvariable="LB_SocioNegocio" method="Translate" component="sif.Componentes.Translate"  xmlfile="rptDocsCxPSolPago.xml"/>
<cfinvoke key="LB_Solicitante" default="Solicitante" returnvariable="LB_Solicitante" method="Translate" component="sif.Componentes.Translate"  xmlfile="rptDocsCxPSolPago.xml"/>
<cfinvoke key="LB_Banco" default="Banco" returnvariable="LB_Banco" method="Translate" component="sif.Componentes.Translate"  xmlfile="rptDocsCxPSolPago.xml"/>
<cfinvoke key="LB_Moneda" default="Moneda" returnvariable="LB_Moneda" method="Translate" component="sif.Componentes.Translate"  xmlfile="rptDocsCxPSolPago.xml"/>

<!--- Se obtienen Bancos --->
<cfquery name="rsGetBancos" datasource="#session.DSN#">
	SELECT Bid,
	       RTRIM(LTRIM(Bdescripcion)) AS Bdescripcion
	FROM Bancos
	WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	ORDER BY Bdescripcion
</cfquery>

<!--- Se obtienen Monedas --->
<cfquery name="rsGetMonedas" datasource="#session.DSN#">
	SELECT Mcodigo, Mnombre
	FROM Monedas
	WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cf_templateheader title="#LB_Titulo#">
	<cf_web_portlet_start _start titulo="#LB_Titulo#">
		<form name="form1" id="form1" action="rptDocsCxPSolPago_sql.cfm" method="post" style="margin:0;">
			<cfoutput>
				<table width="42%" align="center" border="0" al cellspacing="1" cellpadding="2" class="areaFiltro">
					<tr><td colspan="3">&nbsp;</td></tr>
					<tr>
						<td class="fileLabel" align="right"><strong>#LB_SocioNegocio#:&nbsp;</strong></td>
						<td><cf_sifsociosnegocios2 form="form1" SNnombre='SNnombre' SNcodigo='SNcodigo' tabindex="1"></td>
						<td rowspan="3"><input name="btnGenerar" type="button" id="btnGenerar"onclick="validaFiltro();" value="Generar">&nbsp;</td>
					</tr>
					<tr>
						<td class="fileLabel" align="right"><strong>#LB_Solicitante#:&nbsp;</strong></td>
						<td><cf_sifusuario conlis="true" size="20" form="form1" ></td>
					</tr>
					<tr>
						<td align="right"><strong>#LB_Banco#:</strong></td>
						<td>
							<select id="cboBanco" name="cboBanco" default="-1" onchange="javascript:asignaBanco(this);">
								<option value="-1">--- Seleccione ---</option>
								<cfloop query="#rsGetBancos#">
									<cfoutput>
										<option value="#rsGetBancos.Bid#">#rsGetBancos.Bdescripcion#</option>
									</cfoutput>
								</cfloop>
							</select>
							<input type="hidden" name="nameBanco" id="nameBanco" value="">
						</td>
					</tr>
					<tr>
						<td align="right"><strong>#LB_Moneda#:</strong></td>
						<td>
							<select id="cboMoneda" name="cboMoneda" default="-1" onchange="javascript:asignaMoneda(this);">
								<option value="-1">--- Seleccione ---</option>
								<cfloop query="#rsGetMonedas#">
									<cfoutput>
										<option value="#rsGetMonedas.Mcodigo#">#rsGetMonedas.Mnombre#</option>
									</cfoutput>
								</cfloop>
							</select>
							<input type="hidden" name="nameMoneda" id="nameMoneda" value="">
						</td>
					</tr>
				</table>
			</cfoutput>
		</form>
	<cf_web_portlet_end>
<cf_templatefooter>


<!--- VALIDACIONES JAVASCRIPT --->
<script language="javascript1.2" type="text/javascript">
	function validaFiltro(){
		<!--- document.getElementById('imgLoading').style.visibility = "visible";
		document.getElementById('imgLoading2').style.visibility = "visible"; --->
		document.getElementById('form1').submit();
	}

	function asignaMoneda(nameMoneda){
		document.getElementById('nameMoneda').value=nameMoneda.options[nameMoneda.selectedIndex].text;
	}
	function asignaBanco(nameBanco){
		document.getElementById('nameBanco').value=nameBanco.options[nameBanco.selectedIndex].text;
	}
</script>
<!--- <cfdump var="#form#"> --->
<!--- Variables --->
<cfparam name="form.ubicacion" default="">


<!--- Queries necesarios para la pantalla de filtros --->
<!--- Consulta las Oficinas --->
<cfquery name="rsOficinas" datasource="#Session.DSN#">
	select Ocodigo, Odescripcion
	from Oficinas 
	where Ecodigo = #Session.Ecodigo#
	order by Odescripcion
</cfquery>

<!--- Consulta los Grupos de Oficinas --->
<cfquery name="rsGOficinas" datasource="#session.DSN#">
	select GOid, GOnombre
	from AnexoGOficina
	where Ecodigo = #session.Ecodigo#
	order by GOnombre
</cfquery>

<!--- Consulta los Periodos --->
<cfquery name="rsPeriodos" datasource="#Session.DSN#">
	select distinct Speriodo
	from CGPeriodosProcesados
	where Ecodigo = #session.Ecodigo#
	order by Speriodo desc
</cfquery>

<!--- Consulta del Mes --->
<cfquery name="rsMes" datasource="sifControl">
	select <cf_dbfunction args="b.VSvalor" name="to_number" datasource="sifControl"> as VSvalor, b.VSdesc 
	from Idiomas a, VSidioma b 
	where a.Icodigo = '#Session.Idioma#'
		and a.Iid = b.Iid
		and b.VSgrupo = 1
	order by <cf_dbfunction args="b.VSvalor" name="to_number" datasource="sifControl">
</cfquery>

<!--- Consulta de Monedas --->
<cfquery name="rsMonedas" datasource="#Session.DSN#">
	select Mcodigo as Mcodigo, Mnombre, Msimbolo, Miso4217, ts_rversion 
	from Monedas
	where Ecodigo = #Session.Ecodigo#
</cfquery>

<!--- Consulta de la Moneda Local --->
<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
	select a.Mcodigo, b.Mnombre, b.Msimbolo, b.Miso4217
	from Empresas a, Monedas b
	where a.Ecodigo = #Session.Ecodigo#
		and a.Ecodigo = b.Ecodigo
		and a.Mcodigo = b.Mcodigo
</cfquery>

<cfquery name="rsParam" datasource="#Session.DSN#">
	select Pvalor
    from Parametros
    where Ecodigo = #Session.Ecodigo#
    and Pcodigo = 660
</cfquery>

<cfif rsParam.recordCount> 
    <cfquery name="rsMonedaConvertida" datasource="#Session.DSN#">
        select Mcodigo, Mnombre
        from Monedas
        where Ecodigo = #Session.Ecodigo#
        and Mcodigo = #rsParam.Pvalor#
    </cfquery>
</cfif>

<cfquery name="rsGEmpresas" datasource="#session.DSN#">			
    select a.GEid as Ecodigo, a.GEnombre as Edescripcion
    from AnexoGEmpresa a
    where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
</cfquery>

<cf_templateheader title="Balance de Comprobaci&oacute;n Por Cuenta Mayor"> 
		<script language="javascript1.2" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
		<script language="JavaScript1.2" type="text/javascript" src="../../sif/js/sinbotones.js"></script>
		<cfinclude template="../../../sif/cg/consultas/Funciones.cfm">
		
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Balance de Comprobaci&oacute;n Por Cta. Mayor'>
			<cfinclude template="../../../sif/portlets/pNavegacion.cfm">
			<cfset periodo = "#get_val(30).Pvalor#">
			<cfset mes = "#get_val(40).Pvalor#">
			<form action="BalCompPorCtaMayorCons-sql.cfm" method="post" name="form1" style="margin:0;" >
				<cfoutput>
					<table width="100%" border="0" align="center" cellpadding="2" cellspacing="0">
						<!--- Lnea No. 1 --->
						<tr><td colspan="5">&nbsp;</td></tr>
						<!--- Lnea No. 2 --->
                		<tr> 
							<td nowrap align="right" width="20%">Grupo de Empresas:&nbsp;</td>
							<td nowrap width="30%"> 
								<select name="GEid" style="width:250px">
                                    <cfloop query="rsGEmpresas">
                                        <option value="#rsGEmpresas.Ecodigo#"> #trim(rsGEmpresas.Edescripcion)# </option>
                                    </cfloop>
                                </select>
							</td>
							<td nowrap>&nbsp;</td>
							<td nowrap align="right">Per&iacute;odo:&nbsp;</td>
							<td nowrap> 
								<select name="periodo" tabindex="3">
									<cfloop query="rsPeriodos">
										<option value="#Speriodo#" <cfif isdefined("form.periodo") and form.periodo EQ Speriodo>selected</cfif> >#Speriodo#</option>
									</cfloop>
								</select>
							</td>
						</tr>
						<!--- Lnea No. 3 --->
						<tr>
							<td nowrap align="right">Moneda:&nbsp;</td>
							<td rowspan="2" valign="top">
				  				<table border="0" cellspacing="0" cellpadding="2">
     								<tr>
                      					<td nowrap><input name="mcodigoopt" type="radio" value="-2" checked></td>
                     					<td nowrap align="right">Local:</td>
                      					<td><strong>#rsMonedaLocal.Mnombre#</strong></td>
                    				</tr>
									<cfif isdefined("rsMonedaConvertida")>
<!---                                        <tr>
                                          <td nowrap><input name="mcodigoopt" type="radio" value="-3" tabindex="6"></td>
                                          <td nowrap>                      Convertida:</td>
                                          <td><cfoutput><strong>#rsMonedaConvertida.Mnombre#</strong></cfoutput></td>
                                        </tr>
--->                                    </cfif>                                    
									
									<tr>
										<td nowrap><input name="mcodigoopt" type="radio" value="0"></td>
										<td nowrap align="right">Origen:</td>
										<td>
											<select name="Mcodigo" >
												<cfloop query="rsMonedas">
													<option value="#rsMonedas.Mcodigo#"
													<cfif isdefined('rsMonedas') and isdefined('rsMonedaLocal')>
													<cfif rsMonedas.Mcodigo EQ rsMonedaLocal.Mcodigo >selected</cfif>
													</cfif>
													>#rsMonedas.Mnombre#</option>
												</cfloop>
											</select>
										</td>
									</tr>
								</table>
							</td>
							<td nowrap>&nbsp;</td>
							<td nowrap align="right">Mes:&nbsp;</td>
							<td nowrap>
								<select name="mes">
									<cfloop query="rsMes">
										<option value="#VSvalor#" <cfif isdefined("form.mes") and form.mes EQ VSvalor>selected</cfif> >#VSdesc#</option>
									</cfloop>
								</select>								
							</td>
						</tr>
						<!--- Lnea No. 4 
						<tr>
							<td nowrap>&nbsp;</td>
							<td nowrap>&nbsp;</td>
							<td nowrap align="right">
								<input type="checkbox" 
									name="toExcel" 
									value="" 
									onClick="javascript: habilitar();"
									<cfif isdefined("form.toExcel")>checked</cfif>>
							</td>
							<td nowrap>Exportar a Excel</td>
						</tr>
						<!--- Lnea No. 5 --->
						<tr>
							<td nowrap colspan="3">&nbsp;</td>
							<td nowrap align="right">
				  				<input type="checkbox" 
									name="IncluirOficina" 
									value=""
									<cfif isdefined("form.IncluirOficina")>checked</cfif>>
							</td>
							<td nowrap>Saldos por Oficina</td>
						</tr>
						<!--- Lnea No. 6 --->
						<tr>
							<td nowrap colspan="3">&nbsp;</td>
							<td nowrap align="right">
								<input type="checkbox" 
									name="chkCeros" 
									value="" 
									onClick="javascript: habilitarExcel();"
									<cfif isdefined("form.chkCeros")>checked</cfif>>
							</td>
							<td nowrap>Mostrar Saldos Finales en Cero</td>
						</tr>
						<tr>
							<td nowrap colspan="3">&nbsp;</td>
							<td nowrap align="right">
								<input type="checkbox" name="CHKMesCierre" value="1" tabindex="13">
							</td>
							<td>Cierre Anual</td>
						</tr> 
						<!--- Lnea No. 7 --->
						<tr>
							<td nowrap colspan="5">&nbsp;</td>
						</tr> 
						<!--- Lnea No. 8 --->
--->					
						<tr></tr>	
						<tr> 
                  			<td colspan="5" align="center"> 
								<input type="submit" name="Submit" value="Consultar" onClick="javascript: return validar();" >
							</td>
						</tr>
						<!--- Lnea No. 9 --->
						<tr>
							<td nowrap colspan="5">&nbsp;</td>
						</tr>
						 
                 	</table>
				</cfoutput>
			</form>

 		<cf_web_portlet_end>
	<cf_templatefooter> 

<cfoutput>
	<script language="javascript">
		function validar() 
		{
			var grupo = document.form1.ubicacion.value.substring(0,2);
			var oficina = document.form1.IncluirOficina.checked;
			
			if (grupo == 'ge' && oficina == true) {
				alert("No puede seleccionar un Grupo de Empresas con Saldos por Oficina");
				return false;
			}
			return true;
		}
		function habilitar()
		{
			if (document.form1.toExcel.checked == true) {
				document.form1.chkCeros.checked = false;
				document.form1.chkCeros.disabled = true;
			} else {
				document.form1.chkCeros.disabled = false;
			}
		}
		function habilitarExcel()
		{
			if (document.form1.chkCeros.checked == true) {
				document.form1.toExcel.checked = false;
				document.form1.toExcel.disabled = true;
			} else {
				document.form1.toExcel.disabled = false;
			}
		}
	</script>
</cfoutput>



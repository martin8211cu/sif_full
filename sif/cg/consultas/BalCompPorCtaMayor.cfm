<!--- <cfdump var="#form#"> --->
<!--- Variables --->
<cfparam name="form.ubicacion" default="">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Titulo"	default="Balanza de Comprobaci&oacute;n por Cuenta de Mayor"		returnvariable="LB_Titulo"		  xmlfile="BalCompPorCtaMayor.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Moneda"	default="Moneda"	
returnvariable="LB_Moneda"		  xmlfile="BalCompPorCtaMayor.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Periodo"	default="Per&iacute;odo"	
returnvariable="LB_Periodo"		  xmlfile="BalCompPorCtaMayor.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Mes"	default="Mes"	
returnvariable="LB_Mes"		  xmlfile="BalCompPorCtaMayor.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_EmpresaOficina"	default="Empresa u Oficina"	
returnvariable="LB_EmpresaOficina"		  xmlfile="BalCompPorCtaMayor.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Origen"	default="Origen"	
returnvariable="LB_Origen"		  xmlfile="BalCompPorCtaMayor.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_ExportarExcel"	default="Exportar a Excel"	
returnvariable="LB_ExportarExcel"		  xmlfile="BalCompPorCtaMayor.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Saldos_por_Oficina"	default="Saldos por Oficina"	
returnvariable="LB_Saldos_por_Oficina"		  xmlfile="BalCompPorCtaMayor.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Saldos_Finales_Cero"	default="Mostrar Saldos Finales en Cero"	
returnvariable="LB_Saldos_Finales_Cero"		  xmlfile="BalCompPorCtaMayor.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Cierre_Anual"	default="Cierre Anual"	
returnvariable="LB_Cierre_Anual"		  xmlfile="BalCompPorCtaMayor.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="BTN_Consultar"	default="Consultar"	
returnvariable="BTN_Consultar"		  xmlfile="BalCompPorCtaMayor.xml"/>
<!--- Queries necesarios para la pantalla de filtros --->
<!--- Consulta las Oficinas --->
<cfquery name="rsOficinas" datasource="#Session.DSN#">
	select Ocodigo, Odescripcion
	from Oficinas 
	where Ecodigo = #Session.Ecodigo#
	order by Odescripcion
</cfquery>

<!--- Consulta los Grupos de Empresas --->
<cfquery name="rsGEmpresas" datasource="#session.DSN#">			
	select ge.GEid, ge.GEnombre
	from AnexoGEmpresa ge
		join AnexoGEmpresaDet gd
			on ge.GEid = gd.GEid
	where ge.CEcodigo = #session.CEcodigo#
		and gd.Ecodigo = #session.Ecodigo#
	order by ge.GEnombre
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

<cf_templateheader title="#LB_Titulo#"> 
		<script language="javascript1.2" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
		<script language="JavaScript1.2" type="text/javascript" src="../../js/sinbotones.js"></script>
		<cfinclude template="Funciones.cfm">
		
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Titulo#'>
			<cfinclude template="../../portlets/pNavegacion.cfm">
			<cfset periodo = "#get_val(30).Pvalor#">
			<cfset mes = "#get_val(40).Pvalor#">

			<form action="BalCompPorCtaMayor-sql.cfm" method="post" name="form1" style="margin:0;" >
				<cfoutput>
					<table width="100%" border="0" align="center" cellpadding="2" cellspacing="0">
						<!--- Lnea No. 1 --->
						<tr><td colspan="5">&nbsp;</td></tr>
						<!--- Lnea No. 2 --->
                		<tr> 
							<td nowrap align="right" width="20%">#LB_EmpresaOficina#:&nbsp;</td>
							<td nowrap width="30%"> 
								<select name="ubicacion" id="ubicacion" style="width:250px">
									<optgroup label="Empresa">
										<option value="" <cfif len(form.ubicacion) EQ 0>selected</cfif> >#HTMLEditFormat(session.Enombre)#</option>
									</optgroup>
									<optgroup label="Oficina">
										<cfloop query="rsOficinas">
											<option value="of,#Ocodigo#" <cfif form.ubicacion eq 'of,' & Ocodigo >selected</cfif> >#HTMLEditFormat(Odescripcion)#</option>
										</cfloop>
									</optgroup>
									<cfif rsGEmpresas.RecordCount >
										<optgroup label="Grupo de Empresas">
											<cfloop query="rsGEmpresas">
												<option value="ge,#GEid#" <cfif form.ubicacion eq 'ge,' & GEid >selected</cfif> >#HTMLEditFormat(GEnombre)#</option>
											</cfloop>
									   </optgroup>
									</cfif>
									<cfif rsGOficinas.RecordCount>
										<optgroup label="Grupo de Oficinas">
											<cfloop query="rsGOficinas">
												<option value="go,#GOid#" <cfif form.ubicacion eq 'go,' & GOid>selected</cfif> >#HTMLEditFormat(GOnombre)#</option>
											</cfloop>
										</optgroup>
									</cfif>
							  	</select>
							</td>
							<td nowrap>&nbsp;</td>
							<td nowrap align="right">#LB_Periodo#:&nbsp;</td>
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
							<td nowrap align="right">#LB_Moneda#:&nbsp;</td>
							<td rowspan="2" valign="top">
				  				<table border="0" cellspacing="0" cellpadding="2">
     								<tr>
                      					<td nowrap><input name="mcodigoopt" type="radio" value="-2" checked></td>
                     					<td nowrap align="right">Local:</td>
                      					<td><strong>#rsMonedaLocal.Mnombre#</strong></td>
                    				</tr>
									<tr>
										<td nowrap><input name="mcodigoopt" type="radio" value="0"></td>
										<td nowrap align="right">#LB_Origen#:</td>
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
							<td nowrap align="right">#LB_Mes#:&nbsp;</td>
							<td nowrap>
								<select name="mes">
									<cfloop query="rsMes">
										<option value="#VSvalor#" <cfif isdefined("form.mes") and form.mes EQ VSvalor>selected</cfif> >#VSdesc#</option>
									</cfloop>
								</select>								
							</td>
						</tr>
						<!--- Lnea No. 4 --->
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
							<td nowrap>#LB_ExportarExcel#</td>
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
							<td nowrap>#LB_Saldos_por_Oficina#</td>
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
							<td nowrap>#LB_Saldos_Finales_Cero#</td>
						</tr>
						<tr>
							<td nowrap colspan="3">&nbsp;</td>
							<td nowrap align="right">
								<input type="checkbox" name="CHKMesCierre" value="1" tabindex="13">
							</td>
							<td>#LB_Cierre_Anual#</td>
						</tr> 
						<!--- Lnea No. 7 --->
						<tr>
							<td nowrap colspan="5">&nbsp;</td>
						</tr> 
						<!--- Lnea No. 8 --->
						<tr> 
                  			<td colspan="5" align="center"> 
								<input type="submit" name="Submit" value="#BTN_Consultar#" onClick="javascript: return validar();" >
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



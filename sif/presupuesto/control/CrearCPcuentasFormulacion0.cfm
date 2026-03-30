<cfset LvarVERIFICACION = "">
<cfset LvarRESULTADO = "">
<cfset LvarTipoNoAbierto = false>
<cfif isdefined("form.btnCrear")>
	<cfinclude template="CrearCPcuentasFormulacion0_sql.cfm">
<cfelseif isdefined("form.btnVer")>
	<cfinclude template="CrearCPcuentasFormulacion0_sql.cfm">
	<cfset LvarVERIFICACION = LvarVERIFICACION & " ">
</cfif>
<cf_templateheader title="Generación de Cuenta de Presupuesto">
	<cf_web_portlet_start titulo="Generación de Cuenta de Presupuesto Abierta con Formulación en Cero">
		<cfinclude template="/sif/portlets/pNavegacion.cfm">
		
        <cfinclude template="../../Utiles/sifConcat.cfm">
		<cfquery name="rsCPPeriodo" datasource="#session.dsn#">
			select CPPid, 
				case CPPtipoPeriodo when 1 then 'Mensual' when 2 then 'Bimestral' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' else '' end
					#_Cat# ' de ' #_Cat# 
					case {fn month(CPPfechaDesde)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
					#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(CPPfechaDesde)}">
					#_Cat# ' a ' #_Cat# 
					case {fn month(CPPfechaHasta)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
					#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(CPPfechaHasta)}">
				as CPPdescripcion
			  from CPresupuestoPeriodo d
			 where Ecodigo = #session.ecodigo#
			   and CPPestado = 1
		</cfquery>
		
		<cfif #rsCPPeriodo.CPPid# eq ''>			
			<cf_errorCode	code = "51346"
							msg  = "El Período de Presupuesto no está Abierto"
							errorDat_1 = ''
			>
		<cfelse>
			<cfparam name="form.CPPid" default="#rsCPPeriodo.CPPid#">
			<cfquery name="rsCmayor" datasource="#Session.dsn#">
				select c.Cmayor, c.Cdescripcion, m.PCEMformatoP
				  from  CPresupuestoPeriodo p
					inner join CPVigencia vg
						on vg.Ecodigo = p.Ecodigo
					  and p.CPPanoMesDesde between vg.CPVdesdeAnoMes and vg.CPVhastaAnoMes
					inner join PCEMascaras m
						on m.PCEMid = vg.PCEMid
					inner join CtasMayor c
						on c.Ecodigo = vg.Ecodigo
					  and c.Cmayor  = vg.Cmayor
				where p.Ecodigo = #session.Ecodigo#
				  and p.CPPid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPPid#">
				  and (
					select count(1)
					  from PCNivelMascara
					 where PCEMid = vg.PCEMid
						and PCNpresupuesto = 1
					) > 0
				order by c.Cmayor
			</cfquery>
			<cfparam name="form.Cmayor" default="#rsCmayor.Cmayor#">
			<cfparam name="form.PCEMformatoP" default="#rsCmayor.Cmayor#-#mid(rsCmayor.PCEMformatoP,6,100)#">
		</cfif>
		
<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
  	<tr><td >&nbsp;</td></tr>
  	<tr><td >&nbsp;</td></tr>
	<tr>
		<td>
			<form name="form1" action="" method="post" onsubmit="return sbVerificar();">
			<script>
				function sbVerificar()
				{
					var LvarMSG = "";
					if (document.form1.CPPid.value == "")
						LvarMSG += "- Período de Presupuesto\n";
					if (document.form1.Cmayor.value == "")
						LvarMSG += "- Cuenta de Mayor\n";
					if (document.form1.Pdetalle2.value == "")
						LvarMSG += "- Detalle de la Cuenta de Presupuesto\n";
					if (document.form1.CPdescripcion.value == "")
						LvarMSG += "- Descripcion de la Cuenta de Presupuesto\n";
					if (document.form1.CVPcalculoControl.value == "")
						LvarMSG += "- Método de Cálculo de Control\n";
					if (document.form1.Ocodigo.value == "")
						LvarMSG += "- Oficina a formular\n";
					if (LvarMSG != "")
					{
						alert("Campos requeridos:\n"+LvarMSG);
						return false;
					}
					return true;
				}
			</script>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td align="right">
						<strong>Per&iacute;odo Presupuestario:</strong>&nbsp;&nbsp;&nbsp;
					</td>
					<td nowrap>
						<select name="CPPid" onchange="this.form.submit()">
							<cfoutput query="rsCPPeriodo">
								<option value="#rsCPPeriodo.CPPid#" <cfif rsCPPeriodo.CPPid EQ form.CPPid>selected</cfif>>#rsCPPeriodo.CPPdescripcion# </option>
							</cfoutput>
						</select>

					</td>
				<tr>
					<td align="right">
						<strong>Cuenta Mayor:</strong>&nbsp;&nbsp;&nbsp;
					</td>		
					<td colspan="4">
						<select name="Cmayor" onchange="sbCambiarFormato(this.value);">
							<cfoutput query="rsCMayor">
								<option value="#rsCMayor.Cmayor#" <cfif rsCMayor.Cmayor EQ form.Cmayor>selected</cfif>>#rsCMayor.Cmayor# - #rsCMayor.Cdescripcion#</option>
							</cfoutput>
						</select>
						<script>
							function sbCambiarFormato(Cmayor)
							{
							<cfoutput query="rsCMayor">
								if (Cmayor == '#rsCMayor.Cmayor#')
								{
									document.getElementById("PCEMformatoP").value = "#rsCMayor.Cmayor#-#mid(rsCMayor.PCEMformatoP,6,100)#"
									document.getElementById("Pdetalle1").value = "#rsCMayor.Cmayor#"
								}
								else
							</cfoutput>
								if (Cmayor != '***')
								{
									alert ('Cuenta de Mayor no existe');
								}
							}
						</script>
					</td>
				</tr>
				<tr>
					<td align="right">
						<strong>Formato de Presupuesto:</strong>&nbsp;&nbsp;&nbsp;
					</td>
					<td>
						<input name="PCEMformatoP" id="PCEMformatoP" value="<cfoutput>#form.PCEMformatoP#</cfoutput>" size="60" maxlength="100"  readonly="readonly"  style="border:none">
					</td>
				</tr>
				<tr>
					<td align="right">
						<strong>Detalle de la Cuenta:</strong>&nbsp;&nbsp;&nbsp;
					</td>
					<td>
						<cfparam name="form.Pdetalle2" default="">
						<input name="Pdetalle1" id="Pdetalle1" value="<cfoutput>#form.Cmayor#</cfoutput>" align="right" size="4" readonly="readonly" style="border:none">-<input name="Pdetalle2" id="Pdetalle2" value="<cfoutput>#form.Pdetalle2#</cfoutput>"  size="53">
					</td>
				</tr>
				<tr>
					<td align="right">
						<strong>Descripcion de la Cuenta:</strong>&nbsp;&nbsp;&nbsp;
					</td>
					<td>
						<cfparam name="form.CPdescripcion" default="">
						<input type="text" name="CPdescripcion" value="<cfoutput>#form.CPdescripcion#</cfoutput>" size="60" maxlength="60">
					</td>
				</tr>
				<tr>
					<td align="right">
						<strong>Tipo de Control:</strong>&nbsp;&nbsp;&nbsp;
					</td>
					<td>
						<strong>ABIERTO</strong>
						<input type="checkbox" name="chkForzarAbierto" value="1" <cfif isdefined("form.chkForzarAbierto")>checked</cfif>> <font color="#FF0000"><strong>Forzar tipo de control ABIERTO en el Período</strong></font>
					</td>
				</tr>
				<tr>
					<td align="right">
						<strong>Método Cálculo de Control:</strong>&nbsp;&nbsp;&nbsp;
					</td>
					<td>
						<select name="CVPcalculoControl">
							<option value="" >(Escoger método)</option>
							<cfparam name="form.CVPcalculoControl" default="">
							<option value="1" <cfif form.CVPcalculoControl EQ 1>selected</cfif>>Mensual</option>
							<option value="2" <cfif form.CVPcalculoControl EQ 2>selected</cfif>>Acumulado</option>
							<option value="3" <cfif form.CVPcalculoControl EQ 3>selected</cfif>>Total</option>
						</select>
					</td>
				</tr>
				<tr>
					<td align="right">
						<strong>Oficina a Formular en Cero:</strong>&nbsp;&nbsp;&nbsp;
					</td>
					<td>
						<cfparam name="form.Ocodigo" default="1">
						<cf_sifOficinas Ocodigo="Ocodigo" id="#form.Ocodigo#">
					</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td align="left">
						<input type="submit" name="btnVer" 		value="Verificar">
						<input type="submit" name="btnCrear" 	value="Generar Cuenta">
					</td>
				</tr>
			</table>
			</form>
		</td>
	</tr>
</table>
<cfoutput>
	#LvarResultado#
</cfoutput>
	<cf_web_portlet_end>
<cf_templatefooter>


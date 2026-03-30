<cf_templateheader title="SIF - Cuentas por Cobrar">
	<cfinclude template="../../portlets/pNavegacionCC.cfm">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Consolidado Contable'>
		
		<cfif isdefined("url.formatos") and not isdefined("form.formatos")>
			<cfset form.formatos = url.formatos>
		</cfif>
		
		<cfif isdefined("url.anio") and not isdefined("form.anio")>
			<cfset form.anio = url.anio>
		</cfif>
		
		<cfif isdefined("url.mes") and not isdefined("form.mes")>
			<cfset form.mes = url.mes>
		</cfif>
		
		<cfquery name="rsPer" datasource="#Session.DSN#">
			select distinct Speriodo as Eperiodo
			from CGPeriodosProcesados
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			order by Eperiodo desc
		</cfquery>

		<cfinclude template="../../cg/consultas/Funciones.cfm">
		<cfset periodo=get_val(30).Pvalor>
		<cfif isdefined("form.mes") and len(trim(form.mes))>
			<cfset mes= form.mes>
		<cfelse>
			<cfset mes=get_val(40).Pvalor>
		</cfif>
		
		<!--- Clasificación Reporte Consolidado Contable --->
		<cfset LvarSNCEid = get_val(695).Pvalor>
		
		<cfquery name="rsCuentas" datasource="#session.DSN#" maxrows="100">
			select 
				Ccuenta, 
				Cformato, 
				case when <cf_dbfunction name="length" args="Cdescripcion"> > 35 then 
					<cf_dbfunction name="sPart" args="Cdescripcion,1,35"> <cf_dbfunction name="OP_concat"> '...'
				else 
					Cdescripcion 
				end	as Cdescripcion,
				(( 
					select count(1) 
					from CCCuentasConciliacionUsr cu
					where cu.Ccuenta = c.Ccuenta
					  and cu.Usucodigo = #session.Usucodigo#
				)) as Cantidad
			from CContables c
			where c.Ecodigo = #session.Ecodigo#
			  and c.Cmovimiento = 'S'
			  and c.Cmayor <> c.Cformato
			  and c.Mcodigo = 2
			order by Cformato
		</cfquery>
		
		<cfset LvarTituloClas = ''>
		<cfif len(trim(LvarSNCEid)) gt 0>
			<cfquery name="rsClasificacion" datasource="#session.DSN#" maxrows="100">
				select 
					c.SNCDid,
					c.SNCDvalor,
					c.SNCDdescripcion,
					(( 
						select count(1) 
						from CCClasificConciliacionUsr cu
						where cu.SNCDid = c.SNCDid
						  and cu.Usucodigo = #session.Usucodigo#
					)) as Cantidad
				from SNClasificacionD  c
				where c.SNCEid = #LvarSNCEid#
				and c.SNCDactivo = 1
			</cfquery>

			<cfquery name="rsClasEnc" datasource="#session.DSN#">
				select 
					SNCEdescripcion
				from SNClasificacionE
				where SNCEid = #LvarSNCEid#
			</cfquery>
			<cfset LvarTituloClas = rsClasEnc.SNCEdescripcion>
		</cfif>
		<style type="text/css">
			.Mensaje {
				font-weight: bold;
				color: #FF0000;
				padding-top: 10px;
				padding-bottom: 10px;
			}
		</style>
		
		<form name="form1" method="post" action="ConciliacionCCvrsCG_sql.cfm">
			<fieldset><legend>Datos del Reporte</legend>
				<table width="100%" align="center" cellpadding="2" cellspacing="1" border="0">
					<tr><td colspan="7">&nbsp;</td></tr>
					<tr>
						<td nowrap align="right"><strong>Período</strong></td>
						<td>
							<select name="anio" tabindex="1">
								<cfloop query = "rsPer">
									<cfif isdefined("form.anio") and len(trim(form.anio))>
										<option value="<cfoutput>#rsPer.Eperiodo#</cfoutput>" <cfif rsPer.Eperiodo EQ form.anio>selected</cfif>><cfoutput>#rsPer.Eperiodo#</cfoutput></option>
									<cfelse>
										<option value="<cfoutput>#rsPer.Eperiodo#</cfoutput>"><cfoutput>#rsPer.Eperiodo#</cfoutput></option> <cfif periodo EQ "#rsPer.Eperiodo#">selected</cfif>></option>
									</cfif>
								</cfloop>
							</select>
						</td>
						<td align="right"><strong>Mes:</strong></td>
						<td> 
							<select name="mes" size="1" tabindex="1">
								<option value="1" <cfif mes EQ 1>selected</cfif>>Enero</option>
								<option value="2" <cfif mes EQ 2>selected</cfif>>Febrero</option>
								<option value="3" <cfif mes EQ 3>selected</cfif>>Marzo</option>
								<option value="4" <cfif mes EQ 4>selected</cfif>>Abril</option>
								<option value="5" <cfif mes EQ 5>selected</cfif>>Mayo</option>
								<option value="6" <cfif mes EQ 6>selected</cfif>>Junio</option>
								<option value="7" <cfif mes EQ 7>selected</cfif>>Julio</option>
								<option value="8" <cfif mes EQ 8>selected</cfif>>Agosto</option>
								<option value="9" <cfif mes EQ 9>selected</cfif>>Setiembre</option>
								<option value="10" <cfif mes EQ 10>selected</cfif>>Octubre</option>
								<option value="11" <cfif mes EQ 11>selected</cfif>>Noviembre</option>
								<option value="12" <cfif mes EQ 12>selected</cfif>>Diciembre</option>
							</select> 
						</td>
						<td align="right"><strong>Formato:&nbsp;</strong></td>
						<td>
							<select name="Formatos" id="Formatos" tabindex="1">
								<option value="1" <cfif isdefined("form.formatos") and len(trim(form.formatos)) and form.formatos eq 1>selected</cfif>>HTML</option>
								<option value="2" <cfif isdefined("form.formatos") and len(trim(form.formatos)) and form.formatos eq 2>selected</cfif>>Tabular</option>
							</select>
						</td>
						<td>
							<input name="LvarTipoDiferencia" id="LvarTipoDiferencia" type="checkbox" value="1"><label for="LvarTipoDiferencia">&nbsp;Diferencia Acumulada</label>
						</td>
					</tr>
					<tr><td colspan="7">&nbsp;</td></tr>
					<tr>
						<td colspan="4" style="width:50%" valign="top">
							<iframe id="ICuentas" name="ICuentas" src="ConciliacionCCvrsCG_Cuentas.cfm" frameborder="1" height="0" width="0"  scrolling="yes"></iframe>
							<fieldset><legend>Cuentas</legend>
								<table width="100%" cellpadding="2" cellspacing="1" border="0">
									<cfset contador = 0>
									<cfif isdefined("rsCuentas") and rsCuentas.recordcount gt 0>
										<cfoutput query="rsCuentas">
											<cfset contador = contador +1>
											<tr>
												<td>
													<input name="chkCuenta#contador#" id="chkCuenta#contador#" type="checkbox" value="0" onclick="funcChkbox(#Ccuenta#,this);" <cfif cantidad gt 0>checked="checked"</cfif>>
													&nbsp;#Cformato# / #Cdescripcion#
												</td>
											</tr>
										</cfoutput>
									<cfelse>
										<tr>
											<td align="center" class="Mensaje"> No existen Cuentas de CxC que acepten movimientos </td>
										</tr>
									</cfif>
								</table>
							</fieldset>
						</td>
						<td colspan="4" style="width:50%" valign="top">
							<iframe id="IClasificaciones" name="IClasificaciones" src="ConciliacionCCvrsCG_Clasificaciones.cfm" frameborder="" height="0" width="0"  scrolling="yes"></iframe>
							<fieldset><legend>Valores de la Clasificación <cfoutput>#LvarTituloClas#</cfoutput></legend>
								<table width="100%" cellpadding="2" cellspacing="1" border="0">
									<cfset contador = 0>
									<cfif isdefined("rsClasificacion")>
										<cfoutput query="rsClasificacion">
											<cfset contador = contador +1>
											<tr>
												<td>
													<input name="chkClas#contador#" id="chkClas#contador#" type="checkbox" value="0" onclick="funcChkboxClas(#SNCDid#,this);" <cfif cantidad gt 0>checked="checked"</cfif>>
													&nbsp;#SNCDvalor# - #SNCDdescripcion#
												</td>
											</tr>
										</cfoutput>
									<cfelse>
										<tr>
											<td class="Mensaje"> Tiene que definir la Clasificación a usar en este reporte</td>
										</tr>
										<tr>
											<td align="justify" class="Mensaje">Debe ir a Administración del Sitema, Parámetros Adicionales, en el parámetro "Clasificación Reporte Consolidado Contable" y escoger un valor</td>
										</tr>
									</cfif>
								</table>
							</fieldset>
						</td>
					</tr>
					<tr><td colspan="7">&nbsp;</td></tr>
					<tr>
						<td colspan="7" align="center" class="Mensaje">
							<cfif isdefined("rsClasificacion") and isdefined("rsCuentas") and rsCuentas.recordcount gt 0>
								<cf_botones values="Generar" names="Generar" tabindex="1">
							<cfelse>
								Para generar el reporte debe tener Cuentas y Valores de Clasificación.
							</cfif>
						</td>
					</tr>
				</table>
			</fieldset>
		</form>
	<cf_web_portlet_end>
<cf_templatefooter>
<script language="javascript" type="text/javascript">
	function funcChkbox(varCcuenta, varCheckObject){
		var lParam = "ConciliacionCCvrsCG_Cuentas.cfm?"
		if (varCheckObject.checked)
			{
				lParam += "op=I"
			}
			else
			{
				lParam += "op=D"
			}
			lParam += "&Ccuenta=" + varCcuenta;
			document.getElementById("ICuentas").src = lParam;
	}

	function funcChkboxClas(varSNCDid, varCheckObjectClas){
		
		var lParamClas = "ConciliacionCCvrsCG_Clasificaciones.cfm?"
		if (varCheckObjectClas.checked)
			{
				lParamClas += "op=I"
			}
			else
			{
				lParamClas += "op=D"
			}
			lParamClas += "&SNCDid=" + varSNCDid;
			document.getElementById("IClasificaciones").src = lParamClas;
	}
</script>
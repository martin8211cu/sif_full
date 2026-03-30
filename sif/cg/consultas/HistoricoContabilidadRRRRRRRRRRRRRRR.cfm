<cfinclude template="Funciones.cfm">
<script language="JavaScript1.2" type="text/javascript" src="../../js/sinbotones.js"></script>
<cfset fnDatosHistoricoContabilidad()>
<cf_templateheader title="Histórico de Contabilidad">
<cfinclude template="../../portlets/pNavegacion.cfm">

<form name="form1" method="post" action="HistoricoContabilidad2.cfm" onsubmit="return sinbotones()">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Histórico de Contabilidad'>
	<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
	<tr><td colspan="5" align="right"><cf_sifayudaRoboHelp name="imAyuda" imagen="1" Tip="true" width="500" url="Balance_comprobacion.htm"></td></tr>
	<tr> 
	  <td nowrap> <div align="right"></div></td>
	  <td width="21%" nowrap> <div align="right"></div></td>
	  <td colspan="3">&nbsp;</td>
	</tr>
	<tr> 
	  <td nowrap width="19%">&nbsp;</td>
	  <td nowrap><div align="right">Desde:&nbsp;</div></td>
	  <td width="14%" align="left">

		<select name="periodo" tabindex="1">
			<cfoutput query="rsPeriodosProcesados">
			  <option value="#rsPeriodosProcesados.Speriodo#" <cfif isdefined("form.periodo") and form.periodo eq #rsPeriodosProcesados.Speriodo#>selected</cfif>>
				#rsPeriodosProcesados.Speriodo#</option>
			</cfoutput>
		</select>
	  </td>
	  <td width="24%">
		<select name="mes" size="1" tabindex="2">
		  <option value="1" <cfif mes EQ 1>selected</cfif>>Enero</option>
		  <option value="2" <cfif mes EQ 2>selected</cfif>>Febrero</option>
		  <option value="3" <cfif mes EQ 3>selected</cfif>>Marzo</option>
		  <option value="4" <cfif mes EQ 4>selected</cfif>>Abril</option>
		  <option value="5" <cfif mes EQ 5>selected</cfif>>Mayo</option>
		  <option value="6" <cfif mes EQ 6>selected</cfif>>Junio</option>
		  <option value="7" <cfif mes EQ 7>selected</cfif>>Julio</option>
		  <option value="8" <cfif mes EQ 8>selected</cfif>>Agosto</option>
		  <option value="9" <cfif mes EQ 9>selected</cfif>>Septiembre</option>
		  <option value="10" <cfif mes EQ 10>selected</cfif>>Octubre</option>
		  <option value="11" <cfif mes EQ 11>selected</cfif>>Noviembre</option>
		  <option value="12" <cfif mes EQ 12>selected</cfif>>Diciembre</option>
		</select>
		</td>
	  <td width="22%">&nbsp;</td>
	</tr>
	<tr> 
	  <td nowrap>&nbsp;</td>
	  <td nowrap><div align="right">Hasta:&nbsp;</div></td>
	  <td>
		<select name="periodo2" tabindex="3">
			<cfoutput query="rsPeriodosProcesados">
			  <option value="#rsPeriodosProcesados.Speriodo#" <cfif isdefined("form.periodo2") and form.periodo2 eq #rsPeriodosProcesados.Speriodo#>selected</cfif>>#rsPeriodosProcesados.Speriodo#</option>
			</cfoutput>
		</select>
	  </td>
	  <td>
		<select name="mes2" size="1" tabindex="4">
		  <option value="1" <cfif mes EQ 1>selected</cfif>>Enero</option>
		  <option value="2" <cfif mes EQ 2>selected</cfif>>Febrero</option>
		  <option value="3" <cfif mes EQ 3>selected</cfif>>Marzo</option>
		  <option value="4" <cfif mes EQ 4>selected</cfif>>Abril</option>
		  <option value="5" <cfif mes EQ 5>selected</cfif>>Mayo</option>
		  <option value="6" <cfif mes EQ 6>selected</cfif>>Junio</option>
		  <option value="7" <cfif mes EQ 7>selected</cfif>>Julio</option>
		  <option value="8" <cfif mes EQ 8>selected</cfif>>Agosto</option>
		  <option value="9" <cfif mes EQ 9>selected</cfif>>Septiembre</option>
		  <option value="10" <cfif mes EQ 10>selected</cfif>>Octubre</option>
		  <option value="11" <cfif mes EQ 11>selected</cfif>>Noviembre</option>
		  <option value="12" <cfif mes EQ 12>selected</cfif>>Diciembre</option>
	  </select></td>
	  <td>&nbsp;</td>
	</tr>
	<tr> 
	  <td nowrap>&nbsp;</td>
	  <td nowrap> <div align="right">Cuenta Inicial:&nbsp;</div></td>
	  <td colspan="3" nowrap>
		<cfif isdefined("rsCuenta") and rsCuenta.recordcount gt 0>
			<cf_cuentas NoVerificarPres="yes" Conexion="#Session.DSN#" Conlis="S" query="#rsCuenta#" auxiliares="N" movimiento="S"  frame="frcuenta1" descwidth="40" tabindex="5"
			ccuenta="Ccuenta1" cdescripcion="Cdescripcion1" cformato="Cformato1" CFcuenta="CFcuenta1"> 
		<cfelse>
			<cf_cuentas NoVerificarPres="yes" cformato="Cformato1" cdescripcion="Cdescripcion1" ccuenta="Ccuenta1" CFcuenta="CFcuenta1" MOVIMIENTO="S" AUXILIARES="N" frame="frcuenta1" descwidth="40" tabindex="5">
		</cfif>
	  </td>
	</tr>
	<tr> 
	  <td nowrap>&nbsp;</td>
	  <td nowrap> <div align="right">Cuenta Final:&nbsp;</div></td>
	  <td colspan="3" nowrap> 
		<cfif isdefined("rsCuenta2") and rsCuenta2.recordcount gt 0>
			<cf_cuentas NoVerificarPres="yes" Conexion="#Session.DSN#" Conlis="S" query="#rsCuenta2#" auxiliares="N" movimiento="S"  frame="frcuenta2" descwidth="40" tabindex="6"
			ccuenta="Ccuenta2" cdescripcion="Cdescripcion2" cformato="Cformato2" CFcuenta="CFcuenta2"> 
		<cfelse>
			<cf_cuentas NoVerificarPres="yes" cformato="Cformato2" cdescripcion="Cdescripcion2" ccuenta="Ccuenta2" CFcuenta="CFcuenta2" MOVIMIENTO="S" AUXILIARES="N" frame="frcuenta2" descwidth="40" tabindex="6">
		</cfif>
	  </td>
	</tr>
	<tr>
	  <td nowrap>&nbsp;</td>
	  <td align="right" nowrap>Oficina:&nbsp; </td>
	  <td nowrap><select name="Ocodigo" id="select" tabindex="7">
		  <option value="-1">Todas</option>
		  <cfoutput query="rsOficinas">
			<option value="#rsOficinas.Ocodigo#" <cfif isdefined("form.Ocodigo") and form.Ocodigo eq rsOficinas.Ocodigo>selected</cfif>>#rsOficinas.Odescripcion#</option>
		  </cfoutput>
	  </select></td>
	  <td nowrap>&nbsp;</td>
	</tr>
	<tr>
	  <td align="right" nowrap>&nbsp;</td>
	  <td nowrap valign="top"><div align="right">Moneda:</div></td>
	  <td colspan="3" rowspan="2" valign="top">
		<table border="0" cellspacing="0" cellpadding="2">
		  <tr>
			<td nowrap><input name="mcodigoopt" type="radio" value="-2" <cfif isdefined("form.mcodigoopt") and form.mcodigoopt eq -2 or not isdefined("form.mcodigoopt")>checked</cfif> tabindex="8"></td>
			<td nowrap> Local:</td>
			<td><cfoutput><strong>#rsMonedaLocal.Mnombre#</strong></cfoutput></td>
		  </tr>
		  <cfif isdefined("rsMonedaConvertida")>
		  </cfif>
		  <tr>
			<td nowrap><input name="mcodigoopt" type="radio" value="0" <cfif isdefined("form.mcodigoopt") and form.mcodigoopt eq 0>checked</cfif> tabindex="9"></td>
			<td nowrap> Origen:</td>
			<td><select name="Mcodigo" tabindex="10">
				<cfoutput query="rsMonedas">
				  <option value="#rsMonedas.Mcodigo#"
					<cfif isdefined("form.Mcodigo") and len(trim(form.Mcodigo)) and isdefined("form.mcodigoopt") and form.mcodigoopt eq 0>
						<cfif form.Mcodigo eq rsMonedas.Mcodigo>selected</cfif> 
					<cfelse>
						<cfif isdefined('rsMonedas') and isdefined('rsMonedaLocal')>
							<cfif rsMonedas.Mcodigo EQ rsMonedaLocal.Mcodigo>selected</cfif>
						</cfif>
					</cfif> >#rsMonedas.Mnombre#</option>
				</cfoutput>
			</select></td>
		  </tr>
		  <tr>
			<td nowrap><input type="checkbox" id="ckOrdenXMonto" name="ckOrdenXMonto" value="1" <cfif isdefined("form.ckOrdenXMonto")>checked</cfif> title="Ordenar por monto" tabindex="11"></td>
			<td colspan="2" nowrap><label for="ckOrdenXMonto">Ordenar por monto</label></td>
		  </tr>
		  <tr>
			<td nowrap><input type="checkbox" id="chkdownload" name="chkdownload" <cfif isdefined("form.chkdownload")>checked</cfif> value="1" title="Descargar Archivo" tabindex="12"></td>
			<td colspan="2" nowrap><label for="chkdownload">Descargar archivo</label></td>
		  </tr>
		  <tr>
			<td nowrap>
				<input type="checkbox" id="CHKMesCierre" name="CHKMesCierre" value="1" tabindex="12">
			</td>
			<td colspan="2"><label for="CHKMesCierre">Cierre Anual</label></td>
		  </tr>
		  <tr>
			<td nowrap><input type="checkbox" id="chkResumido" name="chkResumido" <cfif isdefined("form.chkResumido")>checked</cfif> value="1" title="Histórico de Contabilidad (Resumido)" tabindex="12"></td>
			<td colspan="2" nowrap><label for="chkResumido">Resumido</label></td>
		  </tr>
	  </table></td>
	</tr>
	<tr>
	  <td align="right" nowrap>&nbsp;</td>
	  <td nowrap><div align="right">&nbsp;</div></td>
	</tr>
	<tr> 
	  <td nowrap> 
		<div align="right"></div>
	  </td>
	  <td nowrap>&nbsp;</td>
	  <td nowrap>
	  <td >&nbsp;</td>
	  <td >&nbsp;</td> 
	</tr>
	<tr> 
	  <td colspan="5"> 
		<div align="center"> 
		  <input type="submit" name="Submit" value="Consultar" tabindex="13">&nbsp;
		  <input type="Reset" name="Limpiar" value="Limpiar" tabindex="14">
		</div>
	  </td>
	</tr>
	<tr> 
	  <td>&nbsp;</td>
	  <td> 
		<div align="right"></div>
	  </td>
	  <td colspan="3">&nbsp;</td>
	</tr>
  </table>
	
	<cf_web_portlet_end>
</form>
<cf_templatefooter>

<cf_qforms>
    <cf_qformsRequiredField name="Ccuenta1" description="Cuenta Inicial">
	<cf_qformsRequiredField name="Ccuenta2" description="Cuenta Final">
</cf_qforms>
<cfif isdefined("form.CFcuenta1") and LEN(TRIM(form.CFcuenta1))>
	<cfoutput>
		<script language="javascript" type="text/javascript">
			document.form1.CFcuenta1.value = #form.CFcuenta1#;
		</script>
	</cfoutput>
</cfif>
<cfif isdefined("form.CFcuenta2") and LEN(TRIM(form.CFcuenta2))>
	<cfoutput>
		<script language="javascript" type="text/javascript">
			document.form1.CFcuenta2.value = #form.CFcuenta2#;
		</script>
	</cfoutput>
</cfif>

	
<cffunction name="fnDatosHistoricoContabilidad" output="no" access="private">
	<cfquery datasource="#Session.DSN#" name="rsOficinas">
		select Ocodigo, Odescripcion
		from Oficinas 
		where Ecodigo = #Session.Ecodigo# 
		order by Ocodigo 
	</cfquery>
	
	<cfquery name="rsMonedas" datasource="#Session.DSN#">
		select Mcodigo as Mcodigo, Mnombre, Msimbolo, Miso4217, ts_rversion 
		from Monedas
		where Ecodigo = #Session.Ecodigo#
	</cfquery>
	
	<cfquery name="rsPeriodosProcesados" datasource="#Session.DSN#">
		select distinct Speriodo
		from CGPeriodosProcesados pp
		where pp.Ecodigo = #Session.Ecodigo#
		order by Speriodo desc
	</cfquery>
	
	<cfset longitud = len(Trim(rsMonedas.Miso4217))>
	
	<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
		select a.Mcodigo, b.Mnombre, b.Msimbolo, b.Miso4217
		from Empresas a
			inner join Monedas b
			on b.Mcodigo = a.Mcodigo
		where a.Ecodigo = #Session.Ecodigo#
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
	
	<cfif isdefined("form.mes") and len(trim(form.mes))>
		<cfset mes = form.mes>
	<cfelse>
		<cfset periodo= get_val(30).Pvalor>
	</cfif>
	
	<cfif isdefined("form.mes2") and len(trim(form.mes2))>
		<cfset mes = form.mes2>
	<cfelse>
		<cfset mes    = get_val(40).Pvalor>
	</cfif>

	<cfif isdefined("form.CFcuenta1") and LEN(TRIM(form.CFcuenta1))>
		<cfquery name="rsCuenta" datasource="#session.DSN#">
			select Ccuenta, rtrim(CFformato) as CFformato, CFdescripcion
			from CFinanciera cf
		where CFcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFcuenta1#">
		</cfquery>
	</cfif>
	<cfif isdefined("form.CFcuenta2") and LEN(TRIM(form.CFcuenta2))>
		<cfquery name="rsCuenta2" datasource="#session.DSN#">
			select Ccuenta, rtrim(CFformato) as CFformato, CFdescripcion
			from CFinanciera cf
			where CFcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFcuenta2#">
		</cfquery>
	</cfif>

</cffunction>
<!---modo--->
<cfset modo = 'ALTA'>
	<cfif isdefined("form.CxCGid") and len(trim(form.CxCGid))>
		<cfset modo = 'CAMBIO' >
	</cfif>
	<cfif isdefined("url.CxCGid") and len(trim(url.CxCGid))>
		<cfset form.CxCGid=#url.CxCGid#>
		<cfset modo = 'CAMBIO' >
	</cfif>
	<!---Transacciones documento-debito--->
	<cfquery name="transacciones" datasource="#session.dsn#">
		select CCTcodigo,CCTdescripcion 
		from CCTransacciones
		where CCTtipo= 'D' 
		and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
		and CCTvencim <>-1
	</cfquery>

	<cfif isdefined ('transacciones') and transacciones.recordCount LTE 0>
		<cf_errorCode	code = "50157" msg = "No Existen Transacciones de Documento">
	</cfif>

	<!---transacciones pago-credito--->
	<cfquery name="transaccionesR" datasource="#session.dsn#">
		select CCTcodigo,CCTdescripcion 
		from CCTransacciones
		where CCTtipo= 'C' 
		and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
		and CCTpago=1
	</cfquery>

	<cfif isdefined ('transaccionesR') and transaccionesR.recordCount LTE 0>
		<cf_errorCode	code = "50158" msg = "No Existen Transacciones de Recibo">
	</cfif>

	<!---Cuenta depositos en transito--->
		<cfquery name="rsCuentas" datasource="#session.dsn#">
			select Descripcion_Cuenta, ID, CFcuenta  
				from CuentasCxC  
				   where Ecodigo = #Session.Ecodigo#
		</cfquery>

	<cfif rsCuentas.recordcount GT 0>
     	<cfset UsarCatalogoCts = true>
	<cfelse>
		<cfquery name="rsParametroCcuentaTransito" datasource="#session.DSN#">
			select CFcuenta, CFdescripcion
			from Parametros a
			inner join CFinanciera b
				on b.Ccuenta = <cf_dbfunction name="to_number" args="a.Pvalor">
			where Pcodigo = 650
				and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		 <cfif rsParametroCcuentaTransito.recordcount eq ''>
				<cf_errorCode	code = "50159" msg = "La Cuenta Depósitos en Tránsito no está defnida.">
		  </cfif>
        <cfset UsarCatalogoCts = false>
		</cfif>

<!---configuracion cobros Automaticos--->
<cfif modo NEQ "ALTA">
	<cfquery name="rsConsulta" datasource="#session.dsn#">
		select 
			a.CxCGid, 
			a.CxCGdescrip,     
			a.CxCGcod,                  
			a.Ecodigo,         
			a.BMUsucodigo,     
			a.SNCEid,          
			a.SNCDid,          
			a.CCTcodigoD,  
			a.CCTcodigoR,     
			a.ID,          
			a.Ocodigo, 
			a.CFcuenta,
			b.SNCEcodigo, 
			b.SNCEdescripcion, 
			c.SNCDvalor, 
			c.SNCDdescripcion
		 from CxCGeneracion a
			inner join SNClasificacionE b
				on a.SNCEid = b.SNCEid
			inner join SNClasificacionD c
				on a.SNCEid = c.SNCEid
				and a.SNCDid = c.SNCDid
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and   a.CxCGid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CxCGid#">
		order by a.CxCGcod asc
	</cfquery>
</cfif> 
 
<form action="generacion_sql.cfm" method="post" name="form1" id="form1">
	<cfoutput>
		<input name="modo" type="hidden" value="#modo#" />
		<input name="CxCGid" type="hidden" <cfif isdefined ('form.CxCGid')>value="#form.CxCGid#"</cfif> />
		<input name="UsarCatalogoCts" type="hidden" id="UsarCatalogoCts" value="#UsarCatalogoCts#">
	</cfoutput>
	<table width="100%" align="center" summary="Tabla de entrada" border="0">
		<tr>
			<td height="20">
			</td>
		</tr>
		<tr>
			<td align="right">
				<strong>Código:</strong>
			</td>
			<td valign="top" nowrap="nowrap">
				<input tabindex="1" name="codigo" type="text" size="30"  maxlength="5" value="<cfif modo NEQ "ALTA"><cfoutput>#Trim(rsConsulta.CxCGcod)#</cfoutput></cfif>" >
			</td>
		</tr>
		<tr>
			<td align="right">
				<strong>Descripción:</strong>
			</td>
			<td valign="top" nowrap="nowrap">
				<input name="descripcion" type="text" tabindex="1" value="<cfif modo NEQ "ALTA"><cfoutput>#HTMLEditFormat(rsConsulta.CxCGdescrip)#</cfoutput></cfif>" size="50" maxlength="80"  alt="El campo Descripción">
			</td>
		</tr>
		<tr>
			<td valign="top" align="right">
				<strong>Transacción de Documento:</strong>
			</td>
			<td valign="top">
				<select name="transaccionD" tabindex="1" >
					<cfoutput>
						<cfloop query="transacciones">
							<option value="#transacciones.CCTcodigo#" <cfif modo neq "ALTA" and Trim(transacciones.CCTcodigo) eq Trim(rsConsulta.CCTcodigoD)>selected</cfif> >#transacciones.CCTdescripcion#</option>
						</cfloop>
					</cfoutput>
				</select>
			</td>
		</tr>
		<tr>
			<td valign="top" align="right">
				<strong>Transacción de Recibo:</strong>
			</td>
			<td valign="top">
				<select name="transaccionR" tabindex="1" >
					<cfoutput>
						<cfloop query="transaccionesR">
							<option value="#transaccionesR.CCTcodigo#" <cfif modo neq "ALTA" and Trim(transaccionesR.CCTcodigo) eq Trim(rsConsulta.CCTcodigoR)>selected</cfif> >#transaccionesR.CCTdescripcion#</option>
						</cfloop>
					</cfoutput>
				</select>
			</td>
		</tr>
		<tr>
			<td valign="top" align="right">
				<strong>Oficinas:</strong>
			</td>
			<td valign="top">	
				<cfif modo NEQ "ALTA">
					<cf_sifoficinas id = '#rsConsulta.Ocodigo#'>
				<cfelse>
					<cf_sifoficinas>
				</cfif>
			</td>
		</tr>
		<tr>
			<td valign="top" align="right">
				<strong>Cuenta de Depósito en Tránsito:</strong>
			</td>
			<td valign="top">
			<cfif UsarCatalogoCts>
				<select name="cuentas" tabindex="1" >
					<cfoutput>
						<cfloop query="rsCuentas">
							<option value="#rsCuentas.ID#" <cfif modo neq "ALTA" and Trim(rsCuentas.ID) eq Trim(rsConsulta.ID)>selected</cfif> >#rsCuentas.Descripcion_Cuenta#</option>
						</cfloop>
					</cfoutput>
				</select>
				<cfelse>
				<cfoutput>#rsParametroCcuentaTransito.CFdescripcion#</cfoutput>
				
			</cfif>	
			</td>
		</tr>
		<tr>
			<td nowrap="nowrap" align="right">
				<strong>Clasificación: </strong> 
			</td>
			<td>
				<cfif modo NEQ "ALTA">
					<cf_sifSNClasificacion form="form1" tabindex="1" query ='#rsConsulta#'>
				<cfelse>
					<cf_sifSNClasificacion form="form1" tabindex="1">
				</cfif>
			</td>
		</tr>
		<tr>
			<td nowrap="nowrap" align="right">
				<strong>Valor Clasificación:</strong> 
			</td>
			<td>
				<cfif modo NEQ "ALTA">
					<cf_sifSNClasfValores form="form1" tabindex="1" query ='#rsConsulta#' SNCEid ="1" id="SNCDid" name="SNCDvalor" desc="SNCDdescripcion" >
				<cfelse>
					<cf_sifSNClasfValores form="form1" tabindex="1" SNCEid ="1" id="SNCDid" name="SNCDvalor" desc="SNCDdescripcion" >
				</cfif>
			</td>
		</tr>
		<tr>
			<td colspan="6">
				<cf_botones values="Regresar" names=" Regresar" tabindex="1">
				<cf_botones modo="#modo#" tabindex="1">
			</td>
		</tr>
	</table>
</form>	
<cf_qforms form="form1">
<script language="javascript1" type="text/javascript">
	function funcRegresar()
	{
		document.form1.method='post';
		document.form1.action='../catalogos/generacion_sql.cfm';
	}		
		objForm.Oficodigo.description = "Oficina";
		objForm.SNCEcodigo.description = "Clasificación";
		objForm.SNCDvalor.description = "Valor Clasificación";
		
	function habilitarValidacion() 
	{
		objForm.codigo.required = true;
		objForm.descripcion.required = true;
		objForm.Oficodigo.required = true;
		objForm.SNCEcodigo.required = true;
		objForm.SNCDvalor.required = true;
	}
</script>
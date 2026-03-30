<cf_templateheader title="Declaraci&oacute;n Pago de Renta">
	<cf_web_portlet_start titulo="Declaraci&oacute;n Pago de Renta">
	<br>

<cffunction name="get_val" access="public" returntype="query">
	<cfargument name="valor" type="numeric" required="true" default="<!--- Código del Parámetro --->">
	<cfquery datasource="#Session.DSN#" name="rsget_val">
		select ltrim(rtrim(Pvalor)) as Pvalor from Parametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#valor#">
	</cfquery>
	<cfreturn #rsget_val#>
</cffunction>

  <cfset periodo="#get_val(50).Pvalor#">
  <cfset mes="#get_val(60).Pvalor#">

	<cfquery name="rsOficinas" datasource="#session.dsn#">
		select
			Ocodigo,
			Oficodigo,
			Odescripcion
		from  Oficinas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		order by Oficodigo
	</cfquery>

	<cfoutput>
	<form name="form1" action="RDPagoRenta_sql.cfm" method="post">
		<table width="100%" cellpadding="2" cellspacing="0" border="0">

				<tr>
					<td nowrap width="10%">
						<input type="radio" name="tipoResumen" value="1" checked id="tipoResumen1"
							 onClick="javascript: funcCambio('1');" tabindex="1">
						<label for="tipoResumen1" style="font-style:normal; font-variant:normal;">Resumido&nbsp;</label>
						&nbsp;&nbsp;&nbsp;
						<input type="radio" name="tipoResumen" value="2"  id="tipoResumen2"
							onClick="javascript: funcCambio('2');" tabindex="1">
						<label for="tipoResumen2" style="font-style:normal; font-variant:normal;">Detallado por Documento</label>
					</td>
				</tr>

				<tr>
					<td>&nbsp;</td>
					<td align="left"><strong>Desde:&nbsp;</strong></td>

					 <td align="left"><strong>Hasta:&nbsp;</strong></td>
					  <td align="left">&nbsp;</td>

					<td colspan="2">&nbsp;</td>
				</tr>

				<tr>
				  <td>&nbsp;</td>
				  <td align="left" nowrap="nowrap"><select name="periodo">
                    <option value="<cfoutput>#periodo-2#</cfoutput>"><cfoutput>#periodo-2#</cfoutput></option>
                    <option value="<cfoutput>#periodo-1#</cfoutput>"><cfoutput>#periodo-1#</cfoutput></option>
                    <option value="<cfoutput>#periodo#</cfoutput>" selected><cfoutput>#periodo#</cfoutput></option>
                    <option value="<cfoutput>#periodo+1#</cfoutput>"><cfoutput>#periodo+1#</cfoutput></option>
                    <option value="<cfoutput>#periodo+2#</cfoutput>"><cfoutput>#periodo+2#</cfoutput></option>
                  </select>
				    <select name="mes" size="1">
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
                    </select></td>
				  <td align="left" nowrap="nowrap"><select name="periodo2">
                    <option value="<cfoutput>#periodo-2#</cfoutput>"><cfoutput>#periodo-2#</cfoutput></option>
                    <option value="<cfoutput>#periodo-1#</cfoutput>"><cfoutput>#periodo-1#</cfoutput></option>
                    <option value="<cfoutput>#periodo#</cfoutput>" selected><cfoutput>#periodo#</cfoutput></option>
                    <option value="<cfoutput>#periodo+1#</cfoutput>"><cfoutput>#periodo+1#</cfoutput></option>
                    <option value="<cfoutput>#periodo+2#</cfoutput>"><cfoutput>#periodo+2#</cfoutput></option>
                  </select>
				    <select name="mes2" size="1">
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
                    </select></td>
				  <td align="left">&nbsp;</td>
				  <td colspan="2">&nbsp;</td>
			   </tr>
				<tr>
					<td align="right"><strong>Oficina:</strong></td>
					<td>
						<select name="Ocodigo" tabindex="1">
								<option value="-1">---Todas---</option>
							<cfloop query="rsOficinas">
								<option value="#Ocodigo#">#Oficodigo#-#Odescripcion#</option>
							</cfloop>
						</select>
					</td>
				</tr>

				<tr id="ProveedorEnc">
					<td>&nbsp;</td>
					<td align="left"><strong>Proveedor Desde:&nbsp;</strong></td>

					 <td align="left"><strong>Proveedor Hasta:&nbsp;</strong></td>
					  <td align="left">&nbsp;</td>

					<td colspan="2">&nbsp;</td>
				</tr>
				<tr id="ProveedorDet">
				  <td>&nbsp;</td>
				  <td align="left" nowrap="nowrap">
						<cf_sifsociosnegocios2 Proveedores="SI" form="form1" SNcodigo="SNcodigo" SNumero="SNumero" SNdescripcion="SNdescripcion" size = "40" tabindex="1" SNnombre="SNnombre" SNnumero="SNnumero">
				  </td>
				  <td align="left" nowrap="nowrap">
						<cf_sifsociosnegocios2 Proveedores="SI" form="form1" SNcodigo="SNcodigo1" SNumero="SNumero1" SNdescripcion="SNdescripcion1" size = "40" tabindex="2" SNnombre="SNnombre1" SNnumero="SNnumero1">
					</td>
				  <td align="left">&nbsp;</td>
				  <td colspan="2">&nbsp;</td>
			    </tr>
               	<tr id="ProveedorCero">
					<td>&nbsp;</td>
					<td align="left"><strong>Proveedores sin renta:</strong><input type="checkbox" name="SaldoCero" id="SaldoCero" /></td>

					 <td align="left">&nbsp;</td>
					  <td align="left">&nbsp;</td>

					<td colspan="2">&nbsp;</td>
				</tr>

					<td colspan="6">
					<cf_botones values="Generar" names="Generar"></td>
				</tr>
        </table>
    </form>
    </cfoutput>

<script language="JavaScript" type="text/javascript">
	function funcCambio(parmvalor){
		var ProveedorEnc  = document.getElementById("ProveedorEnc");
		var ProveedorDet  = document.getElementById("ProveedorDet");
		var ProveedorCero = document.getElementById("ProveedorCero");
		ProveedorEnc.style.display = "";
		ProveedorDet.style.display = "";
		ProveedorCero.style.display = "";
	if(parmvalor=="1"){
			ProveedorEnc.style.display  = "none";
			ProveedorDet.style.display = "none";
			ProveedorCero.style.display = "none";
		}else if(parmvalor=="2"){
			ProveedorEnc.style.display = "";
			ProveedorDet.style.display = "";
			ProveedorCero.style.display = "";
		}
	}
		funcCambio(1);
	</script>
	<cf_web_portlet_end>
<cf_templatefooter>


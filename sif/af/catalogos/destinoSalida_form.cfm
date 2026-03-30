<cfif isdefined("form.AFDcodigo") and len(trim(form.AFDcodigo))>
	<cfquery name="rsForm" datasource="#session.dsn#">
		select
			a.Ecodigo,
			a.AFDSid,
			a.AFDcodigo,
			a.AFDdescripcion,
			a.AFDAtencion,
			a.AFDdireccion1,
			a.AFDdireccion2,
			a.AFDciudad,
			a.AFDestado,
			a.AFDcodigo_postal,
			a.Ppais,
			a.AFDtelefono,
			a.AFDfax,
			a.AFDcorreo_electronico,
            a.ts_rversion
		from AFDestinosSalida a
			where a.Ecodigo = #session.Ecodigo#
			and  a.AFDcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.AFDcodigo#">
	</cfquery>
	<cfset modo = "CAMBIO">
<cfelse>
	<cfset modo = "ALTA">
</cfif>

<cfquery name="rsPaises" datasource="asp">
	select Ppais, Pnombre
	from Pais
</cfquery>

<cfoutput>
	<fieldset>
	<legend><strong>Destino Salida</strong>&nbsp;</legend>
		<form action="destinoSalida_SQL.cfm" method="post" name="form1"
        onSubmit="javascript: document.form1.AFDcodigo.disabled = false; validar(this);">

			<table width="80%" align="center" border="0" >
				<tr>
					<td align="left"><strong>Destino:</strong></td>
					<td colspan="2">
                <input name="AFDcodigo" <cfif modo NEQ "ALTA"> class="cajasinbordeb" readonly tabindex="-1" <cfelse>
						tabindex="1"</cfif> type="text" value="<cfif modo NEQ "ALTA">#rsForm.AFDcodigo#<cfelseif isdefined('rsForm.AFDcodigo')>#rsForm.AFDcodigo#</cfif>"
						size="10" maxlength="10" />
					</td>
				</tr>
				<tr>
					<td align="left"><strong>Descripci&oacute;n:</strong></td>
					<td colspan="2">
					<input type="text" name="AFDdescripcion" maxlength="100" size="50" id="AFDdescripcion" tabindex="1" style="border-spacing:inherit" value="<cfif modo NEQ 'ALTA'>#trim(rsForm.AFDdescripcion)#</cfif>" />
					</td>
				</tr>
				<tr>
					<td class="titulolistas" colspan="3" align="center">
						<strong>Dirección</strong>
					</td>
				</tr>
				<tr>
					<td align="left"><strong>Atenci&oacute;n a:</strong></td>
					<td colspan="2">
					<input type="text" name="AFDAtencion" maxlength="100" size="50" id="AFDAtencion" tabindex="1" style="border-spacing:inherit" value="<cfif modo NEQ 'ALTA'>#trim(rsForm.AFDAtencion)#</cfif>" />
					</td>
				</tr>
				<tr>
					<td align="left"><strong>Direcci&oacute;n 1:</strong></td>
					<td colspan="2">
					<input type="text" name="AFDdireccion1" maxlength="100" size="50" id="AFDdireccion1" tabindex="1" style="border-spacing:inherit" value="<cfif modo NEQ 'ALTA'>#trim(rsForm.AFDdireccion1)#</cfif>" />
					</td>
				</tr>
				<tr>
					<td align="left"><strong>Direcci&oacute;n 2:</strong></td>
					<td colspan="2">
					<input type="text" name="AFDdireccion2" maxlength="100" size="50" id="AFDdireccion1" tabindex="1" style="border-spacing:inherit" value="<cfif modo NEQ 'ALTA'>#trim(rsForm.AFDdireccion2)#</cfif>" />
					</td>
				</tr>
				<tr>
					<td align="left"><strong>Ciudad:</strong></td>
					<td colspan="2">
					<input type="text" name="AFDciudad" maxlength="100" size="30" id="AFDciudad" tabindex="1" style="border-spacing:inherit" value="<cfif modo NEQ 'ALTA'>#trim(rsForm.AFDciudad)#</cfif>" />
					</td>
				</tr>
				<tr>
					<td align="left"><strong>Estado:</strong></td>
					<td colspan="2">
					<input type="text" name="AFDestado" maxlength="100" size="30" id="AFDestado" tabindex="1" style="border-spacing:inherit" value="<cfif modo NEQ 'ALTA'>#trim(rsForm.AFDestado)#</cfif>" />
					</td>
				</tr>
				<tr>
					<td align="left"><strong>Codigo Postal:</strong></td>
					<td colspan="2">
					<input type="text" name="AFDcodigo_postal" maxlength="10" size="30" id="AFDcodigo_postal" tabindex="1" style="border-spacing:inherit" value="<cfif modo NEQ 'ALTA'>#trim(rsForm.AFDcodigo_postal)#</cfif>" />
					</td>
				</tr>
				<tr>
					<td align="left"><strong>Pa&iacute;s:</strong></td>
					<td colspan="2">
					<select name="Ppais" id="Ppais">
		            	<option value="">- No especificado -</option>
		            	<cfloop query="rsPaises">
		              		<option value="#rsPaises.Ppais#" <cfif modo NEQ 'ALTA' and rsPaises.Ppais EQ rsForm.Ppais>selected</cfif>>#HTMLEditFormat(rsPaises.Pnombre)#</option>
						</cfloop>
		          	</select></td>
					</td>
				</tr>
				<tr>
					<td align="left"><strong>Telefono:</strong></td>
					<td colspan="2">
					<input type="text" name="AFDtelefono" maxlength="100" size="50" id="AFDtelefono" tabindex="1" style="border-spacing:inherit" value="<cfif modo NEQ 'ALTA'>#trim(rsForm.AFDtelefono)#</cfif>" />
					</td>
				</tr>
				<tr>
					<td align="left"><strong>Fax:</strong></td>
					<td colspan="2">
					<input type="text" name="AFDfax" maxlength="100" size="50" id="AFDfax" tabindex="1" style="border-spacing:inherit" value="<cfif modo NEQ 'ALTA'>#trim(rsForm.AFDfax)#</cfif>" />
					</td>
				</tr>
				<tr>
					<td align="left"><strong>Correo electrónico:</strong></td>
					<td colspan="2">
					<input type="text" name="AFDcorreo_electronico" maxlength="100" size="50" id="AFDcorreo_electronico" tabindex="1" style="border-spacing:inherit" value="<cfif modo NEQ 'ALTA'>#trim(rsForm.AFDcorreo_electronico)#</cfif>" />
					</td>
				</tr>
				<tr valign="baseline">
					<td colspan="3" align="center" nowrap>
						<cfif isdefined("form.AFDcodigo")>
							<cf_botones modo="#modo#" exclude = "baja" tabindex="7">
						<cfelse>
							<cf_botones modo="#modo#" tabindex="7">
						</cfif>
					</td>
				</tr>
			</table>
			<cfset ts = "">
            <cfif modo NEQ "ALTA">
                <cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" artimestamp="#rsForm.ts_rversion#" returnvariable="ts">
                </cfinvoke>
                <input type="hidden" name="AFDSid" value="#rsForm.AFDSid#" >
                <input type="hidden" name="ts_rversion" value="#ts#" >
            </cfif>
		</form>
	</fieldset>
</cfoutput>

<cfoutput>
	<cf_qforms form="form1">
	<script language="javascript1" type="text/javascript">
		objForm.AFDdescripcion.description = "Descripción";

		objForm.AFDdescripcion.required = true;

		<cfif modo EQ 'ALTA'>
			objForm.AFDcodigo.required      = true;
		</cfif>

	function validar(form){
		var email = document.getElementById("AFDcorreo_electronico").value;

		if (email ==""){
		    return true;
		}
		else{
			if(/^([a-zA-Z0-9_.-])+@([a-zA-Z0-9_.-])+\.([a-zA-Z])+([a-zA-Z])+/.test(email)){
		    	return true;
		    }
		    else{
		    	alert("Direccion de correo no valida");
		    	return false;
		    }
		}
	}

	</script>
</cfoutput>
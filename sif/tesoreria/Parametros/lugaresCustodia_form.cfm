<cfparam name="url.TESCFLUid" default="">

<!--- <cfdump var="#form#">
<cfdump var="#url#"> --->
<cfif isdefined("url.TESCFLUid") and len(trim(url.TESCFLUid))>
	<cfquery datasource="#session.dsn#" name="rsdata">
		select 
			TESid,                          
			TESCFLUid,               
			TESCFLUcodigo,      
			TESCFLUdescripcion, 
			BMUsucodigo        
		  from TESCFlugares
		 where TESid 		= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#session.tesoreria.TESid#"> <!--- null="#Len(session.Tesoreria.TESid) Is 0#" --->
		   and TESCFLUid 	= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#url.TESCFLUid#"><!--- null="#Len(url.TESCFLid) Is 0#" --->
	</cfquery>
<!--- <cf_dump var="#rsdata#"> --->
</cfif>
<cfif isdefined("rsdata")>
	<cfset CAMBIO = rsdata.RecordCount>
<cfelse>
	<cfset CAMBIO = 0>
</cfif>


<style type="text/css">
<!--
.SinBorde {
 	border:none;
}
-->
</style>


<cfoutput>
<script type="text/javascript">
<!--
	function validar(formulario)
	{
		var error_input;
		var error_msg = '';
		// Validando tabla: TESCFlugares - Tipos de Endosos
				// Columna: TESid ID Tesoreria numeric
				if (formulario.TESid.value == "") {
					error_msg += "\n - ID Tesoreria no puede quedar en blanco.";
					error_input = formulario.TESid;
				}
				
				// Columna: TESCFLUcodigo Código char(10)
				if (formulario.TESCFLUcodigo.value == "") {
					error_msg += "\n - Código no puede quedar en blanco.";
					error_input = formulario.TESCFLUcodigo;
				}

				// Columna: TESCFLdescripcion Descripcion varchar(40)
				if (formulario.TESCFLdescripcion.value == "") {
					error_msg += "\n - Descripcion no puede quedar en blanco.";
					error_input = formulario.TESCFLdescripcion;
				}
		// Validacion terminada
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			error_input.focus();
			return false;
		}
		return true;
	}
//-->
</script>

<form action="lugaresCustodia_sql.cfm" onsubmit="return validar(this);" method="post" name="form1" id="form1">
	<table summary="Tabla de entrada" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td align="center" colspan="2" class="tituloListas">
			    Lugar de Custodia
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td align="right" valign="top" nowrap><strong>C&oacute;digo:</strong>&nbsp;</td>
			<td valign="top">
				<input name="TESCFLUcodigo" type="text"  tabindex="1"
					value="<cfif CAMBIO>#HTMLEditFormat(rsdata.TESCFLUcodigo)#</cfif>">
			</td>
		</tr>
		<tr>
			<td align="right" valign="top" nowrap><strong>Descripci&oacute;n&nbsp;del&nbsp;Lugar:</strong>&nbsp;</td>
			<td valign="top">
				<input name="TESid" id="TESid" type="hidden"
					value="#HTMLEditFormat(session.Tesoreria.TESid)#" maxlength="10" size="10">
				<cfif CAMBIO>
					<input name="TESCFLUid" id="TESCFLUid" type="hidden" value="#HTMLEditFormat(rsdata.TESCFLUid)#">
				</cfif>
				<input name="TESCFLdescripcion" id="TESCFLdescripcion" type="text" tabindex="1"maxlength="255" size="60" 
					value="<cfif CAMBIO>#HTMLEditFormat(rsdata.TESCFLUdescripcion)#</cfif>" 
					onfocus="this.select()">
				
			</td>
		</tr>
		<tr>
			<td colspan="2" class="formButtons">
			<cfif isdefined("rsdata") and rsdata.RecordCount>
				<cf_botones modo='CAMBIO' tabindex="1">
			<cfelse>
				<cf_botones modo='ALTA' tabindex="1">
			</cfif>
			</td>
		</tr>
	</table>
</form>
</cfoutput>
<script language="javascript" type="text/javascript">
	<cfif isdefined('rsdata') and rsdata.RecordCount>
		document.form1.TESCFLUcodigo.focus();		
	<cfelse>
		document.frmTES.TESid.focus();
	</cfif>
</script>
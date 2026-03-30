
<cfoutput>
<form name="form1" method="post" action="upload-reporte-sql.cfm" enctype="multipart/form-data" onSubmit="javascript: return confirmar();">
	<table width="100%" border="0" cellpadding="2" cellspacing="0">
		<cfif isdefined("url.ok") or isdefined("url.error")>
			<tr id="mensaje">
				<td colspan="2" align="center">
					<table  class="navbar" width="50%" align="center">
						<tr>
							<td align="center"><a title="#vEliminar#" onClick="javascript: document.getElementById('mensaje').style.display='none';"><strong><cfif isdefined("url.ok")>#vok#<cfelse><cfif isdefined("url.codigo_error") and url.codigo_error eq 2>#verror2#<cfelse>#verror#</cfif></cfif></strong></a></td>
						</tr>
					</table>
				</td>
			</tr>
		</cfif>
		
		<tr>
			<td align="right" width="42%"><strong>#vCodigo#:</strong></td>
			<td><input type="text" name="codigo" 		value=""  maxlength="5" size="10" ></td>
		</tr>
		<tr>
			<td align="right"><strong>#vDescripcion#:</strong></td>
			<td><input type="text" name="descripcion" value="" maxlength="100" size="35" ></td>
		</tr>
		<tr>
			<td align="right"><strong>#vArchivo#:</strong></td>
			<td><input type="file" name="archivo" value="" size="41" ></td>
		</tr>	
		<tr>
			<td align="right"><strong>#vSistema#:</strong></td>
			<td>
				<select name="sistema">
					<option value="">-- #vseleccionar# --</option>
					<option value="RH">RH - Recursos Humanos</option>
					<option value="SIF">SIF - Sistema Financiero Integral</option>					
				</select>
			</td>
		</tr>
		<tr>
			<td align="right"><strong>#vCategoria#:</strong></td>
			<td>
				<select name="categoria">
					<option value="">-- #vseleccionar# --</option>
					<option value="empleados">#vEmpleados#</option>
					<option value="estructura">#vEstructura#</option>
					<option value="nomina">#vNomina#</option>
					<option value="parametros">#vParametros#</option>					
				</select>
			</td>
		</tr>
		<tr>
			<td></td>
			<td>
				<table cellspacing="0" cellpadding="1">
					<tr>
						<td><input type="checkbox" id="RHRURparametros" name="RHRURparametros" value="0" /></td>
						<td><label for="RHRURparametros">#vReqParametros#</label></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr><td colspan="2" align="center"><cf_botones values="Upload" valuesnames="btnUpload" ></td></tr>
	</table>
	<input type="hidden" name="nombre_archivo" value="" >
</form>
</cfoutput>
<cf_qforms>


<script type="text/javascript" language="javascript1.2">
	function funcUpload(){
		document.form1.nombre_archivo.value = document.form1.archivo.value;
		return true;
	}

	function confirmar(){
		if ( confirm('<cfoutput>#vseguro#</cfoutput>') ){
			return true;
		}
		document.form1.nombre_archivo.value = '';
		return false;
	}

	// QFORMS
	<cfoutput>
	objForm.codigo.required = true;
	objForm.codigo.description = '#replace(vCodigo, "&oacute;", "ó", "all")#';
	objForm.descripcion.required = true;
	objForm.descripcion.description = '#replace(vdescripcion, "&oacute;", "ó", "all")#';
	objForm.archivo.required = true;
	objForm.archivo.description = '#varchivo#';
	objForm.sistema.required = true;
	objForm.sistema.description = '#vsistema#';
	objForm.categoria.required = true;
	objForm.categoria.description = '#replace(vcategoria, "&iacute;", "ó", "all")#';
	</cfoutput>
</script>
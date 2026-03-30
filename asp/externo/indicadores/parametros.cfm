<cfset modoAux = 'ALTA'>
<cfif isdefined("form.parametro") and len(trim(form.parametro))>
	<cfset modoAux = 'CAMBIO'>

	<cfquery name="dataParametro" datasource="asp">
		select parametro, indicador, etiqueta, obligatorio
		from IndicadorParam
		where indicador = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.indicador)#">
		and parametro = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.parametro)#"> 
	</cfquery>
</cfif>

<cfoutput>

<style type="text/css">
	.tituloPersona{
	PADDING-RIGHT: 2px;
	PADDING-LEFT: 2px;
	FONT-WEIGHT: bold;
	FONT-SIZE: 10pt;
	PADDING-BOTTOM: 2px;
	PADDING-TOP: 2px;
	FONT-FAMILY: Tahoma, sans-serif;
	BACKGROUND-COLOR: ##cccccc;
	TEXT-ALIGN: right; }
</style>


<table width="95%" cellpadding="2" cellspacing="0">
	<tr><td align="center" colspan="3" class="tituloPersona" style="text-align:center;">Par&aacute;metros</td></tr>

	<form style="margin:0;" name="form2" method="post" action="indicador-sql.cfm" onSubmit="return validarParametros(this);">
		<!--- Sistema --->
		<tr>
			<td align="right" class="etiquetaCampo">Par&aacute;metro:&nbsp;</td>
			<td>
				<input type="text" size="30" maxlength="30" name="parametro"  value="<cfif modoAux neq 'ALTA'>#trim(form.parametro)#</cfif>">
				<cfif modoAux neq 'ALTA'>
					<input type="hidden" name="_parametro" value="#trim(form.parametro)#">
				</cfif>
			</td>
		</tr>
		<tr>
			<td align="right" class="etiquetaCampo">Etiqueta:&nbsp;</td>
			<td><input type="text" size="30" maxlength="60" name="etiqueta" value="<cfif modoAux neq 'ALTA'>#dataParametro.etiqueta#</cfif>"></td>
		</tr>

		<tr>
			<td align="right" class="etiquetaCampo"></td>
			<td>
				<table width="100%" cellpadding="0" cellspacing="0">
					<tr>
						<td width="1"><input type="checkbox" name="obligatorio" <cfif modoAux neq 'ALTA' and dataParametro.obligatorio eq 1>checked</cfif> ></td>
						<td>Obligatorio</td>
					</tr>
				</table>
			</td>
		</tr>

		<tr>
			<td align="center" colspan="2">
				<cfif modoAux neq 'ALTA'>
					<input type="submit" name="btnModificarParametro" value="Modificar" onClick="javascript:valida = true;">
					<input type="submit" name="btnNuevo" value="Nuevo" onClick="javascript:valida = true;">
				<cfelse>	
					<input type="submit" name="btnAgregarParametro" value="Agregar" onClick="javascript:valida = true;">
				</cfif>
			</td>
		</tr>
		
		<input type="hidden" name="indicador" value="#form.indicador#">
		
		<cfquery name="dataParametros" datasource="asp">
			select parametro,etiqueta
			from IndicadorParam
			where indicador = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.indicador)#">
		</cfquery>

		<tr><td align="center" colspan="4" >
			<table width="85%" border="0" align="center" cellpadding="2" cellspacing="0">
				<tr>
					<td class="tituloListas" >Par&aacute;metro</td>
					<td class="tituloListas" >Etiqueta</td>
					<td colspan="2" class="tituloListas"></td>
				</tr>
				<cfif dataParametros.recordCount gt 0>
					<cfloop query="dataParametros">
					<tr class="<cfif dataParametros.currentRow mod 2>listaPar<cfelse>listaNon</cfif>" >
						<td>#dataParametros.parametro#</td>
						<td>#mid(dataParametros.etiqueta,1,15)#</td>
						<td width="1" align="right">
							<input type="image" name="btnModificarParametro" src="../../imagenes/Documentos2.gif" onClick="javascript:return modificar('#trim(dataParametros.parametro)#');" >
						</td>
						<td width="1" align="right">
							<input type="image" name="btnEliminarParametro" src="../../imagenes/delete.gif" onClick="javascript:return eliminar('#trim(dataParametros.parametro)#');" >
						</td>
					</tr>
					</cfloop>
				<cfelse>
					<tr><td align="center" colspan="2"><strong>-- No se encontraron registros --</strong></td></tr>
				</cfif>
			</table>	
		</td></tr>	
	</form>		
</table>

<script type="text/javascript" language="javascript1.2" src="../menu/utilesMonto.js"></script>
<script type="text/javascript" language="javascript1.2">
	var valida = true;

	function eliminar(parametro){
		valida = false;
		if ( confirm('Desea eliminar el registro?') ){
			document.form2.onSubmit = '';
			document.form2.parametro.value = parametro;
			document.form2.submit();
			return true;
		}
		return false;
	}

	function modificar(parametro){
		valida = false;
		document.form2.action = '';
		document.form2.onSubmit = '';
		document.form2.parametro.value = parametro;
		document.form2.submit();
		return true;
	}
	
	function validarParametros(form){
		if ( valida ){
			var error = false;
			var mensaje = 'Se presentaron los siguientes errores:\n';
			
			if ( trim(form.parametro.value) == '' ){
				error = true;
				mensaje += ' - El campo Parámetro es requerido.\n'
			}
		
			if ( error ){
				alert(mensaje);
			}
			return !error;
		}
	}
</script>

</cfoutput>

<form action="agrupador_sql.cfm"  method="post"  name="form1" id="form1" style= "margin: 0;">

<table align="center"  width="100%" border="0">	
		<!---Transaccion de Documento--->
		<tr>
			<td valign="top" align="right"><strong>Transacción de Documento:</strong></td>
			<td valign="top">
			Generación de Recibos

			</td>
		</tr>
<cfoutput>
		<!---Descripción--->
		<tr>
			<td  align="right"><strong>Inicio de Consecutivo:</strong></td>
			<td valign="top" nowrap="nowrap" align="left">
				<cf_inputNumber name="inicio" size="15" enteros="3" decimales="0">
			</td>
		</tr>

		<!---Prefijo--->
		<tr>
			<td nowrap="nowrap"  align="right"><strong>Prefijo:</strong></td> 
			<td>
				<input type="text" name="pref" maxlength="5"  height="25">
			</td> 				
		</tr>
				
		<!---Ceros--->
		<tr>
			<td nowrap="nowrap"  align="right"><strong>Ceros a la izquierda:</strong></td> 
			<td>
				<cf_inputNumber name="ceros" size="15" enteros="2" decimales="0">
			</td> 				
		</tr>
	</cfoutput>
	<cfoutput>
		<tr>
			<td>&nbsp;</td>
			<td align="center" nowrap="nowrap" valign="top" colspan="5">
					<input type="submit"  value="Agrega" name="AgregaP" id="Agregar" onClick="javascript: habilitarValidacion(); "/>
					<input type="reset" name="Limpiar" value="Limpiar" onClick="javascript: inhabilitarValidacion(); " >		
					<input type="submit"  value="Regresar" name="irListaP" id="irLista" onClick="javascript: inhabilitarValidacion(); "/>				
			</td>
		</tr>
	</table>
    </cfoutput>
</form>


<!---ValidacionesFormulario--->
<cf_qforms>
<script language="javascript" type="text/javascript">

	function inhabilitarValidacion() {
		
		objForm.inicio.required = false;	
		objForm.pref.required = false;		
		objForm.ceros.required = false;		
	}

	function habilitarValidacion() {
		objForm.inicio.required = true;	
		objForm.pref.required = true;		
		objForm.ceros.required = true;	
	}

	objForm.inicio.description = "Inicio de Consecutivo";
	objForm.pref.description = "Prefijo";
	objForm.ceros.description = "Cantidad de ceros";
	
	function Reporte(){
		//document.form1.action = 'VRreporte_form.cfm'			
	}
</script>



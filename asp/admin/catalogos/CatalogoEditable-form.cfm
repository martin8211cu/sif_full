<cfparam name="url.tabla" default="">

<cfquery datasource="asp" name="data">
	select *
	from  CatalogoEditable
		where tabla = <cfqueryparam cfsqltype="cf_sql_char" value="#url.tabla#" null="#Len(url.tabla) Is 0#">
</cfquery>

<cfoutput>

<script type="text/javascript">
<!--
	function validar(formulario)
	{
		var error_input;
		var error_msg = '';
		// Validando tabla: CatalogoEditable - CatalogoEditable
		// Columna: tabla Tabla varchar(30)
		if (formulario.tabla.value == "") {
			error_msg += "\n - Tabla no puede quedar en blanco.";
			error_input = formulario.tabla;
		}
		// Columna: descripcion Descripción varchar(255)
		if (formulario.descripcion.value == "") {
			error_msg += "\n - Descripción no puede quedar en blanco.";
			error_input = formulario.descripcion;
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

<form action="CatalogoEditable-apply.cfm" onsubmit="return validar(this);" method="post" name="form1" id="form1">
	<table summary="Tabla de entrada">
	<tr>
	  <td colspan="2" class="subTitulo">
	Informaci&oacute;n sobre el cat&aacute;logo</td>
	</tr>
	
		<tr><td valign="top">Tabla
		</td><td valign="top">
		
			<input name="tabla" id="tabla" type="text" value="#HTMLEditFormat(data.tabla)#" 
				maxlength="30" 
				onfocus="this.select()"  <cfif Len(data.tabla)>readonly</cfif> >
		
		</td></tr>
		
		<tr><td valign="top">Descripción
		</td><td valign="top">
		
			<input name="descripcion" id="descripcion" type="text" value="#HTMLEditFormat(data.descripcion)#" 
				maxlength="255"
				onfocus="this.select()"  >
		
		</td></tr>
	<tr><td colspan="2" class="formButtons">
		<cfif data.RecordCount>
			<cf_botones modo='CAMBIO'>
		<cfelse>
			<cf_botones modo='ALTA'>
		</cfif>
	</td></tr>
	</table>
			<input type="hidden" name="BMfecha" value="#HTMLEditFormat(data.BMfecha)#">
			<input type="hidden" name="BMUsucodigo" value="#HTMLEditFormat(data.BMUsucodigo)#">
			<cfset ts = "">
			<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
				artimestamp="#data.ts_rversion#" returnvariable="ts">
			</cfinvoke>
			<input type="hidden" name="ts_rversion" value="#ts#">
</form>

</cfoutput>



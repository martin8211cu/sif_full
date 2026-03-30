<cfparam name="url.esquema" default="">
<cfquery datasource="asp" name="data">
	select esquema, nombre, datasource, ts_rversion
	from  APEsquema
	where esquema =
		<cfqueryparam cfsqltype="cf_sql_char" value="#url.esquema#" null="#Len(url.esquema) Is 0#">
	</cfquery>
<cfoutput>

<script type="text/javascript">
<!--
	function validar(formulario)
	{
		var error_input;
		var error_msg = '';
		formulario.esquema.value = formulario.esquema.value.toUpperCase();
		// Validando tabla: APEsquema - APEsquema 
				// Columna: esquema Esquema donde ejecutar char(3)
				if (formulario.esquema.value == "") {
					error_msg += "\n - Esquema donde ejecutar no puede quedar en blanco.";
					error_input = formulario.esquema;
				}
			
				// Columna: nombre Nombre del esquema varchar(60)
				if (formulario.nombre.value == "") {
					error_msg += "\n - Nombre del esquema no puede quedar en blanco.";
					error_input = formulario.nombre;
				}
			
				// Columna: datasource Datasource principal varchar(60)
				if (formulario.datasource.value == "") {
					error_msg += "\n - Datasource principal no puede quedar en blanco.";
					error_input = formulario.datasource;
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

<form action="APEsquema-apply.cfm" onsubmit="return validar(this);" method="post" name="form1" id="form1">
	<table summary="Tabla de entrada">
	<tr><td colspan="2" class="subTitulo">
	Datos del esquema
	</td></tr>
	
		<tr><td valign="top">Código de tres letras
		</td><td valign="top">
		
			<input name="esquema" id="esquema" type="text" value="#HTMLEditFormat(data.esquema)#" 
				maxlength="3" onblur="this.value = this.value.toUpperCase()"
				onfocus="this.select()"  >
		
		</td></tr>
		
		<tr><td valign="top">Nombre
		</td><td valign="top">
		
			<input name="nombre" id="nombre" type="text" value="#HTMLEditFormat(data.nombre)#" 
				maxlength="60"
				onfocus="this.select()"  >
		
		</td></tr>
		
		<tr><td valign="top">Datasource principal 
		</td><td valign="top">
		
			<input name="datasource" id="datasource" type="text" value="#HTMLEditFormat(data.datasource)#" 
				maxlength="60"
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
	
	<cfset ts = "">
			<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
				artimestamp="#data.ts_rversion#" returnvariable="ts">
			</cfinvoke>
			<input type="hidden" name="ts_rversion" value="#ts#">
		
</form>

</cfoutput>


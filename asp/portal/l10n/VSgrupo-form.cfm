


<cfparam name="url.VSgrupo" default="">


<cfquery datasource="sifcontrol" name="data">
	select *
	from  VSgrupo
	
		where 
		VSgrupo =
		<cfqueryparam cfsqltype="cf_sql_integer" value="#url.VSgrupo#" null="#Len(url.VSgrupo) Is 0#">
	
</cfquery>

<cfoutput>

<script type="text/javascript">
<!--
	function validar(formulario)
	{
		var error_input;
		var error_msg = '';
		// Validando tabla: VSgrupo - VSgrupo
		
			
			
				// Columna: VSgrupo VSgrupo int
				if (formulario.VSgrupo.value == "") {
					error_msg += "\n - Número no puede quedar en blanco.";
					error_input = formulario.VSgrupo;
				}
			
		
			
			
				// Columna: VSnombre_grupo Nombre de Grupo varchar(30)
				if (formulario.VSnombre_grupo.value == "") {
					error_msg += "\n - Nombre de Grupo no puede quedar en blanco.";
					error_input = formulario.VSnombre_grupo;
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

<form action="VSgrupo-apply.cfm" onsubmit="return validar(this);" method="post" name="form1" id="form1">
	<table summary="Tabla de entrada">
	<tr>
	  <td colspan="2" class="subTitulo">
	Editar Grupo </td>
	</tr>
	
	
		
		
		<tr>
		  <td valign="top">N&uacute;mero</td>
		  <td valign="top">
		
			<input name="VSgrupo" id="VSgrupo" type="text" value="#HTMLEditFormat(data.VSgrupo)#" 
				maxlength="11"
				<cfif Len(data.VSgrupo)>readonly</cfif>
				onfocus="this.select()"  >
		
		</td></tr>
		
	
		
		
		<tr><td valign="top">Nombre </td>
		<td valign="top">
		
			<input name="VSnombre_grupo" id="VSnombre_grupo" type="text" value="#HTMLEditFormat(data.VSnombre_grupo)#" 
				maxlength="30"
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




<cfparam name="url.id_programa" default="">


<cfquery datasource="#session.dsn#" name="data">
	select *
	from  sa_programas
	
		where 
		id_programa =
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_programa#" null="#Len(url.id_programa) Is 0#">
	
</cfquery>

<cfoutput>
<script type="text/javascript">
<!--


	function funcVigencia(){
	<cfif len(data.id_programa)>
		location.href='sa_vigencia.cfm?id_programa=#JSStringFormat(data.id_programa)#';</cfif>
		return false;
	}
	function validar(formulario) {
		var thisinput;
		var error_msg = '';
		// Validando tabla: sa_programas - sa_programas

		// Columna: nombre_programa nombre varchar(60)
		if (formulario.nombre_programa.value == "") {
			error_msg += "\n - El nombre no puede quedar en blanco.";
			thisinput = formulario.nombre_programa;
		}
			
		// Validacion terminada
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			thisinput.focus();
			return false;
		}
		return true;
	}
//-->
</script>

		<form action="sa_programas-apply.cfm" onsubmit="return validar(this);" method="post" name="form1" id="form1">
			<table summary="Tabla de entrada">
			<tr>
			  <td colspan="2" class="subTitulo">
			Registro de Programas </td>
			</tr>
			
			
				
				
					
				
			
				
				
				<tr>
				  <td valign="top">Nombre</td>
				  <td valign="top">&nbsp;
				
				</td></tr>
				
			
				
				
				<tr>
				  <td valign="top"><input name="nombre_programa" id="nombre_programa" type="text" value="#HTMLEditFormat(data.nombre_programa)#" 
						maxlength="60" size="40"
						onFocus="this.select()"  ></td>
				  <td valign="top">&nbsp;</td>
			  </tr>
				<tr>
				  <td valign="top">Descripci&oacute;n</td>
				  <td valign="top">&nbsp;
				
				</td></tr>
				
			
				
				
				<tr>
				  <td valign="top"><textarea rows="6" cols="45" name="descripcion_programa" onFocus="this.select()">#HTMLEditFormat(data.descripcion_programa)#</textarea></td>
				  <td valign="top">&nbsp;</td>
			  </tr>
				<tr>
				  <td valign="top">Caracter&iacute;sticas
				</td>
				  <td valign="top">&nbsp;
				
				</td></tr>
				
			
				
				
					
				
			
				
				
					
				
			
				
				
					
				
			
				
				
					
				
			
				
				
					
				
			
			    <tr>
			      <td class="formButtons"><textarea  rows="6" cols="45" name="caracteristicas_programa" onFocus="this.select()">#HTMLEditFormat(data.caracteristicas_programa)#</textarea></td>
		      <td class="formButtons">&nbsp;</td>
		      </tr>
		      <tr><td colspan="2" class="formButtons">
				<cfif data.RecordCount>
					<cf_botones modo='CAMBIO' include='Vigencia'>
				<cfelse>
					<cf_botones modo='ALTA'>
				</cfif>
			</td></tr>
			</table>
			
			
				
					<input type="hidden" name="id_programa" value="#HTMLEditFormat(data.id_programa)#">
				
			
				
					<cfset ts = "">
      				<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
						artimestamp="#data.ts_rversion#" returnvariable="ts">
      				</cfinvoke>
      				<input type="hidden" name="ts_rversion" value="#ts#">
				
			
				
					<input type="hidden" name="CEcodigo" value="#HTMLEditFormat(data.CEcodigo)#">
				
			
				
					<input type="hidden" name="Ecodigo" value="#HTMLEditFormat(data.Ecodigo)#">
				
			
				
					<input type="hidden" name="BMfechamod" value="#HTMLEditFormat(data.BMfechamod)#">
				
			
				
					<input type="hidden" name="BMUsucodigo" value="#HTMLEditFormat(data.BMUsucodigo)#">
				
			
		</form>
	</cfoutput>



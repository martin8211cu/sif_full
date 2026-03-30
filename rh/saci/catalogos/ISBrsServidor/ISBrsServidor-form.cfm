<cfparam name="url.nombreRS" default="">
<cfquery datasource="#session.dsn#" name="data">
	select *
	from  ISBrsServidor where nombreRS =
		<cfqueryparam cfsqltype="cf_sql_char" value="#url.nombreRS#" null="#Len(url.nombreRS) Is 0#">
	</cfquery>

<cfoutput>

<script type="text/javascript">
<!--
	function validar(formulario)
	{
		var error_input;
		var error_msg = '';
		// Validando tabla: ISBrsServidor - Servidor de RS monitoreado 
				// Columna: nombreRS Nombre servidor RS varchar(30)
				if (formulario.nombreRS.value == "") {
					error_msg += "\n - Nombre servidor RS no puede quedar en blanco.";
					error_input = formulario.nombreRS;
				}
			
				// Columna: nombreASE Nombre servidor RSSD varchar(30)
				if (formulario.nombreASE.value == "") {
					error_msg += "\n - Nombre servidor RSSD no puede quedar en blanco.";
					error_input = formulario.nombreASE;
				}
			
				// Columna: nombreRSSD Nombre basedatos RSSD varchar(30)
				if (formulario.nombreRSSD.value == "") {
					error_msg += "\n - Nombre basedatos RSSD no puede quedar en blanco.";
					error_input = formulario.nombreRSSD;
				}
			
				// Columna: datasource Datasource de coldfusion por usar varchar(30)
				if (formulario.datasource.value == "") {
					error_msg += "\n - Datasource de coldfusion por usar no puede quedar en blanco.";
					error_input = formulario.datasource;
				}
			
				// Columna: activo Monitoreo activado bit
				if (formulario.activo.value == "") {
					error_msg += "\n - Monitoreo activado no puede quedar en blanco.";
					error_input = formulario.activo;
				}
						
		// Validacion terminada
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			if (error_input && error_input.focus) error_input.focus();
			return false;
		}
		return true;
	}
	function funcNuevo(){
		location.href = 'ISBrsServidor-edit.cfm';
		return false;
	}
//-->
</script>

<form action="ISBrsServidor-apply.cfm" onsubmit="return validar(this);" enctype="multipart/form-data" method="post" name="form1" id="form1">
	<table summary="Tabla de entrada">
	<tr>
	  <td colspan="2" class="subTitulo">&nbsp;</td>
	  </tr>
	<tr>
	  <td colspan="2" class="subTitulo">
	Servidor de replicación por monitorear</td>
	</tr>
	
		<tr>
		  <td valign="top">&nbsp;</td>
		  <td valign="top">&nbsp;</td>
	  </tr>
		<tr><td valign="top"><label for="nombreRS">Nombre del servidor de replicación </label></td><td valign="top">
		
			<input name="nombreRS" id="nombreRS" type="text" value="#HTMLEditFormat(data.nombreRS)#" 
				maxlength="30" tabindex="1" size="30"
				onfocus="this.select()"  >
		
		</td></tr>
		
		<tr><td valign="top"><label for="nombreASE">Servidor donde se encuentra el RSSD</label>
		</td><td valign="top">
		
			<input name="nombreASE" id="nombreASE" type="text" value="#HTMLEditFormat(data.nombreASE)#" 
				maxlength="30" tabindex="1" size="30"
				onfocus="this.select()"  >
		
		</td></tr>
		
		<tr><td valign="top"><label for="nombreRSSD">Nombre de base de datos RSSD</label>
		</td><td valign="top">
		
			<input name="nombreRSSD" id="nombreRSSD" type="text" value="#HTMLEditFormat(data.nombreRSSD)#" 
				maxlength="30" tabindex="1" size="30"
				onfocus="this.select()"  >
		
		</td></tr>
		
		<tr><td valign="top"><label for="datasource">Datasource de coldfusion para RSSD </label></td><td valign="top">
		
			<input name="datasource" id="datasource" type="text" value="#HTMLEditFormat(data.datasource)#" 
				maxlength="30" tabindex="1" size="30"
				onfocus="this.select()"  >
		
		</td></tr>
		
		<tr><td valign="top"><label for="activo"></label></td><td valign="top">
		
			<input name="activo" id="activo" type="checkbox" value="1" tabindex="1" <cfif Len(data.activo) And data.activo>checked</cfif> >
			<label for="activo">Activar el monitoreo para este servidor</label>
		
		</td>
		</tr>
		

	    <tr>
	      <td colspan="2" class="formButtons">&nbsp;</td>
      </tr>
      <tr><td colspan="2" class="formButtons">
		<cfif data.RecordCount>
			<cf_botones  regresar="ISBrsServidor.cfm" modo="CAMBIO" tabindex="1">
		<cfelse>
			<cf_botones  regresar="ISBrsServidor.cfm" modo="ALTA" tabindex="1">
		</cfif>
	</td></tr>
	</table>
	
	
			<input type="hidden" name="BMUsucodigo" value="#HTMLEditFormat(data.BMUsucodigo)#">
		<cfset ts = "">
			<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
				artimestamp="#data.ts_rversion#" returnvariable="ts">
			</cfinvoke>
			<input type="hidden" name="ts_rversion" value="#ts#">
		
</form>

</cfoutput>


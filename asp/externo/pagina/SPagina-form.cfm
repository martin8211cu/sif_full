


<cfparam name="url.id_pagina" default="">


<cfquery datasource="asp" name="data">
	select *
	from  SPagina
	
		where 
		id_pagina =
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_pagina#" null="#Len(url.id_pagina) Is 0#">
	
</cfquery>

<cfoutput>

<script type="text/javascript">
<!--
	function validar(formulario)
	{
		var error_input;
		var error_msg = '';
		// Validando tabla: SPagina - Página Personalizable
		
			
			
		
			
			
				// Columna: nombre_pagina nombre_pagina varchar(30)
				if (formulario.nombre_pagina.value == "") {
					error_msg += "\n - nombre_pagina no puede quedar en blanco.";
					error_input = formulario.nombre_pagina;
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

<form action="SPagina-apply.cfm" onsubmit="return validar(this);" method="post" name="form1" id="form1">
	<table summary="Tabla de entrada">
	<tr><td colspan="2" class="subTitulo">
	Página Personalizable
	</td></tr>
	
	
		
		
			
		
	
		
		
		<tr><td valign="top">nombre_pagina
		</td><td valign="top">
		
			<input name="nombre_pagina" id="nombre_pagina" type="text" value="#HTMLEditFormat(data.nombre_pagina)#" 
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
	
	
		
			<input type="hidden" name="id_pagina" value="#HTMLEditFormat(data.id_pagina)#">
		
	
		
			<input type="hidden" name="BMfecha" value="#HTMLEditFormat(data.BMfecha)#">
		
	
		
			<input type="hidden" name="BMUsucodigo" value="#HTMLEditFormat(data.BMUsucodigo)#">
		
	
		
			<cfset ts = "">
			<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
				artimestamp="#data.ts_rversion#" returnvariable="ts">
			</cfinvoke>
			<input type="hidden" name="ts_rversion" value="#ts#">
		
	
</form>

</cfoutput>



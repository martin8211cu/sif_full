


<cfparam name="url.id_pagina">

<cfparam name="url.id_portlet" default="">


<cfquery datasource="asp" name="data">
	select *
	from  SPortletPagina
	
		where 
		id_pagina =
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_pagina#" null="#Len(url.id_pagina) Is 0#">
	
		and 
		id_portlet =
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_portlet#" null="#Len(url.id_portlet) Is 0#">
	
</cfquery>

<cfquery datasource="asp" name="portlets">
	select id_portlet,nombre_portlet
	from SPortlet
	order by nombre_portlet
</cfquery>

<cfoutput>

<script type="text/javascript">
<!--
	function validar(formulario)
	{
		var error_input;
		var error_msg = '';
		// Validando tabla: SPortletPagina - Contenido de Página
		
			
			
				// Columna: id_pagina id pagina numeric
				if (formulario.id_pagina.value == "") {
					error_msg += "\n - id pagina no puede quedar en blanco.";
					error_input = formulario.id_pagina;
				}
			
		
			
			
				// Columna: id_portlet id_portlet numeric
				if (formulario.id_portlet.value == "") {
					error_msg += "\n - id_portlet no puede quedar en blanco.";
					error_input = formulario.id_portlet;
				}
			
		
			
			
				// Columna: columna columna int
				if (formulario.columna.value == "") {
					error_msg += "\n - columna no puede quedar en blanco.";
					error_input = formulario.columna;
				}
			
		
			
			
				// Columna: fila fila int
				if (formulario.fila.value == "") {
					error_msg += "\n - fila no puede quedar en blanco.";
					error_input = formulario.fila;
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

<form action="SPortletPagina-apply.cfm" onsubmit="return validar(this);" method="post" name="form1" id="form1">
	<table summary="Tabla de entrada">
	<tr><td colspan="2" class="subTitulo">
	Contenido de Página
	</td></tr>
	
	
		
		
		<tr><td valign="top">id pagina
		</td><td valign="top">
		
			<input name="id_pagina_out" id="id_pagina_out" type="text" value="#HTMLEditFormat(url.id_pagina)#" 
				maxlength="" onfocus="this.select()"  disabled >
			<input name="id_pagina" id="id_pagina" type="hidden" value="#HTMLEditFormat(url.id_pagina)#" >
		
		</td></tr>
		
	
		
		
		<tr><td valign="top">id_portlet
		</td><td valign="top">
			<select name="id_portlet" id="id_portlet">
			<cfloop query="portlets">
				<option value="#portlets.id_portlet#" <cfif data.id_portlet is portlets.id_portlet>selected</cfif> >#portlets.nombre_portlet#</option>
			</cfloop>
			</select>
		
		</td></tr>
		
	
		
		
		<tr><td valign="top">columna
		</td><td valign="top">
		
			<input name="columna" id="columna" type="text" value="#HTMLEditFormat(data.columna)#" 
				maxlength="11"
				onfocus="this.select()"  >
		
		</td></tr>
		
	
		
		
		<tr><td valign="top">fila
		</td><td valign="top">
		
			<input name="fila" id="fila" type="text" value="#HTMLEditFormat(data.fila)#" 
				maxlength="11"
				onfocus="this.select()"  >
		
		</td></tr>
		
	
		
		
		<tr><td valign="top">parametros
		</td><td valign="top">
		
			<input name="parametros" id="parametros" type="text" value="#HTMLEditFormat(data.parametros)#" 
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



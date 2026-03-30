


<cfparam name="url.id_item" default="">

<cfparam name="url.id_relacionado" default="">


<cfquery datasource="asp" name="data">
	select *
	from  SRelacionado
	
		where 
		id_item =
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_item#" null="#Len(url.id_item) Is 0#">
	
		and 
		id_relacionado =
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_relacionado#" null="#Len(url.id_relacionado) Is 0#">
	
</cfquery>

<cfoutput>

<script type="text/javascript">
<!--
	function validar(formulario)
	{
		var error_input;
		var error_msg = '';
		// Validando tabla: SRelacionado - Páginas Relacionadas
		
			
			
				// Columna: id_item id_item numeric
				if (formulario.id_item.value == "") {
					error_msg += "\n - id_item no puede quedar en blanco.";
					error_input = formulario.id_item;
				}
			
		
			
			
				// Columna: id_relacionado id_relacionado numeric
				if (formulario.id_relacionado.value == "") {
					error_msg += "\n - id_relacionado no puede quedar en blanco.";
					error_input = formulario.id_relacionado;
				}
			
		
			
			
				// Columna: posicion posicion int
				if (formulario.posicion.value == "") {
					error_msg += "\n - posicion no puede quedar en blanco.";
					error_input = formulario.posicion;
				}
			
		
			
			
				// Columna: es_submenu es_submenu bit
				if (formulario.es_submenu.value == "") {
					error_msg += "\n - es_submenu no puede quedar en blanco.";
					error_input = formulario.es_submenu;
				}
			
		
			
			
				// Columna: es_link es_link bit
				if (formulario.es_link.value == "") {
					error_msg += "\n - es_link no puede quedar en blanco.";
					error_input = formulario.es_link;
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

<form action="SRelacionado-apply.cfm" onsubmit="return validar(this);" method="post" name="form1" id="form1">
	<table summary="Tabla de entrada">
	<tr><td colspan="2" class="subTitulo">
	Páginas Relacionadas
	</td></tr>
	
	
		
		
		<tr><td valign="top">id_item
		</td><td valign="top">
		
			<input name="id_item" id="id_item" type="text" value="#HTMLEditFormat(data.id_item)#" 
				maxlength=""
				onfocus="this.select()"  >
		
		</td></tr>
		
	
		
		
		<tr><td valign="top">id_relacionado
		</td><td valign="top">
		
			<input name="id_relacionado" id="id_relacionado" type="text" value="#HTMLEditFormat(data.id_relacionado)#" 
				maxlength=""
				onfocus="this.select()"  >
		
		</td></tr>
		
	
		
		
		<tr><td valign="top">posicion
		</td><td valign="top">
		
			<input name="posicion" id="posicion" type="text" value="#HTMLEditFormat(data.posicion)#" 
				maxlength="11"
				onfocus="this.select()"  >
		
		</td></tr>
		
	
		
		
		<tr><td valign="top">es_submenu
		</td><td valign="top">
		
			<input name="es_submenu" id="es_submenu" type="checkbox" value="1" <cfif Len(data.es_submenu) And data.es_submenu>checked</cfif> >
			<label for="es_submenu">es_submenu</label>
		
		</td></tr>
		
	
		
		
		<tr><td valign="top">es_link
		</td><td valign="top">
		
			<input name="es_link" id="es_link" type="checkbox" value="1" <cfif Len(data.es_link) And data.es_link>checked</cfif> >
			<label for="es_link">es_link</label>
		
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



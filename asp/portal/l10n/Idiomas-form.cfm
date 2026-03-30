<cfparam name="url.Iid" default="">
<cfquery datasource="sifcontrol" name="data">
	select *
	from Idiomas
	where Iid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Iid#" null="#Len(url.Iid) Is 0#">
</cfquery>

<cfset data.Icodigo = LCase(Mid(data.Icodigo,1,2)) & UCase(Mid(data.Icodigo,3,50))>

<cfoutput>

<script type="text/javascript">
<!--
	function validar(formulario)
	{
		var error_input;
		var error_msg = '';
		// Validando tabla: Idiomas - Idiomas
			// Columna: Icodigo Código de Idioma char(10)
			if (formulario.Icodigo.value == "") {
				error_msg += "\n - Código de Idioma no puede quedar en blanco.";
				error_input = formulario.Icodigo;
			}
			// Columna: Descripcion Descripción varchar(80)
			if (formulario.Descripcion.value == "") {
				error_msg += "\n - Descripción no puede quedar en blanco.";
				error_input = formulario.Descripcion;
			}
		// Validacion terminada
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			error_input.focus();
			return false;
		}
		return true;
	}
	function format_locale (obj) {
		var s = obj.value;
		obj.value = s.substring(0,2).toLowerCase() + s.substring(2,50).toUpperCase();
	}
//-->
</script>

<form action="Idiomas-apply.cfm" onsubmit="return validar(this);" method="post" name="form1" id="form1">
	<table summary="Tabla de entrada">
	<tr><td colspan="2" class="subTitulo">
	Idiomas
	</td></tr>
	
		<tr><td valign="top">Código de Idioma
		</td><td valign="top">
		
			<input name="Icodigo" id="Icodigo" type="text" value="#HTMLEditFormat(data.Icodigo)#" 
				maxlength="10"
				onfocus="this.select()" onblur="format_locale(this)" >
		
		</td></tr>
		<tr><td valign="top">Descripción
		</td><td valign="top">
		
			<input name="Descripcion" id="Descripcion" type="text" value="#HTMLEditFormat(data.Descripcion)#" 
				maxlength="80"
				onfocus="this.select()"  >
		</td></tr>
		
		<tr><td valign="top">Nombre Locale
		</td><td valign="top">
		
			<input name="Inombreloc" id="Inombreloc" type="text" value="#HTMLEditFormat(data.Inombreloc)#" 
				maxlength="80"
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
			<input type="hidden" name="Iid" value="#HTMLEditFormat(data.Iid)#">
			<cfset ts = "">
			<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
				artimestamp="#data.ts_rversion#" returnvariable="ts">
			</cfinvoke>
			<input type="hidden" name="ts_rversion" value="#ts#">
</form>

</cfoutput>



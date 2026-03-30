<cfset def = QueryNew("")>
<cfparam name="Attributes.index" type="string" default="">
<cfparam name="Attributes.form" type="string" default="form1">
<cfparam name="Attributes.query" type="query" default="#def#">
<cfquery name="rsTPTipoIdent" datasource="#session.tramites.dsn#">
	select id_tipoident, codigo_tipoident, nombre_tipoident, BMUsucodigo, BMfechamod, vigente_desde, vigente_hasta, es_fisica
	from TPTipoIdent
</cfquery>
<cfoutput>
<script language="javascript" type="text/javascript">
	function funcTraePersona#Attributes.index#(){
		if (document.#Attributes.form#.identificacion_persona#Attributes.index#.value!=""){
			window.#Gvar_name# = document.#Attributes.form#.#Gvar_name#;
			window.identificacion_persona#Attributes.index# = document.#Attributes.form#.identificacion_persona#Attributes.index#;
			window.nombre_persona#Attributes.index# = document.#Attributes.form#.nombre_persona#Attributes.index#;
			var fr = document.getElementById("frame_persona");
			fr.src = "/cfmx/home/tramites/vistas/tablas/persona-query.cfm?gname=#Gvar_name#&index=#Attributes.index#&identificacion_persona="+document.#Attributes.form#.identificacion_persona#Attributes.index#.value+"&id_tipoident="+document.#Attributes.form#.id_tipoident#Attributes.index#.value;
		} else {
			funcLimpiarPersona#Attributes.index#();
		}
	}
	function funcLimpiarPersona#Attributes.index#(){
		document.#Attributes.form#.#Gvar_name#.value="";
		document.#Attributes.form#.identificacion_persona#Attributes.index#.value="";
		document.#Attributes.form#.nombre_persona#Attributes.index#.value="";
	}
	function doConlisPersona#Attributes.index#(){
		var width = 600;
		var height = 500;
		var top = (screen.height - height) / 2;
		var left = (screen.width - width) / 2;
		var nuevo = window.open('/cfmx/home/tramites/vistas/tablas/persona-conlis.cfm?gname=#Gvar_name#&index=#Attributes.index#&form=#Attributes.form#&id_tipoident='+document.#Attributes.form#.id_tipoident#Attributes.index#.value,'ListaPersonas','menu=no,scrollbars=yes,top='+top+',left='+left+',width='+width+',height='+height);
		nuevo.focus();
	}
</script>
<table width="1%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td>
		<cfset Lvar_id_tipoident = "">
		<cfif isdefined("Attributes.query.id_tipoident#Attributes.index#")><cfset Lvar_id_tipoident = Evaluate("Attributes.query.id_tipoident#Attributes.index#")></cfif>
		<select name="id_tipoident#Attributes.index#">
			<cfloop query="rsTPTipoIdent">
				<option value="#id_tipoident#" <cfif id_tipoident eq Lvar_id_tipoident>selected</cfif>>#nombre_tipoident#</option>
			</cfloop>
		</select>
	</td>
	<td>
		<cfset Lvar_id_persona = "">
		<cfif isdefined("Attributes.query.id_persona#Attributes.index#")><cfset Lvar_id_persona = Evaluate("Attributes.query.id_persona#Attributes.index#")></cfif>
		<input type="hidden" name="#Gvar_name#" value="#Lvar_id_persona#">
		<cfset Lvar_identificacion_persona = "">
		<cfif isdefined("Attributes.query.identificacion_persona#Attributes.index#")><cfset Lvar_identificacion_persona = Evaluate("Attributes.query.identificacion_persona#Attributes.index#")></cfif>
		<input type="text" name="identificacion_persona#Attributes.index#" size="12"
		onBlur="javascript: funcTraePersona#Attributes.index#(this.value);" onFocus="this.select()"
		value="#Gvar_Value#">
	</td>
	<td>
		<cfset Lvar_nombre_persona = "">
		<cfif isdefined("Attributes.query.nombre_persona#Attributes.index#")><cfset Lvar_nombre_persona = Evaluate("Attributes.query.nombre_persona#Attributes.index#")></cfif>
		<input type="text" name="nombre_persona#Attributes.index#" size="38" readonly value="#Lvar_nombre_persona#">
	</td>
	<td>
		<a href="javascript: doConlisPersona#Attributes.index#();" onMouseOver="javascript: window.status=''; return true;" onMouseOut="javascript: window.status=''; return true;" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Personas" name="imagen" width="18" height="14" border="0" align="absmiddle"></a>
	</td>
  </tr>
</table>
<cfif not isdefined("Request.FramePersona")>
	<cfset Request.FramePersona = "FramePersonaDefined">
	<iframe name="frame_persona" id="frame_persona" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" style="visibility: ;"></iframe>
</cfif>
</cfoutput>
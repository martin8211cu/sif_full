<cfset def = QueryNew('dato')>

<cfparam name="Attributes.form" default="form1" type="String"> <!--- Nombre del form donde se colocará el campo --->
<cfparam name="Attributes.query" default="#def#" type="query"> <!--- consulta por defecto --->
<cfparam name="Attributes.tabindex" default="0" type="numeric"> <!--- TabIndex del Campo Editable --->
<cfparam name="Attributes.index" default="0" type="numeric"> <!--- Se utiliza cuando se quiere colocar varios tags en la misma pantalla --->
<cfparam name="Attributes.tipo" default="A" type="string"> <!--- Tipo de Documentos de Tránsito: A = Articulos, S = Servicios --->
<cfparam name="Attributes.id" default="" type="string"> <!--- Nombre del Campo Id --->
<cfparam name="Attributes.frame" default="frTransito" type="string"> <!--- Nombre del frame --->

<cfif Attributes.index NEQ 0>
	<cfset index = "" & Attributes.index>
<cfelse>
	<cfset index = "">
</cfif>

<cfif Attributes.tipo EQ 'A'>
	<cfset Attributes.id = Trim(Attributes.id) & Iif(Len(Trim(Attributes.id)) EQ 0, DE("Tid" & index), DE(index))>
<cfelse>
	<cfset Attributes.id = Trim(Attributes.id) & Iif(Len(Trim(Attributes.id)) EQ 0, DE("TCid" & index), DE(index))>
</cfif>

<script language="JavaScript" type="text/javascript">
	function doConlisTransito<cfoutput>#Attributes.tipo##index#</cfoutput>() {
		var width = 800;
		var height = 400;
		var top = (screen.height - height) / 2;
		var left = (screen.width - width) / 2;
		<cfoutput>
		var nuevo = window.open('/cfmx/sif/Utiles/ConlisTransito.cfm?f=#Attributes.form#&tipo=#Attributes.tipo#&tipoid=tipo#Attributes.tipo##index#&id=#Attributes.id#','ListaTransito','menu=no,scrollbars=yes,top='+top+',left='+left+',width='+width+',height='+height);
		</cfoutput>
		nuevo.focus();
	}
</script>

<cfoutput>
<table border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<input type="hidden" name="tipo#Attributes.tipo##index#" id="tipo#Attributes.tipo##index#" value="#Attributes.tipo#">
			<input type="hidden" name="#Attributes.id#" id="#Attributes.id#" value="<cfif isdefined("Attributes.query") and isdefined("Attributes.query.#Attributes.id#")>#Evaluate("Attributes.query.#Attributes.id#")#</cfif>">
			<a href="javascript: doConlisTransito#Attributes.tipo##index#();" onMouseOver="javascript: window.status=''; return true;" onMouseOut="javascript: window.status=''; return true;" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Documentos en Transito" name="imagen" width="18" height="14" border="0" align="absmiddle"></a>
		</td>
	</tr>
</table>
</cfoutput>

<cfif not isdefined("Request.TransitoTag")>
	<cfoutput>
	<iframe id="#Attributes.frame#" name="#Attributes.frame#" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" style="visibility: hidden;"></iframe>
	</cfoutput>
	<cfset Request.TransitoTag = True>
</cfif>

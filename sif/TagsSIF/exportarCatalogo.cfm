
<cfparam  name="Attributes.tableName" 		type="string" 	>							<!--- Tabla a exportar --->
<cfparam  name="Attributes.keyColumnName" 	type="string" 	>							<!--- Columna clave/llave --->
<cfparam  name="Attributes.iframeName" 		type="string" 	default = "iframe1">		<!--- Columna clave/llave --->
 
<cfoutput>

<cfset vsPath_R = "#GetContextRoot()#">
<cfif REFind('(cfmx)$',vsPath_R) gt 0> 
	<cfset vsPath_R = "#vsPath_R#\">
<cfelse> 
	<cfset vsPath_R = "#vsPath_R#\cfmx\">
</cfif>
<cfset vsPath_R = "#vsPath_R#home\public\FuncExportarCatalogo.cfm">

<div align="center">
	<form name="#attributes.iframeName#_form" action="#vsPath_R#" method="post" target="#attributes.iframeName#">
		<input type="hidden" value="exportar" name="export_action">
		<input type="hidden" value="#attributes.tableName#" name="tableName">
		<input type="hidden" value="#attributes.keyColumnName#" name="keyColumnName">
		<input type="button" value="Exportar" onclick="Descargar('#attributes.iframeName#');">
	</form>
	<iframe name="#attributes.iframeName#" id="#attributes.iframeName#" src="#vsPath_R#" style="width:0;height:0;border:0; border:none;">
	</iframe>
</div>

<script language = "JavaScript">
	function Descargar(iframeName){
		var form = document.getElementsByName(iframeName+"_form")[0];
		form.submit();
	}
</script>

</cfoutput>

<!--- ESTE CODIGO DEBE ESTAR EN UN ARCHIVO "FuncExportarCatalogo.cfm" EN EL DIRECTORIO \home\public\


<!--- Body requerido para agregar el elemento de descarga --->
<html>
	<body>
	</body>
</html>

<!--- Invocacion a la funcion de descarga --->
<cfif isdefined('form.export_action')>
	<cfset componentPath = "crc.Componentes.TransferData">
	<cfset componentOBJ = createObject("component","#componentPath#")>
	<cfset result = componentOBJ.Exportar(
			tableName = "#form.tableName#"
		,	keyColumnName = "#form.keyColumnName#"
		,	Ecodigo = #session.ecodigo#
		,	DSN = "#session.dsn#"
	)>
</cfif>

--->
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

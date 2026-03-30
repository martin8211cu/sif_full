
<cfif !isdefined('tableName')>
	<cfthrow type="ExportException" message="Parameter 'tableName' is required. No table to export! Try adding [cfset tableName='myTable']">
</cfif>
<cfif !isdefined('keyColumnName')>
	<cfthrow type="ExportException" message="Parameter 'keyColumnName' is required. No column to export! Try adding [cfset keyColumnName='myColumn']">
</cfif>

<div align="center">
	<form name="export_form" action="#" method="post">
		<input type="hidden" value="exportar" name="export_action">
		<input type="hidden" value="<cfoutput>#tableName#</cfoutput>" name="tableName">
		<input type="hidden" value="<cfoutput>#keyColumnName#</cfoutput>" name="keyColumnName">
		<input type="submit" value="Exportar">
	</form>
</div>


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
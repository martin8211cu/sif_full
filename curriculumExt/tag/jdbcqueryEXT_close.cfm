<!--- 
	Complemento para jdbcqueryEXT_open.cfm.

	Modificado por: Ing. Óscar Bonilla, MBA. 02/AGO/2006
	*
	* Optimiza los cierres de los objetos java del jdbc
	* Utilización:
	*	<CF_JDBCquery_close name="rs" datasource="" update="no/yes">
	*
--->

<cfif LCase ( ThisTag.ExecutionMode ) is 'start'>

	<!--- cerrar conexión --->
	<cfscript>
		if (IsDefined('request.jdbcquery.rs'))
			request.jdbcquery.rs.close();
		if (IsDefined('request.jdbcquery.stmt'))
			request.jdbcquery.stmt.close();
		if (IsDefined('request.jdbcquery.conn'))
			request.jdbcquery.conn.close();
		if (IsDefined('request.jdbcquery'))
			structDelete(request,"jdbcquery");
	</cfscript>
</cfif>

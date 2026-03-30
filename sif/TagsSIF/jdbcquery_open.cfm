<!--- 
	Ejecuta una consulta por JDBC.
	PELIGRO ! PELIGRO ! Si no se usa apropiadamente, puede dejar la conexión
	abierta por un periodo indefinido.
	Es importante utilizar un bloque try/catch, para que si se falla en la utilización
	de la conexión, se cierre de todas maneras.
	Debe invocarse primero el <cf_jdbcquery_open>, y luego el <cf_jdbcquery_close>
	No importa si el close se llama más de una vez, pero sí es problema
	si no se llega a invocar.
	
	Atributos:
		datasource:		Indica la fuente de datos. (#session.dsn#)
	Cuerpo del tag:	Indica la consulta que se desea ejecutar.
	
	Este tag genera una variable llamada "rs" de tipo java.sql.ResultSet
	
	Ejemplo de uso:
	
			<cftry>
				<cf_jdbcquery_open datasource="sifcontrol" name="myrs">
					select name from systypes order by 1
				</cf_jdbcquery_open>
					<cfloop condition="rs.next()">
						<cfoutput>#rs.getString('name')# </cfoutput>
					</cfloop><br />
			<cfcatch type="any">
				<cf_jdbcquery_close>
				<cfrethrow>
			</cfcatch>
			</cftry>
			<cf_jdbcquery_close>

	Modificado por: Ing. Óscar Bonilla, MBA. 02/AGO/2006
	*
	* Permite ejecutar instrucciones No consulta (insert, delete, update, create) por jdbc
	* 	Atributo:	update="yes"
	* Optimiza los cierres de los objetos java del jdbc
	*
	* Utilización:
	*	<CF_JDBCquery_open name="rs" datasource="" update="no/yes">
	*
--->

<cfparam name="Attributes.datasource" 	type="string">
<cfparam name="Attributes.name" 		type="string" default="rs">
<cfparam name="Attributes.update" 		type="boolean" default="no">

<cfif Not ThisTag.HasEndTag>
	<cf_errorCode	code = "50690" msg = "cf_jdbcquery debe tener un tag de cierre">
</cfif>

<cfif LCase( ThisTag.ExecutionMode ) is 'end'>
	<cfscript>
		if(Len(Attributes.datasource)){
			DataSourceFactory = CreateObject("java","coldfusion.server.ServiceFactory");
			if (not isdefined("request.jdbcquery"))
			{
				Request.jdbcquery = StructNew();
				StructInsert(Request.jdbcquery,"conn",DataSourceFactory.DataSourceService.getDataSource(Attributes.datasource).getConnection());
				StructInsert(Request.jdbcquery,"stmt",request.jdbcquery.conn.createStatement());
			}

			try
			{
				if (Attributes.update)
				{
					request.jdbcquery.stmt.executeUpdate(ThisTag.GeneratedContent);
				}
				else
				{
					request.jdbcquery.rs = request.jdbcquery.stmt.executeQuery(ThisTag.GeneratedContent);
				}
			}
			catch (any e)
			{
				if (IsDefined('request.jdbcquery.rs'))
					request.jdbcquery.rs.close();
				if (IsDefined('request.jdbcquery.stmt'))
					request.jdbcquery.stmt.close();
				if (IsDefined('request.jdbcquery.conn'))
					request.jdbcquery.conn.close();
				if (IsDefined('request.jdbcquery'))
					structDelete(request,"jdbcquery");
				request.jdbcquerySQL = ThisTag.GeneratedContent;
				ThisTag.GeneratedContent = '<BR><strong>&lt;jdbcquery_SQL&gt;</strong><BR>' & ThisTag.GeneratedContent & '<BR><strong>&lt;/jdbcquery_SQL&gt;</strong><BR>';

				fnThrow (e);
			}

			if (Attributes.update)
			{
				if (isdefined("Caller.#Attributes.name#"))
				{
					structDelete(Caller, Attributes.name);
				}
			}
			else
			{
				Caller[Attributes.name] = request.jdbcquery.rs;
			}
			ThisTag.GeneratedContent = '';
		}
	</cfscript>
</cfif>
<cfif not isdefined("fnthrow")>
	<cffunction name="fnThrow" returntype="void">
		<cfargument name="LvarCatch" type="any">
		
		<cfthrow object="#LvarCatch#">
	</cffunction>
</cfif>


<cfparam name="Attributes.rows" type="numeric" default="100">
<cfparam name="Attributes.datasource" type="string" default="">

<!---
	TIENE 2 FORMAS: 	

	A) cuando el SQL termina con clausa WHERE se usa cf_dbrowcount1EXT y cf_dbrowcount2EXT
	<cfquery ...>
		<cf_dbrowcount1EXT rows=50 datasource=#session.dsn#> /* genera un set rowcount en sybase */
		
		select A, B
		from Tabla X
		where A.k = B.k    // tiene que haber un where y ser la última clausula del SQL
		
		<cf_dbrowcount2EXT rows=50 datasource=#session.dsn#>  /* genera un and rownum <= 50 en oracle */
	</cfquery>

	B) cuando el SQL termina con clausa diferente a WHERE se usa cf_dbrowcount1EXT y cf_dbrowcount2EXT_a y cf_dbrowcount2EXT_b
	<cfquery ...>
		<cf_dbrowcount1EXT rows=50 datasource=#session.dsn#> /* genera un set rowcount en sybase */
		
		select A, B
		from Tabla X
		where A.k = B.k    // tiene que haber un where
		
		<cf_dbrowcount2EXT_a rows=50 datasource=#session.dsn#>  /* genera un and rownum <= 50 en oracle */
		order by A.k       // termina con order by que es una clausula diferente a WHERE
		<cf_dbrowcount2EXT_b datasource=#session.dsn#>
	</cfquery>
--->


<!--- Validar el datasource --->
<cfif Len(Attributes.datasource) Is 0>
	<cfif IsDefined('session.dsn') and Len(session.dsn) neq 0>
		<cfset Attributes.datasource = session.dsn>
	<cfelse>
		<cfthrow message="Falta el atributo datasource, y session.dsn no est&aacute; definida.">
	</cfif>
</cfif>

<!--- Asegurarse de que la informacion sobre las conexiones este disponible --->
<cfif not StructKeyExists(Application.dsinfo, Attributes.datasource)>
<cfinvoke component="home.Componentes.DbUtils" method="generate_dsinfo" datasource="#Attributes.datasource#"  />
</cfif>
<cfif not StructKeyExists(Application.dsinfo, Attributes.datasource)>
	<cfthrow message="Datasource no definido: #HTMLEditFormat(Attributes.datasource)#">
</cfif>

<cfif ListFind('sybase,sqlserver', Application.dsinfo[Attributes.datasource].type)>
	set rowcount <cfoutput>#Attributes.rows#</cfoutput>
<cfelseif Application.dsinfo[Attributes.datasource].type is 'oracle' or Application.dsinfo[Attributes.datasource].type is 'db2'>
<cfelse>
	<cfthrow message="DBMS no soportado: #Application.dsinfo[Attributes.datasource].type#">
</cfif>

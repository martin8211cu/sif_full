<!--- Únicamente se puede utilizar cuando la instrucción SQL termina con WHERE --->
<cfparam name="Attributes.rows" type="numeric" default="100">
<cfparam name="Attributes.datasource" type="string" default="">

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
	set rowcount 0
<cfelseif Application.dsinfo[Attributes.datasource].type is 'oracle'>
	and rownum <= <cfoutput>#Attributes.rows#</cfoutput>
<cfelse>
	<cfthrow message="DBMS no soportado: #Application.dsinfo[Attributes.datasource].type#">
</cfif>

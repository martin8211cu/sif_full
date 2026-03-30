<cfparam name="Attributes.datasource" type="string" default="#session.DSN#">
<cfparam name="Attributes.name" type="string" default="">
<cfparam name="Attributes.returnvariable" type="string" default="">

<!--- Validar el datasource --->
<cfif Len(Attributes.datasource) Is 0>
	<cfif IsDefined('session.dsn') and Len(session.dsn) neq 0>
		<cfset Attributes.datasource = session.dsn>
	<cfelse>
		<cfthrow message="Falta el atributo datasource, y session.dsn no est&aacute; definida.">
	</cfif>
</cfif>

<cfset retornar = sintaxis()>
<cfif Attributes.returnvariable EQ "">
	<cfoutput>#retornar#</cfoutput>
<cfelse>
	<cfset Caller[Attributes.returnvariable] = retornar>
</cfif>
<cfsetting enablecfoutputonly="no">

<cffunction name="sintaxis" returntype="string">
	<!--- Asegurarse de que la informacion sobre las conexiones este disponible --->
	<cfif not StructKeyExists(Application.dsinfo, Attributes.datasource)>
	<cfinvoke component="home.Componentes.DbUtils" method="generate_dsinfo" datasource="#Attributes.datasource#"  />
	</cfif>
	<cfif not StructKeyExists(Application.dsinfo, Attributes.datasource)>
		<cfthrow message="Datasource no definido: #HTMLEditFormat(Attributes.datasource)#">
	</cfif>
	
	<cfif Application.dsinfo[Attributes.datasource].type eq 'sybase' >
		<cfreturn "(index #Attributes.name#)" >
	<cfelseif Application.dsinfo[Attributes.datasource].type eq 'sqlserver' >
		<cfreturn "with (index (#Attributes.name#))" >	
	<cfelseif Application.dsinfo[Attributes.datasource].type eq 'oracle' >
		<cfreturn "" >
	<cfelse>
		<cfthrow message="DBMS no soportado: #Application.dsinfo[Attributes.datasource].type#">
	</cfif>
</cffunction>
<cfparam name="Attributes.datasource" type="string" default="">
<cfparam name="Attributes.name" type="string" default="">
<cfparam name="Attributes.returnvariable" type="string" default="">
 
<!--- Validar el datasource --->
<cfif Len(Attributes.datasource) Is 0>
	<cfif IsDefined('session.dsn') and Len(session.dsn) neq 0>
		<cfset Attributes.datasource = session.dsn>
	<cfelse>
		<cf_errorCode	code = "50597" msg = "Falta el atributo datasource, y session.dsn no está definida.">
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
		<cf_errorCode	code = "50599"
						msg  = "Datasource no definido: @errorDat_1@"
						errorDat_1="#HTMLEditFormat(Attributes.datasource)#"
		>
	</cfif>
	
	<cfif Application.dsinfo[Attributes.datasource].type eq 'sybase' >
		<cfreturn "">
		<cfreturn "(index #Attributes.name#)" >
	<cfelseif Application.dsinfo[Attributes.datasource].type eq 'sqlserver' >
		<cfreturn "">
		<cfreturn "with (index (#Attributes.name#))" >	
	<cfelseif Application.dsinfo[Attributes.datasource].type eq 'oracle' >
		<cfreturn "" >
	<cfelseif Application.dsinfo[Attributes.datasource].type eq 'db2' >
		<cfreturn "" >
	<cfelse>
		<cf_errorCode	code = "50628"
						msg  = "DBMS no soportado: @errorDat_1@"
						errorDat_1="#Application.dsinfo[Attributes.datasource].type#"
		>
	</cfif>
</cffunction>



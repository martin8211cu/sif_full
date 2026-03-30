<!---
	Tag que permite definir el nivel de aislamiento de un query, por ahora solo esta implementado para Sybase.
	<cfquery name="RsReporte" datasource="#session.dsn#">
		select columna1, columna2 from table1
		<cf_Insolation Nivel="read_uncommitted">
	</cfquery>
--->
<!---Si se tienen el dsn en session no hace falta enviar el datasource--->
<cfparam name="Attributes.datasource" 		type="string" default="">
<!---Enviar el ReturnVariable  si no se va usar dentro de un cfquery--->
<cfparam name="Attributes.returnvariable" 	type="string" default="">
<!---read_committed: Lectura sucia sobre registro que se les hizo commit, read_uncommitted: Lectura sucia, incluyendo registros sin committ--->
<cfparam name="Attributes.Nivel" 			type="string" default="">
 
<cfif NOT Len(Attributes.datasource)>
	<cfif IsDefined('session.dsn') and Len(session.dsn)>
		<cfset Attributes.datasource = session.dsn>
	<cfelse>
		<cfthrow message="Falta el atributo datasource, y session.dsn no está definida [cf_Isolation].">
	</cfif>
</cfif>

<cfset retornar = sintaxis()>
<cfif NOT LEN(TRIM(Attributes.returnvariable))>
	<cfoutput>#retornar#</cfoutput>
<cfelse>
	<cfset Caller[Attributes.returnvariable] = retornar>
</cfif>
<cfsetting enablecfoutputonly="no">
<cffunction name="sintaxis" returntype="string">
	<cfif not StructKeyExists(Application.dsinfo, Attributes.datasource)>
		<cfinvoke component="home.Componentes.DbUtils" method="generate_dsinfo" datasource="#Attributes.datasource#"  />
	</cfif>
	<cfif not StructKeyExists(Application.dsinfo, Attributes.datasource)>
		<cfthrow message="Datasource no definido: #Attributes.datasource# en el dsinfo">
	</cfif>
	
	<cfif Application.dsinfo[Attributes.datasource].type eq 'sybase' >
		<cfif Attributes.Nivel EQ 'read_uncommitted'>
			<cfreturn " at isolation read uncommitted">
		<cfelseif Attributes.Nivel EQ 'read_committed'>
			<cfreturn " at isolation read committed">
		<cfelseif NOT LEN(TRIM(Attributes.Nivel))>
			<cfthrow message="No se envio el atributo Nivel y es requerido">
		<cfelse>
			<cfthrow message="El nivel #Attributes.Nivel# no esta implementado">
		</cfif>
	<cfelseif Application.dsinfo[Attributes.datasource].type eq 'sqlserver' >
		<cfreturn "">
	<cfelseif Application.dsinfo[Attributes.datasource].type eq 'oracle' >
		<cfreturn "" >
	<cfelseif Application.dsinfo[Attributes.datasource].type eq 'db2' >
		<cfreturn "" >
	<cfelse>
		<cfthrow message="DBMS no soportado: #Application.dsinfo[Attributes.datasource].type#">
	</cfif>
</cffunction>
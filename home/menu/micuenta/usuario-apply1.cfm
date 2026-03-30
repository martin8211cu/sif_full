<cfparam name="modo" default="CAMBIO">

<cftry>

	<!--- Modifica los datos personales --->
	
	<cfquery name="userdata" datasource="asp">
		select datos_personales
		from Usuario
		where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
	</cfquery>
	
	<cf_datospersonales action="readform" name="data1">
	<cfset data1.datos_personales = userdata.datos_personales >
	<cf_datospersonales action="update" key="#userdata.datos_personales#" name="data1" data="#data1#">
	<cfset session.datos_personales = data1>
<cfcatch type="database">
	<cfinclude template="/sif/errorPages/BDerror.cfm">
	<cfabort>
</cfcatch>
</cftry>
<cflocation url="index.cfm">
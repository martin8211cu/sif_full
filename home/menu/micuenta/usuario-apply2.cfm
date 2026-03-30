<cfparam name="modo" default="CAMBIO">

<cftry>

	<!--- Modifica la direccion --->
	
	<cfquery name="userdata" datasource="asp">
		select id_direccion
		from Usuario
		where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
	</cfquery>
	
	<cf_direccion action="readform" name="data2">
	<cfset data2.id_direccion = userdata.id_direccion >
	<cf_direccion action="update" key="#userdata.id_direccion#" data="#data2#">
	
<cfcatch type="database">
	<cfinclude template="/sif/errorPages/BDerror.cfm">
	<cfabort>
</cfcatch>
</cftry>

<cflocation url="index.cfm?tab=2">
<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>

 <cfquery name="consulta" datasource="#session.DSN#">
	select 
			 BTid
			,BTcodigo
			,BTdescripcion
			,BTtipo
	from BTransacciones
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and BTtce <> <cfqueryparam cfsqltype="cf_sql_bit" value="1">
</cfquery> 

<cfset GvarXML_OE = LobjInterfaz.fnGeneraQueryToXML(consulta)>

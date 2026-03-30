<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>

 <cfquery name="consulta" datasource="#session.DSN#">
	select 
		 cf.CFcodigo
		,cf.CFdescripcion
		,o.Oficodigo
		,o.Odescripcion
		,d.Deptocodigo
		,d.Dcodigo
		,d.Ddescripcion
		
	from CFuncional cf
		inner join Oficinas o
			on o.Ocodigo = cf.Ocodigo
		   and o.Ecodigo = cf.Ecodigo
		inner join Departamentos d
			on d.Dcodigo = cf.Dcodigo
		   and d.Ecodigo = cf.Ecodigo
	where cf.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">		
</cfquery> 

<cfset GvarXML_OE = LobjInterfaz.fnGeneraQueryToXML(consulta)>

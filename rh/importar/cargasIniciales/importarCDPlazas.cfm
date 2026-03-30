<cfquery datasource="#session.DSN#">
	insert into CDRHHPlazas( CDRHHPLcodigo,CDRHHPLdescripcion,CDRHHCFcodigo,CDRHHPcodigo,Ecodigo )
	select codigo, descripcion, centrofuncional,puesto,#session.Ecodigo#
	from #table_name#	
</cfquery>
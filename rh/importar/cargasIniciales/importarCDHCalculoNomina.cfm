<cfquery datasource="#session.DSN#">
	insert into CDRHHRCalculoNomina (CDRHHRCnomina, CDRHHRCdescripcion, CDRHHRCfdesde, 
									CDRHHRCfhasta, Ecodigo)
	select nomina, descripcion, fechadesde, fechahasta, #session.Ecodigo#
	from #table_name#	
</cfquery>
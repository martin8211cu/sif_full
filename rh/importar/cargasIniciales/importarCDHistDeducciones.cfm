<cfquery datasource="#session.DSN#">
	insert into CDRHHDeduccionesCalculo( CDRHHDCidentificacion, 
										 CDRHHDCfdesde, 
										 CDRHHDCfhasta, 
										 CDRHHDCdeduccion, 
										 CDRHHDCvalor, 
										 CDRHHDCnomina, 
										 CDRHHDCsocio, 
										 Ecodigo)
	select 	cedula, 
			desde, 
			hasta, 
			deduccion, 
			valor, 
			nomina, 
			socio_negocio,
			#session.Ecodigo#
	from #table_name#											
</cfquery>
									 
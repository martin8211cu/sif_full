<cfquery datasource="#session.DSN#">
	insert into CDRHHIncidenciasCalculo( CDRHHICidentificacion, 
										 CDRHHICfdesde, 
										 CDRHHICfhasta, 
										 CDRHHICincidencia,
                                         CDRHHICcantidad, 
										 CDRHHICfecha,
                                         CDRHHICcfuncional, 
                                         CDRHHICnomina, 
										 CDRHHICvalor, 
                                         CDRHHIfechacontrol,
										 CDRHHICespecie,								  
										 Ecodigo)
	select 	cedula,
			desde,
			hasta,
			incidencia,
            cantidad,
            fecha,
            centro_funcional,
            nomina,
			monto,
            fecha_control,
            especie,
			#session.Ecodigo#
	from #table_name#
</cfquery>							
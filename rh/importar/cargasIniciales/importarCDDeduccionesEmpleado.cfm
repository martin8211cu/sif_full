<cfquery datasource="#session.DSN#">
	insert into CDRHHDeduccionesEmpleado( 	CDRHHDEidentificacion, 
											CDRHHDEfdesde, 
											CDRHHDEfhasta, 
											CDRHHDEdeduccion, 
											CDRHHDEvalor, 
											CDRHHDEnomina, 
											CDRHHDEsocio, 
                                            CDRHHDmetodo,
                                            CDRHHDmonto,
                                            Ecodigo)
	select 	cedula, 
			desde, 
			hasta, 
			deduccion, 
			valor, 
			nomina, 
			socio_negocio,
            metodo,
            monto,
            #session.Ecodigo#
	from #table_name#											
</cfquery>
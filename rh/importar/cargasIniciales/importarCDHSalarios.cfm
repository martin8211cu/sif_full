<cfquery datasource="#session.DSN#">
	insert into CDRHHSalarioEmpleado( CDRHHSEidentificacion, 
									  CDRHHSEfdesde, 
									  CDRHHSEfhasta, 
									  CDRHHSEsalariobruto, 
									  CDRHHSEincidencias, 
									  CDRHHSEcargasemp, 
									  CDRHHSEcargaspat, 
									  CDRHHSErenta, 
									  CDRHHSEdeducciones, 
									  CDRHHSEliquido, 
									  CDRHHSEnomina, 
                                      CDRHHSEsubsidiotablas,
									  Ecodigo)

	select 	cedula, 
			desde, 
			hasta, 
			bruto, 
			incidencias, 
			cargas_emp, 
			cargas_pat, 
			renta, 
			deducciones, 
			liquido, 
			nomina, 
            subsidio_tablas,
			#session.Ecodigo#
	from #table_name#
</cfquery>							
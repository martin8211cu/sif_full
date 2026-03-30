<cfquery datasource="#session.DSN#">
	insert into CDRHHPagosEmpleado(	CDRHHPEidentificacion, CDRHHPEfdesde, CDRHHPEfhasta, 
									CDRHHPEsalario, CDRHHPEdias, CDRHHPEdevengado, 
									CDRHHPEnomina, Ecodigo, CDRHTcodigo, CDRHHPEsalarioref,
                                    CDRHHPEfcorteinic, CDRHHPEfcortefin, CDRHHPEsalariobc
                                    )
	select 	cedula, fechadesde, fechahasta, 
			salario, dias, devengado, 
			nomina, #session.Ecodigo#, rhtcodigo, pesalarioref, 
            finiccorte, ffincorte, salariobc
	from #table_name#	
</cfquery>


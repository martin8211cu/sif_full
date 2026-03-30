<cfquery datasource="#session.DSN#">
	insert into CDRHHCargasCalculo( CDRHHCCidentificacion, 
									CDRHHCCfdesde, 
									CDRHHCCfhasta, 
									CDRHHCCcarga, 
									CDRHHCvaloremp, 
									CDRHHCvalorpat, 
									CDRHHCnomina, 
									Ecodigo)
	select 	cedula,
			desde,
			hasta,
			carga,
			valor_emp,
			valor_pat,
			nomina,
			#session.Ecodigo#
	from #table_name#
</cfquery>							
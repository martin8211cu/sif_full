<cfquery datasource="asp" name="grupo">
	select 	{fn concat({fn concat(rtrim(SScodigo), '.')}, rtrim(SGcodigo))}  as valor, <!--- rtrim(SScodigo) || '.' || rtrim(SMcodigo) as valor,  --->
			SGdescripcion as descr,
			SScodigo as grupo, '' as refer
	from SGModulos
	order by 1
</cfquery>
<cfquery datasource="asp" name="grupo">
	select 	{fn concat({fn concat(rtrim(SScodigo), '.')}, rtrim(SMcodigo))}  as valor, <!--- rtrim(SScodigo) || '.' || rtrim(SMcodigo) as valor,  --->
			SMdescripcion as descr, 
			SScodigo as grupo, '' as refer
	from SModulos
	order by 1
</cfquery>
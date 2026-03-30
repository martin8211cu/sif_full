<cfquery datasource="asp" name="grupo">
	select 	{fn concat({fn concat(rtrim(SScodigo), '.')}, rtrim(SRcodigo))} as valor, <!--- rtrim(SScodigo) || '.' || rtrim(SRcodigo) as valor --->
			SRdescripcion as descr,
			rtrim(SScodigo) as grupo, 
			'' as refer
	from SRoles
	order by 1
</cfquery>
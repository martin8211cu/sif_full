<cfquery datasource="asp" name="grupo">
	select Ppais as valor, Pnombre as descr,
		'' as grupo, '' as refer
	from Pais
	order by 1
</cfquery>
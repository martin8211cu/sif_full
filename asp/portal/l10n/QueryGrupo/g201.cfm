<cfquery datasource="asp" name="grupo">
	select Miso4217 as valor, Mnombre as descr,
		'' as grupo, '' as refer
	from Moneda
	order by 1
</cfquery>
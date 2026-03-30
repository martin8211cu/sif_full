<cfquery datasource="asp" name="grupo">
	select SScodigo as valor, SSdescripcion as descr, '' as grupo, '' as refer
	from SSistemas
	order by 1
</cfquery>
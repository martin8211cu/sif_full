<!--- poner en refer el menu padre --->
<cfquery datasource="asp" name="grupo">
	select id_pagina as valor, nombre_pagina as descr,
		'' as grupo, '' as refer
	from SPagina
	order by 2
</cfquery>
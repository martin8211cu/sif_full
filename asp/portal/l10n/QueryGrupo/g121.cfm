<!--- poner en refer el menu padre --->
<cfquery datasource="asp" name="grupo">
	select id_portlet as valor, nombre_portlet as descr,
		'' as grupo, '' as refer
	from SPortlet
	order by 2
</cfquery>
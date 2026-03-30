<!--- este --->
<cfquery datasource="asp" name="grupo">
	select id_menu as valor, nombre_menu as descr, '' as grupo, '' as refer
	from SMenu
	where ocultar_menu = 0
	order by 1
</cfquery>
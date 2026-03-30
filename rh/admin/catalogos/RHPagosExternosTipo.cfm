<!--- * modificado en notepad para incluir el boom * --->
<cfinclude template="RHPagosExternosTipo-dicc.cfm">

<cf_templateheader title="#LB_RHPagosExternosTipo#">
<cf_web_portlet_start titulo="#LB_RHPagosExternosTipo#"/>

<cfif IsDefined("url.PEXTid") and Len(url.PEXTid) or IsDefined("url.edit") or IsDefined("url.btnNuevo")>
	<cfinclude template="RHPagosExternosTipo-form.cfm">
<cfelse>
	<cfset checked = "<img src=''/cfmx/rh/imagenes/checked.gif'' border=''0''>">
	<cfset unchecked = "<img src=''/cfmx/rh/imagenes/unchecked.gif'' border=''0''>">
	<cfset reselect = QueryNew("value,description","cf_sql_integer,cf_sql_varchar")>
	<cfset QueryAddRow(reselect,3)>
	<cfset QuerySetCell(reselect,"value",-1,1)>
	<cfset QuerySetCell(reselect,"description","Todos",1)>
	<cfset QuerySetCell(reselect,"value",0,2)>
	<cfset QuerySetCell(reselect,"description","No Aplica",2)>
	<cfset QuerySetCell(reselect,"value",1,3)>
	<cfset QuerySetCell(reselect,"description","Aplica",3)>
	<cfinvoke component="rh.Componentes.pListas" method="pListaRH"
		tabla="RHPagosExternosTipo"
		columnas="PEXTid,PEXTcodigo,PEXTdescripcion, case PEXTsirenta when 1 then '#checked#' else '#unchecked#' end as PEXTsirenta
			, case PEXTsicargas when 1 then '#checked#' else '#unchecked#' end as PEXTsicargas"
		filtro="Ecodigo = #session.Ecodigo# order by PEXTcodigo,PEXTdescripcion"
		desplegar="PEXTcodigo,PEXTdescripcion,PEXTsirenta,PEXTsicargas"
		rsPEXTsirenta="#reselect#"
		rsPEXTsicargas="#reselect#"
		etiquetas="#LB_Codigo#,#LB_Descripcion#,#LB_PEXTsirenta#,#LB_PEXTsicargas#"
		formatos="S,S,S,S"
		align="left,left,left,left"
		ira="RHPagosExternosTipo.cfm"
		form_method="get"
		keys="PEXTid"
		mostrar_filtro="yes"
		filtrar_automatico="yes"
		botones="Nuevo"
	/>
</cfif>
<cf_web_portlet_end/>
<cf_templatefooter>


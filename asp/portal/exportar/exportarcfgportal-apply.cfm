<cfsetting enablecfoutputonly="yes" requesttimeout="600">
<cfparam name="form.tipo"			type="string" default="">
<cfparam name="form.menues"			type="string" default="0">
<cfparam name="form.menuesocultos"	type="string" default="0">
<cfparam name="form.paginas"		type="string" default="0">
<cfparam name="form.dbms"			type="string" default="syb">

<cfset newline = Chr(13)&Chr(10)>
<cfset indent  = "  ">
<cfinclude template="functions.cfm">
<cfset set_dbms(form.dbms)>

<cfif (tipo EQ "sql")>
	<cfcontent type="text/plain; charset=utf-8">
	<cfheader name="Content-Disposition" value="attachment; filename=portalconfig-#dbms_type#.sql" >
	<cfoutput>-- Exportacion de Configuracion del Portal ASP</cfoutput>
	<cfoutput>-- SYBASE : isql -Usa -Ppasswd -Sserver_name -D asp -i framework-app.sql # newline # </cfoutput>
	<cfoutput>-- ORACLE : sqlplus user/passwd@server_name @framework-app.sql # newline # </cfoutput>
	<cfoutput>-- DB2    : db2 -td/ vf framework-app.sql # newline # </cfoutput>
	<cfoutput>#dbms_go#</cfoutput>
	<!--- este set nocount va a dar errores en oracle, pero no importa porque sigue --->
	<cfoutput>#dbms_sql_init()#</cfoutput>
</cfif>

<cfset insertonly = isDefined("form.insertonly")>

<cfif form.menues EQ '1'>

	<cfset identity_insert_on('SMenuItem','id_item')>
	<cfquery datasource="asp" name="ret_menuitem">
		select * from SMenuItem
	</cfquery>
	<cfset gen(ret_menuitem, "SMenuItem", "id_item", form.tipo, insertonly)>
	<cfset identity_insert_off('SMenuItem','id_item',ret_menuitem)>

	<cfset identity_insert_on('SMenu','id_menu')>
	<cfquery datasource="asp" name="ret_menu">
		select * from SMenu
		<cfif form.menuesocultos EQ '0'>
		where ocultar_menu = 0
		</cfif>
	</cfquery>
	<cfset gen(ret_menu, "SMenu", "id_menu", form.tipo, insertonly)>
	<cfset identity_insert_off('SMenu','id_menu',ret_menu)>

	<cfquery datasource="asp" name="ret_rel">
		select * from SRelacionado
	</cfquery>
	<cfset gen(ret_rel, "SRelacionado", "id_padre,id_hijo", form.tipo, insertonly)>
</cfif>

<cfif form.paginas EQ '1'>
	<cfset identity_insert_on('SPagina','id_pagina')>
	<cfquery datasource="asp" name="ret_pagina">
		select * from SPagina
	</cfquery>
	<cfset gen(ret_pagina, "SPagina", "id_pagina", form.tipo, insertonly)>
	<cfset identity_insert_off('SPagina','id_pagina',ret_pagina)>

	<cfset identity_insert_on('SPortlet','id_portlet')>
	<cfquery datasource="asp" name="ret_sportlet">
		select * from SPortlet
	</cfquery>
	<cfset gen(ret_sportlet, "SPortlet", "id_portlet", form.tipo, insertonly)>
	<cfset identity_insert_off('SPortlet','id_portlet',ret_sportlet)>

	<cfquery datasource="asp" name="ret_portletpagina">
		select * from SPortletPagina
	</cfquery>
	<cfset gen(ret_portletpagina, "SPortletPagina", "id_pagina,id_portlet", form.tipo, insertonly)>
</cfif>

<cfoutput><cfif form.tipo EQ "sql">
<!--- no indentar ---><cfif not insertonly>
-- Eliminar componentes que no van
#dbms_print("Eliminar SRelacionado que no van")#
#dbms_go#
create table TMPDATA_IMPORT (
  id_padre numeric(18) not null,
  id_hijo  numeric(18) not null
)
#dbms_go#
<cfloop query="ret_rel">
insert INTO TMPDATA_IMPORT values (#quoteSQL(ret_rel.id_padre,'numeric')#, #quoteSQL(ret_rel.id_hijo,'numeric')#)
#dbms_go#
</cfloop>
delete from SRelacionado
where not exists (
	select * from TMPDATA_IMPORT
	where TMPDATA_IMPORT.id_padre = SRelacionado.id_padre
	  and TMPDATA_IMPORT.id_hijo = SRelacionado.id_hijo
)
#dbms_go#
#dbms_print("SRelacionado eliminados")#
drop table TMPDATA_IMPORT
#dbms_go#

-- Eliminar componentes que no van
#dbms_print("Eliminar SMenu que no van")#
#dbms_go#
create table TMPDATA_IMPORT (
  id_menu numeric(18) not null
)
#dbms_go#
<cfloop query="ret_menu">
insert INTO TMPDATA_IMPORT values (#quoteSQL(ret_menu.id_menu,'numeric')#)
#dbms_go#
</cfloop>
delete from SMenu
where not exists (
	select * from TMPDATA_IMPORT
	where TMPDATA_IMPORT.id_menu = SMenu.id_menu
)
<cfif form.menuesocultos EQ '0'>
and ocultar_menu = 0
</cfif>
#dbms_go#
#dbms_print("SMenu eliminados")#
drop table TMPDATA_IMPORT
#dbms_go#
<cfif form.paginas EQ '1'>
-- Eliminar SPortletPagina que no van
#dbms_print("Eliminar SPortletPagina que no van")#
#dbms_go#
create table TMPDATA_IMPORT (
  id_pagina numeric(18) not null,
  id_portlet numeric(18) not null
)
#dbms_go#
<cfloop query="ret_portletpagina">
insert INTO TMPDATA_IMPORT values (#quoteSQL(ret_portletpagina.id_pagina,'numeric')#, #quoteSQL(ret_portletpagina.id_portlet,'numeric')#)
#dbms_go#
</cfloop>
delete from SPortletPagina
where not exists (
	select * from TMPDATA_IMPORT
	where TMPDATA_IMPORT.id_pagina = SPortletPagina.id_pagina
	  and TMPDATA_IMPORT.id_portlet = SPortletPagina.id_portlet
)
#dbms_go#
#dbms_print("SPortletPagina eliminados")#
drop table TMPDATA_IMPORT
#dbms_go#
-- Eliminar SPagina que no van
#dbms_print("Eliminar SPagina que no van")#
#dbms_go#
create table TMPDATA_IMPORT (
  id_pagina numeric(18) not null
)
#dbms_go#
<cfloop query="ret_pagina">
insert INTO TMPDATA_IMPORT values (#quoteSQL(ret_pagina.id_pagina,'numeric')#)
#dbms_go#
</cfloop>
delete from SPagina
where not exists (
	select * from TMPDATA_IMPORT
	where TMPDATA_IMPORT.id_pagina = SPagina.id_pagina
)
#dbms_go#
#dbms_print("SPagina eliminados")#
drop table TMPDATA_IMPORT
#dbms_go#
-- Eliminar SPortlet que no van
#dbms_print("Eliminar SPortlet que no van")#
#dbms_go#
create table TMPDATA_IMPORT (
  id_portlet numeric(18) not null
)
#dbms_go#
<cfloop query="ret_sportlet">
insert INTO TMPDATA_IMPORT values (#quoteSQL(ret_sportlet.id_portlet,'numeric')#)
#dbms_go#
</cfloop>
delete from SPortlet
where not exists (
	select * from TMPDATA_IMPORT
	where TMPDATA_IMPORT.id_portlet = SPortlet.id_portlet
)
#dbms_go#
#dbms_print("SPortlet eliminados")#
drop table TMPDATA_IMPORT
#dbms_go#
</cfif><!--- form.paginas is '1' --->
-- Eliminar componentes que no van
#dbms_print("Eliminar SMenuItem que no van")#
#dbms_go#
create table TMPDATA_IMPORT (
  id_item numeric(18) not null
)
#dbms_go#
<cfloop query="ret_menuitem">
insert INTO TMPDATA_IMPORT values (#quoteSQL(ret_menuitem.id_item,'numeric')#)
#dbms_go#
</cfloop>
delete from SMenuItem
where not exists (
	select * from TMPDATA_IMPORT
	where TMPDATA_IMPORT.id_item = SMenuItem.id_item
)
#dbms_go#
#dbms_print("SMenuItem eliminados")#
drop table TMPDATA_IMPORT
#dbms_go#

</cfif></cfif>
#dbms_print('Importacion finalizada. A continuacion la cuenta de los registros')#

select 'SMenuItem            ' as tipo, count(1) as real, #ret_menuitem.RecordCount# as esperado
from SMenuItem
#dbms_go#

select 'SMenu                ' as tipo, count(1) as real, #ret_menu.RecordCount# as esperado
from SMenu<cfif form.menuesocultos EQ '0'>
where ocultar_menu = 0</cfif>
#dbms_go#

select 'SRelacionado         ' as tipo, count(1) as real, #ret_rel.RecordCount# as esperado
from SRelacionado
#dbms_go#
<cfif form.paginas NEQ '0'>
select 'SPortlet             ' as tipo, count(1) as real, #ret_sportlet.RecordCount# as esperado
from SPortlet
#dbms_go#

select 'SPagina              ' as tipo, count(1) as real, #ret_pagina.RecordCount# as esperado
from SPagina
#dbms_go#

select 'SPortletPagina       ' as tipo, count(1) as real, #ret_portletpagina.RecordCount# as esperado
from SPortletPagina
#dbms_go#
</cfif><!--- form.paginas is '1' --->
-- Fin de archivo
</cfoutput>

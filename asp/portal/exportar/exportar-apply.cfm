<cfsetting enablecfoutputonly="yes" requesttimeout="600">
<cfparam name="form.tipo"     type="string" default="">
<cfparam name="form.rango"    type="string" default="">
<cfparam name="form.SScodigo" type="string" default="">
<cfparam name="form.SMcodigo" type="string" default="">
<cfparam name="form.SPcodigo" type="string" default="">
<cfparam name="form.dbms"     type="string" default="syb">

<cfif form.rango IS 'm'>
	<cfset form.SScodigo = ListGetAt(form.SMcodigo,1)>
	<cfset form.SMcodigo = ListGetAt(form.SMcodigo,2)>
<cfelseif form.rango IS 'p'>
	<cfset form.SScodigo = form.SScodigo_P>
	<cfset form.SMcodigo = form.SMcodigo_P>
	<cfset form.SPcodigo = form.SPcodigo_P>
<cfelseif form.rango IS 'r'>
	<cfset form.SScodigo 	  = ListGetAt(form.SMrol,1)>
	<cfset form.SRcodigo      = ListGetAt(form.SMrol,2)>
	<cfset form.SRdescripcion = ListGetAt(form.SMrol,3)>
</cfif>

<cfset newline = Chr(13)&Chr(10)>
<cfset indent  = "  ">
<cfif Not IsDefined('quoteSQL')>
	<!--- este IF es para el caso en que la seguridad se exporte desde un parche --->
	<cfinclude template="functions.cfm">
</cfif>
<cfset set_dbms(form.dbms)>

<cfif (tipo EQ "xml")>
	<cfheader name="Content-Disposition" value="attachment; filename=framework-app.xml">
<cfoutput><?xml version="1.0" encoding="utf-8" ?>
<datos>
  <filtro>
    <cfif form.rango EQ 's'><sistema>#XmlFormat(form.SScodigo)#</sistema>
    <cfelseif form.rango EQ 'm'><sistema>#XmlFormat(form.SScodigo)#</sistema><modulo>#XmlFormat(form.SMcodigo)#</modulo>
	<cfelseif form.rango EQ 'p'><sistema>#XmlFormat(form.SScodigo)#</sistema><modulo>#XmlFormat(form.SMcodigo)#</modulo><proceso>#XmlFormat(form.SPcodigo)#</proceso>
	<cfelseif form.rango EQ 'r'><sistema>#XmlFormat(form.SScodigo)#</sistema><rol>#XmlFormat(form.SRcodigo)#</rol><proceso>#XmlFormat(form.SRdescripcion)#</proceso>
	<cfelse><exportar_todo /></cfif>
  </filtro>
</cfoutput>
<cfelseif (tipo EQ "sql")>

	<cfif Not IsDefined('form.included')>
		<cfcontent type="text/plain">
		<cfheader name="Content-Disposition" value="attachment; filename=framework-#dbms_type#.sql" >
	</cfif>
	<cfoutput> -- Exportación </cfoutput>
    <cfif form.rango EQ 's'><cfoutput>del sistema # form.SScodigo #</cfoutput>
    <cfelseif form.rango EQ 'm'><cfoutput>del modulo # form.SScodigo # # form.SMcodigo #</cfoutput>
	<cfelseif form.rango EQ 'p'><cfoutput>del proceso # form.SScodigo # # form.SMcodigo # # form.SPcodigo #</cfoutput>
	<cfelseif form.rango EQ 'r'><cfoutput>del rol # form.SScodigo # # form.SRcodigo # # form.SRdescripcion #</cfoutput>
	<cfelse><cfoutput>completa, todos los sistemas</cfoutput></cfif>
	<cfoutput># newline # -- SYBASE: isql -Usa -Ppasswd -Sserver_name -D asp -i framework-app.sql # newline # </cfoutput>
	<cfoutput># newline # -- ORACLE: sqlplus user/passwd@server_name @framework-app.sql # newline # </cfoutput>
	<cfoutput># newline # -- DB2:    db2 -td/ vf framework-app.sql # newline # </cfoutput>
	<cfoutput># newline # -- # newline ##dbms_go## newline #</cfoutput>
	<!--- este set nocount va a dar errores en oracle, pero no importa porque sigue --->
	<cfoutput>#dbms_sql_init()#</cfoutput>
</cfif>

<cfset insertonly = isDefined("form.insertonly")>

<cfif IsDefined("form.politica")>
	<cfquery datasource="asp" name="ret_pol">
		select * from PLista
	</cfquery>
	<cfset gen(ret_pol, "PLista", "parametro", form.tipo, insertonly) >
</cfif>

<cfquery datasource="asp" name="ret_sis">
		select * from SSistemas a
		<cfif form.rango EQ 's' >
		where a.SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SScodigo#">
		<cfelseif form.rango EQ 'm' >
		where a.SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SScodigo#">
		<cfelseif form.rango EQ 'p' >
		where a.SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SScodigo#">
		<cfelseif form.rango EQ 'r' >
		where a.SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SScodigo#">
		</cfif>
	</cfquery>
<cfset gen(ret_sis, "SSistemas", "SScodigo", form.tipo, insertonly) >

<cfquery datasource="asp" name="ret_gmod">
		select * from SGModulos a
		<cfif form.rango EQ 's' >
		where a.SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SScodigo#">
		<cfelseif form.rango EQ 'm' or form.rango EQ 'p' or form.rango EQ 'r'>
		where a.SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SScodigo#">
			and a.SGcodigo = (select SGcodigo
								from SModulos
								where SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SScodigo#">
									and SMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SMcodigo#">)
		</cfif>
	</cfquery>

<cfset gen(ret_gmod, "SGModulos", "SGcodigo", form.tipo, insertonly) >

<cfquery datasource="asp" name="ret_mod">
		select * from SModulos a
		<cfif form.rango EQ 's' >
			where a.SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SScodigo#">
		<cfelseif form.rango EQ 'r' >
			where a.SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SScodigo#">
		<cfelseif form.rango EQ 'm' >
			where a.SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SScodigo#">
			  and a.SMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SMcodigo#">
		<cfelseif form.rango EQ 'p' >
			where a.SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SScodigo#">
			  and a.SMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SMcodigo#">
		</cfif>
	</cfquery>
<cfset gen(ret_mod, "SModulos", "SScodigo,SMcodigo", form.tipo, insertonly) >

<cfquery datasource="asp" name="ret_rol">
		select * from SRoles a
		<cfif form.rango EQ 's' >
		where a.SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SScodigo#">
		<cfelseif form.rango EQ 'm' >
		where a.SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SScodigo#">
		<cfelseif form.rango EQ 'p' >
		where a.SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SScodigo#">
		<cfelseif form.rango EQ 'r' >
		where a.SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SScodigo#">
		and a.SRcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SRcodigo#">
		</cfif>
	</cfquery>
<cfset gen(ret_rol, "SRoles", "SScodigo,SRcodigo", form.tipo, insertonly) >

<cfquery datasource="asp" name="ret_pro">
		select *
		from SProcesos a
		<cfif form.rango EQ 's' >
		where a.SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SScodigo#">
		<cfelseif form.rango EQ 'r' >
		where a.SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SScodigo#">
		<cfelseif form.rango EQ 'm' >
		where a.SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SScodigo#">
		  and a.SMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SMcodigo#">
		<cfelseif form.rango EQ 'p' >
		where a.SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SScodigo#">
		  and a.SMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SMcodigo#">
		  and a.SPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SPcodigo#">
		</cfif>
	</cfquery>
<cfset gen(ret_pro, "SProcesos", "SScodigo,SMcodigo,SPcodigo", form.tipo, insertonly) >

<cfquery datasource="asp" name="ret_prorol">
		select * from SProcesosRol a
		<cfif form.rango EQ 's' >
		where a.SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SScodigo#">
		<cfelseif form.rango EQ 's' >
		where a.SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SScodigo#">
		and a.SRcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SRcodigo#">
		<cfelseif form.rango EQ 'm' >
		where a.SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SScodigo#">
		  and a.SMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SMcodigo#">
		<cfelseif form.rango EQ 'p' >
		where a.SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SScodigo#">
		  and a.SMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SMcodigo#">
		  and a.SPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SPcodigo#">
		</cfif>
	</cfquery>
<cfset gen(ret_prorol, "SProcesosRol", "SScodigo,SMcodigo,SPcodigo,SRcodigo", form.tipo, insertonly) >

<cfquery datasource="asp" name="ret_com">
		select *
		from SComponentes a
		<cfif form.rango EQ 's' >
		where a.SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SScodigo#">
		<cfelseif form.rango EQ 'r' >
		where a.SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SScodigo#">
		<cfelseif form.rango EQ 'm' >
		where a.SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SScodigo#">
		  and a.SMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SMcodigo#">
		<cfelseif form.rango EQ 'p' >
		where a.SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SScodigo#">
		  and a.SMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SMcodigo#">
		  and a.SPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SPcodigo#">
		</cfif>
	</cfquery>
<cfset gen(ret_com, "SComponentes", "SScodigo,SMcodigo,SPcodigo,SCuri", form.tipo, insertonly) >

<cfquery datasource="asp" name="ret_men">
		select *  from SMenues a
		<cfif form.rango EQ 's' >
		where a.SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SScodigo#">
		<cfelseif form.rango EQ 'r' >
		where a.SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SScodigo#">
		<cfelseif form.rango EQ 'm' >
		where a.SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SScodigo#">
		  and a.SMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SMcodigo#">
		<cfelseif form.rango EQ 'p' >
		where a.SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SScodigo#">
		  and a.SMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SMcodigo#">
		  and a.SPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SPcodigo#">
		</cfif>
		order by SMNpath
	</cfquery>
<cfset gen(ret_men, "SMenues", "SMNcodigo", form.tipo, insertonly) >

<cfquery datasource="asp" name="ret_prorel">
		select *
		from SProcesoRelacionado a
		<cfif form.rango EQ 's' >
		where a.SSorigen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SScodigo#">
		   or a.SSdestino = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SScodigo#">
		<cfelseif form.rango EQ 'r' >
		where a.SSorigen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SScodigo#">
		   or a.SSdestino = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SScodigo#">
		<cfelseif form.rango EQ 'm' >
		where (a.SSorigen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SScodigo#"> and a.SMorigen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SMcodigo#">)
		   or (a.SSdestino = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SScodigo#"> and a.SMdestino = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SMcodigo#">)
		<cfelseif form.rango EQ 'p' >
		where (a.SSorigen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SScodigo#"> and a.SMorigen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SMcodigo#"> and a.SPorigen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SPcodigo#">)
		   or (a.SSdestino = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SScodigo#"> and a.SMdestino = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SMcodigo#"> and a.SPdestino = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SPcodigo#">)
		</cfif>
		order by SSorigen, SMorigen, SPorigen, SSdestino, SMdestino, SPdestino
	</cfquery>
<cfset gen(ret_prorel, "SProcesoRelacionado", "SSorigen,SMorigen,SPorigen,SSdestino,SMdestino,SPdestino", form.tipo, insertonly) >

<cfif (tipo EQ "xml") >
<cfoutput></datos></cfoutput>
<cfelseif form.tipo EQ "sql">
<cfoutput><!--- no indentar ---><cfif not insertonly>
-- Eliminar componentes que no van
#dbms_print("Eliminar componentes que no van")#
#dbms_go#
<cfif ListFind('ora', form.dbms )>
    create table TMPDATA_IMPORT (
      SScodigo varchar2(10) not null,
      SMcodigo varchar2(10) not null,
      SPcodigo varchar2(10) not null,
      SCuri varchar2(255) not null)
    #dbms_go#
<cfelse>
    create table TMPDATA_IMPORT (
      SScodigo char(10) not null,
      SMcodigo char(10) not null,
      SPcodigo char(10) not null,
      SCuri varchar(255) not null)
    #dbms_go#
</cfif>
<cfloop query="ret_com">
insert INTO TMPDATA_IMPORT values (#quoteSQL(ret_com.SScodigo,'varchar')#, #quoteSQL(ret_com.SMcodigo,'varchar')
	#, #quoteSQL(ret_com.SPcodigo,'varchar')#, #quoteSQL(ret_com.SCuri,'varchar')#)
#dbms_go#
</cfloop>
delete from SComponentes
where 1=1<cfif form.rango EQ 's' >
  		and SScodigo = #quoteSQL(form.SScodigo,'varchar')#<cfelseif form.rango EQ 'r' >
		and SScodigo = #quoteSQL(form.SScodigo,'varchar')#<cfelseif form.rango EQ 'm' >
		and SScodigo = #quoteSQL(form.SScodigo,'varchar')#
		and SMcodigo = #quoteSQL(form.SMcodigo,'varchar')#<cfelseif form.rango EQ 'p' >
		 and SScodigo = #quoteSQL(form.SScodigo,'varchar')#
		 and SMcodigo = #quoteSQL(form.SMcodigo,'varchar')#
		 and SPcodigo = #quoteSQL(form.SPcodigo,'varchar')#
		 </cfif>
  and not exists (select * from TMPDATA_IMPORT
	where TMPDATA_IMPORT.SScodigo = rtrim(SComponentes.SScodigo)
	  and TMPDATA_IMPORT.SMcodigo = rtrim(SComponentes.SMcodigo)
	  and TMPDATA_IMPORT.SPcodigo = rtrim(SComponentes.SPcodigo)
	  and TMPDATA_IMPORT.SCuri = rtrim(SComponentes.SCuri))
#dbms_go#
#dbms_print("SComponentes eliminados")#
drop table TMPDATA_IMPORT
#dbms_go#

-- Eliminar menues que no van
#dbms_print("Eliminar menues que no van")#
#dbms_go#
create table TMPDATA_IMPORT (
  SMNcodigo numeric(18) not null)
#dbms_go#
<cfloop query="ret_men">
insert INTO TMPDATA_IMPORT values (#quoteSQL(ret_men.SMNcodigo,'numeric')#)
#dbms_go#
</cfloop>
delete from SMenues
where 1=1<cfif form.rango EQ 's' >
  and SScodigo = #quoteSQL(form.SScodigo,'varchar')#<cfelseif form.rango EQ 'r' >
  and SScodigo = #quoteSQL(form.SScodigo,'varchar')#<cfelseif form.rango EQ 'm' >
  and SScodigo = #quoteSQL(form.SScodigo,'varchar')#
  and SMcodigo = #quoteSQL(form.SMcodigo,'varchar')#<cfelseif form.rango EQ 'p' >
  and SScodigo = #quoteSQL(form.SScodigo,'varchar')#
  and SMcodigo = #quoteSQL(form.SMcodigo,'varchar')#
  and SPcodigo = #quoteSQL(form.SPcodigo,'varchar')#</cfif>
  and not exists (select * from TMPDATA_IMPORT
	where TMPDATA_IMPORT.SMNcodigo = SMenues.SMNcodigo)
#dbms_go#
#dbms_print("SMenues eliminados")#
drop table TMPDATA_IMPORT
#dbms_go#

-- Eliminar procesos relacionados que no van
#dbms_print("Eliminar procesos relacionados que no van")#
#dbms_go#
<cfif ListFind('ora', form.dbms )>
    create table TMPDATA_IMPORT (
      SSorigen varchar2(10) not null,
      SMorigen varchar2(10) not null,
      SPorigen varchar2(10) not null,
      SSdestino varchar2(10) not null,
      SMdestino varchar2(10) not null,
      SPdestino varchar2(10) not null
    )
    #dbms_go#
<cfelse>
    create table TMPDATA_IMPORT (
      SSorigen char(10) not null,
      SMorigen char(10) not null,
      SPorigen char(10) not null,
      SSdestino char(10) not null,
      SMdestino char(10) not null,
      SPdestino char(10) not null
    )
    #dbms_go#
</cfif>

<cfloop query="ret_prorel">
insert INTO TMPDATA_IMPORT values (#quoteSQL(ret_prorel.SSorigen,'varchar')#, #quoteSQL(ret_prorel.SMorigen,'varchar')#, #quoteSQL(ret_prorel.SPorigen,'varchar')#, #quoteSQL(ret_prorel.SSdestino,'varchar')#, #quoteSQL(ret_prorel.SMdestino,'varchar')#, #quoteSQL(ret_prorel.SPdestino,'varchar')#)
#dbms_go#
</cfloop>
delete from SProcesoRelacionado
where 1=1<cfif form.rango EQ 's' >
   and (SSorigen = #quoteSQL(form.SScodigo,'varchar')#
   or SSdestino = #quoteSQL(form.SScodigo,'varchar')#) <cfelseif form.rango EQ 'r' >
   and (SSorigen = #quoteSQL(form.SScodigo,'varchar')#
   or SSdestino = #quoteSQL(form.SScodigo,'varchar')#) <cfelseif form.rango EQ 'm' >
  and ((SSorigen = #quoteSQL(form.SScodigo,'varchar')# and SMorigen = #quoteSQL(form.SMcodigo,'varchar')#)
   or (SSdestino = #quoteSQL(form.SScodigo,'varchar')# and SMdestino = #quoteSQL(form.SMcodigo,'varchar')#))<cfelseif form.rango EQ 'p' >
  and ((SSorigen = #quoteSQL(form.SScodigo,'varchar')# and SMorigen = #quoteSQL(form.SMcodigo,'varchar')# and SPorigen = #quoteSQL(form.SPcodigo,'varchar')#)
   or (SSdestino = #quoteSQL(form.SScodigo,'varchar')# and SMdestino = #quoteSQL(form.SMcodigo,'varchar')# and SPdestino = #quoteSQL(form.SPcodigo,'varchar')#))</cfif>
  and not exists (select * from TMPDATA_IMPORT
	where TMPDATA_IMPORT.SSorigen = rtrim(SProcesoRelacionado.SSorigen)
	  and TMPDATA_IMPORT.SMorigen = rtrim(SProcesoRelacionado.SMorigen)
	  and TMPDATA_IMPORT.SPorigen = rtrim(SProcesoRelacionado.SPorigen)
	  and TMPDATA_IMPORT.SSdestino = rtrim(SProcesoRelacionado.SSdestino)
	  and TMPDATA_IMPORT.SMdestino = rtrim(SProcesoRelacionado.SMdestino)
	  and TMPDATA_IMPORT.SPdestino = rtrim(SProcesoRelacionado.SPdestino)
  )
#dbms_go#
#dbms_print("SProcesoRelacionado eliminados")#
drop table TMPDATA_IMPORT
#dbms_go#

-- Eliminar procesos rol que no van
#dbms_print("Eliminar procesos que no van")#
#dbms_go#
<cfif ListFind('ora', form.dbms )>
    create table TMPDATA_IMPORT (
      SScodigo varchar2(10) not null,
      SRcodigo varchar2(10) not null,
      SMcodigo varchar2(10) not null,
      SPcodigo varchar2(10) not null)
    #dbms_go#
    create table TMPDATA_IMPORTROL (
      SScodigo varchar2(10) not null,
      SRcodigo varchar2(10) not null)
    #dbms_go#
<cfelse>
    create table TMPDATA_IMPORT (
      SScodigo char(10) not null,
      SRcodigo char(10) not null,
      SMcodigo char(10) not null,
      SPcodigo char(10) not null)
    #dbms_go#
    create table TMPDATA_IMPORTROL (
      SScodigo char(10) not null,
      SRcodigo char(10) not null)
    #dbms_go#
</cfif>
<cfloop query="ret_prorol">
insert INTO TMPDATA_IMPORT values (#quoteSQL(ret_prorol.SScodigo,'varchar')#, #quoteSQL(ret_prorol.SRcodigo,'varchar')#,
	#quoteSQL(ret_prorol.SMcodigo,'varchar')#, #quoteSQL(ret_prorol.SPcodigo,'varchar')#)
#dbms_go#
</cfloop>
<cfloop query="ret_rol">
insert INTO TMPDATA_IMPORTROL values (#quoteSQL(ret_rol.SScodigo,'varchar')#, #quoteSQL(ret_rol.SRcodigo,'varchar')#)
#dbms_go#
</cfloop>
delete from SProcesosRol
where 1=1<cfif form.rango EQ 's' >
  and SScodigo = #quoteSQL(form.SScodigo,'varchar')#<cfelseif form.rango EQ 'r' >
  and SScodigo = #quoteSQL(form.SScodigo,'varchar')#<cfelseif form.rango EQ 'm' >
  and SScodigo = #quoteSQL(form.SScodigo,'varchar')#
  and SMcodigo = #quoteSQL(form.SMcodigo,'varchar')#<cfelseif form.rango EQ 'p' >
  and SScodigo = #quoteSQL(form.SScodigo,'varchar')#
  and SMcodigo = #quoteSQL(form.SMcodigo,'varchar')#
  and SPcodigo = #quoteSQL(form.SPcodigo,'varchar')#</cfif>
  and not exists (select * from TMPDATA_IMPORT
	where TMPDATA_IMPORT.SScodigo = rtrim(SProcesosRol.SScodigo)
	  and TMPDATA_IMPORT.SRcodigo = rtrim(SProcesosRol.SRcodigo)
	  and TMPDATA_IMPORT.SMcodigo = rtrim(SProcesosRol.SMcodigo)
	  and TMPDATA_IMPORT.SPcodigo = rtrim(SProcesosRol.SPcodigo))
  and exists (select * from TMPDATA_IMPORTROL<!--- Solamente los roles que se estan importando --->
	where TMPDATA_IMPORTROL.SScodigo = rtrim(SProcesosRol.SScodigo)
	  and TMPDATA_IMPORTROL.SRcodigo = rtrim(SProcesosRol.SRcodigo))
#dbms_go#
#dbms_print("SProcesosRol eliminados")#
delete from UsuarioProceso
where 1=1<cfif form.rango EQ 's' >
  and SScodigo = #quoteSQL(form.SScodigo,'varchar')#<cfelseif form.rango EQ 'r' >
  and SScodigo = #quoteSQL(form.SScodigo,'varchar')#<cfelseif form.rango EQ 'm' >
  and SScodigo = #quoteSQL(form.SScodigo,'varchar')#
  and SMcodigo = #quoteSQL(form.SMcodigo,'varchar')#<cfelseif form.rango EQ 'p' >
  and SScodigo = #quoteSQL(form.SScodigo,'varchar')#
  and SMcodigo = #quoteSQL(form.SMcodigo,'varchar')#
  and SPcodigo = #quoteSQL(form.SPcodigo,'varchar')#</cfif>
  and not exists (select * from TMPDATA_IMPORT
	where TMPDATA_IMPORT.SScodigo = rtrim(UsuarioProceso.SScodigo)
	  and TMPDATA_IMPORT.SMcodigo = rtrim(UsuarioProceso.SMcodigo)
	  and TMPDATA_IMPORT.SPcodigo = rtrim(UsuarioProceso.SPcodigo))
#dbms_go#
#dbms_print("UsuarioProceso eliminados")#
delete from SShortcut
where 1=1<cfif form.rango EQ 's' >
  and SScodigo = #quoteSQL(form.SScodigo,'varchar')#<cfelseif form.rango EQ 'r' >
  and SScodigo = #quoteSQL(form.SScodigo,'varchar')#<cfelseif form.rango EQ 'm' >
  and SScodigo = #quoteSQL(form.SScodigo,'varchar')#
  and SMcodigo = #quoteSQL(form.SMcodigo,'varchar')#<cfelseif form.rango EQ 'p' >
  and SScodigo = #quoteSQL(form.SScodigo,'varchar')#
  and SMcodigo = #quoteSQL(form.SMcodigo,'varchar')#
  and SPcodigo = #quoteSQL(form.SPcodigo,'varchar')#</cfif>
  and not exists (select * from TMPDATA_IMPORT
	where TMPDATA_IMPORT.SScodigo = rtrim(SShortcut.SScodigo)
	  and TMPDATA_IMPORT.SMcodigo = rtrim(SShortcut.SMcodigo)
	  and TMPDATA_IMPORT.SPcodigo = rtrim(SShortcut.SPcodigo))
#dbms_go#
#dbms_print("SShortcut eliminados")#
delete from SRelacionado
where id_padre in (
select id_item
from SMenuItem
where SScodigo is not null
  and SMcodigo is not null
  and SPcodigo is not null<cfif form.rango EQ 's' >
  and SScodigo = #quoteSQL(form.SScodigo,'varchar')#<cfelseif form.rango EQ 'r' >
  and SScodigo = #quoteSQL(form.SScodigo,'varchar')#<cfelseif form.rango EQ 'm' >
  and SScodigo = #quoteSQL(form.SScodigo,'varchar')#
  and SMcodigo = #quoteSQL(form.SMcodigo,'varchar')#<cfelseif form.rango EQ 'p' >
  and SScodigo = #quoteSQL(form.SScodigo,'varchar')#
  and SMcodigo = #quoteSQL(form.SMcodigo,'varchar')#
  and SPcodigo = #quoteSQL(form.SPcodigo,'varchar')#</cfif>
  and not exists (select * from TMPDATA_IMPORT
	where TMPDATA_IMPORT.SScodigo = rtrim(SMenuItem.SScodigo)
	  and TMPDATA_IMPORT.SMcodigo = rtrim(SMenuItem.SMcodigo)
	  and TMPDATA_IMPORT.SPcodigo = rtrim(SMenuItem.SPcodigo)))
#dbms_go#
#dbms_print("SRelacionado/id_padre eliminados")#
delete from SRelacionado
where id_hijo in (
select id_item
from SMenuItem
where SScodigo is not null
  and SMcodigo is not null
  and SPcodigo is not null<cfif form.rango EQ 's' >
  and SScodigo = #quoteSQL(form.SScodigo,'varchar')#<cfelseif form.rango EQ 'r' >
  and SScodigo = #quoteSQL(form.SScodigo,'varchar')#<cfelseif form.rango EQ 'm' >
  and SScodigo = #quoteSQL(form.SScodigo,'varchar')#
  and SMcodigo = #quoteSQL(form.SMcodigo,'varchar')#<cfelseif form.rango EQ 'p' >
  and SScodigo = #quoteSQL(form.SScodigo,'varchar')#
  and SMcodigo = #quoteSQL(form.SMcodigo,'varchar')#
  and SPcodigo = #quoteSQL(form.SPcodigo,'varchar')#</cfif>
  and not exists (select * from TMPDATA_IMPORT
	where TMPDATA_IMPORT.SScodigo = rtrim(SMenuItem.SScodigo)
	  and TMPDATA_IMPORT.SMcodigo = rtrim(SMenuItem.SMcodigo)
	  and TMPDATA_IMPORT.SPcodigo = rtrim(SMenuItem.SPcodigo)))
#dbms_go#
#dbms_print("SRelacionado/id_hijo eliminados")#
delete from SMenuItem
where SScodigo is not null
  and SMcodigo is not null
  and SPcodigo is not null<cfif form.rango EQ 's' >
  and SScodigo = #quoteSQL(form.SScodigo,'varchar')#<cfelseif form.rango EQ 'r' >
  and SScodigo = #quoteSQL(form.SScodigo,'varchar')#<cfelseif form.rango EQ 'm' >
  and SScodigo = #quoteSQL(form.SScodigo,'varchar')#
  and SMcodigo = #quoteSQL(form.SMcodigo,'varchar')#<cfelseif form.rango EQ 'p' >
  and SScodigo = #quoteSQL(form.SScodigo,'varchar')#
  and SMcodigo = #quoteSQL(form.SMcodigo,'varchar')#
  and SPcodigo = #quoteSQL(form.SPcodigo,'varchar')#</cfif>
  and not exists (select * from TMPDATA_IMPORT
	where TMPDATA_IMPORT.SScodigo = rtrim(SMenuItem.SScodigo)
	  and TMPDATA_IMPORT.SMcodigo = rtrim(SMenuItem.SMcodigo)
	  and TMPDATA_IMPORT.SPcodigo = rtrim(SMenuItem.SPcodigo))
#dbms_go#
#dbms_print("SMenuItem eliminados")#
drop table TMPDATA_IMPORT
#dbms_go#

<cfif ListFind('ora', form.dbms )>
    create table TMPDATA_IMPORT (
      SScodigo varchar2(10) not null,
      SMcodigo varchar2(10) not null,
      SPcodigo varchar2(10) not null)
    #dbms_go#
<cfelse>
    create table TMPDATA_IMPORT (
      SScodigo char(10) not null,
      SMcodigo char(10) not null,
      SPcodigo char(10) not null)
    #dbms_go#
</cfif>
<cfloop query="ret_pro">
insert INTO TMPDATA_IMPORT values (#quoteSQL(ret_pro.SScodigo,'varchar')#, #quoteSQL(ret_pro.SMcodigo,'varchar')
	#, #quoteSQL(ret_pro.SPcodigo,'varchar')#)
#dbms_go#
</cfloop>
delete from SProcesos
where 1=1<cfif form.rango EQ 's' >
  and SScodigo = #quoteSQL(form.SScodigo,'varchar')#<cfelseif form.rango EQ 'r' >
  and SScodigo = #quoteSQL(form.SScodigo,'varchar')#<cfelseif form.rango EQ 'm' >
  and SScodigo = #quoteSQL(form.SScodigo,'varchar')#
  and SMcodigo = #quoteSQL(form.SMcodigo,'varchar')#<cfelseif form.rango EQ 'p' >
  and SScodigo = #quoteSQL(form.SScodigo,'varchar')#
  and SMcodigo = #quoteSQL(form.SMcodigo,'varchar')#
  and SPcodigo = #quoteSQL(form.SPcodigo,'varchar')#</cfif>
  and not exists (select * from TMPDATA_IMPORT
	where TMPDATA_IMPORT.SScodigo = rtrim(SProcesos.SScodigo)
	  and TMPDATA_IMPORT.SMcodigo = rtrim(SProcesos.SMcodigo)
	  and TMPDATA_IMPORT.SPcodigo = rtrim(SProcesos.SPcodigo))
#dbms_go#
#dbms_print("SProcesos eliminados")#
drop table TMPDATA_IMPORT
#dbms_go#
drop table TMPDATA_IMPORTROL
#dbms_go#

<cfif form.rango EQ 's' >
-- Eliminar modulos que no van
#dbms_print("Eliminar modulos que no van")#
#dbms_go#
<cfif ListFind('ora', form.dbms )>
	create table TMPDATA_IMPORT (
      SScodigo varchar2(10) not null,
      SMcodigo varchar2(10) not null)
    #dbms_go#
<cfelse>
	create table TMPDATA_IMPORT (
      SScodigo char(10) not null,
      SMcodigo char(10) not null)
    #dbms_go#
</cfif>

<cfloop query="ret_mod">
insert INTO TMPDATA_IMPORT values (#quoteSQL(ret_mod.SScodigo,'varchar')#, #quoteSQL(ret_mod.SMcodigo,'varchar')#)
#dbms_go#
</cfloop>
delete from ModulosCuentaE
where 1=1<cfif form.rango EQ 's' >
  and SScodigo = #quoteSQL(form.SScodigo,'varchar')#</cfif>
  and not exists (select * from TMPDATA_IMPORT
	where TMPDATA_IMPORT.SScodigo = rtrim(ModulosCuentaE.SScodigo)
	  and TMPDATA_IMPORT.SMcodigo = rtrim(ModulosCuentaE.SMcodigo))
#dbms_go#
#dbms_print("ModulosCuentaE eliminados")#
delete from SMenues
where 1=1<cfif form.rango EQ 's' >
  and SScodigo = #quoteSQL(form.SScodigo,'varchar')#</cfif>
  and not exists (select * from TMPDATA_IMPORT
	where TMPDATA_IMPORT.SScodigo = rtrim(SMenues.SScodigo)
	  and TMPDATA_IMPORT.SMcodigo = rtrim(SMenues.SMcodigo))
#dbms_go#
#dbms_print("SMenues eliminados")#
delete from SModulos
where 1=1<cfif form.rango EQ 's' >
  and SScodigo = #quoteSQL(form.SScodigo,'varchar')#</cfif>
  and not exists (select * from TMPDATA_IMPORT
	where TMPDATA_IMPORT.SScodigo = rtrim(SModulos.SScodigo)
	  and TMPDATA_IMPORT.SMcodigo = rtrim(SModulos.SMcodigo))
#dbms_go#
#dbms_print("SModulos eliminados")#
drop table TMPDATA_IMPORT
#dbms_go#
</cfif></cfif>

#dbms_print('Regenerando vUsuarioProcesos')#
#dbms_go#
<!--- similar a la version anterior de home.Componentes.UsuarioProcesos.cfm, por simplicidad --->
delete from vUsuarioProcesos
where 1=1<cfif form.rango EQ 's' >
  and SScodigo = #quoteSQL(form.SScodigo,'varchar')#<cfelseif form.rango EQ 'r' >
  and SScodigo = #quoteSQL(form.SScodigo,'varchar')#<cfelseif form.rango EQ 'm' >
  and SScodigo = #quoteSQL(form.SScodigo,'varchar')#
  and SMcodigo = #quoteSQL(form.SMcodigo,'varchar')#<cfelseif form.rango EQ 'p' >
  and SScodigo = #quoteSQL(form.SScodigo,'varchar')#
  and SMcodigo = #quoteSQL(form.SMcodigo,'varchar')#
  and SPcodigo = #quoteSQL(form.SPcodigo,'varchar')#</cfif>
#dbms_go#
insert INTO vUsuarioProcesos (Usucodigo, Ecodigo, SScodigo, SMcodigo, SPcodigo)
select Usucodigo, Ecodigo, SScodigo, SMcodigo, SPcodigo
from vUsuarioProcesosCalc
where 1=1<cfif form.rango EQ 's' >
  and SScodigo = #quoteSQL(form.SScodigo,'varchar')#<cfelseif form.rango EQ 'r' >
  and SScodigo = #quoteSQL(form.SScodigo,'varchar')#<cfelseif form.rango EQ 'm' >
  and SScodigo = #quoteSQL(form.SScodigo,'varchar')#
  and SMcodigo = #quoteSQL(form.SMcodigo,'varchar')#<cfelseif form.rango EQ 'p' >
  and SScodigo = #quoteSQL(form.SScodigo,'varchar')#
  and SMcodigo = #quoteSQL(form.SMcodigo,'varchar')#
  and SPcodigo = #quoteSQL(form.SPcodigo,'varchar')#</cfif>
#dbms_go#

<cfif ListFind('syb,mss', form.dbms )>
while @@trancount > 0 begin
	select 'cerrando transaccion ', @@trancount
	commit tran
end
#dbms_go#
</cfif>

#dbms_print('Importacion finalizada. A continuacion la cuenta de los registros')#
#dbms_go#

<cfif IsDefined("form.politica")>
select 'Politicas            ' as tipo, count(1) as real, #ret_pol.RecordCount# as esperado
from PLista
#dbms_go#
</cfif>

select 'Sistemas             ' as tipo, count(1) as real, #ret_sis.RecordCount# as esperado
from SSistemas<cfif form.rango EQ 's' >
where SScodigo = #quoteSQL(form.SScodigo,'varchar')#
<cfelseif form.rango EQ 'r' >
where SScodigo = #quoteSQL(form.SScodigo,'varchar')#
<cfelseif form.rango EQ 'm' >
where SScodigo = #quoteSQL(form.SScodigo,'varchar')#
<cfelseif form.rango EQ 'p' >
where SScodigo = #quoteSQL(form.SScodigo,'varchar')#
</cfif>
#dbms_go#

select 'Modulos              ' as tipo, count(1) as real, #ret_mod.RecordCount# as esperado
from SModulos<cfif form.rango EQ 's' >
where SScodigo = #quoteSQL(form.SScodigo,'varchar')#
<cfelseif form.rango EQ 'r' >
where SScodigo = #quoteSQL(form.SScodigo,'varchar')#
<cfelseif form.rango EQ 'm' >
where SScodigo = #quoteSQL(form.SScodigo,'varchar')#
and SMcodigo = #quoteSQL(form.SMcodigo,'varchar')#
<cfelseif form.rango EQ 'p' >
where SScodigo = #quoteSQL(form.SScodigo,'varchar')#
and SMcodigo = #quoteSQL(form.SMcodigo,'varchar')#
</cfif>
#dbms_go#

select 'Procesos             ' as tipo, count(1) as real, #ret_pro.RecordCount# as esperado
from SProcesos<cfif form.rango EQ 's' >
where SScodigo = #quoteSQL(form.SScodigo,'varchar')#
<cfelseif form.rango EQ 'r' >
where SScodigo = #quoteSQL(form.SScodigo,'varchar')#
<cfelseif form.rango EQ 'm' >
where SScodigo = #quoteSQL(form.SScodigo,'varchar')#
and SMcodigo = #quoteSQL(form.SMcodigo,'varchar')#
<cfelseif form.rango EQ 'p' >
where SScodigo = #quoteSQL(form.SScodigo,'varchar')#
and SMcodigo = #quoteSQL(form.SMcodigo,'varchar')#
and SPcodigo = #quoteSQL(form.SPcodigo,'varchar')#
</cfif>
#dbms_go#

select 'Componentes          ' as tipo, count(1) as real, #ret_com.RecordCount# as esperado
from SComponentes<cfif form.rango EQ 's' >
where SScodigo = #quoteSQL(form.SScodigo,'varchar')#
<cfelseif form.rango EQ 'r' >
where SScodigo = #quoteSQL(form.SScodigo,'varchar')#
<cfelseif form.rango EQ 'm' >
where SScodigo = #quoteSQL(form.SScodigo,'varchar')#
and SMcodigo = #quoteSQL(form.SMcodigo,'varchar')#
<cfelseif form.rango EQ 'p' >
where SScodigo = #quoteSQL(form.SScodigo,'varchar')#
and SMcodigo = #quoteSQL(form.SMcodigo,'varchar')#
and SPcodigo = #quoteSQL(form.SPcodigo,'varchar')#
</cfif>
#dbms_go#

select 'Roles                ' as tipo, count(1) as real, #ret_rol.RecordCount# as esperado
from SRoles<cfif form.rango EQ 's' >
where SScodigo = #quoteSQL(form.SScodigo,'varchar')#
<cfelseif form.rango EQ 'r' >
where SScodigo = #quoteSQL(form.SScodigo,'varchar')#
<cfelseif form.rango EQ 'm' >
where SScodigo = #quoteSQL(form.SScodigo,'varchar')#
<cfelseif form.rango EQ 'p' >
where SScodigo = #quoteSQL(form.SScodigo,'varchar')#
</cfif>
#dbms_go#

select 'ProcesosRol          ' as tipo, count(1) as real, #ret_prorol.RecordCount# as esperado
from SProcesosRol<cfif form.rango EQ 's' >
where SScodigo = #quoteSQL(form.SScodigo,'varchar')#
<cfelseif form.rango EQ 'r' >
where SScodigo = #quoteSQL(form.SScodigo,'varchar')#
<cfelseif form.rango EQ 'm' >
where SScodigo = #quoteSQL(form.SScodigo,'varchar')#
and SMcodigo = #quoteSQL(form.SMcodigo,'varchar')#
<cfelseif form.rango EQ 'p' >
where SScodigo = #quoteSQL(form.SScodigo,'varchar')#
and SMcodigo = #quoteSQL(form.SMcodigo,'varchar')#
and SPcodigo = #quoteSQL(form.SPcodigo,'varchar')#
</cfif>
#dbms_go#

select 'Menues               ' as tipo, count(1) as real, #ret_men.RecordCount# as esperado
from SMenues<cfif form.rango EQ 's' >
where SScodigo = #quoteSQL(form.SScodigo,'varchar')#
<cfelseif form.rango EQ 'r' >
where SScodigo = #quoteSQL(form.SScodigo,'varchar')#
<cfelseif form.rango EQ 'm' >
where SScodigo = #quoteSQL(form.SScodigo,'varchar')#
and SMcodigo = #quoteSQL(form.SMcodigo,'varchar')#
<cfelseif form.rango EQ 'p' >
where SScodigo = #quoteSQL(form.SScodigo,'varchar')#
and SMcodigo = #quoteSQL(form.SMcodigo,'varchar')#
and SPcodigo = #quoteSQL(form.SPcodigo,'varchar')#
</cfif>
#dbms_go#

select 'SProcesoRelacionado  ' as tipo, count(1) as real, #ret_prorel.RecordCount# as esperado
from SProcesoRelacionado <cfif form.rango EQ 's' >
where SSorigen = #quoteSQL(form.SScodigo,'varchar')#
   or SSdestino = #quoteSQL(form.SScodigo,'varchar')#
<cfelseif form.rango EQ 'r' >
where SSorigen = #quoteSQL(form.SScodigo,'varchar')#
   or SSdestino = #quoteSQL(form.SScodigo,'varchar')#
<cfelseif form.rango EQ 'm' >
where (SSorigen = #quoteSQL(form.SScodigo,'varchar')# and SMorigen = #quoteSQL(form.SMcodigo,'varchar')#)
   or (SSdestino = #quoteSQL(form.SScodigo,'varchar')# and SMdestino = #quoteSQL(form.SMcodigo,'varchar')#)
<cfelseif form.rango EQ 'p' >
where (SSorigen = #quoteSQL(form.SScodigo,'varchar')# and SMorigen = #quoteSQL(form.SMcodigo,'varchar')# and SPorigen = #quoteSQL(form.SPcodigo,'varchar')#)
   or (SSdestino = #quoteSQL(form.SScodigo,'varchar')# and SMdestino = #quoteSQL(form.SMcodigo,'varchar')# and SPdestino = #quoteSQL(form.SPcodigo,'varchar')#)
</cfif>
#dbms_go#

-- Fin de archivo
</cfoutput>
</cfif>

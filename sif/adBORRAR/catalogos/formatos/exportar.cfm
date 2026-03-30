<cfsetting enablecfoutputonly="yes">
<cfparam name="url.FMT01COD" type="string" default="">
<cfparam name="url.dbms"     type="string" default="syb">

<cfset newline = Chr(13)&Chr(10)>
<cfset indent  = "  ">
<cfinclude template="/asp/portal/exportar/functions.cfm">
<cfset set_dbms(url.dbms)>


	<cfcontent type="text/plain; charset=utf-8">
	<cfif Len(Trim(url.FMT01COD))>
		<cfset filename_FMT01COD = Trim(url.FMT01COD)>
	<cfelse>
		<cfset filename_FMT01COD = 'todos'>
	</cfif>
	<cfheader name="Content-Disposition" value="attachment; filename=formato-#filename_FMT01COD#-#dbms_type#.sql" >
	<cfoutput>/*# newline# Exportacion del formato # url.FMT01COD # </cfoutput>
	<cfif url.dbms is 'syb'>
		<cfoutput># newline # SYBASE: isql -Usa -Ppasswd -Sserver_name -D db_name -i archivo.sql # newline # </cfoutput>
	<cfelseif url.dbms is 'ora'>
		<cfoutput># newline # ORACLE: sqlplus user/passwd@server_name @archivo.sql # newline # </cfoutput>
	<cfelse>
		<cfoutput># newline # #url.dbms#: ejecuta este archivo para importar los datos # newline #</cfoutput>
	</cfif>
	<cfoutput>#newline#*/ #newline# #dbms_go# #newline#</cfoutput>
	<!--- este set nocount va a dar errores en oracle, pero no importa porque sigue --->
	<cfoutput>#dbms_sql_init()#</cfoutput>
<cfoutput>
<!--- borrarselos primero --->
#dbms_print('Borrar FMT009')#
delete from FMT009<cfif Len(url.FMT01COD)>
where FMT01COD = #quoteSQL(url.FMT01COD,'varchar')#</cfif>
#dbms_go#

#dbms_print('Borrar FMT007')#
delete from FMT007<cfif Len(url.FMT01COD)>
where FMT01COD = #quoteSQL(url.FMT01COD,'varchar')#</cfif>
#dbms_go#

#dbms_print('Borrar FMT006')#
delete from FMT006<cfif Len(url.FMT01COD)>
where FMT01COD = #quoteSQL(url.FMT01COD,'varchar')#</cfif>
#dbms_go#

#dbms_print('Borrar FMT005')#
delete from FMT005<cfif Len(url.FMT01COD)>
where FMT01COD = #quoteSQL(url.FMT01COD,'varchar')#</cfif>
#dbms_go#

#dbms_print('Borrar FMT004')#
delete from FMT004<cfif Len(url.FMT01COD)>
where FMT01COD = #quoteSQL(url.FMT01COD,'varchar')#</cfif>
#dbms_go#

#dbms_print('Borrar FMT003')#
delete from FMT003<cfif Len(url.FMT01COD)>
where FMT01COD = #quoteSQL(url.FMT01COD,'varchar')#</cfif>
#dbms_go#

#dbms_print('Borrar FMT002')#
delete from FMT002<cfif Len(url.FMT01COD)>
where FMT01COD = #quoteSQL(url.FMT01COD,'varchar')#</cfif>
#dbms_go#

#dbms_print('Borrar FMT001')#
delete from FMT001<cfif Len(url.FMT01COD)>
where FMT01COD = #quoteSQL(url.FMT01COD,'varchar')#</cfif>
#dbms_go#
</cfoutput>

<cfquery datasource="#session.dsn#" name="ret_enc">
		select * from FMT001 a
		<cfif Len(url.FMT01COD)>
		where a.FMT01COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.FMT01COD#">
		</cfif>
	</cfquery>
<cfset gen(ret_enc, "FMT001", "FMT01COD", 'sql', true) >

<cfquery datasource="#session.dsn#" name="ret_sis">
		select * from FMT002 a
		<cfif Len(url.FMT01COD)>
		where a.FMT01COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.FMT01COD#">
		</cfif>
	</cfquery>
<cfset gen(ret_sis, "FMT002", "FMT01COD,FMT02LIN", 'sql', true) >

<cfquery datasource="#session.dsn#" name="ret_sis">
		select * from FMT003 a
		<cfif Len(url.FMT01COD)>
		where a.FMT01COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.FMT01COD#">
		</cfif>
	</cfquery>
<cfset gen(ret_sis, "FMT003", "FMT01COD,FMT03LIN", 'sql', true) >

<cfquery datasource="#session.dsn#" name="ret_sis">
		select * from FMT004 a
		<cfif Len(url.FMT01COD)>
		where a.FMT01COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.FMT01COD#">
		</cfif>
	</cfquery>
<cfset gen(ret_sis, "FMT004", "FMT01COD,FMT04LIN", 'sql', true) >

<cfquery datasource="#session.dsn#" name="ret_sis">
		select * from FMT005 a
		<cfif Len(url.FMT01COD)>
		where a.FMT01COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.FMT01COD#">
		</cfif>
	</cfquery>
<cfset gen(ret_sis, "FMT005", "FMT01COD,FMT05LIN", 'sql', true) >

<cfquery datasource="#session.dsn#" name="ret_sis">
		select * from FMT006 a
		<cfif Len(url.FMT01COD)>
		where a.FMT01COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.FMT01COD#">
		</cfif>
	</cfquery>
<cfset gen(ret_sis, "FMT006", "FMT01COD,FMT06LIN", 'sql', true) >

<cfquery datasource="#session.dsn#" name="ret_sis">
		select * from FMT007 a
		<cfif Len(url.FMT01COD)>
		where a.FMT01COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.FMT01COD#">
		</cfif>
	</cfquery>
<cfset gen(ret_sis, "FMT007", "FMT01COD,FMT07NIV", 'sql', true) >

<cfquery datasource="#session.dsn#" name="ret_sis">
		select * from FMT009 a
		<cfif Len(url.FMT01COD)>
		where a.FMT01COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.FMT01COD#">
		</cfif>
	</cfquery>
<cfset gen(ret_sis, "FMT009", "FMT01COD,FMT09LIN", 'sql', true) >

<cfoutput>
/* Fin de archivo */
</cfoutput>

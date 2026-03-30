<cfsetting enablecfoutputonly="yes">
<cfparam name="url.FMT00COD" default="">
<cfif Len(url.FMT00COD)>
	<cfparam name="url.FMT00COD" type="numeric">
</cfif>
<cfparam name="url.dbms"     type="string" default="syb">

<cfset newline = Chr(13)&Chr(10)>
<cfset indent  = "  ">
<cfinclude template="/asp/portal/exportar/functions.cfm">
<cfset set_dbms(url.dbms)>


	<cfcontent type="text/plain; charset=utf-8">
	<cfif Len(Trim(url.FMT00COD))>
		<cfset filename_FMT00COD = Trim(url.FMT00COD)>
	<cfelse>
		<cfset filename_FMT00COD = 'todos'>
	</cfif>
	<cfheader name="Content-Disposition" value="attachment; filename=tipoformato-#filename_FMT00COD#-#dbms_type#.sql" >
	<cfoutput>/*# newline# Exportacion del tipo de formato # url.FMT00COD # </cfoutput>
	<cfif url.dbms is 'syb'>
		<cfoutput># newline # SYBASE: isql -Usa -Ppasswd -Sserver_name -D sifcontrol -i archivo.sql # newline # </cfoutput>
	<cfelseif url.dbms is 'ora'>
		<cfoutput># newline # ORACLE: sqlplus user_sifcontrol/passwd@server_name @archivo.sql # newline # </cfoutput>
	<cfelse>
		<cfoutput># newline # #url.dbms#: ejecuta este archivo para importar los datos # newline #</cfoutput>
	</cfif>
	<cfoutput># newline # */# newline ##dbms_go## newline #</cfoutput>
	<!--- este set nocount va a dar errores en oracle, pero no importa porque sigue --->
	<cfoutput>#dbms_sql_init()#</cfoutput>
	
<cfif Len(url.FMT00COD) is 0>
	<cfquery datasource="sifcontrol" name="current_keys">
		select FMT00COD from FMT000
	</cfquery>
</cfif>
	
<cfoutput>
<!--- borrarselos primero --->
#dbms_print('Borrar FMT010')#
#dbms_go#
delete from FMT010<cfif Len(url.FMT00COD)>
where FMT00COD = #quoteSQL(url.FMT00COD,'integer')#<cfelseif current_keys.RecordCount>
where FMT00COD in (#ValueList(current_keys.FMT00COD)#)</cfif>
#dbms_go#
#dbms_print('Borrar FMT011')#
#dbms_go#
delete from FMT011<cfif Len(url.FMT00COD)>
where FMT00COD = #quoteSQL(url.FMT00COD,'integer')#<cfelseif current_keys.RecordCount>
where FMT00COD in (#ValueList(current_keys.FMT00COD)#)</cfif>
#dbms_go#
</cfoutput>

<cfquery datasource="sifcontrol" name="ret_sis">
		select * from FMT000 a
		<cfif Len(url.FMT00COD)>
		where a.FMT00COD = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.FMT00COD#">
		</cfif>
	</cfquery>
<cfset gen(ret_sis, "FMT000", "FMT00COD", 'sql', false) >

<cfquery datasource="sifcontrol" name="ret_sis">
		select * from FMT010 a
		<cfif Len(url.FMT00COD)>
		where a.FMT00COD = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.FMT00COD#">
		</cfif>
	</cfquery>
<cfset gen(ret_sis, "FMT010", "FMT00COD,FMT10LIN", 'sql', true) >

<cfquery datasource="sifcontrol" name="ret_sis">
		select * from FMT011 a
		<cfif Len(url.FMT00COD)>
		where a.FMT00COD = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.FMT00COD#">
		</cfif>
	</cfquery>
<cfset gen(ret_sis, "FMT011", "FMT00COD,FMT02SQL", 'sql', true) >

<cfoutput>
/* Fin de archivo */
</cfoutput>

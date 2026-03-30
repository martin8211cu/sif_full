<cfsetting enablecfoutputonly="yes" requesttimeout="3600">

<cfparam name="form.ds" >
<cfparam name="form.dbms" default="syb" >
<cfparam name="form.tabla" >
<cfparam name="form.maxrows" default="-1" >
<cfparam name="form.where" >
<cfparam name="form.identity" default="0" >

<cfif REFind('^[A-Za-z_0-9]+$', form.tabla) IS 0>
	<cfthrow message="Tabla invalida: #form.tabla#">
</cfif>

<cfif REFind('^[A-Za-z_0-9]+$', form.ds) IS 0>
	<cfthrow message="Datasource invalido: #form.ds#">
</cfif>

<cfif REFind('(drop)|(truncate)|(delete)|(insert)|(update)|(sp_)|(from)|(select)|(\.\.)|(\.dbo\.)', form.where) NEQ 0>
	<cfthrow message="Where invalido: #form.where#">
</cfif>

<cfif Len(form.maxrows) is 0><cfset form.maxrows = -1></cfif>

<cfinclude template="../../portal/exportar/functions.cfm">

<cfset tipo = 'sql'>
<cfset set_dbms(form.dbms)>

<cfif (tipo EQ "xml")>
	<cfheader name="Content-Disposition" value="attachment; filename=datos-#form.tabla#.xml">
<cfoutput><?xml version="1.0" encoding="ascii" ?>
<datos>
  <filtro>
    <where>#XmlFormat(form.where)#</where>
  </filtro>
</cfoutput>
<cfelseif (tipo EQ "sql")>
	<cfcontent type="text/html; charset=ISO-8859-1">
	<cfheader name="Content-Disposition" value="attachment; filename=datos-#form.tabla#.sql" >
	<cfif dbms_type is 'ora'>
		<cfoutput>/* #newline# </cfoutput>
		<cfoutput>  Exportacion de #form.tabla# #newline#</cfoutput>
		<cfoutput>  Ejecutar asi: sqlplus user/password@server <enter> @archivo.sql  #newline#</cfoutput>
		<cfoutput>*/# dbms_go #</cfoutput>
	<cfelseif dbms_type is 'db2'>
		<cfoutput>--  Exportacion de #form.tabla# #newline#</cfoutput>
		<cfoutput>--  Ejecutar asi: db2 connect to <database> user <user> using <password> #newline#</cfoutput>
		<cfoutput>--  Ejecutar asi: db2 -td/ vf archivo.sql  #newline#</cfoutput>
		<cfoutput>--  #newline#</cfoutput>
	<cfelseif dbms_type is 'syb'>
		<cfoutput>/* #newline# </cfoutput>
		<cfoutput>  Exportacion de #form.tabla# #newline#</cfoutput>
		<cfoutput>  Ejecutar asi: isql -Usa -Ppasswd -Sserver_name -D asp -i archivo.sql  #newline#</cfoutput>
		<cfoutput>*/# dbms_go #</cfoutput>
	<cfelseif dbms_type is 'mss'>
		<cfoutput>/* #newline# </cfoutput>
		<cfoutput>  Exportacion de #form.tabla# #newline#</cfoutput>
		<cfoutput>  Ejecutar asi: osql -Usa -Ppasswd -Sserver_name -D asp -i archivo.sql  #newline#</cfoutput>
		<cfoutput>*/# dbms_go #</cfoutput>
	<cfelse>
	</cfif>
	<cfoutput># dbms_sql_init() #</cfoutput>
</cfif>

<cfquery datasource="#form.ds#" name="ret" maxrows="#form.maxrows#">
		select a.* from #form.tabla# a
		#form.where#
	</cfquery>
	
<cfif form.identity IS 1 and ListFind('syb,mss', form.dbms)>
<cfoutput>
set identity_insert #form.tabla# on
#dbms_go#
</cfoutput><cfelseif form.identity is 1 and form.dbms is 'ora'>
<cfoutput>
call soinpk.set_identity_insert_on()
#dbms_go#
</cfoutput>
</cfif>

<cfset gen(ret, form.tabla, form.pk, tipo, isdefined('form.soloinsert')) >

<cfif form.identity IS 1>
	<cfif ListFind('syb,mss', form.dbms)>
		<cfoutput>set identity_insert #form.tabla# off #dbms_go#</cfoutput>	
	<cfelseif form.dbms is 'ora'>
		<cfif IsDefined("form.identityfield") and Len(Trim(form.identityfield))>
			<cfquery dbtype="query" name="nextval">
			select max(#Trim(form.identityfield)#) as nextval from ret
			</cfquery>
			<cfif Len(nextval.nextval)>
				<cfoutput>#dbms_go#</cfoutput>
				<cfoutput>drop sequence s_#form.tabla#</cfoutput>
				<cfoutput>#dbms_go#</cfoutput>
				<cfoutput>create sequence s_#form.tabla# start with #nextval.nextval#</cfoutput>
				<cfoutput>#dbms_go#</cfoutput>
			</cfif>
		</cfif>
	</cfif>
</cfif>

<cfif (tipo EQ "xml") >
<cfoutput></datos></cfoutput>
<cfelseif tipo EQ "sql">
	
<cfif form.identity IS 1 and ListFind('syb,mss', form.dbms)>
<cfoutput>
set identity_insert #form.tabla# off
#dbms_go#
</cfoutput><cfelseif form.identity is 1 and form.dbms is 'ora'>
<cfoutput>
call soinpk.set_identity_insert_off()
#dbms_go#
</cfoutput>
</cfif>

<cfoutput><!--- no indentar --->
#dbms_print( 'Importacion finalizada') #
-- Fin de archivo
#dbms_go#
</cfoutput>
</cfif>
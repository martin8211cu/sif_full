<cfset form.ds = session.dsn>
<cfset form.dbms = 'syb'>
<cfset form.tabla = 'ISBparametros'>
<cfset form.maxrows = -1>
<cfset form.where = ''>
<cfset form.identity = 0>
<cfset form.pk = 'Ecodigo,Pcodigo'>
<cfset insertonly = isDefined("form.insertonly")>

<cfinclude template="/asp/admin/exportar/datos-apply.cfm">

<cfset newline = Chr(13)&Chr(10)>
<cfset indent  = "  ">

<cfset set_dbms(form.dbms)>


	<cfcontent type="text/plain">
	<xcfheader name="Content-Disposition" value="attachment; filename=framework-#dbms_type#.sql" >

	<cfoutput># newline# -- Exportacion de parametros ISB</cfoutput>
	<cfoutput># newline # -- SYBASE: isql -Usa -Ppasswd -Sserver_name -D asp -i framework-app.sql # newline # </cfoutput>
	<cfoutput># newline # -- ORACLE: sqlplus user/passwd@server_name @framework-app.sql # newline # </cfoutput>
	<cfoutput># newline # -- DB2:    db2 -td/ vf framework-app.sql # newline # </cfoutput>
	<cfoutput># newline # -- # newline ##dbms_go## newline #</cfoutput>
	<!--- este set nocount va a dar errores en oracle, pero no importa porque sigue --->
	<cfoutput>#dbms_sql_init()#</cfoutput>

<cfset tipo = 'sql'>

<cfquery datasource="#session.dsn#" name="ret_pol">
		select * from ISBparametros
	</cfquery>
<cfset gen(ret_pol, "ISBparametros", "Ecodigo,Pcodigo", form.dbms, insertonly) >
#dbms_go#

<cfquery datasource="#session.dsn#" name="ret_pol">
		select * from ISBparametrosLDAP
	</cfquery>
<cfset gen(ret_pol, "ISBparametrosLDAP", "Ecodigo,linea", form.dbms, insertonly) >
#dbms_go#

-- Fin de archivo


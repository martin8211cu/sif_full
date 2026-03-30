	<cfquery datasource="#session.dsn#"  name="RS_agregar">	
	 	insert	CJINT02 (
				CJINT02IDE,
				CJINT02USR,
				CJINT02CC ) 
		values (
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.id#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">,
		'sifweb')
	</cfquery>
	<script language="JavaScript">
			//top.frames['workspace'].location.href='http://www.nacion.com'

			top.frames['workspace'].location.href='<cfoutput>#trim(url.link)#</cfoutput>'
	</script>


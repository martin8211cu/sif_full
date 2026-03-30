<cfif not isdefined("Form.Nuevo")>
		<cfquery name="MSApariencia" datasource="asp">
			<cfif isdefined("Form.Alta")>
				insert into MSApariencia (descripcion,template,home,login,css,footer, BMUsucodigo)
				values (
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.descripcion#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.template#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.home#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.login#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.css#">,
                     <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.footer#" null="#Form.footer EQ "" OR Form.footer EQ "/"#">,
					 #session.Usucodigo#)													
				<cfset modo="ALTA">
			<cfelseif isdefined("Form.Baja")>
				delete from MSApariencia
				where id_apariencia = <cfqueryparam value="#form.id_apariencia#" cfsqltype="cf_sql_numeric">
				<cfset modo="BAJA">
			<cfelseif isdefined("Form.Cambio")>
				update MSApariencia set 
					descripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.descripcion#">,
					template 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.template#">,
					home 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.home#">,
					login 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.login#">,
					css 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.css#">,
                    footer 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.footer#" null="#Form.footer EQ "" OR Form.footer EQ "/"#">
				where id_apariencia = <cfqueryparam value="#form.id_apariencia#" cfsqltype="cf_sql_numeric">
				<cfset modo="CAMBIO">
			</cfif>

		</cfquery>
</cfif>
<form action="apariencia.cfm" method="post" name="sql">
	<cfif IsDefined("form.cambio")>
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<input name="id_apariencia" type="hidden" value="<cfif isdefined("Form.id_apariencia")><cfoutput>#Form.id_apariencia#</cfoutput></cfif>">
	</cfif>
    <input type="hidden" name="Pagina" value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ ""><cfoutput>#Pagenum_lista#</cfoutput><cfelseif isdefined("Form.PageNum")><cfoutput>#PageNum#</cfoutput></cfif>">		
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>


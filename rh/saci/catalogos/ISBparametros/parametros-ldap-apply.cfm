<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Aplicar LDAP</title>
</head>

<body>
<cfoutput>
<cftry>
<cfparam name="url.action" default="">
<cfparam name="url.linea" default="">
<cfparam name="url.atributo" default="">
<cfparam name="url.valor" default="">
<cfparam name="url.correo" default="">
#url.action#/#url.linea# #url.atributo#: #url.valor#

<cfif url.action is 'add'>
	<cfquery datasource="#session.dsn#" name="add">
		insert into ISBparametrosLDAP (Ecodigo, linea, atributo, valor, correo, BMUsucodigo)
		select
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
			(coalesce (max(linea), 0) + 1) as linea,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.atributo#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.valor#">,
			<cfqueryparam cfsqltype="cf_sql_bit" value="#url.correo is 1#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Usucodigo#">
		from ISBparametrosLDAP
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
<cfelseif url.action is 'upd'>
	<cfquery datasource="#session.dsn#" name="add">
		update ISBparametrosLDAP
		set atributo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.atributo#">,
		    valor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.valor#">,
			correo = <cfqueryparam cfsqltype="cf_sql_bit" value="#url.correo is 1#">,
			BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Usucodigo#">
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and linea = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.linea#">
	</cfquery>
	<cfset url.atributo = ''>
	<cfset url.valor = ''>
	<cfset url.linea = ''>
<cfelseif url.action is 'del'>
	<cfquery datasource="#session.dsn#" name="add">
		delete from ISBparametrosLDAP
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and linea = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.linea#">
	</cfquery>
<cfelse>
	<cfthrow message="Parámetro inválido en action: #url.action#">
</cfif>

<cfcatch type="any">
	<script type="text/javascript">
		window.alert('Error inesperado: # JSStringFormat( cfcatch.Message ) # # JSStringFormat( cfcatch.Detail ) # ');
	</script>
</cfcatch>
</cftry>
</cfoutput>
<div style="display:none">
<cfinclude template="parametros-ldap-data.cfm">
</div>

<script type="text/javascript">
	function gtd(d){return d.getElementById('tablaDatos');}
	var par=gtd(window.parent.document), chd=gtd(document);
	par.innerHTML = chd.innerHTML;
	window.parent.listo();
</script>

</body>
</html>

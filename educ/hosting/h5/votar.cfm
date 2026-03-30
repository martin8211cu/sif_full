<cfparam name="form.email" type="string" default="">
<cfparam name="form.name"  type="string" default="">
<cfparam name="form.concursante"  type="numeric" default="0">

<cfif form.concursante is 0>
	<cflocation url="votar2.cfm">
</cfif>

<cfif not isdefined ('cookie.voto') or len(cookie.voto) is 0>
	<cfcookie name="voto" expires="never" value="#session.sessionid#">
</cfif>

<cfif isdefined('cookie.voto')>
	<cfset galletica = cookie.voto>
<cfelseif len(session.sessionid)>
	<cfset galletica = session.sessionid>
<cfelseif len(form.email)>
	<cfset galletica = form.email>
<cfelse>
	<cfset galletica = ''>
</cfif>


<cfset voto_valido = true>

<cfif voto_valido And Len(Trim(form.email))>
	<cfquery datasource="h5_votacion" name="buscar">
		select count(1) hay from Votos
		where email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LCase(Trim(form.email))#">
	</cfquery>
	<cfif buscar.hay>
		<cfset voto_valido = false>
	</cfif>
</cfif>

<cfif voto_valido And Len(Trim(galletica))>
	<cfquery datasource="h5_votacion" name="buscar">
		select count(1) hay from Votos
		where cookie = <cfqueryparam cfsqltype="cf_sql_varchar" value="#galletica#">
	</cfquery>
	<cfif buscar.hay>
		<cfset voto_valido = false>
	</cfif>
</cfif>

<cfif voto_valido>
	<cfquery datasource="h5_votacion">
		insert into Votos (concursante, fecha, ip, cookie, email, votante)
		values (
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.concursante#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.sitio.ip#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#galletica#" null="#Len(galletica) is 0#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#LCase(Trim(form.email))#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.name#">)
	</cfquery>
</cfif>

<cflocation url="votar_count.cfm" addtoken="no">

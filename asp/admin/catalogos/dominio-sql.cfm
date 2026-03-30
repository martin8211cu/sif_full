<cfparam name="form.srty" default="">
<cfparam name="form.srch" default="">

<!--- cfparam porque el ssl_dominio en disabled podría no llegar --->
<cfparam name="form.ssl_dominio" default="">
<cfif IsDefined('form.ssl_domdefault')>
	<cfset form.ssl_dominio = ''></cfif>

<cftransaction>
<cfif IsDefined("form.btnDelete")>
	<cfquery datasource="asp">
		delete from MSDominio
		where Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Scodigo#">
	</cfquery>
	<cfquery datasource="asp">
		delete from Sitio
		where Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Scodigo#">
	</cfquery>
	<cfset form.Scodigo="">
<cfelse>
	<cfif isDefined("form.Scodigo") and Len(form.Scodigo) GT 0>
		<cfquery datasource="asp">
			update Sitio
			set Snombre  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Snombre#">,
				CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CEcodigo#" null="#Len(form.CEcodigo) EQ 0#">
			where Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Scodigo#">
		</cfquery>
	<cfelse>
		<cfquery datasource="asp" name="ins">
			insert into Sitio (
				Snombre, directorio, CEcodigo, BMUsucodigo)
			values (
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Snombre#">,
				' ',
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CEcodigo#" null="#Len(form.CEcodigo) EQ 0#">,
				#session.Usucodigo#)
			<cf_dbidentity1 datasource="asp">
		</cfquery>
		<cf_dbidentity2 datasource="asp" name="ins">
		<cfset form.Scodigo = ins.identity>
	</cfif>

	<!--- Lineas de detalle --->
	<cfloop from="1" to="#form.maxline#" index="lineno">
		<cfset id_dominio = form["id_dominio"&lineno]>
		<cfset dominio = form["dominio"&lineno]>
		<cfset aliases = form["aliases"&lineno]>
		<cfset Ecodigo = form["Ecodigo"&lineno]>
		<cfset id_apariencia = form["id_apariencia"&lineno]>
		<cfset SS_SM_mix = form["SMcodigo"&lineno]>
		<cfif ListLen(SS_SM_mix,'$') IS 2>
			<cfset SScodigo = ListGetAt(SS_SM_mix,1,'$')>
			<cfset SMcodigo = ListGetAt(SS_SM_mix,2,'$')>
		<cfelse>
			<cfset SScodigo = ''>
			<cfset SMcodigo = ''>
		</cfif>
		<cfset SPcodigo  = form["SPcodigo"&lineno]>
		<cfset home      = form["home" &lineno]>
		<cfset login     = form["login"&lineno]>
		<cfset css       = form["css"&lineno]>
		<cfset ssl_login = StructKeyExists(form, "ssl_login"&lineno)>
		<cfset ssl_todo  = StructKeyExists(form, "ssl_todo" &lineno)>
		<cfset ssl_home  = StructKeyExists(form, "ssl_home" &lineno)>
		<cfif Len(id_dominio) NEQ 0 and Len(Trim(dominio)) EQ 0>
			<cfquery datasource="asp">
				delete from MSDominio
				where id_dominio = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_dominio#">
			</cfquery>
		<cfelseif Len(Trim(dominio)) NEQ 0>
			<cfif Len(id_dominio) NEQ 0>
				<cfquery datasource="asp">
					update MSDominio
					set dominio = <cfqueryparam cfsqltype="cf_sql_varchar" value="#dominio#">,
						MSDaliases = <cfqueryparam cfsqltype="cf_sql_varchar" value="#aliases#">,
						Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Scodigo#">,
						CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CEcodigo#" null="#Len(form.CEcodigo) EQ 0#">,
						Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Ecodigo#" null="#Len(Ecodigo) EQ 0#">,
						SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SScodigo#">,
						SMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SMcodigo#">,
						SPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SPcodigo#">,
						id_apariencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_apariencia#">,
						home = <cfqueryparam cfsqltype="cf_sql_varchar" value="#home#" null="#Len(Trim(home)) EQ 0#">,
						login = <cfqueryparam cfsqltype="cf_sql_varchar" value="#login#" null="#Len(Trim(login)) EQ 0#">,
						css = <cfqueryparam cfsqltype="cf_sql_varchar" value="#css#" null="#Len(Trim(css)) EQ 0#">,
						ssl_login = <cfqueryparam cfsqltype="cf_sql_bit" value="#ssl_login#">,
						ssl_todo = <cfqueryparam cfsqltype="cf_sql_bit" value="#ssl_todo#">,
						ssl_home = <cfqueryparam cfsqltype="cf_sql_bit" value="#ssl_home#">,
						ssl_dominio = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ssl_dominio#" null="#Len(Trim(form.ssl_dominio)) EQ 0#">
					where id_dominio = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_dominio#">
				</cfquery>
			<cfelse>
				<cfquery datasource="asp">
					insert into MSDominio (dominio, MSDaliases, Scodigo, CEcodigo, Ecodigo,
						SScodigo, SMcodigo, SPcodigo, id_apariencia, home, login, css,
						ssl_login, ssl_todo, ssl_home, ssl_dominio, BMUsucodigo)
					values (
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#dominio#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#aliases#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Scodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CEcodigo#" null="#Len(form.CEcodigo) EQ 0#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Ecodigo#" null="#Len(Ecodigo) EQ 0#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#SScodigo#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#SMcodigo#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#SPcodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#id_apariencia#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#home#" null="#Len(Trim(home)) EQ 0#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#login#" null="#Len(Trim(login)) EQ 0#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#css#" null="#Len(Trim(css)) EQ 0#">,
						<cfqueryparam cfsqltype="cf_sql_bit" value="#ssl_login#">,
						<cfqueryparam cfsqltype="cf_sql_bit" value="#ssl_todo#">,
						<cfqueryparam cfsqltype="cf_sql_bit" value="#ssl_home#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ssl_dominio#" null="#Len(Trim(form.ssl_dominio)) EQ 0#">, 
						#session.Usucodigo#)
				</cfquery>
			</cfif>
		</cfif>
	</cfloop>

</cfif>
</cftransaction>
<cfif IsDefined("form.btnApply")>
	<cflocation url="dominio-edit.cfm?Scodigo=#form.Scodigo#&srch=#form.srch#&srty=#form.srty###botones" addtoken="no">
<cfelse>
	<cflocation url="dominio.cfm?srch=#form.srch#&srty=#form.srty#">
</cfif>
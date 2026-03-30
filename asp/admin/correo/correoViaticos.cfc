<cfcomponent displayname="CorreoViaticos">
	<cffunction name="enviar" returntype="string" >

		<cfparam name="subject" type="string" default="">
		<cfparam name="mailBody" type="string" default="">
		<!--- Si es mas de un correo separar la cadena por ";" ejemplo: uno@correo.com;dos@correo.com --->
		<cfparam name="to" type="string" default="">
		<!--- Si es mas de un correo separar la cadena por ";" ejemplo: uno@correo.com;dos@correo.com --->
		<cfparam name="from" type="string" default="">
		<cfparam name="cc" type="string" default="">
		<cfparam name="Conexion" type="string" default="#session.dsn#">
		<cfset mailtype = "text/html">

		<cfif from eq "">
			<cfif isdefined("Application.Politicas_PGlobal.correo.cuenta") and trim(Application.Politicas_PGlobal.correo.cuenta) neq "">
				<cfset from = Application.Politicas_PGlobal.correo.cuenta>
			<cfelse>
				<cfset from = "soin@aph.mx">
			</cfif>
		</cfif>

		<cfquery datasource="#Arguments.Conexion#">
			insert into SMTPQueue (
				SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml, SMTPbcc)
			values (
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#from#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#to#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#subject#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#mailBody#">, 1,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#cc#">)
		</cfquery>
		<!--- <cftry>
			<cfmail from="#from#" to="#to#" cc="#cc#" spoolenable="no" subject="#subject#" type="#mailtype#">
				<cfoutput>
					#mailBody#
				</cfoutput>
			</cfmail>

		<cfcatch type="any">
			<cflog file="SMTPQueue" text="#cfcatch.Message# #cfcatch.Detail#">
			<cfdump var="#cfcatch.Detail#">
		</cfcatch>
		</cftry> --->


	</cffunction>
</cfcomponent>
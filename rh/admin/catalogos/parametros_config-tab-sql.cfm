<cfparam name="modo" default="ALTA">

<cfset LvarPagina = "Parametros.cfm">

<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.AgregaConfiguracion")>
		<cfquery name="rsValidaCodigo" datasource="#session.dsn#">
			select Pcodigo from RHParametros
			where Pcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.c_Pcodigo#">
				and Ecodigo = #Session.Ecodigo#
		</cfquery>

		<cfif rsValidaCodigo.recordCount eq 0>
			<cfquery datasource="#Session.DSN#">
				insert into RHParametros (
					Pcodigo,Pcategoria,Pdescripcion,TipoDato,
			        TipoParametro,Parametros, Adicional, Ecodigo)
				values (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.c_Pcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pcategoria#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pdescripcion#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.TipoDato#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.TipoParametro#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Parametros#">,
					1, #Session.Ecodigo#
					)
			</cfquery>
			<cfset modo="ALTA">
		<cfelse>
			<cf_errorcode code="30000101" msg="Codigo duplicado">
		</cfif>
	<cfelseif isdefined("Form.EliminaConfiguracion")>
		<cfquery datasource="#Session.DSN#">
			delete from RHParametros
			where Pcodigo = '#Form.c_Pcodigo#' and Ecodigo = #Session.Ecodigo#
		</cfquery>
		<cfset modo="ALTA">
	<cfelseif isdefined("Form.ModificarConfiguracion")>
		<cfquery datasource="#Session.DSN#">
			update RHParametros set
				Pcategoria = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pcategoria#">,
				Pdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pdescripcion#">,
				TipoDato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.TipoDato#">,
				TipoParametro = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.TipoParametro#">,
				Parametros = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Parametros#">
			where Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.c_Pcodigo#">
				and Ecodigo = #Session.Ecodigo#
		</cfquery>
		<cfset modo="CAMBIO">
	</cfif>
</cfif>

<!---VALIDADOR--->

<form action="<cfoutput>#LvarPagina#</cfoutput>?tab=8<cfif isdefined('url.desde') and Trim(url.desde) eq 'rh'>&desde=rh</cfif>" method="post" name="sql">
	<cfif isdefined("Form.Nuevo")>
		<input name="Nuevo" type="hidden" value="Nuevo">
	</cfif>
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">

	<cfif modo neq 'ALTA'>
		<input name="id" type="hidden" value="<cfif isdefined("Form.id")><cfoutput>#Form.id#</cfoutput></cfif>">
	</cfif>
</form>

<HTML>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>

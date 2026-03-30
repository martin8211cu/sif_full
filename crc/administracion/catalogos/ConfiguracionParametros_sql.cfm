<cfparam name="modo" default="ALTA">

<cfset LvarPagina = "ConfiguracionParametros.cfm">

<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cfquery name="rsValidaCodigo" datasource="#session.dsn#">
			select Pcodigo from CRCParametros
			where Pcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pcodigo#">
				and Ecodigo = #Session.Ecodigo#
		</cfquery>

		<cfif rsValidaCodigo.recordCount eq 0>
			<cfquery datasource="#Session.DSN#">
				insert into CRCParametros (
					Pcodigo,Mcodigo,Pvalor,Pcategoria,Pdescripcion,TipoDato,
			        TipoParametro,Parametros,PSistema,PEspecial,Ecodigo,Usucrea,createdat)
				values (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Mcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pvalor#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pcategoria#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pdescripcion#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.TipoDato#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.TipoParametro#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Parametros#">,
					<cfif isdefined('form.PSistema')>1<cfelse>0</cfif>,
					<cfif isdefined('form.PEspecial')>1<cfelse>0</cfif>,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
					)
			</cfquery>
			<cfset modo="ALTA">
		<cfelse>
			<cf_errorcode code="30000101" msg="Codigo duplicado">
		</cfif>
	<cfelseif isdefined("Form.Baja")>
		<cfquery datasource="#Session.DSN#">
			delete from CRCParametros
			where id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id#">
		</cfquery>
		<cfset modo="ALTA">
	<cfelseif isdefined("Form.Cambio")>
		<cfquery datasource="#Session.DSN#">
			update CRCParametros set
				Mcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Mcodigo#">,
				Pvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pvalor#">,
				Pcategoria = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pcategoria#">,
				Pdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pdescripcion#">,
				TipoDato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.TipoDato#">,
				TipoParametro = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.TipoParametro#">,
				Parametros = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Parametros#">,
				PSistema = <cfif isdefined('form.PSistema')>1<cfelse>0</cfif>,
				PEspecial = <cfif isdefined('form.PEspecial')>1<cfelse>0</cfif>,
				Usumodif = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
				updatedat = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
			where id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id#">
		</cfquery>
		<cfset modo="CAMBIO">
	</cfif>
</cfif>

<!---VALIDADOR--->

<form action="<cfoutput>#LvarPagina#</cfoutput><cfif isdefined('url.desde') and Trim(url.desde) eq 'rh'>?desde=rh</cfif>" method="post" name="sql">
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

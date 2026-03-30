<cfparam name="modo" default="ALTA">
<cfset LvarPagina = "PromocionCredito.cfm">
<cfset resultT = ''>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_RangoFecha"
	Default="El rango de Fechas coincide con otra(s) promocion(es)" XmlFile="/crc/generales.xml" returnvariable="MSG_RangoFecha"/>

		<cfquery name="rsValidaFechas" datasource="#session.dsn#">
		select * from CRCPromocionCredito
			where (<cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(form.FechaDesde,'yyyy-mm-dd')#"> BETWEEN FechaDesde and FechaHasta
					or <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(form.FechaHasta,'yyyy-mm-dd')#"> BETWEEN FechaDesde and FechaHasta)
				and Ecodigo = #Session.Ecodigo#
				<cfif form.id neq -1>
					and id <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.id#">
				</cfif>
		</cfquery>

<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>

		<cfif rsValidaFechas.recordCount gt 0>
			<cfset resultT = "#MSG_RangoFecha#">
		<cfelse>
			<cftry>

				<cfquery datasource="#Session.DSN#">
					insert into CRCPromocionCredito (
						Codigo,Descripcion,Monto,FechaDesde,FechaHasta,Porciento,
						aplicaVales,aplicaTC,aplicaTM,Ecodigo,Usucrea,createdat)
					values (
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Codigo#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Descripcion#">,
						<cfqueryparam cfsqltype="cf_sql_money" value="#Monto#">,
						<cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(form.FechaDesde,'dd/mm/yyyy')#">,
						<cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(form.FechaHasta,'dd/mm/yyyy')#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="1" null="#yesNoFormat(NOT isdefined('form.Porciento'))#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="1" null="#yesNoFormat(NOT isdefined('form.aplicaVales'))#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="1" null="#yesNoFormat(NOT isdefined('form.aplicaTC'))#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="1" null="#yesNoFormat(NOT isdefined('form.aplicaTM'))#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
						)
				</cfquery>
				<cfset modo="ALTA">
			<cfcatch>
				<cfif cfcatch.cause.errorcode eq 2627>
					<cfset msg = REMatch("Violation of UNIQUE KEY constraint '.*?'\.",cfcatch.cause.message)>
					<cfif FindNoCase("_Codigo_",msg[1]) neq 0>
						<cfset resultT = "Codigo (#Form.Codigo#) ya existe, intente modificarla.">
					<cfelse>
						<cfset resultT = "#cfcatch.cause.message#">
					</cfif>
				<cfelse>
					<cfset resultT = "#cfcatch.cause.message#">
				</cfif>
			</cfcatch>
			</cftry>
		</cfif>

	<cfelseif isdefined("Form.Baja")>
		<cfquery datasource="#Session.DSN#">
			delete from CRCPromocionCredito
			where id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id#">
		</cfquery>
		<cfset modo="ALTA">
	<cfelseif isdefined("Form.Cambio")>

		<cfif rsValidaFechas.recordCount gt 0>
			<cfset resultT = "#MSG_RangoFecha#">
		<cfelse>
			<cftry>
				<cfset validaFechas(form.id)>
				<cfquery datasource="#Session.DSN#">
					update CRCPromocionCredito set
						Codigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Codigo#">,
						Descripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Descripcion#">,
						Monto = <cfqueryparam cfsqltype="cf_sql_money" value="#form.Monto#">,
						FechaDesde = <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(form.FechaDesde,'dd/mm/yyyy')#">,
						FechaHasta = <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(form.FechaHasta,'dd/mm/yyyy')#">,
						Porciento = <cfqueryparam cfsqltype="cf_sql_varchar" value="1" null="#yesNoFormat(NOT isdefined('form.Porciento'))#">,
						aplicaVales = <cfqueryparam cfsqltype="cf_sql_varchar" value="1" null="#yesNoFormat(NOT isdefined('form.aplicaVales'))#">,
						aplicaTC = <cfqueryparam cfsqltype="cf_sql_varchar" value="1" null="#yesNoFormat(NOT isdefined('form.aplicaTC'))#">,
						aplicaTM = <cfqueryparam cfsqltype="cf_sql_varchar" value="1" null="#yesNoFormat(NOT isdefined('form.aplicaTM'))#">,
						Usumodif = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
						updatedat = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
					where id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id#">
				</cfquery>
				<cfset modo="CAMBIO">
			<cfcatch>
				<cfif cfcatch.cause.errorcode eq 2627>
					<cfset msg = REMatch("Violation of UNIQUE KEY constraint '.*?'\.",cfcatch.cause.message)>
					<cfif FindNoCase("_Codigo_",msg[1]) neq 0>
						<cfset resultT = "Codigo (#Form.Codigo#) ya existe, intente modificarla.">
					<cfelse>
						<cfset resultT = "#cfcatch.cause.message#">
					</cfif>
				<cfelse>
					<cfset resultT = "#cfcatch.cause.message#">
				</cfif>
			</cfcatch>
			</cftry>
		</cfif>
	</cfif>
</cfif>

<cffunction name="validaFechas">
	<cfargument name="id" type="numeric" required="false" default="-1">
	<cfquery name="rsValidaFechas" datasource="#session.dsn#">
		select * from CRCPromocionCredito
			where (<cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(form.FechaDesde,'yyyy-mm-dd')#"> BETWEEN FechaDesde and FechaHasta
					or <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(form.FechaHasta,'yyyy-mm-dd')#"> BETWEEN FechaDesde and FechaHasta)
				and Ecodigo = #Session.Ecodigo#
				<cfif arguments.id neq -1>
					and id <> #arguments.id#
				</cfif>
		</cfquery>
		<cfif rsValidaFechas.recordCount gt 0>
			<cf_errorcode code="30000102" msg="#MSG_RangoFecha#">
		</cfif>
</cffunction>

<!---VALIDADOR--->

<form action="<cfoutput>#LvarPagina#</cfoutput><cfif isdefined('url.desde') and Trim(url.desde) eq 'rh'>?desde=rh</cfif>" method="post" name="sql">
	<cfif isdefined("Form.Nuevo")>
		<input name="Nuevo" type="hidden" value="Nuevo">
	</cfif>
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">

	<cfif modo neq 'ALTA'>
		<input name="id" type="hidden" value="<cfif isdefined("Form.id")><cfoutput>#Form.id#</cfoutput></cfif>">
	</cfif>
	<input type="hidden" name="resultT" id="resultT" value="<cfoutput>#resultT#</cfoutput>">
</form>

<HTML>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>

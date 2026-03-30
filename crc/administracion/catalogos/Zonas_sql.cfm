<cfparam name="modo" default="ALTA">
<cfset LvarPagina = "Zonas.cfm">
<cfset resultT = ''>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_RangoFecha"
	Default="El rango de Fechas coincide con otra(s) promocion(es)" XmlFile="/crc/generales.xml" returnvariable="MSG_RangoFecha"/>

<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cftry>
			<cfquery datasource="#Session.DSN#">
				insert into CRCZonas (
					Codigo,Descripcion,Ecodigo,Usucrea,createdat)
				values (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Form.Codigo)#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Descripcion#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
					)
			</cfquery>
			<cfset modo="ALTA">
		<cfcatch>
			<cfif cfcatch.cause.errorcode eq 2627>
				<cfset msg = REMatch("Violation of UNIQUE KEY constraint '.*?'\.",cfcatch.cause.message)>
				<cfif FindNoCase("_codigo_",msg[1]) neq 0>
					<cfset resultT = "Codigo (#Form.Codigo#) ya existe, intente modificarla.">
				<cfelse>
					<cfset resultT = "#cfcatch.cause.message#">
				</cfif>
			<cfelse>
				<cfset resultT = "#cfcatch.cause.message#">
			</cfif>
		</cfcatch>
		</cftry>
	<cfelseif isdefined("Form.Baja")>
		<cftry>
		<cfquery datasource="#Session.DSN#">
			delete from CRCZonas
			where id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id#">
		</cfquery>
		<cfset modo="ALTA">
		<cfcatch type = "Database">
			<cfif Find('IntegrityConstraintViolationException',CFCATCH.Cause.Type)>
				<cfset resultT = REMatch('table \".+\",', CFCATCH.Cause.Message)>
				<cfset resultT = "#replace(resultT[1],'table "dbo.','',"all")#">
				<cfset resultT = Replace(resultT,'",','',"all")>
				<cfset resultT = "Este item se encuentra asociado con otros registros">
				<!---
				<cf_errorCode code = "547" msg = "
					<cf_translate key=ConstraintViolationException>
						<cfoutput>#resultT#</cfoutput>
					</cf_translate>
				">--->
			</cfif>
		</cfcatch>
		</cftry>
	<cfelseif isdefined("Form.Cambio")>
		<cftry>
			<cfquery datasource="#Session.DSN#">
				update CRCZonas set
					Codigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Form.Codigo)#">,
					Descripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Descripcion#">,
					Usumodif = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					updatedat = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
				where id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id#">
			</cfquery>
			<cfset modo="CAMBIO">
		<cfcatch>
			<cfif cfcatch.cause.errorcode eq 2627>
				<cfset msg = REMatch("Violation of UNIQUE KEY constraint '.*?'\.",cfcatch.cause.message)>
				<cfif FindNoCase("_codigo_",msg[1]) neq 0>
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

<!---VALIDADOR--->

<form action="<cfoutput>#LvarPagina#</cfoutput>" method="post" name="sql">
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

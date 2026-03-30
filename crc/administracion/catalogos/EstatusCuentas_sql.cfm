<cfparam name="modo" default="ALTA">
<cfset resultT = ''>

<cfset LvarPagina = "EstatusCuentas.cfm">

<cfquery name="queryDescripcion" datasource="#Session.DSN#">
	select * from CRCEstatusCuentas 
	where Descripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Descripcion#">
	<cfif isdefined("Form.Cambio")>
		and id <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id#">
	</cfif>
</cfquery>

<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cfquery name="q_unique" datasource="#Session.DSN#">
			select id from CRCEstatusCuentas where 
					Orden = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Form.Orden)#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				;
		</cfquery>
		<cfif q_unique.RecordCount neq 0>
			<cfset resultT = "El orden (#Form.Orden#) ya ha sido asignado a otro estatus.">
		</cfif>
		<cfif queryDescripcion.RecordCount gt 0>
			<cfset resultT = "La descripci&oacute;n ya existe.">
		<cfelse>
			<cfquery datasource="#Session.DSN#">
				insert into CRCEstatusCuentas (
					Orden,Descripcion,AplicaVales,AplicaTC,AplicaTM,Ecodigo,Usucrea,createdat)
				values (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Form.Orden)#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Descripcion#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="1" null="#yesNoFormat(NOT isdefined('form.AplicaVales'))#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="1" null="#yesNoFormat(NOT isdefined('form.AplicaTC'))#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="1" null="#yesNoFormat(NOT isdefined('form.AplicaTM'))#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
					)
			</cfquery>
			<cfset modo="ALTA">
		</cfif>
	<cfelseif isdefined("Form.Baja")>
		<cftry>
			<cfquery datasource="#Session.DSN#">
				delete from CRCEstatusCuentas
				where id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id#">
			</cfquery>
			<cfset modo="ALTA">
		<cfcatch type = "Database">
			<cfif Find('IntegrityConstraintViolationException',CFCATCH.Cause.Type)>
				<cfset resultT = REMatch('table \".+\",', CFCATCH.Cause.Message)>
				<cfset resultT = "#replace(resultT[1],'table "dbo.','',"all")#">
				<cfset resultT = Replace(resultT,'",','',"all")>
				<cfset resultT = "Este item se encuentra asociado con otros registros">
			</cfif>
		</cfcatch>
		</cftry>
	<cfelseif isdefined("Form.Cambio")>
		<cfquery name="q_unique" datasource="#Session.DSN#">
			select id from CRCEstatusCuentas where 
					Orden = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Form.Orden)#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				;
		</cfquery>
		
		<cfloop query="#q_unique#">
			<cfif q_unique.id neq Form.id>
				<cfset resultT ="El orden (#Form.Orden#) ya ha sido asignado a otro estatus.">
			</cfif>
		</cfloop>

		<cfif queryDescripcion.RecordCount gt 0>
			<cfset resultT = "La descripcion ya se encuentra asociada a otra orden">
		<cfelse>
			<cfquery datasource="#Session.DSN#">
				update CRCEstatusCuentas set
					Orden = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Form.Orden)#">,
					Descripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Descripcion#">,
					AplicaVales = <cfqueryparam cfsqltype="cf_sql_integer" value="1" null="#yesNoFormat(NOT isdefined('form.AplicaVales'))#">,
					AplicaTC = <cfqueryparam cfsqltype="cf_sql_integer" value="1" null="#yesNoFormat(NOT isdefined('form.AplicaTC'))#">,
					AplicaTM = <cfqueryparam cfsqltype="cf_sql_integer" value="1" null="#yesNoFormat(NOT isdefined('form.AplicaTM'))#">,
					Usumodif = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					updatedat = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
				where id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id#">
			</cfquery>
			<cfset modo="CAMBIO">
		</cfif>
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
	<input type="hidden" name="resultT" id="resultT" value="<cfoutput>#resultT#</cfoutput>">
</form>

<HTML>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>

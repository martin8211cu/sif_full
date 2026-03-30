<cfparam name="modo" default="ALTA">
<cfset resultT = ''>

<cfset LvarPagina = "CategoriaDistribuidor.cfm">

<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cfquery datasource="#Session.DSN#" name="rsCatVal">
			select * from CRCCategoriaDist 
			where
				not ((#form.MontoMin# < MontoMin and #form.MontoMax# < MontoMin) or
				(#form.MontoMax# > MontoMax and #form.MontoMin# > MontoMax))
		</cfquery>
		
		<cfif rsCatVal.RecordCount eq 0>
		<cftry>
		<cfquery datasource="#Session.DSN#">
			insert into CRCCategoriaDist (
				Orden,Titulo,Descripcion,Monto,MontoMin,MontoMax,Descuentoinicial,PenalizacionDia,
				PorcientoSeguro,Ecodigo,Usucrea,createdat,emisorq1,emisorq2)
			values (
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Form.Orden)#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Form.Titulo)#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Descripcion#">,
				<cfqueryparam cfsqltype="cf_sql_money" value="#form.Monto#">, <!--- no form --->
				<cfqueryparam cfsqltype="cf_sql_money" value="#form.MontoMin#">,
				<cfqueryparam cfsqltype="cf_sql_money" value="#form.MontoMax#">,
				<cfqueryparam cfsqltype="cf_sql_money" value="#form.Descuentoinicial#">, <!--- no form --->
				<cfqueryparam cfsqltype="cf_sql_money" value="#form.PenalizacionDia#">,
				<cfqueryparam cfsqltype="cf_sql_money" value="#form.PorcientoSeguro#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.emisorq1#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.emisorq2#">
				)
		</cfquery>
		<cfset modo="ALTA">
		<cfcatch>
			<cfif cfcatch.cause.errorcode eq 2627>
				<cfset msg = REMatch("Violation of UNIQUE KEY constraint '.*?'\.",cfcatch.cause.message)>
				<cfif FindNoCase("_orden_",msg[1]) neq 0>
					<cfset resultT = "El Orden (#Form.Orden#) ya ha sido asignado a otra categor&iacute;a">
				<cfelseif FindNoCase("_titulo_",msg[1]) neq 0>
					<cfset resultT = "C&oacute;digo (#Form.Titulo#) ya existe, intente modificarlo.">
				<cfelse>
					<cfset resultT = "#cfcatch.cause.message#">
				</cfif>
			<cfelse>
				<cfset resultT = "#cfcatch.cause.message#">
			</cfif>
		</cfcatch>
		</cftry>
		<cfelse>
			<cfset resultT = "El rango de montos ya pertenece a otra categor&iacute;a">
		</cfif>
	<cfelseif isdefined("Form.Baja")>
		<cftry>

			<cfquery datasource="#Session.DSN#">
				delete from CRCCategoriaDist
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
		<cfquery datasource="#Session.DSN#" name="rsCatVal">
			select * from CRCCategoriaDist 
			where 
				not ((#form.MontoMin# < MontoMin and #form.MontoMax# < MontoMin) or
				(#form.MontoMax# > MontoMax and #form.MontoMin# > MontoMax))
		</cfquery>
		<cfif rsCatVal.RecordCount eq 1 and rsCatVal.id eq Form.id>
			<cftry>
			<cfquery datasource="#Session.DSN#">
				update CRCCategoriaDist set
					Orden = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Form.Orden)#">,
					Titulo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Form.Titulo)#">,
					Descripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Descripcion#">,
					Monto = <cfqueryparam cfsqltype="cf_sql_money" value="#form.Monto#">,
					MontoMin = <cfqueryparam cfsqltype="cf_sql_money" value="#form.MontoMin#">,
					MontoMax = <cfqueryparam cfsqltype="cf_sql_money" value="#form.MontoMax#">,
					Descuentoinicial = <cfqueryparam cfsqltype="cf_sql_money" value="#form.Descuentoinicial#">,
					PenalizacionDia = <cfqueryparam cfsqltype="cf_sql_money" value="#form.PenalizacionDia#">,
					PorcientoSeguro = <cfqueryparam cfsqltype="cf_sql_money" value="#form.PorcientoSeguro#">,
					Usumodif = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					updatedat = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
					emisorq1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.emisorq1#">,
					emisorq2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.emisorq2#">
				where id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id#">
			</cfquery>
			<cfset modo="CAMBIO">
			<cfcatch>
				<cfif cfcatch.cause.errorcode eq 2627>
					<cfset msg = REMatch("Violation of UNIQUE KEY constraint '.*?'\.",cfcatch.cause.message)>
					<cfif FindNoCase("_orden_",msg[1]) neq 0>
						<cfset resultT = "El Orden (#Form.Orden#) ya ha sido asignado a otra categor&iacute;a">
					<cfelseif FindNoCase("_titulo_",msg[1]) neq 0>
						<cfset resultT = "C&oacute;digo (#Form.Titulo#) ya existe, intente modificarlo.">
					<cfelse>
						<cfset resultT = "#cfcatch.cause.message#">
					</cfif>
				<cfelse>
					<cfset resultT = "#cfcatch.cause.message#">
				</cfif>
			</cfcatch>
			</cftry>
		<cfelse>
			<cfset resultT = "El rango de montos ya pertenece a otra categor&iacute;a">
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

<cfparam name="modo" default="ALTA">
<cfset LvarPagina = "TipoTransaccion.cfm">
<cfset resultT = ''>

<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cftry>
			<cfquery datasource="#Session.DSN#">
				insert into CRCTipoTransaccion 
					(Codigo,Descripcion,TipoMov,#form.AFECTA_A#,Ecodigo)
				values (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#UCase(Trim(Form.CODIGO))#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DESCRIPCION#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.TIPOMOV#">,
					<cfqueryparam cfsqltype="cf_sql_bit" value="1">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
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
			delete from CRCTipoTransaccion
			where id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id#">
		</cfquery>
		<cfset modo="ALTA">
		<cfcatch type = "Database">
			<cfif Find('IntegrityConstraintViolationException',CFCATCH.Cause.Type)>
				<cfset resultT = REMatch('table \".+\",', CFCATCH.Cause.Message)>
				<cfset resultT = "#replace(resultT[1],'table "dbo.','',"all")#">
				<cfset resultT = Replace(resultT,'",','',"all")>
				<cfset resultT = "Este item se encuentra asociado con otros registros">
				<!---<cf_errorCode code = "547" msg = "
					<cf_translate key=ConstraintViolationException>
						<cfoutput>#resultT#</cfoutput>
					</cf_translate>
				">--->
			</cfif>
		</cfcatch>
		</cftry>
	<cfelseif isdefined("Form.Cambio")>
		<cfset af_Saldo = 0>
		<cfset af_Interes = 0>
		<cfset af_Compras = 0>
		<cfset af_Pagos = 0>
		<cfset af_Condonaciones = 0>
		<cfset af_Gasto = 0>
		<cfset af_Seguro= 0>
		<cfswitch expression="#Form.AFECTA_A#">
			<cfcase value="afectaSaldo"> <cfset af_Saldo = 1> </cfcase>
			<cfcase value="afectaInteres"> <cfset af_Interes = 1> </cfcase>
			<cfcase value="afectaCompras"> <cfset af_Compras = 1> </cfcase>
			<cfcase value="afectaPagos"> <cfset af_Pagos = 1> </cfcase>
			<cfcase value="afectaCondonaciones"> <cfset af_Condonaciones = 1> </cfcase>
			<cfcase value="afectaGastoCobranza"> <cfset af_Gasto = 1> </cfcase>
			<cfcase value="afectaSeguro"> <cfset af_Seguro = 1> </cfcase>
			<cfdefaultcase></cfdefaultcase>
		</cfswitch>
		
		<cftry>
			<cfquery datasource="#Session.DSN#">
				update CRCTipoTransaccion set
					Codigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#UCase(Trim(Form.CODIGO))#">,
					Descripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Descripcion#">,
					TipoMov = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.TipoMov#">,
					afectaSaldo = <cfqueryparam cfsqltype="cf_sql_bit" value="#af_Saldo#">,
					afectaInteres = <cfqueryparam cfsqltype="cf_sql_bit" value="#af_Interes#">,
					afectaCompras = <cfqueryparam cfsqltype="cf_sql_bit" value="#af_Compras#">,
					afectaPagos = <cfqueryparam cfsqltype="cf_sql_bit" value="#af_Pagos#">,
					afectaCondonaciones = <cfqueryparam cfsqltype="cf_sql_bit" value="#af_Condonaciones#">,
					afectaGastoCobranza = <cfqueryparam cfsqltype="cf_sql_bit" value="#af_Gasto#">,
					afectaSeguro = <cfqueryparam cfsqltype="cf_sql_bit" value="#af_Seguro#">,

					updatedat = <cfqueryparam cfsqltype="cf_sql_date" value='#DateFormat(Now(), "yyyy/mm/dd")#'>
				where id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.id#">
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

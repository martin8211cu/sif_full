<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_RangoPago"
	Default="Los saldos m&iacute;nimo y m&aacute;ximo coinciden con los valores de otro(s) registros(s)" XmlFile="/crc/generales.xml" returnvariable="MSG_RangoPago"/>


<cfparam name="modo" default="ALTA">
<cfset LvarPagina = "PagoMinimo.cfm">
<cfset resultT = ''>

<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cfset count = ValidarRangoPagos()>
		<cfif count eq 0>
			<cfquery datasource="#Session.DSN#">
				insert into CRCPagoMinimo (
					SaldoMin,SaldoMax,MontoPagoMin,Porciento,Ecodigo,Usucrea,createdat)
				values (
					<cfqueryparam cfsqltype="cf_sql_money" value="#form.SaldoMin#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#form.SaldoMax#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#form.MontoPagoMin#">,
					<cfif isdefined('form.porciento')> <cfset form.porciento = 1> <cfelse> <cfset form.porciento = 0></cfif>
					<cfqueryparam cfsqltype="cf_sql_boolean" value="#form.porciento#">, 	
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
					)
			</cfquery>
		</cfif>
		<cfset modo="ALTA">
	<cfelseif isdefined("Form.Baja")>
		<cftry>
			<cfquery datasource="#Session.DSN#">
				delete from CRCPagoMinimo
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
		<cfset count = ValidarRangoPagos(form.id)>
		<cfif count eq 0>
			<cfquery datasource="#Session.DSN#">
				update CRCPagoMinimo set
					SaldoMin = <cfqueryparam cfsqltype="cf_sql_money" value="#form.SaldoMin#">,
					SaldoMax = <cfqueryparam cfsqltype="cf_sql_money" value="#form.SaldoMax#">,
					MontoPagoMin = <cfqueryparam cfsqltype="cf_sql_money" value="#form.MontoPagoMin#">,
					<cfif isdefined('form.porciento')> <cfset form.porciento = 1> <cfelse> <cfset form.porciento = 0></cfif>
					Porciento = <cfqueryparam cfsqltype="cf_sql_boolean" value="#form.porciento#">,	
					Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
					Usumodif = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					updatedat = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
				where id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id#">
			</cfquery>
		</cfif>
		<cfset modo="CAMBIO">
	</cfif>
</cfif>

<cffunction name="ValidarRangoPagos">
	<cfargument name="id" type="numeric" required="false" default="-1">
	
	<cfquery datasource="#Session.DSN#" name="q_ValidarRangoPagos">
		select * from CRCPagoMinimo 
		where 
			not ((<cfqueryparam cfsqltype="cf_sql_money" value="#form.SaldoMin#"> < SaldoMin and <cfqueryparam cfsqltype="cf_sql_money" value="#form.SaldoMax#"> < SaldoMin) or
			(<cfqueryparam cfsqltype="cf_sql_money" value="#form.SaldoMax#"> > SaldoMax and <cfqueryparam cfsqltype="cf_sql_money" value="#form.SaldoMin#"> > SaldoMax))
			and Ecodigo = #Session.Ecodigo#
			<cfif arguments.id neq -1>
				and id <> #arguments.id#
			</cfif>
	</cfquery>
	<cfif q_ValidarRangoPagos.recordCount gt 0>
		<cfset resultT = MSG_RangoPago>
		<!--- <cf_errorcode code="30000102" msg="#MSG_RangoPago#"> --->
	</cfif>
	<cfreturn q_ValidarRangoPagos.recordCount>
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

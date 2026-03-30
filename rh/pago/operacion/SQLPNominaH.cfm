<cfsetting 	requestTimeOut = "8400" >

<cfset action = "PNominaH.cfm">
<cfif not isDefined("Form.ERNid")>
	<cflocation url="listaPNominaH.cfm">
</cfif>
<html>
<head>
<title>SQL DE REGISTRO DE PAGO DE NÓMINA</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body>

<cfparam name="form.ERNid" default="0" type="any">
<!--- <cfdump var="#Form#"> --->

<cfif (isdefined("form.chk"))>
	<cfset vchk = ListToArray(form.chk)>
</cfif>

<cfif IsDefined("form.btnpagar")>
	<cfloop from="1" index="i" to="#ArrayLen(vchk)#">
		<cfset datos = ListToArray(vchk[i],'|')>
		<cfquery datasource="#session.dsn#" name="data">
			<!--- Marca como pagados los registros marcados, vienen en el parámetro chk de la forma "ERNid|DRNlinea" separados por coma. --->
			update HDRNomina
			set HDRNestado = 1 <!--- Pagado --->
			where ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos[1]#">
			and DRNlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos[2]#">
		</cfquery>
	</cfloop>

<cfelseif IsDefined("form.btnrechazar")>

	<cfloop from="1" index="i" to="#ArrayLen(vchk)#">
		<cfset datos = ListToArray(vchk[i],'|')>
		<cfquery datasource="#session.dsn#" name="data">
			<!--- Marca como rechazados los registros marcados, vienen en el parámetro chk de la forma "ERNid|DRNlinea" separados por coma. --->
			update HDRNomina
			set HDRNestado = 2 <!--- Rechazado --->
			where ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos[1]#">
			  and DRNlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos[2]#">
		</cfquery>
	</cfloop>
	
<cfelseif IsDefined("form.btnpendiente")>

	<cfloop from="1" index="i" to="#ArrayLen(vchk)#">
		<cfset datos = ListToArray(vchk[i],'|')>
		<cfquery datasource="#session.dsn#" name="data">
			<!--- Marca como pendientes los registros marcados, vienen en el parámetro chk de la forma "ERNid|DRNlinea" separados por coma. --->
			update HDRNomina
			set HDRNestado = 3 <!--- Pendiente --->
			where ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos[1]#">
			and DRNlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos[2]#">
		</cfquery>
	</cfloop>

<cfelseif IsDefined("form.btnpagarall")>
	<cfquery datasource="#session.dsn#" name="data">
		<!--- Marca como pagados los registros que se encuentren con estado pendiente --->
		update HDRNomina
		set HDRNestado = 1 <!--- Pagado --->
		where ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ERNid#">
		<!--- and DRNestado = 3 --->
	</cfquery>

<cfelseif IsDefined("form.btnrechazarall")>
	<cfquery datasource="#session.dsn#" name="data">
		<!--- Marca como rechazados los registros que se encuentren con estado pendiente --->
		update HDRNomina
		set HDRNestado = 2 <!--- Rechazado --->
		where ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ERNid#">
		<!--- and DRNestado = 3 --->
	</cfquery>
	
<cfelseif IsDefined("form.btnFinalizar")>
	<cfset chkDefinido = true >
	<cfif len(trim(form.ERNid))>
		<cfset chkDefinido = false >
		<cfset form.chk = form.ERNid >
	</cfif>


	<cfloop list="#form.chk#" index="LvarERNid">
		<cfinvoke 
			component="rh.Componentes.RH_PagoNomina"
			method="rh_HistoricosNomina"
		>
			<cfinvokeargument name="ERNid" value="#LvarERNid#" />
			<cfinvokeargument name="debug" value="N" />
		</cfinvoke>
		<!--- 
		<cfquery datasource="#session.dsn#" name="data">
			set nocount on
			execute rh_HistoricosNomina 
			  @Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			, @ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarERNid#">
			, @Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
			, @debug = 'N'
				
			select @@rowcount as rc
			set nocount off
		</cfquery>
			<cf_dump var="#data#" label="query btnpendienteall">	
		--->
	
		<cfif (isdefined("data.RC") and data.RC GT 0) or (isdefined("data") AND data.RecordCount gt 0) >
			<cfinclude template="PagoErrores.cfm">
			<cfabort>
		</cfif>
		
		<cfset action = "listaPNominaH.cfm">
	</cfloop>

	<cfif chkDefinido >
		<cflocation url="listaPNominaH.cfm" >
	</cfif>

</cfif>

<form action="<cfoutput>#action#</cfoutput>" method="post" name="SQLform">
	<input name="ERNid" type="hidden" value="<cfoutput>#Form.ERNid#</cfoutput>">
	<!--- <input type="submit" name="Continuar" value="Continuar"> --->
</form>

</body>
</html>
<script language="JavaScript" type="text/javascript">document.SQLform.submit();</script>
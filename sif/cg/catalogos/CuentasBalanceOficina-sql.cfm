<!--- <cf_dump var="#form#"> --->

<cfset params = "">
<cfset modo = "ALTA">

<cftry>
	<cfif form.botonsel eq "alta">
		<cfquery name="rsVerifica" datasource="#session.DSN#">
			select Cconcepto	
			from CuentaBalanceOficina
			where Ecodigo 		= <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and Cconcepto 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Cconcepto#">
				and Ocodigoori 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ocodigoori#">
				and Ocodigodest = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ocodigodest#">
		</cfquery>	
		<cfif #rsVerifica.recordCount# eq 0>
			<cfquery name="rsCuenta" datasource="#session.DSN#">
				insert into CuentaBalanceOficina (Ecodigo,Cconcepto,Ocodigoori,Ocodigodest,CFcuentacxc,CFcuentacxp)
				values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
						 <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Cconcepto#">,
						 <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ocodigoori#">,
						 <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ocodigodest#">,
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFcuentacxc#">,
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFcuentacxp#">) 
			</cfquery>
	
			<cfset modo = "CAMBIO">
			<cfset params="?Cconcepto="&form.Cconcepto>
			<cfset params=params&"&Ocodigoori="&form.Ocodigoori>
			<cfset params=params&"&Ocodigodest="&form.Ocodigodest>
			<cfset params=params&"&modo="&#modo#>		
		<cfelse>
			<cf_errorCode	code = "50216" msg = "No se puede agregar porque la cuenta ya está asignada.">		
		</cfif>
	<cfelseif form.botonsel eq "Importar">
		<cflocation url="../importar/importaBalanceO.cfm">

	<cfelseif form.botonsel eq "cambio">
		<cfquery name="rsCuenta" datasource="#session.DSN#">
			update CuentaBalanceOficina
			set CFcuentacxc = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFcuentacxc#">,
				CFcuentacxp = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFcuentacxp#">
			where Ecodigo 		= <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and Cconcepto 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Cconcepto#">
				and Ocodigoori 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ocodigoori#">
				and Ocodigodest = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ocodigodest#">					
		</cfquery>	

		<cfset modo = "CAMBIO">
		<cfset params="?Cconcepto="&form.Cconcepto>
		<cfset params=params&"&Ocodigoori="&form.Ocodigoori>
		<cfset params=params&"&Ocodigodest="&form.Ocodigodest>
		<cfset params=params&"&modo="&#modo#>
		
	<cfelseif form.botonsel eq "baja">
		<cfquery name="rsCuenta" datasource="#session.DSN#">
			delete from CuentaBalanceOficina
			where Ecodigo 		= <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and Cconcepto 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Cconcepto#">
				and Ocodigoori 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ocodigoori#">
				and Ocodigodest = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ocodigodest#">								
		</cfquery>	
		
		<cfset modo = "CAMBIO">
		<cfset params="?modo="&#modo#>
	</cfif>

	<cfcatch type="any">
		<cfinclude template="/sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
</cftry>

<cflocation url="CuentasBalanceOficina.cfm#params#">


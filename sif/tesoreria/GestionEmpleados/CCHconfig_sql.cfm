<!---Agrega--->
<cfif isdefined ('form.Agrega')>
	<cfquery name="inSQL" datasource="#session.dsn#">
		insert into CCHconfig (
		Ecodigo,
		CCHCmonto,
		CCHCmax,
		CCHCmin,
		CCHCdias,
		CCHCreintegro,
		BMUsucodigo,
		BMfecha,
		CCHCdiasvencAnti,
		CCHCdiasvencAntiViat,
		CCHCantsPendientes
		)
		values(
		<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
		<cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.montoMax,',','','ALL')#">,
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.porcMax#">,
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.porcMin#">,
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.dias1#">,
			<cfif isdefined ('form.reintegro')>
				<cfqueryparam cfsqltype="cf_sql_bit" value="1">,
			<cfelse>
				<cfqueryparam cfsqltype="cf_sql_bit" value="0">,
			</cfif>
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
		<cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(now(),'DD/MM/YYYY')#">,
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.diasAnti#">,
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.diasAntiViat#">,
		<cfif isdefined ('form.CCHCantsPendientes')>
			1
		<cfelse>
			0
		</cfif>
		)
	</cfquery>
	<cflocation url="CCHconfig.cfm">
</cfif>

<!---Modificar--->
<cfif isdefined ('form.modificar')>
	<cfquery name="upSQL" datasource="#session.dsn#">
		update CCHconfig set
			Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
			CCHCmonto=<cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.montoMax,',','','ALL')#">,
			CCHCmax=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.porcMax#">,
			CCHCmin=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.porcMin#">,
			CCHCdias=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.dias1#">,
				<cfif isdefined ('form.reintegro')>
					CCHCreintegro=<cfqueryparam cfsqltype="cf_sql_bit" value="1">,
				<cfelse>
					CCHCreintegro=<cfqueryparam cfsqltype="cf_sql_bit" value="0">,
				</cfif>			
			BMUsucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
			BMfecha=<cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(now(),'DD/MM/YYYY')#">,
			CCHCdiasvencAnti=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.diasAnti#">,
     		CCHCdiasvencAntiViat=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.diasAntiViat#">,
			<cfif isdefined ('form.CCHCantsPendientes')>
				CCHCantsPendientes = 1
			<cfelse>
				CCHCantsPendientes = 0
			</cfif>
	</cfquery>
	<cflocation url="CCHconfig.cfm">
</cfif>

<!---Regresar--->

<cfif isdefined ('form.Regresar')>
	<cflocation url="/cfmx/home/menu/modulo.cfm?s=SIF&m=TES">
</cfif>

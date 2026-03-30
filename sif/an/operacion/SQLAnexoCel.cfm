<cfif not isdefined("form.Nuevo")>
	<cfif isdefined("Form.ALTA")>
		<cfquery name="AnexoCel_ABC" datasource="#Session.DSN#">
				insert into AnexoCel (AnexoId, AnexoRan, AnexoCon, AnexoRel, AnexoMes, AnexoPer, Ocodigo, AnexoNeg)
				values(
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AnexoId#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.AnexoRan#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.AnexoCon#">,
				<cfif isdefined("Form.AnexoRel")>
					<cfqueryparam cfsqltype="cf_sql_integer" value="1">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.AnexoMes#"> ,
				<cfelse>
					<cfqueryparam cfsqltype="cf_sql_integer" value="0">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Meses#"> ,
				</cfif>
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.AnexoPer#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ocodigo#">,
				<cfif isdefined("Form.AnexoNeg")>
					<cfqueryparam cfsqltype="cf_sql_integer" value="1">
				<cfelse>
					<cfqueryparam cfsqltype="cf_sql_integer" value="0">
				</cfif>
				)
			<cf_dbidentity1 datasource="#session.dsn#" name="AnexoCel_ABC">
		</cfquery>
		<cf_dbidentity2 name="AnexoCel_ABC" datasource="#session.dsn#" returnvariable="AnexoCelId">
		<cfset modo = "ALTA">
	<cfelseif isdefined("Form.CAMBIO")>
		<cfquery name="AnexoCel_ABC" datasource="#Session.DSN#">
			update AnexoCel set 
				AnexoRan = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.AnexoRan#">,
				AnexoCon = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.AnexoCon#">,
				AnexoRel = #iif(isdefined("Form.AnexoRel"),1,0)#,
				AnexoMes = #iif(isdefined("Form.AnexoRel"),Form.AnexoMes,Form.Meses)#,
				AnexoPer = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.AnexoPer#">,
				Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ocodigo#">,
				AnexoNeg = #iif(isdefined("Form.AnexoNeg"),1,0)#
			where AnexoCelId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AnexoCelId#">
		</cfquery>
		<cfset modo = "CAMBIO">
	<cfelseif isdefined("Form.BAJA")>
		<cfquery name="AnexoCel_ABC" datasource="#Session.DSN#">
			delete from AnexoCelD
			where AnexoCelId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AnexoCelId#">
		 </cfquery>
		 <cfquery name="AnexoCel_ABC" datasource="#Session.DSN#">
			delete from AnexoCel
			where AnexoCelId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AnexoCelId#">
		</cfquery>
		<cfset modo = "ALTA">
	</cfif>
<cfif isdefined("form.BAJA")>
	<cflocation url="Definirdatos.cfm?AnexoId=#Form.AnexoId#">
<cfelse>
	<cfif isdefined("form.ALTA")>
		<cfset form.AnexoCelId = #AnexoCelId# >
	</cfif>
	<cflocation url="Definirdatos.cfm?AnexoId=#Form.AnexoId#&AnexoCelId2=#Form.AnexoCelId#">
</cfif>


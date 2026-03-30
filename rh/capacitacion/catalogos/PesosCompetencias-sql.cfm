<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="MSG_LaSumaDeLosPesosNoPuedeSerMayorA" default="La suma de los pesos no puede ser mayor a 100%" returnvariable="MSG_LaSumaDeLosPesosNoPuedeSerMayorA"component="sif.Componentes.Translate" method="Translate">
<!--- FIN VARIABLES DE TRADUCCION --->
<cfset modo = "ALTA">
<cfset params="">
<cfif not isdefined("Form.Nuevo")>
	<cftransaction>
	<cfif isdefined("Form.Baja")>
		<cfquery name="delete" datasource="#Session.DSN#">
			delete from RHPesosCompetencia
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and  RHPCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPCid#">
		</cfquery>  
		<cfset modo="ALTA">
	<cfelseif isdefined("Form.Cambio")>
		<cfquery name="rsSumaTotales" datasource="#session.DsN#">
			select sum(RHPCpeso) as Total
			from RHPesosCompetencia
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and  RHPCid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPCid#">
		</cfquery>
		<cfset Lvar_Total = rsSumaTotales.Total + form.RHPCpeso>
		<cfif Lvar_Total LTE 100>
			<cf_dbtimestamp datasource="#session.dsn#"
				table="RHPesosCompetencia"
				redirect="PesosCompetencias.cfm"
				timestamp="#form.ts_rversion#"				
				field1="Ecodigo" type1="integer" value1="#session.Ecodigo#"
				field2="RHPCid" type2="numeric" value2="#form.RHPCid#">
			<cfquery name="update" datasource="#Session.DSN#">
				update RHPesosCompetencia  
				set RHPCpeso 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPCpeso#">,
					RHPCdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHPCdescripcion#">,
					BMfechaalta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					BMUsucodigo =	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
				where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >
				  and RHPCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPCid#" >
			</cfquery> 
		<cfelse>
			<cf_throw message="#MSG_LaSumaDeLosPesosNoPuedeSerMayorA#" errorcode="10015">
		</cfif>
		<cfset modo="CAMBIO">
		<cfset params = params & iif(len(trim(params)),DE("&"),DE("?")) &  "RHPCid=" &  RHPCid>	
	</cfif>
	</cftransaction>
</cfif>
<cfset params = params & iif(len(trim(params)),DE("&"),DE("?")) &  "modo=" & modo>	
<cflocation url="PesosCompetencias.cfm#params#">
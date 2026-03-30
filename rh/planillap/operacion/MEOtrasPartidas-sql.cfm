<cfset params = '?RHEid=#form.RHEid#'>
<cfif isdefined('form.Modificar')>
	<cfquery name="rsOP" datasource="#session.DSN#">
		select a.RHOPFid
		from RHOPFormulacion a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and a.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
	</cfquery>
	<cftransaction>
		<cfloop query="rsOP">
			<cfset Lvar_Disponible= form['Disponible#rsOP.RHOPFid#'] >
			<cfset Lvar_Refuerzo = form['Refuerzo#rsOP.RHOPFid#']>
			<cfset Lvar_Modificacion = form['Modificacion#rsOP.RHOPFid#']>
			<cfquery name="updateEscenario" datasource="#session.DSN#">
				update RHOPFormulacion
				set RHOPFdisponible 	 = <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(Lvar_Disponible,',','','all')#">,
					RHOPFrefuerzo 	 = <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(Lvar_Refuerzo,',','','all')#">,
					RHOPFmodificacion = <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(Lvar_Modificacion,',','','all')#">,
					BMfecha 		 = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
					BMUsucodigo 	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
				where RHOPFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOP.RHOPFid#">
			</cfquery>
		</cfloop>
	</cftransaction>
</cfif>
<cflocation url="MEOtrasPartidas.cfm#params#">

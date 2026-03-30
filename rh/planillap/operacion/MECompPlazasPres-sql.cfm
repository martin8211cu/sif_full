<!--- TRAE LOS DATOS DE LOS COMPONENTES SALARIALES --->
<cfset params = '?RHEid=#form.RHEid#&RHSAid=#form.RHSAid#'>
<cfif isdefined('form.Modificar')>
	<cfquery name="rsComponentes" datasource="#session.DSN#">
		select RHCFid
		from RHFormulacion a
		inner join RHCFormulacion b
			on b.RHFid = a.RHFid
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
		  and RHSAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHSAid#">
	</cfquery>
	<cftransaction>
		<cfloop query="rsComponentes">
			<cfset Lvar_Disponible= form['Disponible#rsComponentes.RHCFid#'] >
			<cfset Lvar_Refuerzo = form['Refuerzo#rsComponentes.RHCFid#']>
			<cfset Lvar_Modificacion = form['Modificacion#rsComponentes.RHCFid#']>
			<cfquery name="updateEscenario" datasource="#session.DSN#">
				update RHCFormulacion
				set RHCFdisponible 	 = <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(Lvar_Disponible,',','','all')#">,
					RHCFrefuerzo 	 = <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(Lvar_Refuerzo,',','','all')#">,
					RHCFmodificacion = <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(Lvar_Modificacion,',','','all')#">,
					BMfecha 		 = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
					BMUsucodigo 	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
				where RHCFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsComponentes.RHCFid#">
			</cfquery>
		</cfloop>
	</cftransaction>
</cfif>
<cflocation url="MECompPlazasPres.cfm#params#">

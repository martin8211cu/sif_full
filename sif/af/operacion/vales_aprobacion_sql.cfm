<cfset params = "?DEid=#form.DEid#">
<cfif isdefined("form.btnaprobar")>
	<cfset llaves = ListToArray(form.chk)>
	<cfloop from="1" to="#ArrayLen(llaves)#" index="i">
		<cfquery datasource="#session.DSN#">
			update AFAdquisicion 
			set AFAstatus = 20
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and AFAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#llaves[i]#">
				and AFAstatus = 10
		</cfquery>			
	</cfloop>				
<cfelseif isdefined("form.btnRechazar")>
	<cfset llaves = ListToArray(form.chk)>
	<cfloop from="1" to="#ArrayLen(llaves)#" index="i">
		<cfquery datasource="#session.DSN#">
			update AFAdquisicion 
			set AFAstatus = 0
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and AFAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#llaves[i]#">
				and AFAstatus = 10
		</cfquery>			
	</cfloop>
<cfelseif isdefined("form.btncambiar")>
	<cfquery name="rsUpdate" datasource="#session.DSN#">
		Update AFAdquisicion
		set AFMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFMid#">, 
			AFMMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFMMid#">, 
			AFAdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.AFAdescripcion#">, 
			AFAplaca = <cfqueryparam cfsqltype="cf_sql_char" value="#UCase(form.AFAplaca)#">, 
			Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">, 
			Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and AFAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFAid#">
			and AFAstatus = 10
	</cfquery>
</cfif>
<cflocation url="vales_aprobacion.cfm#params#">
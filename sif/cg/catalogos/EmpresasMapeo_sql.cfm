<cfset LvarEcodigo = session.navegacion.default.Ecodigo2>

<cfif isdefined("form.ALTA")>
	<cfquery datasource="#session.DSN#">
		insert into CGIC_Empresa 
		(	CGICMid, 
			Ecodigo, 
			CGICinfo1
			<cfif isdefined("form.CGICinfo2")>
				, CGICinfo2
			</cfif> 
			<cfif isdefined("form.CGICinfo3")>
				, CGICinfo3 
			</cfif> 
			<cfif isdefined("form.CGICinfo4")>
				, CGICinfo4 
			</cfif> 
			<cfif isdefined("form.CGICinfo5")>
				, CGICinfo5 
			</cfif> 
			<cfif isdefined("form.CGICinfo6")>
				, CGICinfo6
			</cfif> 
			<cfif isdefined("form.CGICinfo7")>
				, CGICinfo7 
			</cfif> 
			<cfif isdefined("form.CGICinfo8")>
				, CGICinfo8 
			</cfif> 
			<cfif isdefined("form.CGICinfo9")>
				, CGICinfo9
			</cfif> 
			, MonedaConvertida
			
		)
		values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CGICMid#">, 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#LvarEcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CGICINFO1#">
				<cfif isdefined("form.CGICINFO2")>
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CGICINFO2#">
				</cfif> 
				<cfif isdefined("form.CGICINFO3")>
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CGICINFO3#">
				</cfif> 
				<cfif isdefined("form.CGICINFO4")>
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CGICINFO4#">
				</cfif> 
				<cfif isdefined("form.CGICINFO5")>
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CGICINFO5#">
				</cfif> 
				<cfif isdefined("form.CGICINFO6")>
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CGICINFO6#"> 
				</cfif> 
				<cfif isdefined("form.CGICINFO7")>
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CGICINFO7#">
				</cfif> 
				<cfif isdefined("form.CGICINFO8")>
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CGICINFO8#"> 
				</cfif> 
				<cfif isdefined("form.CGICINFO9")>
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CGICINFO9#">
				</cfif> 
				<cfif isdefined("form.MonedaConvertida")>
					, 1
				<cfelse>
					, 0
				</cfif>
			)
	</cfquery>
<cfelseif isdefined("form.CAMBIO")>	
	<cfquery datasource="#session.DSN#">
		update CGIC_Empresa set 
			CGICinfo1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CGICinfo1#">
			<cfif isdefined("form.CGICINFO2")>
				, CGICinfo2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CGICinfo2#">
			</cfif>
			<cfif isdefined("form.CGICinfo3")>
				, CGICinfo3 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CGICinfo3#">
			</cfif>
			<cfif isdefined("form.CGICinfo4")>
				, CGICinfo4 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CGICinfo4#">
			</cfif>
			<cfif isdefined("form.CGICinfo5")>
				, CGICinfo5 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CGICinfo5#">
			</cfif>
			<cfif isdefined("form.CGICinfo6")>
				, CGICinfo6 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CGICinfo6#">
			</cfif>
			<cfif isdefined("form.CGICinfo7")>
				, CGICinfo7 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CGICinfo7#">
			</cfif>
			<cfif isdefined("form.CGICinfo8")>
				, CGICinfo8 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CGICinfo8#">
			</cfif>
			<cfif isdefined("form.CGICinfo9")>
				, CGICinfo9 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CGICinfo9#">
			</cfif>
			<cfif isdefined("form.MonedaConvertida")>
				, MonedaConvertida = 1
			<cfelse>
				, MonedaConvertida = 0
			</cfif>
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarEcodigo#">
		and CGICMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CGICMid#">
	</cfquery>
	
<cfelseif isdefined("form.BAJA")>	
	<cfquery datasource="#session.DSN#">
		delete from CGIC_Empresa
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarEcodigo#">
		and CGICMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CGICMid#">
	</cfquery>
</cfif>

<cfif isdefined("LvarInfo")>
	<cfset LvarAction   = 'EmpresasMapeoInf.cfm'>
<cfelse>
	<cfset LvarAction   = 'EmpresasMapeo.cfm'>
</cfif>

<cflocation url="#LvarAction#?CGICMid=#form.CGICMid#&Ecodigo=#LvarEcodigo#" addtoken="yes">

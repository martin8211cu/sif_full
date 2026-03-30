<cfif IsDefined("form.Cambio")>
		<cf_dbtimestamp datasource="#session.dsn#"
				table="RHGrupoMateriaCF"
				redirect="programas-cf.cfm?CFpk=<cfoutput>#form.CFpk#</cfoutput>"
				timestamp="#form.ts_rversion#"
				field1="CFid"
				type1="numeric"
				value1="#form.CFpk#"
				field2="RHGMid"
				type2="numeric"
				value2="#form._RHGMid#"
		>
	
	<cfquery datasource="#session.dsn#">
		update RHGrupoMateriaCF
		set RHGMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHGMid#">
		where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFpk#" null="#Len(form.CFpk) Is 0#">
		  and RHGMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form._RHGMid#" null="#Len(form._RHGMid) Is 0#">
	</cfquery>
	<cflocation url="programas-cf.cfm?CFpk=#form.CFpk#&RHGMid=#URLEncodedFormat(form.RHGMid)#">
	<!----<cflocation url="RHGrupoMateriaCF.cfm?CFpk=#URLEncodedFormat(form.CFpk)#&RHGMid=#URLEncodedFormat(form.RHGMid)#">---->

<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="#session.dsn#">
		delete from RHGrupoMateriaCF
		where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFpk#" null="#Len(form.CFpk) Is 0#">  
		  and RHGMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form._RHGMid#" null="#Len(form._RHGMid) Is 0#">
	</cfquery>
<cfelseif IsDefined("form.Nuevo")>
<cfelseif IsDefined("form.Alta")>
	<cfquery datasource="#session.dsn#">
		insert into RHGrupoMateriaCF (CFid,RHGMid,Ecodigo,BMfecha,BMUsucodigo)
		values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFpk#" null="#Len(form.CFpk) Is 0#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHGMid#" null="#Len(form.RHGMid) Is 0#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,			
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
	</cfquery>
<cfelse>
	<!--- Tratar como form.nuevo --->
</cfif>
<cflocation url="programas-cf.cfm?CFpk=#form.CFpk#">

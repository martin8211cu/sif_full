<cfparam name="form.ant" default="">
<cfparam name="form.val" default="">
<cfloop list="#form.val#" index="item">

	<cfif (StructKeyExists(form, 'ck' & item)) AND (NOT ListFind(form.ant, item))>
		<cfquery datasource="#session.dsn#">
			update RHOfertaAcademica
			set RHOAactivar = 1
			where RHIAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ListFirst(item,'x')#">
			  and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ListRest (item,'x')#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
	<cfelseif (NOT StructKeyExists(form, 'ck' & item)) AND (ListFind(form.ant, item))>
		<cfquery datasource="#session.dsn#">
			update RHOfertaAcademica
			set RHOAactivar = 0
			where RHIAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ListFirst(item,'x')#">
			  and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ListRest (item,'x')#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
	</cfif>
</cfloop>
<cflocation url=".?RHIAid=#form.RHIAid#&RHACid=#form.RHACid#&RHGMid=#form.RHGMid#&Mnombre=#URLEncodedFormat(form.Mnombre)#">
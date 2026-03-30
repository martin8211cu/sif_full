<cfif Not IsDefined("form.logintext") OR Len(form.logintext) EQ 0>
	<cflocation url="signup2.cfm?error=1">
<cfelse>
	<cfquery datasource="sdc" name="repetidos">
		select Usulogin
		from Usuario
		where Usulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.logintext#">
		  and (Usucodigo != <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			or Ulocalizacion != <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Ulocalizacion#">) 
	</cfquery>
	<cfif repetidos.RecordCount GT 0>
		<cflocation url="signup2.cfm?error=2">
	<cfelse>
		<cflocation url="signup3.cfm?logintext=#URLEncodedFormat( form.logintext )#">
	</cfif>
</cfif>


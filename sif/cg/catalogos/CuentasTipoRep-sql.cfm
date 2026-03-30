<cfif IsDefined("form.Alta")>

	<cfquery name="insCtaTipoRep" datasource="#Session.DSN#">
		insert into CGAreasTipoRepCtas (CGARepid, CGARCtaMayor, CGARctaTipo, CGARctaGrupo, CGARctaBalance)
		values (
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CGARepid#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Form.Ctipo#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Csubtipo1#">,
			<!--- <cfif Form.Ctipo EQ 'I'>
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Csubtipo1#">,
			<cfelseif Form.Ctipo EQ 'G'>
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Csubtipo2#">,
			<cfelse>
				null,
			</cfif> --->
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.CGARctaBalance#">
		)
	</cfquery>

<cfelseif IsDefined("form.Cambio")>

	<cfquery name="insCtaTipoRep" datasource="#Session.DSN#">
		Update CGAreasTipoRepCtas 
		set CGARctaTipo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Ctipo#">, 			
			CGARctaGrupo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Csubtipo1#">,
			<!--- 
			<cfif Form.Ctipo EQ 'I'>
				CGARctaGrupo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Csubtipo1#">,
			<cfelseif Form.Ctipo EQ 'G'>
				CGARctaGrupo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Csubtipo2#">,
			<cfelse>
				CGARctaGrupo =  null,
			</cfif> --->
			CGARctaBalance = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.CGARctaBalance#">
		Where CGARepid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CGARepid#">
		  and CGARCtaMayor = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#">		
	</cfquery>

<cfelseif IsDefined("form.Baja")>

	<cfquery name="insCtaTipoRep" datasource="#Session.DSN#">
	Delete from CGAreasTipoRepCtas 
	Where CGARepid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CGARepid#">
	  and CGARCtaMayor = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#">	
	</cfquery>

</cfif>

<cfset params= "">
<cfif isdefined("Form.PageNum_lista") and Len(Trim(Form.PageNum_lista))>
	<cfset params = params & Iif (Len(Trim(params)), DE("&"), DE("?")) & "PageNum_lista=" & Form.PageNum_lista>
<cfelseif isdefined("Form.PageNum") and Len(Trim(Form.PageNum))>
	<cfset params = params & Iif (Len(Trim(params)), DE("&"), DE("?")) & "PageNum_lista=" & Form.PageNum>
</cfif>

<cfif isdefined("Form.fCGARcodigo") and Len(Trim(Form.fCGARcodigo))>
	<cfset params = params & Iif (Len(Trim(params)), DE("&"), DE("?")) & "fCGARcodigo=" & Form.fCGARcodigo>
</cfif>
<cfif isdefined("Form.fCGARdescripcion") and Len(Trim(Form.fCGARdescripcion))>
	<cfset params = params & Iif (Len(Trim(params)), DE("&"), DE("?")) & "fCGARdescripcion=" & Form.fCGARdescripcion>
</cfif>
<cfif isdefined("Form.fCGARresponsable") and Len(Trim(Form.fCGARresponsable))>
	<cfset params = params & Iif (Len(Trim(params)), DE("&"), DE("?")) & "fCGARresponsable=" & Form.fCGARresponsable>
</cfif>

<cfif isdefined("Form.fCGARepid") and Len(Trim(Form.fCGARepid))>
	<cfset params = params & Iif (Len(Trim(params)), DE("&"), DE("?")) & "fCGARepid=" & Form.fCGARepid>
</cfif>

<cfset params = params & Iif (Len(Trim(params)), DE("&"), DE("?")) & "tab=1">
<cflocation url="CuentasTipoRep_Option.cfm#params#">


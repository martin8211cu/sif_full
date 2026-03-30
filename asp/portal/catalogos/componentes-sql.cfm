<cfinclude template="fnUriNotExists.cfm">
<cftry>
	<cfset LvarUri = fnUriNotExists(form.SCuri, form.SCtipo)>
	<cfif LvarUri.NotExists EQ 1><cfset form.SCuri = LvarUri.Uri></cfif>
	<cfif isdefined("form.Guardar")>
		<cfif LvarUri.NotExists EQ 2>
			<cfif form.SCtipo EQ 'P'>
				<cfthrow message="No existe la Pagina: #form.SCuri#">
			<cfelse>
				<cfthrow message="No existe el Directorio: #form.SCuri#">
			</cfif>
		</cfif>
		<cfquery name="rs" datasource="asp">
			update SComponentes
			set SCuri = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SCuri#">,
				SCtipo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SCtipo#">,
				BMfecha = <cfqueryparam  cfsqltype="cf_sql_timestamp" value="#Now()#">,
				BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			where SCuri = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.f_SCuri#"> 
			  and SPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.SPcodigo)#">
			  and SMcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.SMcodigo)#">
			  and SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.SScodigo)#">
		</cfquery>
	<cfelseif isdefined("form.Eliminar")>
		<cfquery name="rs" datasource="asp">
			delete from SComponentes
			where SCuri = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SCuri#"> 
			  and SPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.SPcodigo)#">
			  and SMcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.SMcodigo)#">
			  and SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.SScodigo)#">
		</cfquery>
	<cfelseif isdefined("form.Home")>
		<cfif LvarUri.NotExists EQ 2>
			<cfif form.SCtipo EQ 'P'>
				<cfthrow message="No existe la Pagina: #form.SCuri#">
			<cfelse>
				<cfthrow message="No existe el Directorio: #form.SCuri#">
			</cfif>
		</cfif>
		<cfquery name="rs" datasource="asp">
			update SProcesos
			set SPhomeuri = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SCuri#">,
			    BMfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
				BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			where SPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.SPcodigo)#">
			  and SMcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.SMcodigo)#">
			  and SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.SScodigo)#">
		</cfquery>
	<cfelseif isdefined("form.Agregar")>
		<cfif LvarUri.NotExists EQ 2>
			<cfif form.SCtipo EQ 'P'>
				<cfthrow message="No existe la Pagina: #form.SCuri#">
			<cfelse>
				<cfthrow message="No existe el Directorio: #form.SCuri#">
			</cfif>
		</cfif>
		<cfquery name="rs" datasource="asp">
			insert into SComponentes ( SScodigo, SMcodigo, SPcodigo, SCuri, SCtipo, BMfecha, BMUsucodigo )
			values ( <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.SScodigo)#">,
					 <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.SMcodigo)#">,
					 <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.SPcodigo)#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SCuri#">,
					 <cfqueryparam cfsqltype="cf_sql_char" value="#form.SCtipo#">,
					 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				   )
		</cfquery>
	</cfif>
	<cfcatch type="database">
		<!--- <cflocation url="componentes.cfm">	 --->
	</cfcatch>
</cftry>


<cfparam name="form.fSScodigo" default="">
<cfparam name="form.fSMcodigo" default="">
<cfparam name="form.SScodigo" default="">
<cfparam name="form.SMcodigo" default="">
<cfparam name="form.SPcodigo" default="">
<cflocation url="componentes.cfm?fSScodigo=#form.fSScodigo#&fSMcodigo=#form.fSMcodigo#&SScodigo=#form.SScodigo#&SMcodigo=#form.SMcodigo#&SPcodigo=#form.SPcodigo#" addtoken="no">
<!---
<cfoutput>
<form action="componentes.cfm" method="post" name="sql">
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">
<cfif isdefined("form.fSScodigo")>
	<input type="hidden" name="fSScodigo" value="#Form.fSScodigo#">
</cfif>
<cfif isdefined("form.fSMcodigo")>
	<input type="hidden" name="fSMcodigo" value="#form.fSMcodigo#">
</cfif>
<cfif isdefined("form.SScodigo")>
	<input type="hidden" name="SScodigo" value="#Form.SScodigo#">
</cfif>
<cfif isdefined("form.SMcodigo")>
	<input type="hidden" name="SMcodigo" value="#form.SMcodigo#">
</cfif>
<cfif isdefined("Form.SPcodigo")>
	<input type="hidden" name="SPcodigo" value="#form.SPcodigo#">
</cfif>
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>--->
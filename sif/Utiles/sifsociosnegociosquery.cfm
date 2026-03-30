	<cfparam name="url.form" default="form1">
	<cfparam name="url.desc" default="SNnombre">
	<cfparam name="url.identificacion" default="SNidentificacion">
	<cfparam name="url.id" default="SNcodigo">
	<cfparam name="url.FuncJSalCerrar" default="">
		
	<cfif isdefined("url.SNidentificacion") and url.SNidentificacion NEQ "">
		<cfquery name="rs" datasource="#Session.DSN#">			
			select * from SNegocios 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
			  and rtrim(ltrim(upper(SNidentificacion))) = <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(Trim(url.SNidentificacion))#">								
		</cfquery>

		<script language="JavaScript">
			parent.<cfoutput>#url.form#.#url.id#</cfoutput>.value="<cfoutput>#rs.SNcodigo#</cfoutput>";
			parent.<cfoutput>#url.form#.#url.identificacion#</cfoutput>.value="<cfoutput>#rs.SNidentificacion#</cfoutput>";
			parent.<cfoutput>#url.form#.#url.desc#</cfoutput>.value="<cfoutput>#rs.SNnombre#</cfoutput>";
			
			<cfif isdefined("url.FuncJSalCerrar") and Len(Trim(url.FuncJSalCerrar)) GT 0>parent.<cfoutput>#url.FuncJSalCerrar#</cfoutput> </cfif>
		</script>

	</cfif>
<!--- Recibe conexion, form, name, desc, ecodigo y dato --->
<cfif isdefined("url.form") and not isdefined("form.form")>
	<cfset form.form= url.form >
<cfelse>
	<cfset form.form= 'form1'>
</cfif>

<cfif isdefined("url.id") and not isdefined("form.id")>
	<cfset form.id= url.id >
<cfelse>
	<cfset form.name= 'CFid' >
</cfif>
<cfif isdefined("url.name") and not isdefined("form.name")>
	<cfset form.name= url.name >
<cfelse>
	<cfset form.name= 'CFcodigo' >
</cfif>
<cfif isdefined("url.desc") and not isdefined("form.desc")>
	<cfset form.desc= url.desc >
<cfelse>
	<cfset form.desc= 'CFdescripcion' >
</cfif>
<cfparam name="url.Ecodigo" default="#session.Ecodigo#">

<cfif isdefined("url.dato") and url.dato NEQ "">
		<cfquery name="rs" datasource="#session.DSN#">
			select CFid, CFcodigo, CFdescripcion 
			from CFuncional
			where CFcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#Trim(url.dato)#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Ecodigo#">
		</cfquery>	
	<cfif rs.recordCount gt 0>
		<script language="JavaScript">
			window.parent.document.<cfoutput>#form.form#</cfoutput>.<cfoutput>#form.id#</cfoutput>.value="<cfoutput>#rs.CFid#</cfoutput>";
			window.parent.document.<cfoutput>#form.form#</cfoutput>.<cfoutput>#form.name#</cfoutput>.value="<cfoutput>#trim(rs.CFcodigo)#</cfoutput>";
			window.parent.document.<cfoutput>#form.form#</cfoutput>.<cfoutput>#form.desc#</cfoutput>.value="<cfoutput>#trim(rs.CFdescripcion)#</cfoutput>";
			if (window.parent.tipos) window.parent.tipos("<cfoutput>#rs.CFid#</cfoutput>");
		</script>
	<cfelse>
		<script language="JavaScript">
			window.parent.document.<cfoutput>#form.form#</cfoutput>.<cfoutput>#form.id#</cfoutput>.value="";
			window.parent.document.<cfoutput>#form.form#</cfoutput>.<cfoutput>#form.name#</cfoutput>.value="";
			window.parent.document.<cfoutput>#form.form#</cfoutput>.<cfoutput>#form.desc#</cfoutput>.value="";
			if (window.parent.document.<cfoutput>#form.form#</cfoutput>.CMTScodigo) window.parent.document.<cfoutput>#form.form#</cfoutput>.CMTScodigo.length = 0;
			if (window.parent.document.<cfoutput>#form.form#</cfoutput>.CMElinea) window.parent.document.<cfoutput>#form.form#</cfoutput>.CMElinea.length = 0;
		</script>
	</cfif>
</cfif>



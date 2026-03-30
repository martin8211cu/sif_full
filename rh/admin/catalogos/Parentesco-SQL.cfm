<cfset modo = "ALTA">
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
			<cfquery name="rsNextPid" datasource="#form.Ccache#">
				select coalesce(max(Pid),0)+1 as Pid from RHParentesco 
			</cfquery>
			<cfquery name="Parentesco" datasource="#form.Ccache#">
				insert into RHParentesco (Pid,Pdescripcion)
				values 	(<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsNextPid.Pid#">,rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pdescripcion#">)))
			</cfquery>
			<cfset modo="ALTA">
		<cfelseif isdefined("Form.Baja")>
			<cfquery name="Parentesco" datasource="#form.Ccache#">
				delete from RHParentesco
				where Pid  = <cfqueryparam value="#Form.Pid#" cfsqltype="cf_sql_varchar">
			</cfquery>  
			<cfset modo="BAJA">
		<cfelseif isdefined("Form.Cambio")>
			<cfquery name="Parentesco" datasource="#form.Ccache#">
				update RHParentesco set 
					Pdescripcion = rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pdescripcion#">))
				where Pid = <cfqueryparam value="#Form.Pid#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cfset modo="CAMBIO">
		</cfif>
</cfif>
<form action="Parentesco.cfm<cfif isdefined('url.desde') and Trim(url.desde) eq 'rh'>?desde=rh</cfif>" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<cfif isdefined("Form.Pid") and modo neq "BAJA" and not isdefined("Form.Nuevo")>
		<input name="Pid" type="hidden" value="<cfoutput>#Form.Pid#</cfoutput>">
	</cfif>
    <input type="hidden" name="Pagina" value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ ""><cfoutput>#Pagenum_lista#</cfoutput><cfelseif isdefined("Form.PageNum")><cfoutput>#PageNum#</cfoutput></cfif>">		
	<input type="hidden" name="desde" value="<cfif isdefined("form.desde")><cfoutput>#form.desde#</cfoutput></cfif>">		
	<input name="Ccache" type="hidden" value="<cfif isdefined("Form.Ccache")><cfoutput>#Form.Ccache#</cfoutput></cfif>">
</form>

<html>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</html>


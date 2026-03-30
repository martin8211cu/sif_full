	<cfparam name="url.form" default="form1">
	<cfparam name="url.desc" default="Cdescripcion">
	<cfparam name="url.fmt" default="Cformato">
	<cfparam name="url.id" default="Ccuenta">
<cftry>
	<cfif isdefined("url.Cformato") and url.Cformato NEQ "">
		<cfquery name="rsSIFCuentas" datasource="#Session.DSN#">
			select 
				convert(varchar,Ccuenta) as Ccuenta, 
				Ecodigo, 
				Cmayor, 
				Cformato, 
				Mcodigo, 
				convert(varchar,SCid) as SCid, 
				Cdescripcion, 
				Cmovimiento, 
				convert(varchar,Cpadre) as Cpadre, 
				Cbalancen, 
				ts_rversion 
			from CContables
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and Cformato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.Cformato#">
		</cfquery>
		<script language="JavaScript">
		alert(#rsSIFCuentas.Cmovimiento#);
			<cfif Trim(rsSIFCuentas.Cmovimiento) EQ "S">
				parent.<cfoutput>#url.form#.#url.id#</cfoutput>.value="<cfoutput>#rsSIFCuentas.Ccuenta#</cfoutput>";
			<cfelse>
				parent.<cfoutput>#url.form#.#url.id#</cfoutput>.value="";
			</cfif>
			parent.<cfoutput>#url.form#.#url.desc#</cfoutput>.value="<cfoutput>#rsSIFCuentas.Cdescripcion#</cfoutput>";
		</script>
	</cfif>
<cfcatch type="any">
		<script language="JavaScript">
			alert("#cfcatch.Message#");
		</script>
</cfcatch>
</cftry>	

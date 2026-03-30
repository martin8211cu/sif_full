<cfparam name="url.name"  default="RHHid">

<cfquery name="rsHabilidad" datasource="#Session.DSN#">
	select RHHid, RHHcodigo, RHHdescripcion, PCid, RHHubicacionB
	from RHHabilidades
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	and upper(RHHcodigo) = <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(Trim(url.codigo))#">
</cfquery>
<script language="JavaScript" type="text/javascript">
	parent.ctlid.value = "<cfoutput>#rsHabilidad.RHHid#</cfoutput>";
	parent.ctlcod.value = "<cfoutput>#rsHabilidad.RHHcodigo#</cfoutput>";
	parent.ctldesc.value = "<cfoutput>#rsHabilidad.RHHdescripcion#</cfoutput>";
	parent.ctlpcid.value = "<cfoutput>#rsHabilidad.PCid#</cfoutput>";
	parent.ctlrhubic.value = "<cfoutput>#rsHabilidad.RHHubicacionB#</cfoutput>";		
	
	if (parent.func<cfoutput>#trim(Url.name)#</cfoutput>) {
		parent.func<cfoutput>#trim(Url.name)#</cfoutput>();
	}	
</script>
<cfif isdefined("url.NTIcodigo") and Len(Trim(url.NTIcodigo)) NEQ 0 and url.NTIcodigo NEQ "-1" and isdefined("url.RHOidentificacion") and Len(Trim(url.RHOidentificacion)) NEQ 0>
	<cfquery name="rsoferente" datasource="#session.DSN#">
		select a.RHOid, a.RHOidentificacion, <cf_dbfunction name="concat" args="a.RHOnombre,' ',a.RHOapellido1,'  ',a.RHOapellido2"> as NombreCompleto
		from DatosOferentes a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		and a.RHOidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(url.RHOidentificacion)#">
		and a.NTIcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Trim(url.NTIcodigo)#">
		and coalesce(a.RHAprobado,0) = 1
	</cfquery>
	<script language="JavaScript" type="text/javascript">
		parent.ctlid.value = "<cfoutput>#rsoferente.RHOid#</cfoutput>";
		parent.ctlident.value = "<cfoutput>#rsoferente.RHOidentificacion#</cfoutput>";
		parent.ctlemp.value = "<cfoutput>#rsoferente.NombreCompleto#</cfoutput>";
		
		if (window.parent.funcRHOid){ window.parent.funcRHOid(); }
		
	</script>
<cfelseif isdefined("url.NTIcodigo") and (Len(Trim(url.NTIcodigo)) NEQ 0) and (url.NTIcodigo EQ "-1") and isdefined("url.RHOidentificacion") and (Len(Trim(url.RHOidentificacion)) NEQ 0)>
	<!--- Para cuando no se necesita el tipo de identificacion (NTIcodigo= "-1") --->
	<cfquery name="rsoferente" datasource="#Session.DSN#">
		select a.RHOid, a.RHOidentificacion, <cf_dbfunction name="concat" args="a.RHOnombre,' ',a.RHOapellido1,'  ',a.RHOapellido2"> as NombreCompleto
		from DatosOferentes a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		and a.RHOidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(url.RHOidentificacion)#">
		and coalesce(a.RHAprobado,0) = 1
	</cfquery>
	<script language="JavaScript" type="text/javascript">
		parent.ctlid.value = "<cfoutput>#rsoferente.RHOid#</cfoutput>";
		parent.ctlident.value = "<cfoutput>#rsoferente.RHOidentificacion#</cfoutput>";
		parent.ctlemp.value = "<cfoutput>#rsoferente.NombreCompleto#</cfoutput>";
		
		if (window.parent.funcRHOid){ window.parent.funcRHOid(); }
	</script>
</cfif>

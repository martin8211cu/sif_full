<cfif isdefined("url.NTIcodigo") and Len(Trim(url.NTIcodigo)) NEQ 0 and url.NTIcodigo NEQ "-1" and isdefined("url.DEidentificacion") and Len(Trim(url.DEidentificacion)) NEQ 0>
	<cfquery name="rsEmpleado" datasource="#Session.DSN#">
		select a.DEid, a.DEidentificacion, 
			{fn concat(a.DEnombre,{fn concat(' ',{fn concat(a.DEapellido1,{fn concat(' ',a.DEapellido2)})})})} as NombreCompleto
		from DatosEmpleado a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		and a.DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(url.DEidentificacion)#">
		and a.NTIcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Trim(url.NTIcodigo)#">
		
		<cfif isdefined("url.filtro") and len(trim(url.filtro))>
			and a.DEid in ( select DEid from RHListaEvalDes where Ecodigo = #session.Ecodigo# and RHEEid = #url.filtro# )
		</cfif>
	</cfquery>
	<script language="JavaScript" type="text/javascript">
		parent.ctlid.value = "<cfoutput>#rsEmpleado.DEid#</cfoutput>";
		parent.ctlident.value = "<cfoutput>#rsEmpleado.DEidentificacion#</cfoutput>";
		parent.ctlemp.value = "<cfoutput>#rsEmpleado.NombreCompleto#</cfoutput>";
		
		if (window.parent.funcDEid){ window.parent.funcDEid(); }
		
	</script>
<cfelseif isdefined("url.NTIcodigo") and (Len(Trim(url.NTIcodigo)) NEQ 0) and (url.NTIcodigo EQ "-1") and isdefined("url.DEidentificacion") and (Len(Trim(url.DEidentificacion)) NEQ 0)>
	<!--- Para cuando no se necesita el tipo de identificacion (NTIcodigo= "-1") --->
	<cfquery name="rsEmpleado" datasource="#Session.DSN#">
		select a.DEid, a.DEidentificacion, a.DEnombre + ' ' + a.DEapellido1 + ' ' + a.DEapellido2 as NombreCompleto
		from DatosEmpleado a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		and a.DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(url.DEidentificacion)#">
		<cfif isdefined("url.filtro") and len(trim(url.filtro))>
			and a.DEid in ( select DEid from RHListaEvalDes where Ecodigo = #session.Ecodigo# and RHEEid = #url.filtro# )
		</cfif>

	</cfquery>
	<script language="JavaScript" type="text/javascript">
		parent.ctlid.value = "<cfoutput>#rsEmpleado.DEid#</cfoutput>";
		parent.ctlident.value = "<cfoutput>#rsEmpleado.DEidentificacion#</cfoutput>";
		parent.ctlemp.value = "<cfoutput>#rsEmpleado.NombreCompleto#</cfoutput>";
		
		if (window.parent.funcDEid){ window.parent.funcDEid(); }
	</script>
</cfif>

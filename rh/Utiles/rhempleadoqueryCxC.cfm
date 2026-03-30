<!--- 
	Modificado por: Ana Villavicencio
	Fecha: 10 de octubre dle 2005
	Motivo: eliminar dos lineas de codigo innecesarias q producían error porqueno existía en la ventana de la llamada.
	Líneas: 23, 43
 --->

<cfif isdefined("url.NTIcodigo") and Len(Trim(url.NTIcodigo)) NEQ 0 and url.NTIcodigo NEQ "-1" and isdefined("url.DEidentificacion") and Len(Trim(url.DEidentificacion)) NEQ 0>
	<cfquery name="rsEmpleado" datasource="#Session.DSN#">
		select a.DEid, a.DEidentificacion, <cf_dbfunction name="concat" args="a.DEnombre,' ',a.DEapellido1,' ', a.DEapellido2" > as NombreCompleto,b.RESNtipoRol
		from DatosEmpleado a, RolEmpleadoSNegocios b
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		  and a.Ecodigo = b.Ecodigo
		  and a.DEid = b.DEid
		  and a.DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(url.DEidentificacion)#">
		  and a.NTIcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Trim(url.NTIcodigo)#">
		  and b.RESNtipoRol = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#url.rol#">
	</cfquery>
	<script language="JavaScript" type="text/javascript">
		parent.ctlid.value = "<cfoutput>#rsEmpleado.DEid#</cfoutput>";
		parent.ctlident.value = "<cfoutput>#rsEmpleado.DEidentificacion#</cfoutput>";
		parent.ctlemp.value = "<cfoutput>#rsEmpleado.NombreCompleto#</cfoutput>";
		//parent.ctlrol.value = "<cfoutput>#rsEmpleado.RESNtipoRol#</cfoutput>";
		
		if (window.parent.funcDEid){ window.parent.funcDEid(); }
		
	</script>
<cfelseif isdefined("url.NTIcodigo") and (Len(Trim(url.NTIcodigo)) NEQ 0) and (url.NTIcodigo EQ "-1") and isdefined("url.DEidentificacion") and (Len(Trim(url.DEidentificacion)) NEQ 0)>
	<!--- Para cuando no se necesita el tipo de identificacion (NTIcodigo= "-1") --->
	<cfquery name="rsEmpleado" datasource="#Session.DSN#">
		select a.DEid, a.DEidentificacion, <cf_dbfunction name="concat" args="a.DEnombre,' ',a.DEapellido1,' ', a.DEapellido2" > as NombreCompleto,b.RESNtipoRol
		from DatosEmpleado a, RolEmpleadoSNegocios b
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		  and a.Ecodigo = b.Ecodigo
		  and a.DEid = b.DEid
		  and a.DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(url.DEidentificacion)#">
		  and b.RESNtipoRol = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#url.rol#">
	</cfquery>
	<script language="JavaScript" type="text/javascript">
		parent.ctlid.value = "<cfoutput>#rsEmpleado.DEid#</cfoutput>";
		parent.ctlident.value = "<cfoutput>#rsEmpleado.DEidentificacion#</cfoutput>";
		parent.ctlemp.value = "<cfoutput>#rsEmpleado.NombreCompleto#</cfoutput>";
		//parent.ctlrol.value = "<cfoutput>#rsEmpleado.RESNtipoRol#</cfoutput>";
		if (window.parent.funcDEid){ window.parent.funcDEid(); }
	</script>
</cfif>

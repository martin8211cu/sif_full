<cfif isdefined("form.cue") and len(trim(form.cue))>
	<cfset form.CTid = form.cue>
</cfif>

<cfif IsDefined("form.Aprobar")>
	<cfquery datasource="#Session.DSN#" name="rsProducto">
		select * 
		from  ISBproducto
		where CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTid#"> 
	</cfquery>
	
	<cfloop query="rsProducto">
		<cfinvoke component="saci.comp.ISBproducto" method="Cambio" >
			<cfinvokeargument name="Contratoid" value="#rsProducto.Contratoid#">
			<cfinvokeargument name="CTid" value="#rsProducto.CTid#">
			<cfinvokeargument name="CTidFactura" value="#rsProducto.CTidFactura#">
			<cfinvokeargument name="PQcodigo" value="#rsProducto.PQcodigo#">
			<cfinvokeargument name="Vid" value="#rsProducto.Vid#">
			<cfinvokeargument name="CTcondicion" value="1">
			<cfinvokeargument name="CNsuscriptor" value="#rsProducto.CNsuscriptor#">
			<cfinvokeargument name="CNnumero" value="#rsProducto.CNnumero#">
		</cfinvoke>
	</cfloop>
	<cflocation url="seguimiento_lista.cfm">
	
<cfelseif IsDefined("form.Des_Aprobar")>	
	<cfquery datasource="#Session.DSN#" name="rsProducto">
		select * 
		from  ISBproducto
		where CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTid#"> 
	</cfquery>	
	
	<cfloop query="rsProducto">	
		<cfinvoke component="saci.comp.ISBproducto"	method="Cambio" >
			<cfinvokeargument name="Contratoid" value="#rsProducto.Contratoid#">
			<cfinvokeargument name="CTid" value="#rsProducto.CTid#">
			<cfinvokeargument name="CTidFactura" value="#rsProducto.CTidFactura#">
			<cfinvokeargument name="PQcodigo" value="#rsProducto.PQcodigo#">
			<cfinvokeargument name="Vid" value="#rsProducto.Vid#">
			<cfinvokeargument name="CTcondicion" value="X">
			<cfinvokeargument name="CNsuscriptor" value="#rsProducto.CNsuscriptor#">
			<cfinvokeargument name="CNnumero" value="#rsProducto.CNnumero#">
		</cfinvoke>
	</cfloop>
	<cflocation url="seguimiento_lista.cfm">
	
<cfelseif IsDefined("form.Guardar")>	
	<cfinclude template="cuenta-seguimiento-apply.cfm">
<cfelseif IsDefined("form.quitar") and form.quitar NEQ '-1'>	
	<cfinvoke component="saci.comp.ISBproducto"	method="Ocultar" >
		<cfinvokeargument name="Contratoid" value="#form.quitar#">
		<cfinvokeargument name="CNconsultar" value="0">
	</cfinvoke>
</cfif>
<cfinclude template="seguimiento-redirect.cfm">
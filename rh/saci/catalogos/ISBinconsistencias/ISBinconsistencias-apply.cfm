<cfif IsDefined("form.Cambio")>	
	<cfinvoke component="saci.comp.ISBinconsistencias"
		method="Cambio" >
		<cfinvokeargument name="Iid" value="#form.Iid#">
		<cfinvokeargument name="Inombre" value="#form.Inombre#">
		<cfinvokeargument name="Idescripcion" value="#form.Idescripcion#">
		<cfinvokeargument name="Iseveridad" value="#form.Iseveridad#">
		<cfinvokeargument name="Ipenalizada" value="#IsDefined('form.Ipenalizada')#">
		<cfinvokeargument name="ts_rversion" value="#form.ts_rversion#">
	</cfinvoke>
<cfelseif IsDefined("form.Baja")>
	<cfinvoke component="saci.comp.ISBinconsistencias"
		method="Baja" >
		<cfinvokeargument name="Iid" value="#form.Iid#">
	</cfinvoke>
<cfelseif IsDefined("form.Nuevo")>
<cfelseif IsDefined("form.Alta")>	
	<cfinvoke component="saci.comp.ISBinconsistencias" returnvariable="newID"
		method="Alta"  >
		<cfinvokeargument name="Inombre" value="#form.Inombre#">
		<cfinvokeargument name="Idescripcion" value="#form.Idescripcion#">
		<cfinvokeargument name="Iseveridad" value="#form.Iseveridad#">
		<cfinvokeargument name="Ipenalizada" value="#IsDefined('form.Ipenalizada')#">
	</cfinvoke>
	<cfif isdefined('newID') and newID NEQ -1>
		<cfset form.Iid = newID>
	</cfif>	
<cfelse>
	<!--- Tratar como form.nuevo --->
</cfif>

<cfinclude template="ISBinconsistencias-redirect.cfm">




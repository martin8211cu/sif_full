<cfif IsDefined("form.Cambio")>	
	<cfinvoke component="saci.comp.ISBrsServidor"
		method="Cambio" >
		<cfinvokeargument name="nombreRS" value="#form.nombreRS#">
		<cfinvokeargument name="nombreASE" value="#form.nombreASE#">
		<cfinvokeargument name="nombreRSSD" value="#form.nombreRSSD#">
		<cfinvokeargument name="datasource" value="#form.datasource#">
		<cfinvokeargument name="activo" value="#IsDefined('form.activo')#">
		<cfinvokeargument name="EVfecha" value="#Now()#">
		<cfinvokeargument name="ts_rversion" value="#form.ts_rversion#">
	</cfinvoke>

	<cflocation url="ISBrsServidor.cfm?nombreRS=#URLEncodedFormat(form.nombreRS)#">

<cfelseif IsDefined("form.Baja")>
	<cfinvoke component="ISBrsServidor"
		method="Baja" >
		<cfinvokeargument name="nombreRS" value="#form.nombreRS#">
	</cfinvoke>
<cfelseif IsDefined("form.Nuevo")>
<cfelseif IsDefined("form.Alta")>	
	<cfinvoke component="saci.comp.ISBrsServidor"
		method="Alta"  >
		<cfinvokeargument name="nombreRS" value="#form.nombreRS#">
		<cfinvokeargument name="nombreASE" value="#form.nombreASE#">
		<cfinvokeargument name="nombreRSSD" value="#form.nombreRSSD#">
		<cfinvokeargument name="datasource" value="#form.datasource#">
		<cfinvokeargument name="activo" value="#IsDefined('form.activo')#">
		<cfinvokeargument name="EVfecha" value="#Now()#">
	</cfinvoke>
<cfelse>
	<!--- Tratar como form.nuevo --->
</cfif>

<cflocation url="ISBrsServidor.cfm">




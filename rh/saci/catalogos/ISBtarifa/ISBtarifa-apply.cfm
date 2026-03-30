<cfif IsDefined("form.Cambio")>	
	<cfinvoke component="saci.comp.ISBtarifa"
		method="Cambio">
		<cfinvokeargument name="TAtarifa" value="#form.TAtarifa#">
		<cfinvokeargument name="Miso4217" value="#form.Miso4217#">
		<cfinvokeargument name="TAnombreTarifa" value="#form.TAnombreTarifa#">
		<cfinvokeargument name="TAunidades" value="#form.TAunidades#">
		<cfinvokeargument name="ts_rversion" value="#form.ts_rversion#">
	</cfinvoke>

	<cflocation url="ISBtarifa-edit.cfm?TAtarifa=#URLEncodedFormat(form.TAtarifa)#">

<cfelseif IsDefined("form.Baja")>
	<cfinvoke component="saci.comp.ISBtarifa"
		method="Baja" >
		<cfinvokeargument name="TAtarifa" value="#form.TAtarifa#">
	</cfinvoke>
<cfelseif IsDefined("form.Nuevo")>
<cfelseif IsDefined("form.Alta")>	
	<cfinvoke component="saci.comp.ISBtarifa"
		method="Alta" returnvariable="TAtarifaNueva" >  >
		<cfinvokeargument name="Miso4217" value="#form.Miso4217#">
		<cfinvokeargument name="TAnombreTarifa" value="#form.TAnombreTarifa#">
		<cfinvokeargument name="TAunidades" value="#form.TAunidades#">
	</cfinvoke>
	<cflocation url="ISBtarifa-edit.cfm?TAtarifa=#URLEncodedFormat(TAtarifaNueva)#">
<cfelse>
	<!--- Tratar como form.nuevo --->
</cfif>

<cflocation url="ISBtarifa.cfm">




<cfif IsDefined("form.CambioHor")>	
	<cfinvoke component="saci.comp.ISBtarifaHorario"
		method="Cambio" >
		<cfinvokeargument name="TAtarifa" value="#form.TAtarifa#">
		<cfinvokeargument name="TAlinea" value="#form.TAlinea#">
		<cfinvokeargument name="TAdia" value="#form.TAdia#">
		<cfinvokeargument name="TAhoraDesde" value="#form.TAhoraDesde#">
		<cfinvokeargument name="TAhoraHasta" value="#form.TAhoraHasta#">
		<cfinvokeargument name="_TAdia" value="#form._TAdia#">
		<cfinvokeargument name="_TAhoraDesde" value="#form._TAhoraDesde#">
		<cfinvokeargument name="ts_rversion" value="#form.ts_rversion#">
	</cfinvoke>

	<cflocation url="ISBtarifa-edit.cfm?TAtarifa=#URLEncodedFormat(form.TAtarifa)#&TAlinea=#URLEncodedFormat(form.TAlinea)#">

<cfelseif IsDefined("form.BajaHor")>
	<cfinvoke component="saci.comp.ISBtarifaHorario"
		method="Baja" >
		<cfinvokeargument name="TAtarifa" value="#form.TAtarifa#">
		<cfinvokeargument name="TAlinea" value="#form.TAlinea#">
		<cfinvokeargument name="TAdia" value="#form.TAdia#">
		<cfinvokeargument name="TAhoraDesde" value="#form.TAhoraDesde#">
		<cfinvokeargument name="TAhoraHasta" value="#form.TAhoraHasta#">
	</cfinvoke>
<cfelseif IsDefined("form.NuevoHor")>
<cfelseif IsDefined("form.AltaHor")>	
	<cfinvoke component="saci.comp.ISBtarifaHorario"
		method="Alta"  >
		<cfinvokeargument name="TAtarifa" value="#form.TAtarifa#">
		<cfinvokeargument name="TAlinea" value="#form.TAlinea#">
		<cfinvokeargument name="TAdia" value="#form.TAdia#">
		<cfinvokeargument name="TAhoraDesde" value="#form.TAhoraDesde#">
		<cfinvokeargument name="TAhoraHasta" value="#form.TAhoraHasta#">
	</cfinvoke>
<cfelse>
	<!--- Tratar como form.nuevo --->
</cfif>

<cflocation url="ISBtarifa-edit.cfm?TAtarifa=#URLEncodedFormat(form.TAtarifa)#&TAlinea=#URLEncodedFormat(form.TAlinea)#">




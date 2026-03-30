<cfif IsDefined("form.CambioDet")>	
	<cfinvoke component="saci.comp.ISBtarifaDetalle"
		method="Cambio" >
		<cfinvokeargument name="TAtarifa" value="#form.TAtarifa#">
		<cfinvokeargument name="TAlinea" value="#form.TAlinea#">
		<cfinvokeargument name="TAlineaNombre" value="#form.TAlineaNombre#">
		<cfinvokeargument name="TAtarifaBasica" value="#form.TAtarifaBasica#">
		<cfinvokeargument name="TAprecioBase" value="#form.TAprecioBase#">
		<cfinvokeargument name="TAprecioExc" value="#form.TAprecioExc#">
		<cfinvokeargument name="TAredondeoMetodo" value="#form.TAredondeoMetodo#">
		<cfinvokeargument name="TAredondeoMultiplo" value="#form.TAredondeoMultiplo#">
		<cfinvokeargument name="ts_rversion" value="#form.ts_rversion#">
	</cfinvoke>

	<cflocation url="ISBtarifa-edit.cfm?TAtarifa=#URLEncodedFormat(form.TAtarifa)#&TAlinea=#URLEncodedFormat(form.TAlinea)#">

<cfelseif IsDefined("form.BajaDet")>
	<cfinvoke component="saci.comp.ISBtarifaDetalle"
		method="Baja" >
		<cfinvokeargument name="TAtarifa" value="#form.TAtarifa#">
		<cfinvokeargument name="TAlinea" value="#form.TAlinea#">
	</cfinvoke>
<cfelseif IsDefined("form.NuevoDet")>
<cfelseif IsDefined("form.AltaDet")>	

	<cfquery datasource="#session.dsn#" name="sig">
		select coalesce (max(TAlinea),0) +1 as TAlinea
		from ISBtarifaDetalle
		where TAtarifa = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TAtarifa#">
	</cfquery>

	<cfinvoke component="saci.comp.ISBtarifaDetalle"
		method="Alta"  >
		<cfinvokeargument name="TAtarifa" value="#form.TAtarifa#">
		<cfinvokeargument name="TAlinea" value="#sig.TAlinea#">
		<cfinvokeargument name="TAlineaNombre" value="#form.TAlineaNombre#">
		<cfinvokeargument name="TAlineaDefault" value="#IsDefined('form.TAlineaDefault')#">
		<cfinvokeargument name="TAtarifaBasica" value="#form.TAtarifaBasica#">
		<cfinvokeargument name="TAprecioBase" value="#form.TAprecioBase#">
		<cfinvokeargument name="TAprecioExc" value="#form.TAprecioExc#">
		<cfinvokeargument name="TAredondeoMetodo" value="#form.TAredondeoMetodo#">
		<cfinvokeargument name="TAredondeoMultiplo" value="#form.TAredondeoMultiplo#">
	</cfinvoke>
<cfelse>
	<!--- Tratar como form.nuevo --->
</cfif>

<cflocation url="ISBtarifa-edit.cfm?TAtarifa=#URLEncodedFormat(form.TAtarifa)#">




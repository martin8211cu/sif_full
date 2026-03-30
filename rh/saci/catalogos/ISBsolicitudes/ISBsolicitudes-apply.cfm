<cfif IsDefined("form.Cambio")>	
	<cfinvoke component="saci.comp.ISBsolicitudes"
		method="Cambio" >
		<cfinvokeargument name="SOid" value="#form.SOid#">
		<cfinvokeargument name="SOfechasol" value="#form.SOfechasol#">
		<cfinvokeargument name="SOtipo" value="#form.SOtipo#">
		<cfinvokeargument name="SOestado" value="#form.SOestado#">
		<cfinvokeargument name="SOtiposobre" value="#form.SOtiposobre#">
		<cfinvokeargument name="SOcantidad" value="#form.SOcantidad#">
		<cfinvokeargument name="SOgenero" value="#form.SOgenero#">
		<cfinvokeargument name="SOPrefijo" value="#form.SOPrefijo#">
		<cfinvokeargument name="SOobservaciones" value="#form.SOobservaciones#">
		<cfinvokeargument name="ts_rversion" value="#form.ts_rversion#">
	</cfinvoke> 
<cfelseif IsDefined("form.Baja")>
 	<cfinvoke component="saci.comp.ISBsolicitudes"
		method="Baja" >
		<cfinvokeargument name="SOid" value="#form.SOid#">
	</cfinvoke>
<cfelseif IsDefined("form.Nuevo")>
<cfelseif IsDefined("form.Enviar_Solicitud")>
	<cfinvoke component="saci.comp.ISBsolicitudes"
		method="marcaEnviado" >
		<cfinvokeargument name="SOid" value="#form.SOid#">
		<cfinvokeargument name="ts_rversion" value="#form.ts_rversion#">
	</cfinvoke> 
	<script language="javascript" type="text/javascript">
		alert('La solicitud fue enviada con éxito');
	</script>
<cfelseif IsDefined("form.Alta")>	
	<cfinvoke component="saci.comp.ISBsolicitudes"
		method="Alta" returnvariable="newSolic">
		<cfinvokeargument name="SOfechasol" value="#form.SOfechasol#">
		<cfinvokeargument name="SOtipo" value="#form.SOtipo#">
		<cfinvokeargument name="SOestado" value="#form.SOestado#">
		<cfinvokeargument name="SOtiposobre" value="#form.SOtiposobre#">
		<cfinvokeargument name="SOcantidad" value="#form.SOcantidad#">
		<cfinvokeargument name="SOgenero" value="#form.SOgenero#">
		<cfinvokeargument name="SOPrefijo" value="#form.SOPrefijo#">
		<cfinvokeargument name="SOobservaciones" value="#form.SOobservaciones#">
	</cfinvoke>
	
	<cfif isdefined('newSolic') and newSolic NEQ -1>
		<cfset form.SOid = newSolic>
	</cfif>
<cfelse>
	<!--- Tratar como form.nuevo --->
</cfif>

<cfinclude template="ISBsolicitudes-redirect.cfm">
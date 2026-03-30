<!----======================= Agregar una opcion  =======================---->

<cfif isdefined("form.submit") and (isdefined("session.parche.guid") and len(trim(session.parche.guid)))>
	<cfif len(trim(form.SMNcodigo)) EQ 0><cfset form.SMNcodigo=-1></cfif>
	<cfinvoke component="asp.parches.comp.parche" method="agregar_opciones"
	tipo="#form.SMNtipo#" SScodigo="#form.SScodigo#" SMcodigo="#form.SMcodigo#" SMNcodigo="#form.SMNcodigo#" detalle="#form.SMNdescripcion#" returnvariable="mensaje"/>	
<!----======================= Eliminar una opcion  =======================---->
<cfelseif isdefined("url.eliminar") and (isdefined("session.parche.guid") and len(trim(session.parche.guid)))>	
	<cfset mensaje = ''>
	<cfif len(trim(url.SMNcodigo)) EQ 0><cfset url.SMNcodigo=-1></cfif>
	<cfinvoke component="asp.parches.comp.parche" method="quitar_opciones"
	SScodigo="#url.SScodigo#" SMcodigo="#url.SMcodigo#" SMNcodigo="#url.SMNcodigo#"/>			
</cfif>

<cfset params = '?x=1'>
<cfif isdefined("form.SMNtipo") and len(trim(form.SMNtipo))><!---Tipo--->
	<cfset params = params & '&SMNtipo=#form.SMNtipo#'> 
</cfif>
<cfif isdefined("form.SScodigo") and len(trim(form.SScodigo))><!---Sistema--->
	<cfset params = params & '&SScodigo=#form.SScodigo#'> 
</cfif>
<cfif isdefined("form.SMcodigo") and len(trim(form.SMcodigo))><!---Modulo--->
	<cfset params = params & '&SMcodigo=#form.SMcodigo#'> 
</cfif>
<cfif isdefined("mensaje") and len(trim(mensaje))><!---Mensaje--->
	<cfset params = params & '&mensaje=#mensaje#'> 
</cfif>

<cflocation url="menubuscar-a.cfm#params#">

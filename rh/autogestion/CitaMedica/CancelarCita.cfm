<cfset ComponenteAgenda = CreateObject("Component", "home.Componentes.Agenda")>

<cfparam name="form.fecha">
<cfparam name="form.cita" type="numeric">
<cfparam name="form.e" default="1">

<cfif form.e>
	<cfset ComponenteAgenda.EliminarCita(ComponenteAgenda.MiAgenda(), form.cita)>
<cfelse>
	<cfset ComponenteAgenda.RestaurarCita(ComponenteAgenda.MiAgenda(), form.cita)>
	<cfset ComponenteAgenda.ConfirmarCita(ComponenteAgenda.MiAgenda(), form.cita, true)>
</cfif>

<cflocation url="MiAgenda.cfm?fecha=#URLEncodedFormat(form.fecha)#">
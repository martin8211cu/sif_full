<cfinvoke component="rh.Componentes.AgendaMedica" method="AgendaMedica" returnvariable="CodigoAgendaMedica">
	<cfinvokeargument name="create" value="yes">
</cfinvoke>
<cfset ComponenteAgenda = CreateObject("Component", "home.Componentes.Agenda")>

<cfparam name="form.propietario" default="0">
<cfparam name="form.lectura"     default="0">
<cfparam name="form.escritura"   default="0">
<cfparam name="form.citar"       default="0">
<cfif form.Usucodigo neq session.Usucodigo>
	<cfif form.propietario is 1>
		<cfset ComponenteAgenda.OtorgarPermiso(form.agenda, form.Usucodigo, 'propietario')>
		<cfelse>
		<cfset ComponenteAgenda.RevocarPermiso(form.agenda, form.Usucodigo, 'propietario')>
	</cfif>
</cfif>
<cfif form.lectura is 1>
	<cfset ComponenteAgenda.OtorgarPermiso(form.agenda, form.Usucodigo, 'lectura')>
	<cfelse>
	<cfset ComponenteAgenda.RevocarPermiso(form.agenda, form.Usucodigo, 'lectura')>
</cfif>
<cfif form.escritura is 1>
	<cfset ComponenteAgenda.OtorgarPermiso(form.agenda, form.Usucodigo, 'escritura')>
	<cfelse>
	<cfset ComponenteAgenda.RevocarPermiso(form.agenda, form.Usucodigo, 'escritura')>
</cfif>
<cfif form.citar is 1>
	<cfset ComponenteAgenda.OtorgarPermiso(form.agenda, form.Usucodigo, 'citar')>
<cfelse>
	<cfset ComponenteAgenda.RevocarPermiso(form.agenda, form.Usucodigo, 'citar')>
</cfif>
	
<cflocation url="Permisos.cfm?ag=#form.agenda#&modif=1">
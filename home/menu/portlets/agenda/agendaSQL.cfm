<cfparam name="form.fecha" default="#DateFormat(Now(), 'DD/MM/YYYY')#">

<cfif REFind('^[0-9]{2}/[0-9]{2}/[0-9]{4}$', form.fecha) is 0>
	<cfset form.fecha = DateFormat(Now(), 'DD/MM/YYYY')>
</cfif>

<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec" />

<cfset ComponenteAgenda = CreateObject("Component", "home.Componentes.Agenda")>
<cfset CodigoAgendaPersonal = ComponenteAgenda.AgendaDeUsuario(session.Usucodigo)>
<cfset infoAgenda = ComponenteAgenda.infoAgenda(CodigoAgendaPersonal)>
					
<!--- Crea la fecha desde y fecha hasta--->
<cfset LvarFecha = listToArray(form.fecha,'/') >
<cfset LvarHora = listToArray(form.hora,':') >
<cfset LvarFechaDesde = CreateDateTime(LvarFecha[3],LvarFecha[2], LvarFecha[1], LvarHora[1], LvarHora[2], 0) >
<cfset LvarFechaHasta = DateAdd('n',infoAgenda.escala,LvarFechaDesde) >

<cfif isdefined("form.citaid") and len(trim(form.citaid))>
	<cfif isdefined("form.txt") and len(trim(form.txt))>
		<cfset ComponenteAgenda.ModificarCita(CodigoAgendaPersonal,form.citaid,form.txt)>
	<cfelse>
		<cfset ComponenteAgenda.EliminarCita(CodigoAgendaPersonal, form.citaid) >
		<script language="javascript1.2" type="text/javascript">
			window.parent.ajustarNombre('<cfoutput>#form.hora#</cfoutput>', '<cfoutput>#form.citaid#</cfoutput>', '<cfoutput>#form.indice#</cfoutput>', 'BAJA');
		</script>
	</cfif>
<cfelseif isdefined("form.txt") and len(trim(form.txt))>
	<cfset cita = ComponenteAgenda.NuevaCita (
		CodigoAgendaPersonal,
		CodigoAgendaPersonal, 
		CodigoAgendaPersonal, 
		LvarFechaDesde, 
		LvarFechaHasta, 
		form.txt,
		"", 
		"portal:cita-agenda",
		session.EcodigoSDC)>

	<script language="javascript1.2" type="text/javascript">
		window.parent.ajustarNombre('<cfoutput>#form.hora#</cfoutput>', '<cfoutput>cita</cfoutput>', '<cfoutput>#form.indice#</cfoutput>', 'ALTA');
	</script>
</cfif>
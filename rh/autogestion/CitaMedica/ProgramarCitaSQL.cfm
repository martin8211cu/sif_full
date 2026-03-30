<cfparam name="form.fecha" default="#DateFormat(Now(), 'DD/MM/YYYY')#">
<cfif REFind('^[0-9]{2}/[0-9]{2}/[0-9]{4}$', form.fecha) is 0>
	<cfset form.fecha = DateFormat(Now(), 'DD/MM/YYYY')>
</cfif>
<cfinvoke component="rh.Componentes.AgendaMedica" method="AgendaMedica" returnvariable="CodigoAgendaMedica">

<cfset ComponenteAgenda = CreateObject("Component", "home.Componentes.Agenda")>
<cfset CodigoAgendaPersonal = ComponenteAgenda.MiAgenda()>
<cfset CitasParaHoy = ComponenteAgenda.ListarCitas(CodigoAgendaPersonal, LSParseDateTime(form.fecha))>
<cfset Disponible = ComponenteAgenda.TiempoLibre(form.agendaMed, 
					LSParseDateTime(form.fecha)).Fragment(30).getQuery()>

<cfif ListLen(form.cita) Neq 2>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_HaSeleccionadoUnHorarioInvalido"
		Default="Ha seleccionado un horario inválido"
		returnvariable="LB_HaSeleccionadoUnHorarioInvalido"/>
	<cf_throw message="#LB_HaSeleccionadoUnHorarioInvalido#" errorcode="5005">
</cfif>

<cfset desde=ListGetAt(form.cita,1)>
<cfset hasta=ListGetAt(form.cita,2)>
<cfif Len(desde) is 3><cfset desde='0'&desde></cfif>
<cfif Len(hasta) is 3><cfset hasta='0'&hasta></cfif>
<cfset fecha=LSParseDateTime(form.fecha)>
<cfset desde=CreateDateTime(Year(fecha), Month(fecha), Day(fecha), Val(Mid(desde,1,2)), Val(Mid(desde,3,2)),0)>
<cfset hasta=CreateDateTime(Year(fecha), Month(fecha), Day(fecha), Val(Mid(hasta,1,2)), Val(Mid(hasta,3,2)),0)>

<cfif desde LT Now()>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_LaOpcionSeleccionadaNoEsValida"
		Default="La opción seleccionada(fecha u hora) no es válida"
		returnvariable="MSG_LaOpcionSeleccionadaNoEsValida"/>
	<cf_throw message="#MSG_LaOpcionSeleccionadaNoEsValida#" errorcode="5010">
</cfif>

<cfinvoke component="home.Componentes.Seguridad" method="getUsuarioByCod" returnvariable="empleado">
	<cfinvokeargument name="Usucodigo" value="#session.Usucodigo#">
	<cfinvokeargument name="Ecodigo" value="#session.EcodigoSDC#">
	<cfinvokeargument name="Tabla" value="DatosEmpleado">
</cfinvoke>
<cfif empleado.RecordCount Is 0>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_ElUsuarioQueAccesoLaAplicacionNoEstaRegistradoComoEmpleadoDeLaEmpresaEnLaCualIngreso"
		Default="El usuario que accesó la aplicación no esta registrado como empleado de la empresa en la cual ingresó."
		returnvariable="LB_ElUsuarioQueAccesoLaAplicacionNoEstaRegistradoComoEmpleadoDeLaEmpresaEnLaCualIngreso"/>
	<!---En este momento no es posible localizar su registro de empleado en esta empresa--->	
	<cf_throw message="#LB_ElUsuarioQueAccesoLaAplicacionNoEstaRegistradoComoEmpleadoDeLaEmpresaEnLaCualIngreso#" errorcode="5045">
</cfif>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_CitaMedica"
	Default="Cita médica"
	returnvariable="LB_CitaMedica"/>
<cfset cita = ComponenteAgenda.NuevaCita (
	form.agendaMed & "," & CodigoAgendaPersonal,
	CodigoAgendaPersonal, CodigoAgendaPersonal,
	desde, hasta, LB_CitaMedica & session.datos_personales.Nombre &
		 " " & Session.datos_personales.Apellido1 &
		 " " & Session.datos_personales.Apellido2 & "<br>" &
		 empleado.Pid,
	"", "rh:cita-medica", #session.EcodigoSDC# & ',' & #empleado.llave#)>

<cfif !isDefined("LvarErpMobile")><!--- siempre y cuando no venga del app----->
	<cflocation url="ProgramarCitaGracias.cfm?cita=#cita#">
</cfif>
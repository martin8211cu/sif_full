<!---

	Todos los métodos restringen el acceso a las citas según la
		definición de permisos en ORGPermisosAgenda

	Administración de agendas
		CrearAgenda (Tipo, nombre_agenda [, Propietario, horario_habil, escala ])
		MiAgenda()
	- Administración de agenda
		EstablecerHorario ( agenda, horario_habil, escala )
		Renombrar ( agenda, nombre_agenda )
	- Administracion de Permisos (solamente para el dueño)
		ListarPermisos ( agenda [, Usucodigo] )
		RevocarPermiso ( agenda, Usucodigo )
		OtorgarPermiso ( agenda, Usucodigo, 'propietario|lectura|escritura|citar')
	- Administración de citas
		InfoAgenda ( agenda )
		InfoCita ( agenda, cita )
		NuevaCita ( ListaAgendas, NotificarLista, ConfirmadaLista,
			FechaInicio, FechaFinal, Texto [, Link])
		TiempoLibre (ListaAgendas, Fecha )
		EliminarCita ( Agenda, Cita )
		RestaurarCita ( Agenda, Cita )
		ListarCitas ( ListaAgendas, Fecha )
	- Notificacion de cita
		NotificarEmail ()

--->
<cfcomponent>

<cfset ComponenteHorario = CreateObject("component", "Horario")>

<cffunction name="CrearAgenda" access="public" output="false" returntype="numeric">
	<cfargument name="Tipo" type="string" required="yes">
	<cfargument name="nombre_agenda" type="string" required="yes">
	<cfargument name="Propietario" type="numeric" default="0">
	<cfargument name="horario_habil" type="string" default="L-D0900-1900" hint="Horario hábil eg L-V9-19,S9-13,J14-15"><!--- OPARRALES 2018-05-22 Horario AHP Mexico --->
	<cfargument name="escala" type="numeric" default="30" hint="Escala en minutos">

	<cfif ListFind('P,R,L', Arguments.Tipo) Is 0>
		<cfthrow message="CrearAgenda: Tipo debe ser P(Personal),R(Recurso compartido) o L(Localizable - festivos y asuetos)"></cfif>
	<cfset Arguments.nombre_agenda = Trim(Arguments.nombre_agenda)>
	<cfif Len(Arguments.nombre_agenda) Is 0>
		<cfthrow message="CrearAgenda: El nombre de la agenda no puede estar en blanco"></cfif>
	<cfif Arguments.Propietario Is 0>
		<cfset Arguments.Propietario = session.Usucodigo></cfif>
	<cfif Arguments.Propietario Is 0>
		<cfthrow message="Debe especificarse el dueño de la agenda"></cfif>
	<cfset ComponenteHorario.Validate(Arguments.horario_habil)>
	<cfif Arguments.escala LE 0 Or Arguments.escala GT 1440>
		<cfthrow message="La escala debe estar entre un minuto y un día"></cfif>
	<cftransaction>
		<cfquery datasource="asp" name="NuevaAgendaQuery">
			insert into ORGAgenda (CEcodigo, tipo_agenda, nombre_agenda, horario_habil,
				escala, lectura_publico, escritura_publico, citar_publico,
				BMUsucodigo, BMfecha)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Tipo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.nombre_agenda#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.horario_habil#">,
				<cfqueryparam cfsqltype="cf_sql_numeric " value="#Arguments.Escala#">,
				0, 0,
				<cfqueryparam cfsqltype="cf_sql_numeric " value="#Arguments.Tipo Is 'R'#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">, <cf_dbfunction name="now">)
			<cf_dbidentity1 datasource="asp">
		</cfquery>
		<cf_dbidentity2 datasource="asp" name="NuevaAgendaQuery">
		<cfquery datasource="asp">
			insert into ORGPermisosAgenda (Usucodigo, agenda, CEcodigo,
				propietario, lectura, escritura, citar, BMUsucodigo, BMfecha)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Propietario#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#NuevaAgendaQuery.identity#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">,
				1, 1, 1, 1,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">, <cf_dbfunction name="now">)
		</cfquery>
	</cftransaction>
	<cfreturn NuevaAgendaQuery.identity>
</cffunction>
<cffunction name="MiAgenda" access="public" output="false" returntype="numeric">
	<cfreturn AgendaDeUsuario(session.Usucodigo)>
</cffunction>
<cffunction name="AgendaDeUsuario" access="public" output="false" returntype="numeric">
	<cfargument name="Usucodigo" type="numeric">

	<cfquery datasource="asp" name="buscar_usuario">
		select Usucodigo, Usulogin, CEcodigo from Usuario
		where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
	</cfquery>

	<cfquery datasource="asp" name="MiAgendaQuery">
		select pa.agenda
		from ORGPermisosAgenda pa, ORGAgenda a
		where pa.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#buscar_usuario.CEcodigo#">
		  and pa.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#buscar_usuario.Usucodigo#">
		  and pa.propietario = 1
		  and a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#buscar_usuario.CEcodigo#">
		  and a.tipo_agenda = 'P'
		  and a.agenda = pa.agenda
		  and a.CEcodigo = pa.CEcodigo
		  and UPPER(Ltrim(Rtrim(a.horario_habil))) = 'L-D0900-1900' <!--- OPARRALES 2018-05-22 Horario APH Mexico  --->
		order by pa.agenda
	</cfquery>
	<cfif MiAgendaQuery.RecordCount>
		<cfreturn MiAgendaQuery.agenda>
	<cfelse>
		<cfreturn This.CrearAgenda('P','Mi Agenda (' & buscar_usuario.Usulogin & ')',buscar_usuario.Usucodigo)>
	</cfif>
</cffunction>
<cffunction name="ValidarPermiso" access="public" output="false">
	<cfargument name="agenda" type="numeric" required="yes">
	<cfargument name="permiso" type="string" default="propietario" hint="propietario,lectura,escritura,citar">

	<cfreturn>
	<!---
		se deshabilita porque se hace un enredo para que el medico pueda ver la agenda de la gente.
	--->

	<cfif ListFind('propietario,lectura,escritura,citar',Arguments.permiso) Is 0>
		<cfthrow message="ValidarPermiso: permiso debe ser 'propietario', 'lectura', 'escritura' o 'citar'">
	</cfif>
	<cfif Not IsDefined("session.CEcodigo") Or Len(session.CEcodigo) Is 0 Or session.CEcodigo Is 0>
		<cfthrow message="No ha iniciado sesión">
	</cfif>
	<cfif Not IsDefined("session.Usucodigo") Or Len(session.Usucodigo) Is 0 Or session.Usucodigo Is 0>
		<cfthrow message="No ha iniciado sesión">
	</cfif>
	<cfquery datasource="asp" name="ORGAgenda">
		select lectura_publico, escritura_publico, citar_publico
		from ORGAgenda
		where agenda = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.agenda#">
		  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	</cfquery>
	<cfif ORGAgenda.RecordCount Is 0>
		<cfthrow message="Agenda no existe: #Arguments.agenda#">
	</cfif>
	<cfquery datasource="asp" name="ORGPermisosAgenda">
		select propietario, lectura, escritura, citar
		from ORGPermisosAgenda
		where agenda = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.agenda#">
		  and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	</cfquery>
	<cfset permPropietario = false>
	<cfset permLectura     = ORGAgenda.lectura_publico>
	<cfset permEscritura   = ORGAgenda.escritura_publico>
	<cfset permCitar       = ORGAgenda.citar_publico>
	<cfif ORGPermisosAgenda.RecordCount>
		<cfset permPropietario =                ORGPermisosAgenda.propietario>
		<cfset permLectura   = permLectura   Or ORGPermisosAgenda.lectura    >
		<cfset permEscritura = permEscritura Or ORGPermisosAgenda.escritura  >
		<cfset permCitar     = permCitar     Or ORGPermisosAgenda.citar      >
	</cfif>
	<cfset permEscritura = permEscritura Or permPropietario>
	<cfset permLectura   = permLectura   Or permPropietario>
	<cfset permCitar     = permCitar     Or permPropietario Or permLectura>
	<cfif Arguments.permiso Is 'propietario' And Not permPropietario>
		<cfthrow message="No es propietario de la agenda #Arguments.agenda#">
	</cfif>
	<cfif Arguments.permiso Is 'lectura' And Not permLectura>
		<cfthrow message="No hay permiso de lectura para la agenda #Arguments.agenda#">
	</cfif>
	<cfif Arguments.permiso Is 'escritura' And Not permEscritura>
		<cfthrow message="No hay permiso de escritura para la agenda #Arguments.agenda#">
	</cfif>
	<cfif Arguments.permiso Is 'citar' And Not permCitar>
		<cfthrow message="No hay permiso para realizar citas para la agenda #Arguments.agenda#">
	</cfif>
</cffunction>
<cffunction name="ListarPermisos" access="public" output="false" returntype="query">
	<cfargument name="agenda" type="numeric" required="yes">
	<cfargument name="Usucodigo" type="numeric" default="0">

	<cfset This.ValidarPermiso(Arguments.Agenda)>
	<cfquery datasource="asp" name="Permisos">
		select *
		from ORGPermisosAgenda
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
		  and agenda   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Agenda#">
		  <cfif Arguments.Usucodigo>
		  and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
		  </cfif>
	</cfquery>
	<cfreturn Permisos>
</cffunction>

<cffunction name="RevocarPermiso" access="public" output="false">
	<cfargument name="agenda" type="numeric" required="yes">
	<cfargument name="Usucodigo" type="numeric" required="yes">
	<cfargument name="permiso" type="string" default="propietario" hint="propietario,lectura,escritura,citar">

	<cfset This.ValidarPermiso(Arguments.Agenda)>
	<cfif ListFind('propietario,lectura,escritura,citar',Arguments.permiso) Is 0>
		<cfthrow message="RevocarPermiso: permiso debe ser 'propietario', 'lectura', 'escritura' o 'citar'">
	</cfif>
	<!--- Validar que siempre haya al menos un propietario para cada agenda --->
	<cfif Arguments.permiso is 'propietario'>
		<cfquery datasource="asp" name="OtrosPropietarios">
			select count(1) as cantidad
			from ORGPermisosAgenda
			where propietario = 1
			  and CEcodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
			  and agenda    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Agenda#">
			  and Usucodigo != <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
		</cfquery>
		<cfif OtrosPropietarios.cantidad Is 0>
			<cfthrow message="RevocarPermiso: No se puede quitar el último propietario de una agenda.">
		</cfif>
	</cfif>
	<cfquery datasource="asp">
		update ORGPermisosAgenda
		set #Arguments.permiso# = 0,
			BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
			BMfecha = <cf_dbfunction name="now">
		where CEcodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
		  and agenda    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Agenda#">
		  and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
	</cfquery>
</cffunction>
<cffunction name="OtorgarPermiso" access="public" output="false">
	<cfargument name="agenda" type="numeric" required="yes">
	<cfargument name="Usucodigo" type="numeric" required="yes">
	<cfargument name="permiso" type="string" default="propietario" hint="propietario,lectura,escritura,citar">

	<cfset This.ValidarPermiso(Arguments.Agenda)>
	<cfif ListFind('propietario,lectura,escritura,citar',Arguments.permiso) Is 0>
		<cfthrow message="OtorgarPermiso: permiso debe ser 'propietario', 'lectura', 'escritura' o 'citar'">
	</cfif>
	<cfquery name="rsPermisos" datasource="asp">
		select 1
		from ORGPermisosAgenda
		where CEcodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
		  and agenda    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Agenda#">
		  and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
	</cfquery>

	<cfquery name="rsUpdateA" datasource="asp">
		update ORGPermisosAgenda
		set #Arguments.permiso# = 1,
			BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
			BMfecha = <cf_dbfunction name="now">
		where CEcodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
		  and agenda    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Agenda#">
		  and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
	</cfquery>
	<cfif rsPermisos.RecordCount EQ 0>
		<cfquery name="insertA" datasource="asp">
			insert into ORGPermisosAgenda (Usucodigo, agenda, CEcodigo,
				propietario, lectura, escritura, citar, BMUsucodigo, BMfecha)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.agenda#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_bit"     value="#Arguments.permiso Is 'propietario'#">,
				<cfqueryparam cfsqltype="cf_sql_bit"     value="#Arguments.permiso Is 'lectura'#">,
				<cfqueryparam cfsqltype="cf_sql_bit"     value="#Arguments.permiso Is 'escritura'#">,
				<cfqueryparam cfsqltype="cf_sql_bit"     value="#Arguments.permiso Is 'citar'#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">, <cf_dbfunction name="now">)
		</cfquery>
	</cfif>
</cffunction>

<!---  Administración de agenda --->
<cffunction name="EstablecerHorario" access="public" output="false">
	<cfargument name="agenda" type="numeric" required="yes">
	<cfargument name="horario_habil" type="string" required="yes" hint="Horario eg L-V8-11,S9-12,J14-15">
	<cfargument name="escala" type="numeric" required="yes" hint="Escala en minutos">

	<cfset This.ValidarPermiso(Arguments.Agenda)>
	<cfset ComponenteHorario.validate(Arguments.horario_habil)>
	<cfif Arguments.escala LE 0 Or Arguments.escala GT 1440>
		<cfthrow message="La escala debe estar entre un minuto y un día"></cfif>
	<cfquery datasource="asp">
		update ORGAgenda
		set horario_habil = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.horario_habil#">,
		    escala = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.escala#">,
			BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
			BMfecha = <cf_dbfunction name="now">
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
		  and agenda   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Agenda#">
	</cfquery>
</cffunction>

<cffunction name="Renombrar" access="public" output="false">
	<cfargument name="agenda" type="numeric" required="yes">
	<cfargument name="nombre_agenda" type="string" required="yes">

	<cfset This.ValidarPermiso(Arguments.Agenda)>
	<cfset Arguments.nombre_agenda = Trim(Arguments.nombre_agenda)>
	<cfif Len(Arguments.nombre_agenda) Is 0>
		<cfthrow message="CrearAgenda: El nombre de la agenda no puede estar en blanco"></cfif>
	<cfquery datasource="asp">
		update ORGAgenda
		set nombre_agenda = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.nombre_agenda#">,
			BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
			BMfecha = <cf_dbfunction name="now">
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
		  and agenda   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Agenda#">
	</cfquery>
</cffunction>

<!--- Administración de citas --->
<cffunction name="InfoAgenda" access="public" output="false" returntype="query">
	<cfargument name="agenda" type="numeric" required="yes">
	<cfset This.ValidarPermiso(Arguments.Agenda, 'citar')>
	<cfquery datasource="asp" name="InfoAgendaQuery">
		select tipo_agenda, nombre_agenda, horario_habil, escala
		from ORGAgenda
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
		  and agenda = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.agenda#">
	</cfquery>
	<cfreturn InfoAgendaQuery>
</cffunction>

<cffunction name="InfoCita" access="public" output="false" returntype="query">
	<cfargument name="agenda" type="numeric" required="yes">
	<cfargument name="cita" type="numeric" required="yes">
	<cfset This.ValidarPermiso(Arguments.Agenda, 'lectura')>
	<cfquery datasource="asp" name="InfoCitaQuery">
		select c.fecha, c.inicio, c.final, c.texto, c.url_link, c.origen, c.referencia,
			ac.confirmada, ac.notificar, ac.eliminada, ac.notificada
		from ORGAgendaCita ac, ORGCita c
		where ac.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
		  and ac.agenda = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.agenda#">
		  and ac.cita = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.cita#">
		  and c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
		  and c.cita = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.cita#">
		  and ac.cita = c.cita
		  and ac.CEcodigo = c.CEcodigo
	</cfquery>
	<cfreturn InfoCitaQuery>
</cffunction>

<cffunction name="NuevaCita" access="public" output="false" returntype="numeric">
	<cfargument name="AgendasLista" type="string" required="yes" hint="Lista de agendas en las que se incluirá la cita">
	<cfargument name="NotificarLista" type="string" required="yes" hint="Lista de agendas en las que la cita se notificará">
	<cfargument name="ConfirmadaLista" type="string" required="yes" hint="Lista de agendas en las que la cita se pone como confirmada">
	<cfargument name="FechaInicio" type="date" required="yes">
	<cfargument name="FechaFinal"  type="date" required="yes">
	<cfargument name="Texto" type="string" required="yes">
	<cfargument name="Link" type="string" required="no" default="">
	<cfargument name="Origen" type="string" required="no" default="">
	<cfargument name="Referencia" type="string" required="no" default="">

	<cfif ListLen(AgendasLista) LT 1>
		<cfthrow message="La cita debe incluir al menos una agenda. No es posible crear citas que no estén ligadas a una agenda.">
	</cfif>
	<cfloop from="1" to="#ListLen(AgendasLista)#" index="i">
		<cfset This.ValidarPermiso(ListGetAt(Arguments.AgendasLista, i), 'citar')>
	</cfloop>
	<cfloop from="1" to="#ListLen(NotificarLista)#" index="i">
		<cfif ListFind(Arguments.AgendasLista, ListGetAt(Arguments.NotificarLista, i)) Is 0>
			<cfthrow message="No se puede notificar de esta cita a la agenda #HTMLEditFormat(ListGetAt(Arguments.NotificarLista, i))
				# porque no está incluida en las agendas de la cita: #HTMLEditFormat(Arguments.AgendasLista)#.">
		</cfif>
	</cfloop>
	<cfloop from="1" to="#ListLen(ConfirmadaLista)#" index="i">
		<cfif ListFind(Arguments.AgendasLista, ListGetAt(Arguments.ConfirmadaLista, i)) Is 0>
			<cfthrow message="No se puede confirmar esta cita en la agenda #HTMLEditFormat(ListGetAt(Arguments.ConfirmadaLista, i))
				# porque no está incluida en las agendas de la cita: #HTMLEditFormat(Arguments.AgendasLista)#.">
		</cfif>
	</cfloop>
	<cfif DateFormat(Arguments.FechaInicio, 'dd-mm-yyyy') Neq DateFormat(Arguments.FechaFinal, 'dd-mm-yyyy')>
		<cfthrow message="Las citas deben empezar y terminar el mismo día">
	</cfif>
	<cfquery name="ValidaCita" datasource="asp">
				Select coalesce(b.eliminada,0) as eliminada
				from ORGCita a
				inner join ORGAgendaCita b
					on a.cita=b.cita
					and b.CEcodigo = a.CEcodigo
				inner join ORGAgenda c
					on b.agenda= c.agenda
					and c.tipo_agenda='R'
				Where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric"   value="#session.CEcodigo#">
				and inicio= <cfqueryparam cfsqltype="cf_sql_timestamp"      value="#Arguments.FechaInicio#">
				and final= <cfqueryparam cfsqltype="cf_sql_timestamp"      value="#Arguments.FechaFinal#">

	</cfquery>
	<cfif ValidaCita.Recordcount GT 0 and ValidaCita.Eliminada EQ 0>
		<cfthrow message="Este Horario de cita ya ha sido reservado por otro Usuario, por favor seleccione otro horario">
	</cfif>
	<cfset Arguments.Texto = Trim(Arguments.texto)>
	<cfif Len(Arguments.Texto) Is 0>
		<cfthrow message="Debe indicar la descripción de la cita"></cfif>

	<cftransaction>
		<cfset FechaSolita = CreateDate(Year(FechaInicio), Month(FechaInicio), Day(FechaInicio))>
		<cfquery datasource="asp" name="NuevaCitaQuery">
			insert into ORGCita (
				CEcodigo, fecha, inicio, final,
				texto, url_link, origen, referencia, BMUsucodigo, BMfecha)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric"   value="#session.CEcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_date"      value="#FechaSolita#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.FechaInicio#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.FechaFinal#">,
				<cfqueryparam cfsqltype="cf_sql_varchar"   value="#Arguments.Texto#">,
				<cfqueryparam cfsqltype="cf_sql_varchar"   value="#Arguments.Link#"       null="#Len(Arguments.Link) Is 0#">,
				<cfqueryparam cfsqltype="cf_sql_varchar"   value="#Arguments.Origen#"     null="#Len(Arguments.Origen) Is 0#">,
				<cfqueryparam cfsqltype="cf_sql_varchar"   value="#Arguments.Referencia#" null="#Len(Arguments.Referencia) Is 0#">,
				<cfqueryparam cfsqltype="cf_sql_numeric"   value="#session.Usucodigo#">, <cf_dbfunction name="now">)
			<cf_dbidentity1 datasource="asp">
		</cfquery>
		<cf_dbidentity2 datasource="asp" name="NuevaCitaQuery">

		<cfloop from="1" to="#ListLen(Arguments.AgendasLista)#" index="i">
			<cfset EstaAgenda = ListGetAt(Arguments.AgendasLista, i)>
			<cfquery datasource="asp">
				insert into ORGAgendaCita (cita, agenda, CEcodigo,
					confirmada, notificar, eliminada, BMUsucodigo, BMfecha)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric"   value="#NuevaCitaQuery.identity#">,
					<cfqueryparam cfsqltype="cf_sql_numeric"   value="#EstaAgenda#">,
					<cfqueryparam cfsqltype="cf_sql_numeric"   value="#session.CEcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_bit"       value="#ListFind(Arguments.ConfirmadaLista, EstaAgenda) Neq 0#">,
					<cfqueryparam cfsqltype="cf_sql_bit"       value="#ListFind(Arguments.NotificarLista,  EstaAgenda) Neq 0#">,
					0,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">, <cf_dbfunction name="now">)
			</cfquery>
		</cfloop>
	</cftransaction>
	<cfreturn NuevaCitaQuery.identity>
</cffunction>

<cffunction name="ModificarCita" access="public" output="false" >
	<cfargument name="agenda" type="numeric" required="yes">
	<cfargument name="cita" type="numeric" required="yes">
	<cfargument name="Texto" type="string" required="yes">

	<cfset This.ValidarPermiso(Arguments.Agenda, 'escritura')>
	<cfquery datasource="asp">
		update ORGCita
		set texto = <cfqueryparam cfsqltype="cf_sql_varchar"   value="#Arguments.Texto#">
		where cita = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.cita#">
		  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric"   value="#session.CEcodigo#">
	</cfquery>
</cffunction>

<cffunction name="TiempoLibre" access="public" output="false" returntype="Horario">
	<cfargument name="AgendasLista" type="string" required="yes">
	<cfargument name="Fecha" type="date" required="yes">

	<cfif ListLen(AgendasLista) LT 1>
		<cfthrow message="Debe especificar una lista de agendas para consultar el tiempo libre."></cfif>
	<cfloop from="1" to="#ListLen(AgendasLista)#" index="i">
		<cfset This.ValidarPermiso(ListGetAt(Arguments.AgendasLista, i), 'citar')>
	</cfloop>
	<cfquery datasource="asp" name="TiempoLibreHorariosQuery">
		select horario_habil
		from ORGAgenda
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric"   value="#session.CEcodigo#">
		  and agenda in (<cfqueryparam cfsqltype="cf_sql_numeric"   value="#Arguments.AgendasLista#" list="yes">)
	</cfquery>
	<cfquery datasource="asp" name="TiempoLibreCitasQuery">
		select fecha, inicio, final
		from ORGCita c, ORGAgendaCita ac
		where ac.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric"   value="#session.CEcodigo#">
		  and ac.agenda in (<cfqueryparam cfsqltype="cf_sql_numeric"   value="#Arguments.AgendasLista#" list="yes">)
		  and c.CEcodigo  = <cfqueryparam cfsqltype="cf_sql_numeric"   value="#session.CEcodigo#">
		  and c.cita = ac.cita
		  and c.fecha = <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.fecha#">
		  and ac.eliminada = 0
	</cfquery>
	<cfset h = ComponenteHorario.WholeDay(DatePart("w", Arguments.Fecha))>
	<cfloop query="TiempoLibreHorariosQuery">
		<cfset h2 = ComponenteHorario.Parse(TiempoLibreHorariosQuery.horario_habil)>
		<cfset h = h.intersect(h2)>
	</cfloop>
	<cfloop query="TiempoLibreCitasQuery">
		<cfset h3 = ComponenteHorario.Empty()>
		<cfset h3.addInterval(DatePart("w", TiempoLibreCitasQuery.fecha),
			TimeFormat(TiempoLibreCitasQuery.inicio,'HHMM'),
			TimeFormat(TiempoLibreCitasQuery.final,'HHMM'))>
		<cfset h = h.subtract(h3)>
	</cfloop>
	<cfreturn h>
</cffunction>

<cffunction name="EliminarCita" access="public" output="false">
	<cfargument name="agenda" type="numeric" required="yes">
	<cfargument name="cita" type="numeric" required="yes">

	<cfset This.ValidarPermiso(Arguments.Agenda, 'escritura')>
	<cftransaction>
		<cfquery datasource="asp" name="EliminarCitaQuery">
			select count(1) as existingRows
			from ORGAgendaCita
			where cita     = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#Arguments.cita#">
			  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#session.CEcodigo#">
			  and eliminada = 0
<!---			  and confirmada = 1--->
			  and agenda != <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.agenda#">
		</cfquery>
		<cfif EliminarCitaQuery.RecordCount Is 1 and EliminarCitaQuery.existingRows Is 0>
			<cfquery datasource="asp" name="EliminarCitaQuery">
				delete ORGAgendaCita
				where cita     = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#Arguments.cita#">
				  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#session.CEcodigo#">
			</cfquery>
			<cfquery datasource="asp" name="EliminarCitaQuery">
				delete ORGCita
				where cita     = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#Arguments.cita#">
				  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#session.CEcodigo#">
				<!--- select @@rowcount as rowsAffected --->
			</cfquery>
			<!--- <cfif EliminarCitaQuery.rowsAffected Is 0>
				<cfthrow message="No existe la cita #Arguments.cita# para la agenda #Arguments.Agenda#">
			</cfif> --->
		<cfelse>
			<cfquery datasource="asp" name="EliminarCitaQuery">
				update ORGAgendaCita
				set eliminada = 1, confirmada = 0,
					BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					BMfecha = <cf_dbfunction name="now">
				where agenda    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Agenda#">
				  and cita     = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#Arguments.cita#">
				  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#session.CEcodigo#">
				<!---select @@rowcount as rowsAffected--->
			</cfquery><!---
			<cfif EliminarCitaQuery.rowsAffected Is 0>
				<cfthrow message="No existe la cita #Arguments.cita# para la agenda #Arguments.Agenda#">
			</cfif>--->
		</cfif>
	</cftransaction>
</cffunction>

<cffunction name="RestaurarCita" access="public" output="false">
	<cfargument name="agenda" type="numeric" required="yes">
	<cfargument name="cita" type="numeric" required="yes">

	<cfset This.ValidarPermiso(Arguments.Agenda, 'escritura')>


	<cfquery name="ValidaCita" datasource="asp">
			Select coalesce(b.eliminada,0) as eliminada
			from ORGCita a
			inner join ORGAgendaCita b
				on a.cita=b.cita
				and b.CEcodigo = a.CEcodigo
			inner join ORGAgenda c
				on b.agenda= c.agenda
				and c.tipo_agenda='R'
			Where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric"   value="#session.CEcodigo#">
			and a.cita  = <cfqueryparam cfsqltype="cf_sql_numeric"   value="#Arguments.cita#">
			and b.agenda = <cfqueryparam cfsqltype="cf_sql_numeric"   value="#Arguments.agenda#">
			and b.eliminada=1
			and exists (Select 1
						from ORGCita aa
						inner join ORGAgendaCita bb
							on aa.cita=bb.cita
							and bb.CEcodigo = aa.CEcodigo
						inner join ORGAgenda cc
							on bb.agenda= cc.agenda
							and cc.tipo_agenda='R'
						Where aa.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric"   value="#session.CEcodigo#">
						and aa.cita<>a.cita
						and bb.agenda = b.agenda
						and aa.inicio=a.inicio
						and aa.final=a.final
						and bb.eliminada=0
						)
	</cfquery>
	<cfif ValidaCita.Recordcount GT 0>
		<cfthrow message="Este Horario de cita ya ha sido reservado por otro Usuario, por favor seleccione otro horario">
	</cfif>

	<cftransaction>
		<cfquery datasource="asp" name="EliminarCitaQuery">
			update ORGAgendaCita
			set eliminada = 0,
				BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				BMfecha = <cf_dbfunction name="now">
			where agenda    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Agenda#">
			  and cita     = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#Arguments.cita#">
			  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#session.CEcodigo#">
			<!---select @@rowcount as rowsAffected--->
		</cfquery><!---
		<cfif EliminarCitaQuery.rowsAffected Is 0>
			<cfthrow message="No existe la cita #Arguments.cita# para la agenda #Arguments.Agenda#">
		</cfif>--->
	</cftransaction>
</cffunction>

<cffunction name="ConfirmarCita" access="public" output="false">
	<cfargument name="agenda" type="numeric" required="yes">
	<cfargument name="cita" type="numeric" required="yes">
	<cfargument name="confirmar" type="boolean" default="yes">

	<cfset This.ValidarPermiso(Arguments.Agenda, 'escritura')>
	<cftransaction>
		<cfquery datasource="asp" name="ConfirmarCitaQuery">
			update ORGAgendaCita
			set confirmada = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.confirmar#">,
				BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				BMfecha = <cf_dbfunction name="now">
			where agenda    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Agenda#">
			  and cita     = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#Arguments.cita#">
			  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#session.CEcodigo#">
			<!---select @@rowcount as rowsAffected--->
		</cfquery><!--- esta confirmacion podria no darse, eg si la cita ya fue borrada.
		<cfif ConfirmarCitaQuery.rowsAffected Is 0>
			<cfthrow message="No existe la cita #Arguments.cita# para la agenda #Arguments.Agenda#">
		</cfif>--->
	</cftransaction>
</cffunction>

<cffunction name="ListarCitas" access="public" output="false" returntype="query">
	<cfargument name="AgendasLista" type="string" required="yes">
	<cfargument name="Fecha" type="date" required="yes">
	<cfargument name="incluir_tiempo_libre" type="boolean" default="no">

	<cfif ListLen(AgendasLista) LT 1>
		<cfthrow message="Debe especificar una lista de agendas para listar las citas."></cfif>
	<cfloop from="1" to="#ListLen(AgendasLista)#" index="i">
		<cfset This.ValidarPermiso(ListGetAt(Arguments.AgendasLista, i), 'lectura')>
	</cfloop>
	<cfquery datasource="asp" name="ListarCitasQuery">
		select c.cita, c.fecha, c.inicio, c.final,
			c.texto, c.url_link, c.origen, c.referencia,
			ac.agenda, ac.confirmada, ac.notificar, ac.eliminada,
			case	when ac.confirmada = 0 then 0
					when exists (select * from ORGAgendaCita ot
						where ot.cita = ac.cita
						  and ot.CEcodigo = ac.CEcodigo
						  and ot.confirmada = 0)
						then 0
					else 1 end as TodosVan,
			case	when ac.eliminada = 1 then 1
					when exists (select * from ORGAgendaCita ot
						where ot.cita = ac.cita
						  and ot.CEcodigo = ac.CEcodigo
						  and ot.eliminada = 1)
						then 1
					else 0 end as AlguienElimino
		from ORGAgendaCita ac, ORGCita c
		where ac.agenda in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AgendasLista#" list="yes">)
		  and ac.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
		  and c.CEcodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
		  and c.fecha     = <cfqueryparam cfsqltype="cf_sql_date"    value="#Arguments.Fecha#">
		  and c.cita      = ac.cita
		order by c.inicio, ac.agenda
	</cfquery>
	<cfif Arguments.incluir_tiempo_libre>
		<cfset libre = This.TiempoLibre(ListGetAt(Arguments.AgendasLista,1), Arguments.Fecha)>
		<cfset info = This.InfoAgenda(ListGetAt(Arguments.AgendasLista,1))>
		<cfset libre = libre.fragment(info.escala)>
		<cfset ret = QueryNew("cita,fecha,inicio,final,texto,url_link,origen,referencia,agenda,confirmada,notificar,eliminada,TodosVan,AlguienElimino")>
		<cfset RowNum = 1>
		<cfloop query="ListarCitasQuery">
			<cfloop from="1" to="100" index="i">
				<cfif RowNum GT libre.CountInterval()><cfbreak></cfif>
				<cfset interv = libre.getInterval(RowNum)>
				<cfset LibreInicio = CreateDateTime(Year(Arguments.Fecha), Month(Arguments.Fecha), Day(Arguments.Fecha),
										Mid(interv.inicio,1,2), Mid(interv.inicio,3,2), 0)>
				<cfset LibreFinal  = CreateDateTime(Year(Arguments.Fecha), Month(Arguments.Fecha), Day(Arguments.Fecha),
										Mid(interv.final, 1,2), Mid(interv.final, 3,2), 0)>
				<cfif LibreInicio Gt ListarCitasQuery.inicio><cfbreak></cfif>
				<cfset QueryAddRow (ret)>
				<cfset QuerySetCell(ret, "fecha",  Arguments.Fecha)>
				<cfset QuerySetCell(ret, "inicio", LibreInicio )>
				<cfset QuerySetCell(ret, "final",  LibreFinal  )>
				<cfset RowNum = RowNum + 1>
			</cfloop>
			<cfset QueryAddRow (ret)>
			<cfset QuerySetCell(ret, "cita",           ListarCitasQuery.cita)>
			<cfset QuerySetCell(ret, "fecha",          ListarCitasQuery.Fecha)>
			<cfset QuerySetCell(ret, "inicio",         ListarCitasQuery.inicio)>
			<cfset QuerySetCell(ret, "final",          ListarCitasQuery.final)>
			<cfset QuerySetCell(ret, "texto",          ListarCitasQuery.texto)>
			<cfset QuerySetCell(ret, "url_link",       ListarCitasQuery.url_link)>
			<cfset QuerySetCell(ret, "origen",         ListarCitasQuery.origen)>
			<cfset QuerySetCell(ret, "referencia",     ListarCitasQuery.referencia)>
			<cfset QuerySetCell(ret, "agenda",         ListarCitasQuery.agenda)>
			<cfset QuerySetCell(ret, "confirmada",     true and ListarCitasQuery.confirmada)>
			<cfset QuerySetCell(ret, "notificar",      true and ListarCitasQuery.notificar)>
			<cfset QuerySetCell(ret, "eliminada",      true and ListarCitasQuery.eliminada)>
			<cfset QuerySetCell(ret, "TodosVan",       true and ListarCitasQuery.TodosVan)>
			<cfset QuerySetCell(ret, "AlguienElimino", true and ListarCitasQuery.AlguienElimino)>
		</cfloop>
		<cfloop from="#RowNum#" to="#libre.CountInterval()#" index="RowNum">
			<cfset interv = libre.getInterval(RowNum)>
			<cfset LibreInicio = CreateDateTime(Year(Arguments.Fecha), Month(Arguments.Fecha), Day(Arguments.Fecha),
									Mid(interv.inicio,1,2), Mid(interv.inicio,3,2), 0)>
			<cfset LibreFinal  = CreateDateTime(Year(Arguments.Fecha), Month(Arguments.Fecha), Day(Arguments.Fecha),
									Mid(interv.final, 1,2), Mid(interv.final, 3,2), 0)>
			<cfset QueryAddRow (ret)>
			<cfset QuerySetCell(ret, "fecha",  Arguments.Fecha)>
			<cfset QuerySetCell(ret, "inicio", LibreInicio )>
			<cfset QuerySetCell(ret, "final",  LibreFinal  )>
		</cfloop>

		<cfset ListarCitasQuery = ret >
	</cfif>
	<cfreturn ListarCitasQuery>
</cffunction>

<cffunction name="NotificarEmail" access="public" output="false" returntype="numeric">
	<cfquery datasource="asp" name="NotificarQuery">
		select
			ac.agenda, c.cita, c.inicio, c.final, c.texto, ap.Usucodigo, u.Usulogin,
			u.datos_personales, ac.CEcodigo
		from ORGPermisosAgenda ap, ORGAgendaCita ac,
			ORGCita c, Usuario u
		where ac.notificada = 0
		  and ac.notificar = 1
		  and c.cita = ac.cita
		  and c.CEcodigo = ac.CEcodigo
		  and ap.agenda = ac.agenda
		  and ap.CEcodigo = ac.CEcodigo
		  and u.Usucodigo = ap.Usucodigo
		  and c.inicio > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
		  and c.inicio < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('n', 120, Now())#"><!--- 120 minutos --->
		order by c.inicio, c.cita
	</cfquery>

	<cfoutput query="NotificarQuery">
		<cf_datospersonales action="select" key="#NotificarQuery.datos_personales#" name="_user_datos_personales">
		<cfif Len(Trim(_user_datos_personales.email1))>
			<cfsavecontent variable="_mail_body">
				<cfinclude template="Agenda_Notifica_mailbody.cfm">
			</cfsavecontent>

			<cfset FromEmail = "Agenda@soin.co.cr">
			<cfquery name="CuentaPortal"  datasource="asp">
				Select valor
				from  PGlobal
				Where parametro='correo.cuenta'
			</cfquery>
			<cfif isdefined ('CuentaPortal') and CuentaPortal.Recordcount GT 0>
				<cfset FromEmail=CuentaPortal.valor>
			</cfif>

			<cfquery datasource="asp">
				insert into SMTPQueue (
					SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml)
				values (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#FromEmail#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#_user_datos_personales.email1#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="Recordatorio">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#_mail_body#">, 1)
			</cfquery>
		</cfif>

		<cfif Len(Trim(_user_datos_personales.celular))>
			<cfquery datasource="asp" name="newsms">
				insert into SMS ( SScodigo, SMcodigo, asunto, para, texto, fecha_creado, BMfecha, BMUsucodigo )
				values ( 'sys',
						 'home',
						 <cfqueryparam cfsqltype="cf_sql_varchar"   value="Recordatorio">,
						 <cfqueryparam cfsqltype="cf_sql_varchar"   value="#_user_datos_personales.celular#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar"   value="Cita a punto de iniciar: #mid(NotificarQuery.texto, 1, 90)#">,
						 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						 <cfqueryparam cfsqltype="cf_sql_numeric"   value="0"> )
			</cfquery>
		</cfif>

		<cfquery datasource="asp">
			update ORGAgendaCita
			set notificada = 1
			where cita = <cfqueryparam cfsqltype="cf_sql_numeric" value="#NotificarQuery.cita#">
			  and agenda = <cfqueryparam cfsqltype="cf_sql_numeric" value="#NotificarQuery.agenda#">
			  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#NotificarQuery.CEcodigo#">
			  and notificada = 0
		</cfquery>
	</cfoutput>
	<cfreturn NotificarQuery.RecordCount>
</cffunction>

</cfcomponent>

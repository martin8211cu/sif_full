<cfparam name="modo_Ag" default="ALTA">

<cfif Len(form.hora_desde) EQ 1>
	<cfset form.hora_desde = "0" & form.hora_desde>
</cfif>	
<cfif Len(form.hora_hasta) EQ 1>
	<cfset form.hora_hasta = "0" & form.hora_hasta>
</cfif>	
<cfif Len(form.hora_inicomida) EQ 1>
	<cfset form.hora_inicomida = "0" & form.hora_inicomida>
</cfif>	
<cfif Len(form.hora_fincomida) EQ 1>
	<cfset form.hora_fincomida = "0" & form.hora_fincomida>
</cfif>	
<cfif Len(form.min_desde) EQ 1>
	<cfset form.min_desde = "0" & form.min_desde>
</cfif>	
<cfif Len(form.min_hasta) EQ 1>
	<cfset form.min_hasta = "0" & form.min_hasta>
</cfif>	
<cfif Len(form.min_inicomida) EQ 1>
	<cfset form.min_inicomida = "0" & form.min_inicomida>
</cfif>	
<cfif Len(form.min_fincomida) EQ 1>
	<cfset form.min_fincomida = "0" & form.min_fincomida>
</cfif>	
<cfif isdefined("form.chk")>
	<cfquery name="rsDescr" datasource="#session.tramites.dsn#">
		<cfif isdefined('form.tabsuc')>
			Select id_tiposerv,(rtrim(codigo_tiposerv) || '  ' || nombre_tiposerv) as nombreSucuTipoServ
			from TPTipoServicio	
			where id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_inst#">
				and id_tiposerv in (#form.chk#)				
		</cfif>	
		<cfif isdefined('form.tabserv')>
			Select id_sucursal,(rtrim(codigo_sucursal) || '  ' || nombre_sucursal) as nombreSucuTipoServ
			from TPSucursal	
			where id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_inst#">
				and id_sucursal in (#form.chk#)			
		</cfif>
	</cfquery>
	
	<cfset datos = ListToArray(form.chk)>
	<cfset HoraDesde = form.hora_desde & ":" & form.min_desde & ":00">
	<cfset HoraHasta = "00:00:00">
	<cfif (isdefined('form.hora_hasta') and form.hora_hasta NEQ '') and (isdefined('form.min_hasta') and form.min_hasta NEQ '')>
		<cfset HoraHasta = form.hora_hasta & ":" & form.min_hasta & ":00">
	</cfif>	
	<cfset HoraDesdeComida = form.hora_inicomida & ":" & form.min_inicomida & ":00">
	<cfset HoraHastaComida = "00:00:00">
	<cfif (isdefined('form.hora_fincomida') and form.hora_fincomida NEQ '') and (isdefined('form.min_fincomida') and form.min_fincomida NEQ '')>
		<cfset HoraHastaComida = form.hora_fincomida & ":" & form.min_fincomida & ":00">
	</cfif>			

	<cfset cadenaDias = cadenaDias()>
	
	<cfif isdefined('form.id_tiposerv') and form.id_tiposerv NEQ ''>
		<cfquery name="rsDirec" datasource="#session.tramites.dsn#">
			Select id_direccion,id_sucursal
			from TPSucursal
			where id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_inst#">
				and id_sucursal in (#form.chk#)		
		</cfquery>
		<cfquery name="rsCantTPRequisito" datasource = "#session.tramites.dsn#">
			select count(1) as Cantidad
			from TPRequisito a
			where a.id_tiposerv = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tiposerv#">
			  and a.es_cita = 1
		</cfquery> 		
	<cfelse>
		<cfquery name="rsDirec" datasource="#session.tramites.dsn#">
			Select id_direccion,id_sucursal
			from TPSucursal
			where id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_inst#">
				and id_sucursal=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_sucursal#">
		</cfquery>		
	</cfif>
	
	<cfloop from="1" to="#ArrayLen(datos)#" index="idx">
		<cfif isdefined('form.id_tiposerv') and form.id_tiposerv NEQ ''>	<!--- Lista de Sucursales --->
			<cfif isdefined('rsDescr') and rsDescr.recordCount GT 0>
				<cfquery name="rsDescripcion" dbtype="query">
					select nombreSucuTipoServ
					from rsDescr
					where id_sucursal = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos[idx]#">
				</cfquery>
			</cfif>
					
			<cftransaction>	
				<cfquery name="validaAgenda" datasource="#session.tramites.dsn#">
					insert TPAgendaServicio 
						(id_sucursal, id_tiposerv, nombre_agenda, id_tiporecurso, hora_desde, hora_hasta, hora_inicomida, hora_fincomida
							, periodicidad, cupo, dia_semanal, fdesde, fhasta, BMUsucodigo, BMfechamod)
					values (
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#datos[idx]#">
							, <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tiposerv#">
							<cfif isdefined('rsDescripcion') and rsDescripcion.recordCount GT 0>
								, <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDescripcion.nombreSucuTipoServ#">
							<cfelse>
								, 'Nombre de la agenda'
							</cfif>
							, <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tiporecurso#">
							, <cfqueryparam cfsqltype="cf_sql_time" value="#HoraDesde#">
							, <cfqueryparam cfsqltype="cf_sql_time" value="#HoraHasta#">
							, <cfqueryparam cfsqltype="cf_sql_time" value="#HoraDesdeComida#">
							, <cfqueryparam cfsqltype="cf_sql_time" value="#HoraHastaComida#">
							, <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.periodicidad#">
							, <cfqueryparam cfsqltype="cf_sql_integer" value="#form.cupo#">
							, <cfqueryparam cfsqltype="cf_sql_char" value="#cadenaDias#">
							, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
							, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(6100,1,1)#">
							, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
							, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
						)
					<cf_dbidentity1 datasource="#session.tramites.dsn#">
				</cfquery>
				<cf_dbidentity2 datasource="#session.tramites.dsn#" name="validaAgenda">
			</cftransaction>
			
			<cfif isdefined('rsDirec') and rsDirec.recordCount GT 0>
				<cfquery name="rsDirecID" dbtype="query">
					select id_direccion
					from rsDirec
					where id_sucursal = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos[idx]#">
				</cfquery>
			</cfif>
			
			<cftransaction>
				<cfquery name="AltaRecurso" datasource="#session.tramites.dsn#">
					insert TPRecurso 
						(id_sucursal, id_direccion, id_tiporecurso, codigo_recurso, nombre_recurso
							, BMUsucodigo, BMfechamod, vigente_desde, vigente_hasta, id_agendaserv)
					values (
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#datos[idx]#">
						<cfif isdefined('rsDirecID') and rsDirecID.recordCount GT 0>
							, <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDirecID.id_direccion#">
						<cfelse>
							, null
						</cfif>
						, <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tiporecurso#">
						, <cfqueryparam cfsqltype="cf_sql_char" value="#validaAgenda.identity#">
						<cfif isdefined('rsDescripcion') and rsDescripcion.recordCount GT 0>
							, <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDescripcion.nombreSucuTipoServ# (#validaAgenda.identity#)">
						<cfelse>
							, <cfqueryparam cfsqltype="cf_sql_varchar" value="Nombre del Recurso (#validaAgenda.identity#)">
						</cfif>
						, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
						, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
						, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
						, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(6100,1,1)#">		
						, <cfqueryparam cfsqltype="cf_sql_numeric" value="#validaAgenda.identity#">
					)
					<cf_dbidentity1 datasource="#session.tramites.dsn#">
				</cfquery>
				<cf_dbidentity2 datasource="#session.tramites.dsn#" name="AltaRecurso">
			</cftransaction>

			<!--- Insercion de la agenda de forma automatica para cda uno de los recursos --->
			<cfset horaInicio = HoraDesde>
			<cfset NuevaHora = horaInicio>
			
			<cfset banderaHrComida = 0>

			<cfloop condition = "NuevaHora LESS THAN #HoraHasta#">
				<cfif horaInicio GTE HoraDesdeComida and banderaHrComida EQ 0>
					<cfset banderaHrComida = 1>
					<cfset horaInicio = HoraHastaComida>
					<cfset NuevaHora = horaInicio>
				</cfif>
				<cfset NuevaHora = DateAdd("n", form.periodicidad, NuevaHora)>

				<cfif horaInicio LT HoraHasta >
					<cfquery name="AltaAgenda" datasource="#session.tramites.dsn#">
						insert TPAgenda 
							( id_tiposerv, id_recurso, id_direccion, id_inst, id_sucursal, id_responsable, dia_semana
								 , hora_desde, hora_hasta, id_requisito, cupo, BMUsucodigo, BMfechamod, vigente_desde
								 , vigente_hasta, dia_semanal, cupo1, cupo2, cupo3, cupo4, cupo5, cupo6, cupo7)
						<cfif isdefined('rsCantTPRequisito') and rsCantTPRequisito.recordcount GT 0 and rsCantTPRequisito.Cantidad GT 0>
							select 
						<cfelse>
							values (					
						</cfif>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tiposerv#">
							, <cfqueryparam cfsqltype="cf_sql_numeric" value="#AltaRecurso.identity#">
							<cfif isdefined('rsDirecID') and rsDirecID.recordCount GT 0>
								, <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDirecID.id_direccion#">
							<cfelse>
								, null
							</cfif>						
							, <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_inst#">
							, <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos[idx]#">
							, null
							, 1
							, <cfqueryparam cfsqltype="cf_sql_time" value="#horaInicio#">
							, <cfqueryparam cfsqltype="cf_sql_time" value="#NuevaHora#">
							<cfif isdefined('rsCantTPRequisito') and rsCantTPRequisito.recordcount GT 0 and rsCantTPRequisito.Cantidad GT 0>
								, a.id_requisito
							<cfelse>
								, null
							</cfif>
							, <cfqueryparam cfsqltype="cf_sql_integer" value="#form.cupo#">
							, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
							, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
							, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
							, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(6100,1,1)#">	
							, <cfqueryparam cfsqltype="cf_sql_char" value="#cadenaDias#">
							, <cfqueryparam cfsqltype="cf_sql_integer" value="#form.cupo#">
							, <cfqueryparam cfsqltype="cf_sql_integer" value="#form.cupo#">
							, <cfqueryparam cfsqltype="cf_sql_integer" value="#form.cupo#">
							, <cfqueryparam cfsqltype="cf_sql_integer" value="#form.cupo#">
							, <cfqueryparam cfsqltype="cf_sql_integer" value="#form.cupo#">
							, <cfqueryparam cfsqltype="cf_sql_integer" value="#form.cupo#">
							, <cfqueryparam cfsqltype="cf_sql_integer" value="#form.cupo#">
						<cfif isdefined('rsCantTPRequisito') and rsCantTPRequisito.recordcount GT 0 and rsCantTPRequisito.Cantidad GT 0>
							from TPRequisito a
							where a.id_tiposerv = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tiposerv#">
							  and a.es_cita = 1
						<cfelse>
							)
						</cfif>
					</cfquery>				
				</cfif>
				
				<cfset horaInicio = NuevaHora>
			</cfloop>
		<cfelseif isdefined('form.id_sucursal') and form.id_sucursal NEQ ''>	<!--- Lista de Tipos de Servicios --->
			<cfif isdefined('rsDescr') and rsDescr.recordCount GT 0>
				<cfquery name="rsDescripcion" dbtype="query">
					select nombreSucuTipoServ
					from rsDescr
					where id_tiposerv = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos[idx]#">
				</cfquery>
			</cfif>		
			<cftransaction>
				<cfquery name="validaAgenda" datasource="#session.tramites.dsn#">
					insert TPAgendaServicio 
						(id_sucursal, id_tiposerv, nombre_agenda, id_tiporecurso, hora_desde, hora_hasta, hora_inicomida, hora_fincomida
							, periodicidad, cupo, dia_semanal, fdesde, fhasta, BMUsucodigo, BMfechamod)
					values (
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_sucursal#">
							, <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos[idx]#">
							<cfif isdefined('rsDescripcion') and rsDescripcion.recordCount GT 0>
								, <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDescripcion.nombreSucuTipoServ#">
							<cfelse>
								, 'Nombre de la agenda'
							</cfif>
							, <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tiporecurso#">
							, <cfqueryparam cfsqltype="cf_sql_time" value="#HoraDesde#">
							, <cfqueryparam cfsqltype="cf_sql_time" value="#HoraHasta#">
							, <cfqueryparam cfsqltype="cf_sql_time" value="#HoraDesdeComida#">
							, <cfqueryparam cfsqltype="cf_sql_time" value="#HoraHastaComida#">
							, <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.periodicidad#">
							, <cfqueryparam cfsqltype="cf_sql_integer" value="#form.cupo#">
							, <cfqueryparam cfsqltype="cf_sql_char" value="#cadenaDias#">
							, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
							, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(6100,1,1)#">	
							, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
							, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
						)
					<cf_dbidentity1 datasource="#session.tramites.dsn#">
				</cfquery>
				<cf_dbidentity2 datasource="#session.tramites.dsn#" name="validaAgenda">
			</cftransaction>
			
			<cftransaction>
				<cfquery name="AltaRecurso" datasource="#session.tramites.dsn#">
					insert TPRecurso 
						(id_sucursal, id_direccion, id_tiporecurso, codigo_recurso, nombre_recurso
							, BMUsucodigo, BMfechamod, vigente_desde, vigente_hasta, id_agendaserv)
					values (
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_sucursal#">
						<cfif isdefined('rsDirec') and rsDirec.recordCount GT 0>
							, <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDirec.id_direccion#">
						<cfelse>
							, null
						</cfif>
						, <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tiporecurso#">
						, <cfqueryparam cfsqltype="cf_sql_char" value="#validaAgenda.identity#">
						<cfif isdefined('rsDescripcion') and rsDescripcion.recordCount GT 0>
							, <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDescripcion.nombreSucuTipoServ# (#validaAgenda.identity#)">
						<cfelse>
							, <cfqueryparam cfsqltype="cf_sql_varchar" value="Nombre del Recurso (#validaAgenda.identity#)">
						</cfif>
						, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
						, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
						, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
						, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(6100,1,1)#">	
						, <cfqueryparam cfsqltype="cf_sql_numeric" value="#validaAgenda.identity#">
					)
					<cf_dbidentity1 datasource="#session.tramites.dsn#">
				</cfquery>
				<cf_dbidentity2 datasource="#session.tramites.dsn#" name="AltaRecurso">
			</cftransaction>

			<!--- Insercion de la agenda de forma automatica para cda uno de los recursos --->
			<cfset horaInicio = HoraDesde>
			<cfset NuevaHora = horaInicio>
			<cfset banderaHrComida = 0>

			<cfloop condition = "NuevaHora LESS THAN #HoraHasta#">
				<cfquery name="rsCantTPRequisito" datasource = "#session.tramites.dsn#">
					select count(1) as Cantidad
					from TPRequisito a
					where a.id_tiposerv = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos[idx]#">
					  and a.es_cita = 1
				</cfquery> 			

				<cfif horaInicio GTE HoraDesdeComida and banderaHrComida EQ 0>
					<cfset banderaHrComida = 1>
					<cfset horaInicio = HoraHastaComida>
					<cfset NuevaHora = horaInicio>
				</cfif>
				<cfset NuevaHora = DateAdd("n", form.periodicidad, NuevaHora)>
				
				<cfif horaInicio LT HoraHasta>
					<cfquery name="AltaAgenda" datasource="#session.tramites.dsn#">
						insert TPAgenda 
							( id_tiposerv, id_recurso, id_direccion, id_inst, id_sucursal, id_responsable, dia_semana
								 , hora_desde, hora_hasta, id_requisito, cupo, BMUsucodigo, BMfechamod, vigente_desde
								 , vigente_hasta, dia_semanal, cupo1, cupo2, cupo3, cupo4, cupo5, cupo6, cupo7)
						<cfif isdefined('rsCantTPRequisito') and rsCantTPRequisito.recordcount GT 0 and rsCantTPRequisito.Cantidad GT 0>
							select 
						<cfelse>
							values (					
						</cfif>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#datos[idx]#">
							, <cfqueryparam cfsqltype="cf_sql_numeric" value="#AltaRecurso.identity#">
							<cfif isdefined('rsDirec') and rsDirec.recordCount GT 0>
								, <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDirec.id_direccion#">
							<cfelse>
								, null
							</cfif>
							, <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_inst#">
							, <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_sucursal#">
							, null
							, 1
							, <cfqueryparam cfsqltype="cf_sql_time" value="#horaInicio#">
							, <cfqueryparam cfsqltype="cf_sql_time" value="#NuevaHora#">
							<cfif isdefined('rsCantTPRequisito') and rsCantTPRequisito.recordcount GT 0 and rsCantTPRequisito.Cantidad GT 0>
								, a.id_requisito 
							<cfelse>
								, null
							</cfif>
							, <cfqueryparam cfsqltype="cf_sql_integer" value="#form.cupo#">
							, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
							, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
							, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
							, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(6100,1,1)#">	
							, <cfqueryparam cfsqltype="cf_sql_char" value="#cadenaDias#">
							, <cfqueryparam cfsqltype="cf_sql_integer" value="#form.cupo#">
							, <cfqueryparam cfsqltype="cf_sql_integer" value="#form.cupo#">
							, <cfqueryparam cfsqltype="cf_sql_integer" value="#form.cupo#">
							, <cfqueryparam cfsqltype="cf_sql_integer" value="#form.cupo#">
							, <cfqueryparam cfsqltype="cf_sql_integer" value="#form.cupo#">
							, <cfqueryparam cfsqltype="cf_sql_integer" value="#form.cupo#">
							, <cfqueryparam cfsqltype="cf_sql_integer" value="#form.cupo#">
						<cfif isdefined('rsCantTPRequisito') and rsCantTPRequisito.recordcount GT 0 and rsCantTPRequisito.Cantidad GT 0>
							from TPRequisito a
							where a.id_tiposerv = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos[idx]#">
							  and a.es_cita = 1
						<cfelse>
							)
						</cfif>
					</cfquery>				
				</cfif>				
				
				<cfset horaInicio = NuevaHora>
			</cfloop>
		</cfif>		
	</cfloop>
</cfif>

<cffunction name="cadenaDias" returntype="string">
	<cfset dias = "">
	<cfset CountVar = 0>	
	
	<cfloop condition = "CountVar LESS THAN OR EQUAL TO 6">
		<cfset CountVar = CountVar + 1>
		
		<cfif isdefined("form.dia_#CountVar#")>
			<cfif dias NEQ ''>
				<cfset dias = dias & ",1">
			<cfelse>
				<cfset dias = dias & "1">
			</cfif>
		<cfelse>
			<cfif dias NEQ ''>
				<cfset dias = dias & ",0">
			<cfelse>
				<cfset dias = dias & "0">
			</cfif>
		</cfif>		
	</cfloop>

	<cfreturn dias>
</cffunction>

<cfoutput>
	<cfset p = "?id_inst=#form.id_inst#">
	
	<cfif isdefined('form.tabsuc')>
		<cfif isdefined('form.id_sucursal') and form.id_sucursal NEQ ''>
			<cfset p = p & "&id_sucursal=#form.id_sucursal#">
		</cfif>		
		<cfset p = p & "&tabsuc=#form.tabsuc#&tab=#form.tab#">
	</cfif>	
	<cfif isdefined('form.tabserv')>
		<cfif isdefined('form.id_tiposerv') and form.id_tiposerv NEQ ''>
			<cfset p = p & "&id_tiposerv=#form.id_tiposerv#">
		</cfif>			
		<cfset p = p & "&tabserv=#form.tabserv#&tab=#form.tab#">
	</cfif>		

	<cflocation url="../instituciones.cfm#p#">
</cfoutput>
<cfcomponent output="yes">
	<!--- 
		Funcion principal de proceso:
			Realiza las asignaciones iniciales
			Invoca la validación de los registros
			Si validacion no es correcta y total:
				Invoca función de despliegue de errores
			Genera Tablas de Trabajo
			Invoca la función de Aplicación ( funcion privada a este componente )
			
			Para poder desplegar los errores al usuario, las siguientes funciones:
					AF_ContabilizarTraslado
					fnDesplegarErrores
					verDebugFinal
				deben tener el parametro output="yes". 
			Todas las otras deben tener el parametro en output="no"
	---> 
	<cffunction name="AF_ContabilizarTraslado" access="public" returntype="boolean" output="yes">
		<cfargument name="Ecodigo" 			 type="numeric" required="no" 	default="0" >        <!--- Código de Empresa (sif) --->
		<cfargument name="Usucodigo" 		 type="numeric" required="no" 	default="0" >        <!--- Código de Usuario (asp) --->
		<cfargument name="Conexion" 		 type="string"  required="no" 	default="" >         <!--- IP de PC de Usuario --->
		<cfargument name="AGTPid" 			 type="numeric" required="yes">
		<cfargument name="Programar" 		 type="boolean" required="no" 	default="false" >    <!---Si es verdadero se requiere la fecha de programación y solo se programa y no se calcula--->
		<cfargument name="FechaProgramacion" type="date"    required="no" 	default="#CreateDate(1900,01,01)#" >
		<cfargument name="Periodo" 			 type="numeric" required="no" 	default="0" >        <!---Si se envían No se sacan de la tabla de parámetros--->
		<cfargument name="Mes" 				 type="numeric" required="no" 	default="0" >        <!---Si se envían No se sacan de la tabla de parámetros--->
		<cfargument name="debug" 			 type="boolean" required="no" 	default="false" >    <!--- si se prende simula la transacción, pinta los resultados y desahace los cambios --->
		<cfargument name="contabilizar" 	 type="boolean" required="no" 	default="true" >     <!--- si se apaga no contabiliza pero si aplica el traslado, por ahora solo se utiliza para las pruebas iniciales del sistema --->
		<cfargument name="descripcion" 		 type="string"  required="no" 	default="" >         <!--- Descripción de la transacción --->
		<cfargument name="TransaccionActiva" type="boolean" required="false"default="false">
	
		<cfif len(trim(Arguments.Conexion)) EQ 0>
			<cfset Arguments.Conexion = session.dsn >
		</cfif>
		<cfif Arguments.Ecodigo EQ 0>
			<cfset Arguments.Ecodigo = session.Ecodigo >
		</cfif>
		<cfif Arguments.descripcion eq "">
			<cfset Arguments.descripcion = "Activo Fijo: Traslado">
		</cfif>

		<cfset LvarErrorVerificacion = fnVerifica(Arguments.AGTPid, Arguments.Ecodigo, Arguments.Conexion)>
		<cfif LvarErrorVerificacion gt 0>
        	<cfset fnDesplegarErrores(LvarErrorVerificacion)>
            <cf_abort errorInterfaz="">
        </cfif>

		<!---Valida Fecha de Programación Vrs Programar--->
		<cfif (Arguments.Programar) and (DateCompare(Arguments.FechaProgramacion, Now()) eq -1)>
			<cfset Arguments.Programar = false>
		</cfif>

		<!--- Si programar --->
		<cfif (Arguments.Programar)>
			<cfquery name="rsActualizaProceso" datasource="#Arguments.Conexion#">
				update AGTProceso 
				set AGTPestadp = 2,
					AGTPfechaprog = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.FechaProgramacion#" null="#DateCompare(Arguments.FechaProgramacion, Now()) eq -1#">
				where AGTPid = #Arguments.AGTPid#
			</cfquery>
			<cfreturn true>
			<cf_abort errorInterfaz="">
		</cfif>
	
		<cfif Arguments.contabilizar>
			<!--- Crea tabla temportal TAG para crear tablas temporales, devuelve un string con el nombre de la tabla creada en la variable "temp_table"--->
			<cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="CreaIntarc" returnvariable="INTARC">
					<cfinvokeargument name="Conexion" value="#Arguments.Conexion#"/>
			</cfinvoke>
		</cfif>

		<cfset LvarActualizaCFid = fnActualizaCFid(Arguments.Ecodigo, Arguments.Usucodigo, Arguments.conexion, Arguments.AGTPid)>

        <cfset ADTProceso_ori = fnCreaTablaTemporal1(arguments.conexion)>
		<cfset ACT_NUEVOS = fnCreaTablaTemporal2(arguments.conexion)>

		<cfif Arguments.TransaccionActiva>
			<cfinvoke 
				method="AF_ContabilizarTrasladoPrivate"
				returnvariable="private_results"
				Ecodigo="#Arguments.Ecodigo#"
				Usucodigo="#Arguments.Usucodigo#"
				Conexion="#Arguments.Conexion#"
				AGTPid="#Arguments.AGTPid#"
				Mes="#Arguments.Mes#"
				debug="#Arguments.debug#"
				contabilizar="#Arguments.contabilizar#"
				descripcion="#Arguments.descripcion#"
				ADTProceso_ori="#ADTProceso_ori#"
				ACT_NUEVOS = "#ACT_NUEVOS#"/>
		<cfelse>
			<cftransaction>
				<cfinvoke 
					method="AF_ContabilizarTrasladoPrivate"
					returnvariable="private_results"
					Ecodigo="#Arguments.Ecodigo#"
					Usucodigo="#Arguments.Usucodigo#"
					Conexion="#Arguments.Conexion#"
					AGTPid="#Arguments.AGTPid#"
					Mes="#Arguments.Mes#"
					debug="#Arguments.debug#"
					contabilizar="#Arguments.contabilizar#"
					descripcion="#Arguments.descripcion#"
					ADTProceso_ori="#ADTProceso_ori#"
					ACT_NUEVOS = "#ACT_NUEVOS#"/>
			</cftransaction>
		</cfif>
		<cfreturn private_results>
	</cffunction>

	<cffunction name="fnActualizaCFid" access="private" returntype="any" output="no">
		<cfargument name="Ecodigo"        type="numeric"   required="yes">
		<cfargument name="Usucodigo"      type="numeric"   required="yes">
		<cfargument name="Conexion"       type="string"    required="yes">
		<cfargument name="AGTPid"         type="numeric"   required="yes">
		<cfargument name="Periodo"        type="numeric"   required="no">
		<cfargument name="Mes"            type="numeric"   required="no">

		<cfif isdefined("Arguments.Periodo") and Arguments.Periodo neq 0>
			<cfset LvarPeriodo = Arguments.Periodo>
		<cfelse>
			<cfquery name="rsPeriodo" datasource="#Arguments.Conexion#">
				select Pvalor as value
				from Parametros
				where Ecodigo = #Arguments.Ecodigo#
					and Pcodigo = 50
					and Mcodigo = 'GN'
			</cfquery>
			<cfset LvarPeriodo = rsPeriodo.value>
		</cfif>
		<cfif isdefined("Arguments.mes") and Arguments.Mes neq 0>
			<cfset LvarMes = Arguments.Mes>
		<cfelse>
			<cfquery name="rsMes" datasource="#Arguments.Conexion#">
				select Pvalor as value
				from Parametros
				where Ecodigo = #Arguments.Ecodigo#
					and Pcodigo = 60
					and Mcodigo = 'GN'
			</cfquery>
			<cfset LvarMes = rsMes.value>
		</cfif>

		<!---  1. Actualizar el valor de CFid con el valor actual del Activo Fijo origen --->
		<cfquery datasource="#Arguments.Conexion#">
			update ADTProceso
			set CFid = (( 
					select min(s.CFid)
					from AFSaldos s
					where s.Aid = ADTProceso.Aid
					  and s.AFSperiodo = #LvarPeriodo#
					  and s.AFSmes     = #LvarMes#
					  ))
			where AGTPid = #arguments.AGTPid#
		</cfquery>
		
		<!---  2. Actualizar el valor de CFiddest con el valor actual del Activo Fijo Destino --->
		<cfquery datasource="#Arguments.Conexion#">
			update ADTProceso
			set CFiddest = (( 
					select min(s.CFid)
					from AFSaldos s
					where s.Aid = ADTProceso.Aiddestino
					  and s.AFSperiodo = #LvarPeriodo#
					  and s.AFSmes     = #LvarMes#
					  ))
			where AGTPid = #arguments.AGTPid#
		</cfquery>
		
		<!---  3. Actualizar el valor de CFiddest con CFid para los registros que tienen CFiddest en nulo --->
		<cfquery datasource="#Arguments.Conexion#">
			update ADTProceso
			set CFiddest = CFid
			where AGTPid = #arguments.AGTPid#
			  and CFiddest is null
		</cfquery>
	</cffunction>

	<cffunction name="AF_ContabilizarTrasladoPrivate" access="private" returntype="boolean" output="yes">
		<cfargument name="Ecodigo"        type="numeric"   required="yes">
		<cfargument name="Usucodigo"      type="numeric"   required="yes">
		<cfargument name="Conexion"       type="string"    required="yes">
		<cfargument name="AGTPid"         type="numeric"   required="yes">
		<cfargument name="Periodo"        type="numeric"   required="no">
		<cfargument name="Mes"            type="numeric"   required="no">
		<cfargument name="debug"          type="boolean"   required="yes">
		<cfargument name="contabilizar"   type="boolean"   required="yes">
		<cfargument name="descripcion"    type="string"    required="yes">
		<cfargument name="ADTProceso_ori" type="string"    required="yes">
		<cfargument name="ACT_NUEVOS"     type="string"    required="yes">
	
		<cfset var lVarComplemento = ''>
		<cfset var lVarErrorCta = 0>
		<cfset var lVarCtasError = ''>
		
		<cfset ADTProceso_ori = Arguments.ADTProceso_ori>
		<cfset ACT_NUEVOS = Arguments.ACT_NUEVOS>

		<!---Cuando Arguments.AGTPid estos valores no son necesarios--->
		<cfif Arguments.Ecodigo eq 0>
			<cfset Arguments.Ecodigo = session.Ecodigo >
			<cfset Arguments.Conexion = session.dsn >
			<cfset Arguments.Usucodigo = session.Usucodigo >	
		</cfif>
        
		<cfset Arguments.IPregistro = session.sitio.ip >

		<!--- 
				Calculos previsos al inicio del proceso:
				Obtiene el Periodo y Mes de Auxiliares 
		--->
		<cfif isdefined("Arguments.Periodo") and Arguments.Periodo neq 0>
			<cfset rsPeriodo.value = Arguments.Periodo>
		<cfelse>
			<cfquery name="rsPeriodo" datasource="#Arguments.Conexion#">
				select Pvalor as value
				from Parametros
				where Ecodigo = #Arguments.Ecodigo#
					and Pcodigo = 50
					and Mcodigo = 'GN'
			</cfquery>
		</cfif>
		<cfif isdefined("Arguments.mes") and Arguments.Mes neq 0>
			<cfset rsMes.value = Arguments.Mes>
		<cfelse>
			<cfquery name="rsMes" datasource="#Arguments.Conexion#">
				select Pvalor as value
				from Parametros
				where Ecodigo = #Arguments.Ecodigo#
					and Pcodigo = 60
					and Mcodigo = 'GN'
			</cfquery>
		</cfif>

		<!--- Obtiene la Moneda Local --->
		<cfquery name="rsMoneda" datasource="#Arguments.Conexion#">
			select Mcodigo as value
			from Empresas 
			where Ecodigo = #Arguments.Ecodigo#
		</cfquery>

		<!--- Crea la FechaAux a partir del periodo / mes de auxiliares y le pone el último día del mes --->
		<cfset lvarFechaAux = CreateDate(fnIsNull(rsPeriodo.value,01), fnIsNull(rsMes.value,01), 01)>
		<cfset lvarFechaAux = DateAdd("m",1,lvarFechaAux)>
		<cfset lvarFechaAux = DateAdd("d",-1,lvarFechaAux)>
        <cfoutput>lvarFechaAux = #lvarFechaAux#</cfoutput><br>

		<cfif Arguments.debug>

			<!--- Pinta los valores obtenidos hasta el momento para debug --->
			<cfoutput>
				<h1>DEBUG</h1><br>
				<p>
				<strong>Periodo</strong> = #rsPeriodo.value#<br>
				<strong>Mes</strong> = #rsMes.value#<br>
				<strong>Moneda</strong> = #rsMoneda.value#<br>
				<strong>FechaAux</strong> = #lvarFechaAux#<br>
				<strong>Fecha del Sistema</strong> = #Now()#<br>
				</p>
				<cfflush interval="64">
			</cfoutput>
			<cf_dump var="#Arguments#" label="Arguments">
		</cfif>
		
		<!---
			Consolidación de los registros de traslado de activos ( origen ) para realizar los controles de saldos necesarios 
		--->
        <cfquery datasource="#Arguments.Conexion#">
            insert into #ADTProceso_ori# (
                Aid, 
                Ecodigo,
                TAperiodo,
                TAmes,
                TAvaladq,
                TAmontolocadq, 
                TAmontolocmej, 
                TAmontolocrev, 
                TAmontodepadq, 
                TAmontodepmej, 
                TAmontodeprev
            )
            select 
                Aid, 
                Ecodigo,
                TAperiodo,
                TAmes,
                sum(TAvaladq) as TAvaladq,
                sum(TAmontolocadq) as TAmontolocadq, 
                sum(TAmontolocmej) as TAmontolocmej, 
                sum(TAmontolocrev) as TAmontolocrev, 
                sum(TAmontodepadq) as TAmontodepadq, 
                sum(TAmontodepmej) as TAmontodepmej, 
                sum(TAmontodeprev) as TAmontodeprev
            from ADTProceso
            where AGTPid = #Arguments.AGTPid#
            group by Aid, 
                    Ecodigo,
                    TAperiodo,
                    TAmes
        </cfquery>

		<!--- Obtiene el número de Documento --->
		<cfquery name="rsAGTProcesoDoc" datasource="#Arguments.Conexion#">
			select AGTPdocumento 
			from AGTProceso 
			where AGTPid = #Arguments.AGTPid#
		</cfquery>
		
		<cfif rsAGTProcesoDoc.recordcount eq 0 or len(trim(rsAGTProcesoDoc.AGTPdocumento)) eq 0 or rsAGTProcesoDoc.AGTPdocumento eq 0>
			<cf_errorCode	code = "50928" msg = "Error obteniendo el Documento, No se pudo obtener el documento de la transacción de traslado, Proceso Cancelado!">
		</cfif>
	
		<!--- Obtiene las placas nuevas --->
		<cfquery datasource="#Arguments.Conexion#" name="rsPlacasNuevas">
			select a.Aplacadestino, count(1) as Cantidad
			from ADTProceso a
			where a.AGTPid = #Arguments.AGTPid#
			  and a.Aid is not null
			  and a.Aplacadestino is not null
			  and (
			  			a.Aiddestino is null
					or
						( 
							select count(1) 
							from Activos b
							where b.Ecodigo = a.Ecodigo
							  and b.Aplaca  = a.Aplacadestino
						) < 1
				) 
			group by a.Aplacadestino
		</cfquery>	

		<!---
			Procesa las transacciones de Adquisicion de los nuevos Activos.  
			Uno por cada placa nueva registrada en un ciclo para hacerlo correctamente.
			Se debe verificar que la placa nueva no exista en la empresa!
		--->
		<cfloop query="rsPlacasNuevas"> 	
			<cfset placaAct = rsPlacasNuevas.Aplacadestino>
            <cfoutput>#placaAct#</cfoutput><br>

			<cfquery name="rsVerificaPlaca" datasource="#Arguments.Conexion#">
				select count(1) as Cantidad
				from Activos
				where Ecodigo = #Arguments.Ecodigo#
				and Aplaca = '#placaAct#'
			</cfquery>
            <cfdump var="#rsVerificaPlaca#">

			<!--- Si la placa destino ya existe, no se incluye el nuevo activo fijo --->
			<cfif rsVerificaPlaca.Cantidad EQ 0>
				<cfquery name="rsActivoActual" datasource="#Arguments.Conexion#">
					select min(Aid) as Aid, min(ADTPlinea) as ADTPlinea
					from ADTProceso
					where AGTPid = #Arguments.AGTPid#
					  and Aplacadestino = '#placaAct#'
					  and Aid is not null
				</cfquery>
				<cfset LvarActivoActual = rsActivoActual.Aid>
				<cfset LvarLineaActual  = rsActivoActual.ADTPlinea>

				<cfquery datasource="#Arguments.Conexion#">
					insert into Activos (
						Ecodigo, ACid, ACcodigo, AFMid, AFMMid, SNcodigo, AFCcodigo, ARcodigo, Adescripcion, Aserie, 
						Aplaca, Astatus, Aid_padre, Areflin, Afechainidep, Afechainirev, Avutil, Avalrescate, Afechaaltaadq)
					select 
						b.Ecodigo, b.ACid, b.ACcodigo, b.AFMid, b.AFMMid, b.SNcodigo, b.AFCcodigo, b.ARcodigo, b.Adescripcion, b.Aserie, 
						'#placaAct#', b.Astatus, b.Aid_padre, b.Areflin, b.Afechainidep, b.Afechainirev, b.Avutil, b.Avalrescate, b.Afechaaltaadq
					from Activos b
					where b.Aid = #LvarActivoActual#
				</cfquery>

				<cfquery datasource="#Arguments.Conexion#">
					insert into #ACT_NUEVOS# (Aid, Placa, AidOri, ADTPlinea)
					select a.Aid, a.Aplaca, b.Aid, b.ADTPlinea
					from ADTProceso b
						inner join Activos a
						on  a.Aplaca  = b.Aplacadestino
						and a.Ecodigo = b.Ecodigo 
					where b.AGTPid        = #Arguments.AGTPid#
					  and ADTPlinea       = #LvarLineaActual#
				</cfquery>
			</cfif>
		</cfloop>				

		<!--- 
			Asocia los Activos Nuevos cuando el Aiddestino es nulo 
		--->
		<cfquery datasource="#Arguments.Conexion#">
			update ADTProceso
			set Aiddestino = (( 
						select min(Activos.Aid)
						from Activos
						where Activos.Ecodigo   = #Arguments.Ecodigo#
						  and Activos.Aplaca    = ADTProceso.Aplacadestino
					))
			where ADTProceso.AGTPid = #Arguments.AGTPid#
			  and ADTProceso.Aiddestino is null
		</cfquery>
						
		<!--- Valida que se hayan creado correctamente todos los Activos --->
		<cfquery name="rsValidaADTProceso" datasource="#Arguments.Conexion#">
			select Aplacadestino
			from ADTProceso
			where AGTPid = #Arguments.AGTPid#
			  and Aiddestino is null
		</cfquery>
		
		<cfif rsValidaADTProceso.recordcount gt 0>
			<h2>Error. No se pudieron crear correctamente los Activos para las siguientes placas (Proceso Cancelado!):</h2><br>
			<cfloop query="rsValidaADTProceso">
				<ul>
				<li>#rsValidaADTProceso.Aplacadestino#</li>
				</ul>
			</cfloop>
			<cfquery name="rs" datasource="#Arguments.Conexion#">
	            select p.Aplacadestino, p.Aiddestino, p.AplacaAnt, p.AplacaNueva, p.Aid, a.Aid as Activo
                from ADTProceso p
                	inner join Activos a
                    on a.Aid = p.Aiddestino
				where p.AGTPid = #Arguments.AGTPid#
                order by 1
            </cfquery>
			<cfdump var="#rs#">

			<cfquery name="rs" datasource="#Arguments.Conexion#">
            	select Aplacadestino, Aiddestino, AplacaAnt, AplacaNueva, Aid
                from ADTProceso
				where AGTPid = #Arguments.AGTPid#
                order by 1
            </cfquery>
			<cfdump var="#rs#">

            <cftransaction action="rollback" />
			<cf_abort errorInterfaz="">
		</cfif>

		<cfset LvarIDcontable = 0>		
		<cfif Arguments.contabilizar is true>
			<cfset LvarIDcontable = fnAsientoTraslado (Arguments.AGTPid, Arguments.Ecodigo, Arguments.descripcion, Arguments.Conexion, Arguments.debug)>
			<cfset LvarIDcontable = fnContabilizaTraslado (Arguments.AGTPid, Arguments.Ecodigo, Arguments.descripcion, Arguments.Conexion, Arguments.debug)>
		</cfif>

		<cfset fnInsertarTransaccionesActivos(Arguments.Conexion, Arguments.Usucodigo, Arguments.AGTPid)>
		<cfset fnActualizarAFSaldos(Arguments.Conexion, Arguments.Ecodigo, Arguments.AGTPid, Arguments.Usucodigo)>
		
		<!--- 
			Crea el vale al Activo Nuevo
		 --->
		 <cfset fechaFin = '01/01/6100'>
		<cfquery datasource="#Arguments.conexion#">
			insert into AFResponsables (
				Ecodigo, DEid, Alm_Aid, Aid, CFid, CRCCid, CRTDid, 
				CRDRdescripcion, CRDRdescdetallada, CRDRtipodocori, 
				CRDRdocori, AFRfini, AFRffin, AFRdocumento, 
				Usucodigo, Ulocalizacion, BMUsucodigo, 
				CRTCid, EOidorden, DOlinea, 
				CRDRlindocori, Monto, CRDRid)
			select 
				b.Ecodigo, b.DEid, b.Alm_Aid, a.Aiddestino, b.CFid, b.CRCCid, b.CRTDid, 
				b.CRDRdescripcion, b.CRDRdescdetallada, b.CRDRtipodocori, 
				b.CRDRdocori, 
 				act.Afechaaltaadq,				
				#lsparsedatetime(fechaFin)#, 
				b.AFRdocumento, #Arguments.Usucodigo#, '00', #Arguments.Usucodigo#, b.CRTCid, b.EOidorden, b.DOlinea, b.CRDRlindocori, b.Monto, b.CRDRid
			from ADTProceso a
				inner join #ACT_NUEVOS# n
					on n.ADTPlinea = a.ADTPlinea
                inner join Activos act
                	on act.Aid=n.Aid    
				inner join AFResponsables b
					on b.Ecodigo = a.Ecodigo
					and b.Aid = a.Aid
					and <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#lvarFechaAux#"> between b.AFRfini and b.AFRffin
			where a.AGTPid = #Arguments.AGTPid#	
		</cfquery>
		<!---Se valida que la Mejora no halla causado Duplicidad de Documentos de Responsabilidad--->
		<cfquery name="rs_Activo" datasource="#Arguments.Conexion#">
			select Aid, Placa from #ACT_NUEVOS#
		</cfquery>
		<cfloop query="rs_Activo">
			<cftry>
				<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Documentos" Aid="#rs_Activo.Aid#"/> 	
				<cfcatch type="any">
					<cfset Error= "<br><table><tr><td>#cfcatch.Message#</td></tr></table>">
					<cfthrow detail="La Aplicación de la transacción, genera la siguiente inconsistencia en el Activo #rs_Activo.Placa#:#Error#">
				</cfcatch>
			</cftry>
		</cfloop>

		<!--- Actualiza Activos, dejandolos con estatus 60 si no tienen saldo --->
		<cfquery name="rsActivosSinSaldo" datasource="#Arguments.Conexion#">
			select distinct a.Aid
			from ADTProceso a
				inner join AFSaldos b
				on  b.Aid        = a.Aid
				and b.AFSperiodo = a.TAperiodo
				and b.AFSmes     = a.TAmes
			where a.AGTPid = #Arguments.AGTPid#
			  and a.Ecodigo = #Arguments.Ecodigo#
			  and round(b.AFSvaladq,2)     = 0
			  and round(b.AFSdepacumadq,2) = 0
			  and round(b.AFSvalmej,2)     = 0
			  and round(b.AFSdepacummej,2) = 0
			  and round(b.AFSvalrev,2)     = 0
			  and round(b.AFSdepacumrev,2) = 0
		</cfquery>
		<cfloop query="rsActivosSinSaldo">
			<cfset LvarAid = rsActivosSinSaldo.Aid>
			<cfquery name="rsActivos" datasource="#Arguments.Conexion#">
				update Activos 
					set Astatus = 60
				where Activos.Aid = #LvarAid#
			</cfquery>
			<!--- 
				Retira el Vale si existe del Activo Anterior si el Activo quedó con saldos en cero 
			--->
			<cfquery datasource="#Arguments.conexion#">
				update AFResponsables
					set AFRffin = <cfqueryparam cfsqltype="cf_sql_date" value="#dateadd('d', -1, lvarFechaAux)#">
				where AFResponsables.Ecodigo = #Arguments.Ecodigo#
				  and AFResponsables.Aid = #LvarAid#
				  and <cfqueryparam cfsqltype="cf_sql_date" value="#lvarFechaAux#"> between AFResponsables.AFRfini and AFResponsables.AFRffin
			</cfquery>
		</cfloop>

		<cfif Arguments.debug>
			<cfquery name="rsActivosDeleted" datasource="#Arguments.conexion#">
				select * 
				from Activos 
				where Astatus = 60
				  and Ecodigo = #Arguments.Ecodigo#
				  and Aid in (
						select Aid 
						from TransaccionesActivos 
						where AGTPid = #Arguments.AGTPid#
				)
			</cfquery>
			<cfdump var="#rsActivosDeleted#" label="Activos Estado 60">
		</cfif>

		<cfif Arguments.debug>
			<cfset verDebugFinal(Arguments.Ecodigo, Arguments.AGTPid, Arguments.Conexion)>
		</cfif>
		
		<!---Borra ADTProceso--->
		<cfquery name="rsDeleteADTProceso" datasource="#Arguments.Conexion#">
			delete from ADTProceso
			where AGTPid = #Arguments.AGTPid#
		</cfquery>
		
		<!---Actualiza estado a AGTProceso--->
		<cfquery name="rsUpdateAGTProceso" datasource="#Arguments.Conexion#">
			update AGTProceso
			set AGTPestadp = 4,
				AGTPfaplica  = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
				AGTPipaplica = '#arguments.ipregistro#',
				Usuaplica    = #Arguments.Usucodigo#
			where AGTPid     = #Arguments.AGTPid#
		</cfquery>
		
		<cfreturn true>
	</cffunction>

	<cffunction name="fnAsientoTraslado" access="private" returntype="numeric" output="no">
		<cfargument name="AGTPid"      type="numeric" required="yes">
		<cfargument name="Ecodigo"     type="numeric" required="yes">
		<cfargument name="descripcion" type="string" required="yes">
		<cfargument name="Conexion"    type="string"  required="yes">
		<cfargument name="debug" type="boolean" required="yes">

		<!--- **************************** C O N T A B I L I Z A C I O N **************************** 
			1. Se deduce del valor de adquisición el traslado de valor original del activo origen ( Tipo Credito )
			2. Se deduce del valor de mejoras  el traslado del activo origen ( tipo Credito )
			3. Se deduce del valor de revaluación  el traslado del activo origen ( tipo Credito )
			4. Se deduce del valor de depreciación de adquisicion el traslado del activo origen ( tipo Debito )
			5. Se deduce del valor de depreciación de mejoras el traslado del activo origen ( tipo Debito )
			6. Se deduce del valor de depreciacion de revaluación el traslado del activo origen ( tipo Debito )

			7. Se aumenta el valor de adquisición el traslado de valor original del activo destino ( Tipo Debito )
			8. Se aumenta el valor de mejoras  el traslado del activo destino ( tipo Debito )
			9. Se aumenta el valor de revaluación  el traslado del activo destino ( tipo Debito )
			10. Se aumenta el valor de depreciación de adquisicion el traslado del activo destino ( tipo Credito )
			11. Se aumenta el valor de depreciación de mejoras el traslado del activo destino ( tipo Credito )
			12. aumenta el valor de depreciacion de revaluación el traslado del activo destino ( tipo Credito )

			SI EL TRASLADO ES A UN ACTIVO EXISTENTE, LO QUE SE LE CONTABILIZA AL ACTIVO DESTINO ES UNA MEJORA.  
			EN CASO CONTRARIO, SE CONTABILIZA UNA ADQUISICION
			Se trata de un Activo nuevo si está en la tabla de Activos Nuevos! En caso contrario es una mejora
		--->
		<cfset hoy= "#dateformat(now(), "DDMMYYYY")#">
		<cfquery datasource="#Arguments.Conexion#">
			insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, CFid)
			select 
					'AFTR',
					1,
					<cf_dbfunction name="to_char" args="g.AGTPdocumento">, 
					'TR',
					a.TAmontolocadq,
					'C',
					<cf_dbfunction name="sPart"	args="{fn concat('Retiro Adquisición: ', b.Adescripcion)}|1|80" delimiters="|">,
                    '#hoy#',<!---String(8)--->
					1.00,
					#rsPeriodo.value#, 
					#rsMes.value#,
					c.ACcadq,
					#rsMoneda.value#,
					d.Ocodigo,
					a.TAmontolocadq,
                    a.CFid
			from ADTProceso a
				inner join Activos b
					on b.Aid = a.Aid
				inner join AClasificacion c
					on c.Ecodigo   = b.Ecodigo
					and c.ACcodigo = b.ACcodigo
					and c.ACid     = b.ACid
				inner join CFuncional d
					on d.CFid = a.CFid
				inner join AGTProceso g
					on g.AGTPid = a.AGTPid
			where a.AGTPid = #Arguments.AGTPid#
			  and a.TAmontolocadq <> 0
		</cfquery>

		<cfquery datasource="#Arguments.Conexion#">
			insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, CFid)
			select 
					'AFTR',
					1,
					<cf_dbfunction name="to_char" args="g.AGTPdocumento">, 
					'TR',
					a.TAmontolocmej,
					'C',
                    <cf_dbfunction name="sPart"	args="{fn concat('Retiro Mejoras: ', b.Adescripcion)}|1|80" delimiters="|">,
					'#hoy#',
					1.00,
					#rsPeriodo.value#, 
					#rsMes.value#,
					c.ACcadq,
					#rsMoneda.value#,
					d.Ocodigo,
					a.TAmontolocmej,
                    a.CFid
			from ADTProceso a
				inner join Activos b
					on b.Aid = a.Aid
				inner join AClasificacion c
					on c.Ecodigo = b.Ecodigo
					and c.ACcodigo = b.ACcodigo
					and c.ACid = b.ACid
				inner join CFuncional d
					on d.CFid = a.CFid
				inner join AGTProceso g
					on g.AGTPid = a.AGTPid
			where a.AGTPid = #Arguments.AGTPid#
			  and a.TAmontolocmej <> 0
		</cfquery>

		<cfquery datasource="#Arguments.Conexion#">
			insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, CFid)
			select 
					'AFTR',
					1,
					<cf_dbfunction name="to_char" args="g.AGTPdocumento">, 
					'TR',
					a.TAmontolocrev,
					'C',
					<cf_dbfunction name="sPart"	args="{fn concat('Retiro Revaluación: ', b.Adescripcion)}|1|80" delimiters="|">,
					'#hoy#',
					1.00,
					#rsPeriodo.value#, 
					#rsMes.value#,
					c.ACcrevaluacion,
					#rsMoneda.value#,
					d.Ocodigo,
					a.TAmontolocrev,
                    a.CFid
			from ADTProceso a
				inner join Activos b
					on b.Aid = a.Aid
				inner join AClasificacion c
					on c.Ecodigo   = b.Ecodigo
					and c.ACcodigo = b.ACcodigo
					and c.ACid     = b.ACid
				inner join CFuncional d
					on  d.CFid = a.CFid
				inner join AGTProceso g
					on g.AGTPid = a.AGTPid
			where a.AGTPid = #Arguments.AGTPid#
			  and a.TAmontolocrev <> 0
		</cfquery>
		
		<cfquery datasource="#Arguments.Conexion#">
			insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, CFid)
			select 
					'AFTR',
					1,
					<cf_dbfunction name="to_char" args="g.AGTPdocumento">, 
					'TR',
					TAmontodepadq,
					'D',
                    <cf_dbfunction name="sPart"	args="{fn concat('Retiro Depr. Adq.: ', b.Adescripcion)}|1|80" delimiters="|">,
					'#hoy#',
					1.00,
					#rsPeriodo.value#, 
					#rsMes.value#,
					c.ACcdepacum,
					#rsMoneda.value#,
					d.Ocodigo,
					TAmontodepadq,
                    a.CFid
			from ADTProceso a
				inner join Activos b
					on b.Aid = a.Aid
				inner join AClasificacion c
					on c.Ecodigo = b.Ecodigo
					and c.ACcodigo = b.ACcodigo
					and c.ACid = b.ACid
				inner join CFuncional d
					on d.CFid = a.CFid
				inner join AGTProceso g
					on g.AGTPid = a.AGTPid
			where a.AGTPid = #Arguments.AGTPid#
			  and TAmontodepadq <>  0
		</cfquery>
		
		<cfquery datasource="#Arguments.Conexion#">
			insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, CFid)
			select 
					'AFTR',
					1,
					<cf_dbfunction name="to_char" args="g.AGTPdocumento">, 
					'TR',
					TAmontodepmej,
					'D',
                    <cf_dbfunction name="sPart"	args="{fn concat('Retiro Depr. Mej: ', b.Adescripcion)}|1|80" delimiters="|">,
					'#hoy#',
					1.00,
					#rsPeriodo.value#, 
					#rsMes.value#,
					c.ACcdepacum,
					#rsMoneda.value#,
					d.Ocodigo,
					TAmontodepmej,
                    a.CFid
			from ADTProceso a
				inner join Activos b
					on b.Aid = a.Aid
				inner join AClasificacion c
					on c.Ecodigo = b.Ecodigo
					and c.ACcodigo = b.ACcodigo
					and c.ACid = b.ACid
				inner join CFuncional d
					on d.CFid = a.CFid
				inner join AGTProceso g
					on g.AGTPid = a.AGTPid
			where a.AGTPid = #Arguments.AGTPid#
			  and TAmontodepmej <> 0
		</cfquery>
		
		<cfquery datasource="#Arguments.Conexion#">
			insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, CFid)
			select 
					'AFTR',
					1,
					<cf_dbfunction name="to_char" args="g.AGTPdocumento">, 
					'TR',
					TAmontodeprev,
					'D',
                    <cf_dbfunction name="sPart"	args="{fn concat('Retiro Depr. Rev: ', b.Adescripcion)}|1|80" delimiters="|">,
					'#hoy#',
					1.00,
					#rsPeriodo.value#, 
					#rsMes.value#,
					c.ACcdepacumrev,
					#rsMoneda.value#,
					d.Ocodigo,
					TAmontodeprev,
                    a.CFid
			from ADTProceso a
				inner join Activos b
					on b.Aid = a.Aid
				inner join AClasificacion c
					on c.Ecodigo = b.Ecodigo
					and c.ACcodigo = b.ACcodigo
					and c.ACid = b.ACid
				inner join CFuncional d
					on d.CFid = a.CFid
				inner join AGTProceso g
					on g.AGTPid = a.AGTPid
			where a.AGTPid = #Arguments.AGTPid#
			  and TAmontodeprev <> 0
		</cfquery>

		<!--- Destinos: --->
		<cfquery datasource="#Arguments.Conexion#">
			insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, CFid)
			select 
					'AFTR',
					1,
					<cf_dbfunction name="to_char" args="g.AGTPdocumento">, 
					'TR',
					a.TAmontolocadq,
					'D',
                    <cf_dbfunction name="sPart"	args="{fn concat('Adquisición: ' , b.Adescripcion)}|1|80" delimiters="|">,
					'#hoy#',
					1.00,
					#rsPeriodo.value#, 
					#rsMes.value#,
					c.ACcadq,
					#rsMoneda.value#,
					d.Ocodigo,
					a.TAmontolocadq,
                    a.CFid
			from ADTProceso a

				inner join #ACT_NUEVOS# n
				on n.ADTPlinea = a.ADTPlinea
				
				inner join Activos b
					on b.Aid = a.Aiddestino

				inner join AClasificacion c
					on c.Ecodigo = b.Ecodigo
					and c.ACcodigo = b.ACcodigo
					and c.ACid = b.ACid

				inner join CFuncional d
					on d.CFid = a.CFiddest

				inner join AGTProceso g
					on g.AGTPid = a.AGTPid

			where a.AGTPid = #Arguments.AGTPid#
			  and a.TAmontolocadq <> 0
		</cfquery>

		<cfquery datasource="#Arguments.Conexion#">
			insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, CFid)
			select 
					'AFTR',
					1,
					<cf_dbfunction name="to_char" args="g.AGTPdocumento">, 
					'TR',
					
					case when n.Placa is not null
						then a.TAmontolocmej
						else (a.TAmontolocmej + a.TAmontolocadq)
					end,
					'D',
                    <cf_dbfunction name="sPart"	args="{fn concat('Mejora: ' , b.Adescripcion)}|1|80" delimiters="|">,
					'#hoy#',
					1.00,
					#rsPeriodo.value#, 
					#rsMes.value#,
					c.ACcadq,
					#rsMoneda.value#,
					d.Ocodigo,
					
					case when n.Placa is not null
						then a.TAmontolocmej
						else (a.TAmontolocmej + a.TAmontolocadq)
					end,
                    a.CFid
			from ADTProceso a
				inner join Activos b
					on b.Aid = a.Aiddestino
				inner join AClasificacion c
					on c.Ecodigo = b.Ecodigo
					and c.ACcodigo = b.ACcodigo
					and c.ACid = b.ACid
				inner join CFuncional d
					on d.CFid = a.CFiddest
				inner join AGTProceso g
					on g.AGTPid = a.AGTPid
				left outer join #ACT_NUEVOS# n
					on n.ADTPlinea = a.ADTPlinea
			where a.AGTPid = #Arguments.AGTPid#
		</cfquery>

		<cfquery datasource="#Arguments.Conexion#">
			insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, CFid)
			select 
					'AFTR',
					1,
					<cf_dbfunction name="to_char" args="g.AGTPdocumento">, 
					'TR',
					a.TAmontolocrev,
					'D',
					<cf_dbfunction name="sPart"	args="{fn concat('Revaluación: ', b.Adescripcion)}|1|80" delimiters="|">,
					'#hoy#',
					1.00,
					#rsPeriodo.value#, 
					#rsMes.value#,
					c.ACcrevaluacion,
					#rsMoneda.value#,
					d.Ocodigo,
					a.TAmontolocrev,
                    a.CFid
			from ADTProceso a
				inner join Activos b
					on b.Aid = a.Aiddestino
				inner join AClasificacion c
					on c.Ecodigo = b.Ecodigo
					and c.ACcodigo = b.ACcodigo
					and c.ACid = b.ACid
				inner join CFuncional d
					on d.CFid = a.CFiddest
				inner join AGTProceso g
					on g.AGTPid = a.AGTPid
			where a.AGTPid = #Arguments.AGTPid#
		</cfquery>
		
		<cfquery datasource="#Arguments.Conexion#">
			insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, CFid)
			select 
					'AFTR',
					1,
					<cf_dbfunction name="to_char" args="g.AGTPdocumento">, 
					'TR',
					TAmontodepadq,
					'C',
                    <cf_dbfunction name="sPart"	args="{fn concat('Depr. Adq: ', b.Adescripcion)}|1|80" delimiters="|">,
					'#hoy#',
					1.00,
					#rsPeriodo.value#, 
					#rsMes.value#,
					c.ACcdepacum,
					#rsMoneda.value#,
					d.Ocodigo,
					TAmontodepadq,
                    a.CFid
			from ADTProceso a
				inner join Activos b
					on b.Aid = a.Aiddestino

				inner join #ACT_NUEVOS# n
					on n.ADTPlinea = a.ADTPlinea

				inner join AClasificacion c
					on c.Ecodigo = b.Ecodigo
					and c.ACcodigo = b.ACcodigo
					and c.ACid = b.ACid
				inner join CFuncional d
					on d.CFid = a.CFiddest
				inner join AGTProceso g
					on g.AGTPid = a.AGTPid

			where a.AGTPid = #Arguments.AGTPid#
		</cfquery>
							
		<cfquery datasource="#Arguments.Conexion#">
			insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, CFid)
			select 
					'AFTR',
					1,
					<cf_dbfunction name="to_char" args="g.AGTPdocumento">, 
					'TR',
					
					case when n.Placa is not null
						then TAmontodepmej
						else 
						(TAmontodepmej + TAmontodepadq)
					end,
					
					'C',
					<cf_dbfunction name="sPart"	args="{fn concat('Depr. Mejoras: ', b.Adescripcion)}|1|80" delimiters="|">,
					'#hoy#',
					1.00,
					#rsPeriodo.value#, 
					#rsMes.value#,
					c.ACcdepacum,
					#rsMoneda.value#,
					d.Ocodigo,
					
					case when n.Placa is not null
						then TAmontodepmej
						else (TAmontodepmej + TAmontodepadq)
                        end,
                    a.CFid
			from ADTProceso a
				inner join Activos b
					on  b.Aid = a.Aiddestino
				inner join AClasificacion c
					on c.Ecodigo = b.Ecodigo
					and c.ACcodigo = b.ACcodigo
					and c.ACid = b.ACid
				inner join CFuncional d
					on d.CFid = a.CFiddest
				inner join AGTProceso g
					on g.AGTPid = a.AGTPid
				left outer join #ACT_NUEVOS# n
					on n.ADTPlinea = a.ADTPlinea
			where a.AGTPid = #Arguments.AGTPid#
		</cfquery>
		
		<cfquery datasource="#Arguments.Conexion#">
			insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, CFid)
			select 
					'AFTR',
					1,
					<cf_dbfunction name="to_char" args="g.AGTPdocumento">, 
					'TR',
					TAmontodeprev,
					'C',
                    <cf_dbfunction name="sPart"	args="{fn concat('Depr Rev: ', b.Adescripcion)}|1|80" delimiters="|">,
					'#hoy#',
					1.00,
					#rsPeriodo.value#, 
					#rsMes.value#,
					c.ACcdepacumrev,
					#rsMoneda.value#,
					d.Ocodigo,
					TAmontodeprev,
                    a.CFid
			from ADTProceso a
				inner join Activos b
					on b.Aid = a.Aiddestino
				inner join AClasificacion c
					on c.Ecodigo = b.Ecodigo
					and c.ACcodigo = b.ACcodigo
					and c.ACid = b.ACid
				inner join CFuncional d
					on d.CFid = a.CFiddest
				inner join AGTProceso g
					on g.AGTPid = a.AGTPid
			where a.AGTPid = #Arguments.AGTPid#
		</cfquery>
        <cfreturn 1>
	</cffunction>

	<cffunction name="fnContabilizaTraslado" access="private" returntype="numeric" output="no">
		<cfargument name="AGTPid"      type="numeric" required="yes">
		<cfargument name="Ecodigo"     type="numeric" required="yes">
		<cfargument name="descripcion" type="string" required="yes">
		<cfargument name="Conexion"    type="string"  required="yes">
		<cfargument name="debug" type="boolean" required="yes">
		
		<!--- Obtiene la minima oficina para la empresa. (La oficina se le manda al genera asiento para que agrupe) --->
		<cfquery name="rsMinOficina" datasource="#session.dsn#">
			Select Min(Ocodigo) as MinOcodigo
			from Oficinas
			where Ecodigo = #Arguments.Ecodigo#
		</cfquery>					
		<cfif isdefined("rsMinOficina") and rsMinOficina.recordcount GT 0>
			<cfset LvarOcodigo = rsMinOficina.MinOcodigo>
		<cfelse>
			<cfset LvarOcodigo = -100>
		</cfif>					
		
		<!--- Genera Asiento --->
		<cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="GeneraAsiento" returnvariable="res_GeneraAsiento">
			<cfinvokeargument name="Conexion" value="#Arguments.Conexion#"/>
			<cfinvokeargument name="Ecodigo" value="#Arguments.Ecodigo#"/>
			<cfinvokeargument name="Oorigen" value="AFTR"/>
			<cfinvokeargument name="Eperiodo" value="#rsPeriodo.value#"/>
			<cfinvokeargument name="Emes" value="#rsMes.value#"/>
			<cfinvokeargument name="Efecha" value="#lvarFechaAux#"/>
			<cfinvokeargument name="Edescripcion" value="#Arguments.descripcion#"/>
			<cfinvokeargument name="Edocbase" value="#rsAGTProcesoDoc.AGTPdocumento#"/>
			<cfinvokeargument name="Ereferencia" value="TR"/>
			<cfinvokeargument name="Ocodigo" value="#LvarOcodigo#"/>
			<cfinvokeargument name="Debug" value="#Arguments.Debug#"/>
		</cfinvoke>
		<cfreturn res_GeneraAsiento>
	</cffunction>

	<cffunction name="fnActualizarAFSaldos" access="private" output="no">
		<cfargument name="Conexion" 	type="string"	 required="yes">
		<cfargument name="Ecodigo"		 type="numeric" required="yes">
		<cfargument name="AGTPid"		 type="numeric" required="yes">
		<cfargument name="Usucodigo"	 type="numeric" required="yes">

		<!--- Inserta en AFSaldos el Activo Destino cuando no existía --->
		<cfquery name="rsAFSaldos" datasource="#Arguments.Conexion#">
			insert into AFSaldos 
				(Aid, Ecodigo, CFid, AFCcodigo, ACid, ACcodigo, AFSperiodourev, AFSmesurev, AFSperiodo, AFSmes, 
				AFSvutiladq, AFSvutilrev, AFSsaldovutiladq, AFSsaldovutilrev, 
				AFSvaladq, AFSvalmej, AFSvalrev, 
				AFSdepacumadq, AFSdepacummej, AFSdepacumrev, 
				AFSmetododep, AFSdepreciable, AFSrevalua, 
				BMUsucodigo, Ocodigo)
			select 
				a.Aiddestino,  b.Ecodigo, b.CFid, b.AFCcodigo, b.ACid, b.ACcodigo, b.AFSperiodourev, b.AFSmesurev, b.AFSperiodo, b.AFSmes, 
				b.AFSvutiladq, b.AFSvutilrev, a.TAvutil, a.TAvutil, 
				0.00, 0.00, 0.00, 0.00, 0.00, 0.00,
				b.AFSmetododep, b.AFSdepreciable, b.AFSrevalua, 
				#Arguments.Usucodigo#, b.Ocodigo
			from #ACT_NUEVOS# n
				inner join ADTProceso a
				on a.ADTPlinea = n.ADTPlinea
				
				inner join AFSaldos b
				on b.Aid = a.Aid
				and b.AFSperiodo = a.TAperiodo
				and b.AFSmes = a.TAmes			
			where (
				select count(1)
				from AFSaldos x
					where x.Aid 			= a.Aiddestino
					  and x.AFSperiodo 		= a.TAperiodo
					  and x.AFSmes 			= a.TAmes
					  and x.Ecodigo 	= a.Ecodigo
				) = 0
		</cfquery>
		 
		<!--- Actualizar AFSaldos para los activos Origen de las transferencias --->
		<cfquery name="rsAFSaldos" datasource="#Arguments.Conexion#">
				select 
					Aid, TAperiodo, TAmes, 
					coalesce((TAmontolocadq),0.00) as TAmontolocadq,
					coalesce((TAmontolocmej),0.00) as TAmontolocmej, 			 
					coalesce((TAmontolocrev),0.00) as TAmontolocrev,		
					coalesce((TAmontodepadq),0.00) as TAmontodepadq,
					coalesce((TAmontodepmej),0.00) as TAmontodepmej,
					coalesce((TAmontodeprev),0.00) as TAmontodeprev
				from #ADTProceso_ori#
		</cfquery>

		<cfloop query="rsAFSaldos">
			<cfquery datasource="#Arguments.Conexion#">
					UPDATE AFSaldos 
					set   AFSvaladq 	= AFSvaladq - #rsAFSaldos.TAmontolocadq#
						, AFSvalmej 	= AFSvalmej - #rsAFSaldos.TAmontolocmej#  			 
						, AFSvalrev 	= AFSvalrev - #rsAFSaldos.TAmontolocrev#		
						, AFSdepacumadq = AFSdepacumadq - #rsAFSaldos.TAmontodepadq#
						, AFSdepacummej = AFSdepacummej - #rsAFSaldos.TAmontodepmej#
						, AFSdepacumrev = AFSdepacumrev - #rsAFSaldos.TAmontodeprev#
					where AFSaldos.Aid        = #rsAFSaldos.Aid# 
					  and AFSaldos.AFSperiodo  = #rsAFSaldos.TAperiodo# 
					  and AFSaldos.AFSmes      = #rsAFSaldos.TAmes#
			</cfquery>
		</cfloop>		

		<!--- Actualizar AFSaldos para los activos Destino de las transferencias --->
		<cfquery name="rsAFSaldos" datasource="#Arguments.Conexion#">
				select 
					t.Aiddestino as Aid, t.TAperiodo, t.TAmes, 
					coalesce(sum(t.TAmontolocadq),0.00) as TAmontolocadq,
					coalesce(sum(t.TAmontolocmej),0.00) as TAmontolocmej, 			 
					coalesce(sum(t.TAmontolocrev),0.00) as TAmontolocrev,		
					coalesce(sum(t.TAmontodepadq),0.00) as TAmontodepadq,
					coalesce(sum(t.TAmontodepmej),0.00) as TAmontodepmej,
					coalesce(sum(t.TAmontodeprev),0.00) as TAmontodeprev,
					(( 
						select count(1) 
						from #ACT_NUEVOS# n
						where n.Aid = t.Aiddestino
					)) as NuevoActivo
				from ADTProceso t
				where t.AGTPid = #Arguments.AGTPid#
				group by t.Aiddestino, t.TAperiodo, t.TAmes
		</cfquery>
		
		<cfloop query="rsAFSaldos">
			<cfset ActNuevo = false>
			<cfif rsAFSaldos.NuevoActivo GT 0>
				<cfset ActNuevo = true>
			</cfif>

			<cfquery datasource="#Arguments.Conexion#">
				UPDATE AFSaldos 
				set 
					<cfif Actnuevo>
						AFSvaladq = AFSvaladq + #rsAFSaldos.TAmontolocadq#
					,	AFSvalmej = AFSvalmej + #rsAFSaldos.TAmontolocmej#
					<cfelse>
						AFSvalmej = AFSvalmej + #rsAFSaldos.TAmontolocmej# + #rsAFSaldos.TAmontolocadq#
					</cfif>
					,	AFSvalrev = AFSvalrev + #rsAFSaldos.TAmontolocrev#
					<cfif Actnuevo>
					,	AFSdepacumadq = AFSdepacumadq + #rsAFSaldos.TAmontodepadq#
					, 	AFSdepacummej = AFSdepacummej + #rsAFSaldos.TAmontodepmej#
					<cfelse>
					, 	AFSdepacummej = AFSdepacummej + #rsAFSaldos.TAmontodepmej# + #rsAFSaldos.TAmontodepadq#
					</cfif>
					,	AFSdepacumrev = AFSdepacumrev + #rsAFSaldos.TAmontodeprev#
				where AFSaldos.Aid        = #rsAFSaldos.Aid# 
				  and AFSaldos.AFSperiodo  = #rsAFSaldos.TAperiodo# 
				  and AFSaldos.AFSmes      = #rsAFSaldos.TAmes#
			</cfquery>
		</cfloop>		

		<!--- Validación de saldos negativos --->
		<!--- Actualiza los saldos de las placas origenes que aparecen n veces--->
		<cfquery name="rsAFSaldos" datasource="#Arguments.Conexion#">
				select a.Aid, a.Aplaca, 
					s.AFSvaladq, s.AFSvalmej, s.AFSvalrev,
					s.AFSdepacumadq, s.AFSdepacummej, s.AFSdepacumrev
				from #ADTProceso_ori# ADTProceso
					inner join Activos a
						on a.Aid = ADTProceso.Aid
					inner join AFSaldos s
						on s.Aid         = ADTProceso.Aid
						and s.AFSperiodo = ADTProceso.TAperiodo
						and s.AFSmes     = ADTProceso.TAmes
				where 
					   s.AFSvaladq  < 0
					or s.AFSvalmej < 0
					or s.AFSvalrev < 0
					or s.AFSdepacumadq < 0 
					or s.AFSdepacummej < 0
					or s.AFSdepacumrev < 0
		</cfquery>
		
		<cfif rsAFSaldos.recordcount GT 0>
			<cf_errorCode	code = "50929"
							msg  = "Existen @errorDat_1@ activos que quedan con saldos menores a cero. Proceso Cancelado"
							errorDat_1="#rsAFSaldos.recordcount#"
			>}
			<cftransaction action="rollback" />
			<cf_abort errorInterfaz="">
		</cfif>
	</cffunction>

	<cffunction name="fnInsertarTransaccionesActivos" access="private" output="no">
		<cfargument name="Conexion"		 type="string"		 required="yes">
		<cfargument name="Usucodigo"	 type="numeric"		 required="yes">
		<cfargument name="AGTPid"		 type="numeric"		 required="yes">
		
			<!---Inserta en TransaccionesActivos el Traslado--->
			<cfquery name="rsTransaccionesActivos" datasource="#Arguments.Conexion#">
				insert into TransaccionesActivos(
					Ecodigo,		
					Aid,			
					IDtrans,	
					CFid,	
					TAperiodo,		
					TAmes,			
					TAfecha,		
					TAfalta,
					TAmontooriadq, 	
					TAmontolocadq,	
					TAmontoorimej,		
					TAmontolocmej,		
					TAmontoorirev, 	
					TAmontolocrev,
					TAmontodepadq, 	
					TAmontodepmej,	
					TAmontodeprev,		
					TAvaladq,			
					TAvalmej,		
					TAvalrev,
					TAdepacumadq,  	
					TAdepacummej, 	
					TAdepacumrev,		
					TAmontolocventa,	
					Icodigo,		
					TAsuperavit,
					Mcodigo,		
					TAtipocambio,	
					IDcontable,			
					Ccuenta,			
					AGTPid,			
					Usucodigo,
					TAfechainidep,		
					TAvalrescate,		
					TAvutil,		
					TAfechainirev,
					TAmeses,		
					Aiddestino,		
					Aplacadestino,		
					ADTPrazon
				)
				select 
					a.Ecodigo,		
					a.Aid,			
					a.IDtrans,			
					a.CFid,			
					a.TAperiodo,			
					a.TAmes,	
					a.TAfecha,		
					a.TAfalta,
					a.TAmontolocadq, 
					a.TAmontolocadq,	
					a.TAmontolocmej,	
					a.TAmontolocmej,	
					a.TAmontolocrev,	
					a.TAmontolocrev,
					a.TAmontodepadq, 
					a.TAmontodepmej,	
					a.TAmontodeprev,	
					a.TAvaladq,			
					a.TAvalmej,			
					a.TAvalrev,
					a.TAdepacumadq,  
					a.TAdepacummej,	
					a.TAdepacumrev,		
					a.TAmontolocventa,	
					a.Icodigo,			
					a.TAsuperavit,
					a.Mcodigo, 		 
					a.TAtipocambio,	
					#LvarIDcontable#,
					(Select ACcadq
						from AClasificacion acl
						where acl.ACid = b.ACid
						   and acl.ACcodigo = b.ACcodigo
						   and acl.Ecodigo = b.Ecodigo) as Ccuenta,						
					a.AGTPid,
					#Arguments.Usucodigo#,
					b.Afechainidep,	
					b.Avalrescate,	
					a.TAvutil,	
					b.Afechainirev,	
					a.TAmeses,	
					a.Aiddestino,	
					a.Aplacadestino, 
					a.ADTPrazon
				from ADTProceso a
					inner join Activos b 
						on b.Aid = a.Aid
				where a.AGTPid = #Arguments.AGTPid#
			</cfquery>
	
			<!--- Incluir las transacciones de los Activos Nuevos ( Adquisiciones por efecto de la transferencia --->
			<cfquery datasource="#Arguments.Conexion#">
				insert into TransaccionesActivos(
					Ecodigo,		Aid,			IDtrans,		CFid,				TAperiodo,
					TAmes,			TAfecha,		TAfalta,		TAmontooriadq,		TAmontolocadq,
					TAmontoorimej,	TAmontolocmej,	TAmontoorirev,	TAmontolocrev,		TAmontodepadq,
					TAmontodepmej,	TAmontodeprev,	TAvaladq,		TAvalmej,			TAvalrev,
					TAdepacumadq,	TAdepacummej,	TAdepacumrev,	TAmontolocventa,	Icodigo,
					TAsuperavit,	Mcodigo,		TAtipocambio,	IDcontable,			Ccuenta,
					AGTPid,			Usucodigo,		TAdocumento,	TAreferencia,		TAfechainidep,
					TAvalrescate,	TAvutil,		TAfechainirev,	TAmeses,			Aiddestino,
					ADTPrazon			
				)
				select  
					b.Ecodigo,		b.Aid,			1 as IDtrans,	CFiddest,				TAperiodo,
					a.TAmes,		a.TAfecha,		a.TAfalta,		
					
						(CASE WHEN a.TAmontolocadq = 0
							THEN a.TAmontolocmej
							ELSE a.TAmontolocadq 
						END) as TAmontooriadq,
					
						(CASE WHEN a.TAmontooriadq = 0
							THEN a.TAmontolocmej
							ELSE a.TAmontolocadq 
						END) as TAmontolocadq,
					0.00 as TAmontoorimej,
					0.00 as TAmontolocmej,
					0.00 as TAmontoorirev,
					0.00 as TAmontolocrev,
					
						(CASE WHEN a.TAmontolocadq = 0
							THEN a.TAmontodepmej	
							ELSE a.TAmontodepadq 
						END) as TAmontodepadq, 
					
						(CASE WHEN a.TAmontolocadq = 0
							THEN 0
							ELSE a.TAmontodepmej 
						END) as TAmontodepmej, 
					0.00 as TAmontodeprev,
					0.00 as TAvaladq,
					0.00 as TAvalmej,
					0.00 as TAvalrev,
					0.00 as TAdepacumadq,
					0.00 as TAdepacummej,
					0.00 as TAdepacumrev,
					a.TAmontolocventa,
					a.Icodigo,
					a.TAsuperavit,
					a.Mcodigo,
					a.TAtipocambio,
					#LvarIDcontable#,
					a.Ccuenta,
					a.AGTPid,
					a.Usucodigo,
					a.TAdocumento,
					a.TAreferencia,
					a.TAfechainidep,
					a.TAvalrescate,
					a.TAvutil,
					a.TAfechainirev,
					a.TAmeses,
					a.Aiddestino,
					a.ADTPrazon
				from #ACT_NUEVOS# n
					inner join ADTProceso a
						on a.ADTPlinea    = n.ADTPlinea
					inner join Activos b
						on  b.Aid    = n.Aid
						and b.Aplaca = n.Placa
			</cfquery>
	
			<!---
				Inserta en TransaccionesActivos la Mejora de el Activo Destino ya Existente
					Pregunta que no exista en la tabla de los activos nuevos en el caso del activo destino debido a que el activo nuevo no debe ingresar mejora 
			--->
	
			<cfquery name="rsTransaccionesActivoDestino" datasource="#Arguments.Conexion#">
				insert into TransaccionesActivos(
					Ecodigo,		
                    Aid,			
                    IDtrans,		
                    CFid,		
                    TAperiodo,			
                    TAmes,			
                    TAfecha,			
                    TAfalta,
					TAmontooriadq,	
                    TAmontolocadq,
                    	
                    TAmontoorimej,	
                    TAmontolocmej,	
                    TAmontoorirev,	
                    TAmontolocrev,
					TAmontodepadq,	
                    TAmontodepmej,	
                    TAmontodeprev,	
                    TAvaladq,		
                    TAvalmej,		
                    TAvalrev,
                    
					TAdepacumadq,	
                    TAdepacummej,	
                    TAdepacumrev,	
                    TAmontolocventa,
					Icodigo,		
                    TAsuperavit,	
                    Mcodigo,		
                    TAtipocambio,	
                    AGTPid,
					Usucodigo,		
                    TAfechainidep,	
                    TAvalrescate,
					TAvutil,		
                    TAfechainirev,	
                    TAmeses,		
					IDcontable,		
                    ADTPrazon 
				)
				select 
					a.Ecodigo,		
                    a.Aiddestino,	
                    2,	
                    a.CFiddest,		
                    a.TAperiodo,		
                    a.TAmes,		
                    a.TAfecha,			
                    a.TAfalta,
					0.00,		
                    0.00,
                    
                    (a.TAmontolocadq + a.TAmontolocmej),	
                    (a.TAmontolocadq + a.TAmontolocmej),
					0.00,		
                    0.00,	
                    0.00,				
                    (a.TAmontodepadq + a.TAmontodepmej),
					0.00,		
                    a.TAvaladq,				
                    a.TAvalmej,				
                    a.TAvalrev,
                    
					a.TAdepacumadq,				
                    a.TAdepacummej,			
                    a.TAdepacumrev,
					a.TAmontolocventa,			
                    a.Icodigo,				
                    a.TAsuperavit,			
                    a.Mcodigo,		
                    a.TAtipocambio,
					a.AGTPid,					
                    #Arguments.Usucodigo#,	
                    
					b.Afechainidep,				
                    b.Avalrescate,			
                    a.TAvutil,				
                    b.Afechainirev,
					0 as TAmeses,				
					#LvarIDcontable#,			
                    'Mej. Gen. Proc. Traslados'
				from ADTProceso a
					inner join Activos b 
						on b.Ecodigo = a.Ecodigo
						and b.Aid = a.Aid
				where a.AGTPid = #Arguments.AGTPid#
				and (
						Select count(1)
						from #ACT_NUEVOS# c
						where c.ADTPlinea = a.ADTPlinea
					) = 0
			</cfquery>
	</cffunction>

	<cffunction name="fnIsNull" access="private" returntype="boolean" output="no">
		<cfargument name="lValue" required="yes" type="any">
		<cfargument name="IValueIfNull" required="yes" type="any">
		<cfif len(trim(lValue))>
			<cfreturn lValue>
		<cfelse>
			<cfreturn lValueIfNull>
		</cfif>
	</cffunction>

	<cffunction name="AplicarMascara" access="public" output="no" returntype="string">
		<cfargument name="cuenta"   type="string" required="true">
		<cfargument name="objgasto" type="string" required="true">

		<cfset vCuenta = arguments.cuenta >
		<cfset vObjgasto = arguments.objgasto >

		<cfif len(trim(vCuenta))>
			<cfloop condition="Find('?',vCuenta,0) neq 0">
				<cfif len(trim(vObjgasto))>
					<cfset caracter = mid(vObjgasto, 1, 1) >
					<cfset vObjgasto = mid(vObjgasto, 2, len(vObjgasto)) >
					<cfset vCuenta = replace(vCuenta,'?',caracter) >
				<cfelse>
					<cfbreak>
				</cfif>
			</cfloop>
		</cfif>
		<cfreturn vCuenta >
	</cffunction>

	<cffunction name="fnVerifica" access="private" output="no" hint="Validaciones Iniciales y Actualizacion Inicial de Datos de la relacion" returntype="numeric">
		<cfargument name="AGTPid"   type="numeric"	 required="yes">	
		<cfargument name="Ecodigo"  type="numeric"	 required="yes">	
		<cfargument name="Conexion" type="string"	 required="yes">	
		<cfset LvarCantidadErrores = 0>
        <cfset LarrErreres = arraynew(1)>

			<!--- 0.  Valida que el AGTPid corresponda a un Proceso Válido y que tenga registros --->
			<cfquery name="rs" datasource="#Arguments.Conexion#">
				select count(1) as cuantos 
                from AGTProceso
				where AGTPid = #Arguments.AGTPid#
				and AGTPestadp in (0,2)
			</cfquery>
			
			<cfif rs.cuantos NEQ 1>
				<cfset LvarCantidadErrores = LvarCantidadErrores + 1>
                <cfset LarrErrores[LvarCantidadErrores] = "El Grupo de Transacciones seleccionado es inválido o no se ha encontrado!">
			</cfif>

			<cfquery name="rs" datasource="#Arguments.Conexion#">
				select count(1) as cuantos 
                from ADTProceso
				where AGTPid = #Arguments.AGTPid#
			</cfquery>
			
			<cfif rs.cuantos LT 1>
				<cfset LvarCantidadErrores = LvarCantidadErrores + 1>
                <cfset LarrErrores[LvarCantidadErrores] = "No existen activos  a transferir en la Relación!">
			</cfif>

			<cfquery name="rsPeriodo" datasource="#Arguments.Conexion#">
				select Pvalor as value
				from Parametros
				where Ecodigo = #Arguments.Ecodigo#
					and Pcodigo = 50
			</cfquery>
			<cfquery name="rsMes" datasource="#Arguments.Conexion#">
				select Pvalor as value
				from Parametros
				where Ecodigo = #Arguments.Ecodigo#
					and Pcodigo = 60
			</cfquery>
			<cfquery name="rsMoneda" datasource="#Arguments.Conexion#">
				select Mcodigo as value
				from Empresas 
				where Ecodigo = #Arguments.Ecodigo#
			</cfquery>
			<cfif rsPeriodo.recordcount eq 0 or len(trim(rsPeriodo.value)) eq 0>
				<cfset LvarCantidadErrores = LvarCantidadErrores + 1>
                <cfset LarrErrores[LvarCantidadErrores] = "No se ha definido el parámetro Periodo para los Sistemas Auxiliares!">
			</cfif>
			<cfif rsMes.recordcount eq 0 or len(trim(rsMes.value)) eq 0>
				<cfset LvarCantidadErrores = LvarCantidadErrores + 1>
                <cfset LarrErrores[LvarCantidadErrores] = "No se ha definido el parámetro Mes para los Sistemas Auxiliares!">
			</cfif>
			<cfif rsMoneda.recordcount eq 0 or len(trim(rsMoneda.value)) eq 0>
				<cfset LvarCantidadErrores = LvarCantidadErrores + 1>
                <cfset LarrErrores[LvarCantidadErrores] = "No se ha definido el parámetro Moneda local para la Empresa!">
			</cfif>

			<!--- Actualizar la columna de Activo Destino para aquellos que existan --->
			<cfquery datasource="#Arguments.Conexion#">
				update ADTProceso
				set Aiddestino = (( 
							select min(Activos.Aid)
							from Activos
							where Activos.Ecodigo   = #Arguments.Ecodigo#
							  and Activos.Aplaca    = ADTProceso.Aplacadestino
						))
				where ADTProceso.AGTPid = #Arguments.AGTPid#
				  and ADTProceso.Aplacadestino is not null
			</cfquery>

			<!--- Actualizar la columna de Placa Destino para aquellos que existan y que tengan la columna Placa Destino en nulo --->
			<cfquery datasource="#Arguments.Conexion#">
				update ADTProceso
				set Aplacadestino = (( 
							select min(Activos.Aplaca)
							from Activos
							where Activos.Aid       = ADTProceso.Aiddestino
						))
				where ADTProceso.AGTPid = #Arguments.AGTPid#
				  and ADTProceso.Aplacadestino is null
				  and ADTProceso.Aiddestino is not null
			</cfquery>
			<!---
				 Valida que el traslado no tenga los 3 valores en cero, pues crearia un Activo sin Saldos
			--->
			<cfquery name="rsMontos" datasource="#Arguments.Conexion#">
				select b.Aplaca as placa
				from ADTProceso a
					inner join Activos b
					  on a.Aid = b.Aid 
				where (TAmontolocadq = 0 and  TAmontolocmej = 0 and TAmontolocrev = 0)
				  and a.AGTPid = #Arguments.AGTPid#
			</cfquery>
			
			<cfif rsMontos.recordcount gt 0>
				<cfloop query="rsMontos">
					<cfset LvarCantidadErrores = LvarCantidadErrores + 1>
	                <cfset LarrErrores[LvarCantidadErrores] = "Placa: #rsMontos.Placa#no puede realizar un traslado con los 3 montos en cero (Adq, Mej, Rev).  Revise los movimientos">
				</cfloop>
			</cfif>
	
			<!--- 1.0 Verificar que las placas destino estén definidas ( columna Aplacadestino ) o el dato Aiddestino exista.  --->
			<cfquery name="rsControlTraslados" datasource="#Arguments.Conexion#">
					select 
						count(1) as Cantidad
					from ADTProceso p
					where p.AGTPid = #Arguments.AGTPid#
					  and p.Aplacadestino is null
			</cfquery>

			<cfif rsControlTraslados.Cantidad gt 0>
				<cfloop query="rsControlTraslados">
					<cfset LvarCantidadErrores = LvarCantidadErrores + 1>
	                <cfset LarrErrores[LvarCantidadErrores] = "Existen #rsControlTraslados.Cantidad# movimientos sin placa destino!">
				</cfloop>
			</cfif>


			<!--- 1.1 Verificar que las placas destino no estén duplicadas.  --->
			<cfquery name="rsControlTraslados" datasource="#Arguments.Conexion#">
					select 
						Aplacadestino, 
						count(1) as Cantidad 
					from ADTProceso p
					where p.AGTPid = #Arguments.AGTPid#
					  and p.Aplacadestino is not null
					group by Aplacadestino
					having count(1) > 1
			</cfquery>

			<cfif rsControlTraslados.recordcount gt 0>
				<cfloop query="rsControlTraslados">
					<cfset LvarCantidadErrores = LvarCantidadErrores + 1>
	                <cfset LarrErrores[LvarCantidadErrores] = "Placa: #rsControlTraslados.Aplacadestino# tiene #rsControlTraslados.Cantidad# de movimientos destino!">
				</cfloop>
			</cfif>

			<!--- Redondea los montos calculados a 2 decimales para efectos de contabilización --->
			<cfquery datasource="#Arguments.Conexion#">
				update ADTProceso
					set 
						  TAvaladq			= round(TAvaladq, 2)
						, TAmontolocadq 	= round(TAmontolocadq, 2)
						, TAmontolocmej 	= round(TAmontolocmej, 2)
						, TAmontolocrev 	= round(TAmontolocrev, 2)
						, TAmontodepadq 	= round(TAmontodepadq, 2)
						, TAmontodepmej 	= round(TAmontodepmej, 2)
						, TAmontodeprev		= round(TAmontodeprev, 2)
				where AGTPid = #Arguments.AGTPid#
			</cfquery>
			
			<!--- 
				2. Valida el valor residual con respecto al monto de adquisición.  No puede quedar el valor residual mayor que el valor de adquisición resultante 
			--->
			<cfquery name="rsValRescate" datasource="#Arguments.Conexion#">
				select b.Aplaca as Aplaca
				from ADTProceso a
					inner join Activos b
					  on a.Aid = b.Aid 
				where ( a.TAvaladq - a.TAmontolocadq) < b.Avalrescate
				  and ( a.TAvaladq - a.TAmontolocadq) > 0
				  and a.AGTPid = #Arguments.AGTPid#
			</cfquery>
			
			<cfif rsValRescate.recordcount gt 0>
				<cfloop query="rsValRescate">
					<cfset LvarCantidadErrores = LvarCantidadErrores + 1>
	                <cfset LarrErrores[LvarCantidadErrores] = "Placa: #rsValRescate.APlaca# quedará con valor negativo.  Revise los movimientos.">
				</cfloop>
			</cfif>
	
			<!--- 3. Verifica si la placa existe entre los activos en TRANSITO.  Esto no es válido --->		
			<cfquery name="rsControlTransito" datasource="#Arguments.Conexion#">
				select a.Aplacadestino as Placa
				from ADTProceso a
					inner join CRDocumentoResponsabilidad b
					on a.Aplacadestino = b.CRDRplaca         
				where a.AGTPid = #Arguments.AGTPid#
				  and a.Aiddestino is null
			</cfquery>

			<cfif rsControlTransito.recordcount gt 0>
				<cfloop query="rsControlTransito">
					<cfset LvarCantidadErrores = LvarCantidadErrores + 1>
	                <cfset LarrErrores[LvarCantidadErrores] = "Placa: #rsControlTransito.Placa# es Activo en Tránsito.">
				</cfloop>
			</cfif>
			
			<!--- 
				4. Verifica si el Aid existe entre los activos en TRANSITO.  
				Esto no es válido 
			--->		
			<cfquery name="rsControlTransito" datasource="#Arguments.Conexion#">
				select b.Aplaca as Placa
				from ADTProceso a
					inner join Activos b
						on a.Aiddestino = b.Aid
					inner join CRDocumentoResponsabilidad c
						 on  c.CRDRplaca = b.Aplaca
						 and c.Ecodigo = b.Ecodigo
				where a.AGTPid = #Arguments.AGTPid#
				and a.Aplacadestino is null
			</cfquery>

			<cfif rsControlTransito.recordcount gt 0>
				<cfloop query="rsControlTransito">
					<cfset LvarCantidadErrores = LvarCantidadErrores + 1>
	                <cfset LarrErrores[LvarCantidadErrores] = "Placa: #rsControlTransito.Placa# es Activo en Tránsito.">
				</cfloop>
			</cfif>

			<!--- 
				5. Valida el valor residual con respecto al monto de adquisición de todas las transacciones de Activos Fijos ( Traslados ). 
				No puede quedar mayor que el valor de adquisición resultante 
			--->
			
			<cfquery name="rsValRescate" datasource="#Arguments.Conexion#">
				select 
					p.Aid, 
                    min( a.Aplaca ) as Placa,
                    min( a.Avalrescate ) as ValorRescate,
					sum( p.TAvaladq ) as TAvaladq,
					sum( p.TAmontolocadq ) as TAmontolocadq, 
					sum( p.TAmontolocmej ) as TAmontolocmej, 
					sum( p.TAmontolocrev ) as TAmontolocrev, 
					sum( p.TAmontodepadq ) as TAmontodepadq, 
					sum( p.TAmontodepmej ) as TAmontodepmej, 
					sum( p.TAmontodeprev ) as TAmontodeprev
				from ADTProceso p
                	inner join Activos a
                    on a.Aid = p.Aid
				where p.AGTPid = #Arguments.AGTPid#
				group by p.Aid
                having ( sum( p.TAvaladq ) - sum( p.TAmontolocadq ) ) < 0 or ( sum( p.TAvaladq ) - sum( p.TAmontolocadq ) > 0 and sum( p.TAvaladq ) - sum( p.TAmontolocadq ) < min ( a.Avalrescate ) )
			</cfquery>
			
			<cfif rsValRescate.recordcount gt 0>
				<cfloop query="rsValRescate">
					<cfset LvarCantidadErrores = LvarCantidadErrores + 1>
	                <cfset LarrErrores[LvarCantidadErrores] = "Placa: #rsValRescate.Placa# quedará con valor negativo o su valor de adquisición será menor al valor residual.">
				</cfloop>
			</cfif>
            <cfreturn LvarCantidadErrores>
	</cffunction>

	<!---Deplegar los Errores--->
	<cffunction name="fnDesplegarErrores" access="private" output="yes" hint="Despliega los mensajes de error que se generaron durante el proceso de validacion">
		<cfargument name="CantidadErrores" type="numeric" required="yes" hint="Cantidad de Errores que se despliegan">
		<cfset LvarCantidadErores = Arguments.CantidadErrores>
		<cfset i = 1>
		<!---------   AQUI HAY QUE PINTAR LA PANTALLA CON TODOS LOS ERRORES -  LO PONGO ASÍ PARA QUE SE COMPLETE --------->
		<p>&nbsp;</p>
		<p>&nbsp;</p>
		<p>&nbsp;</p>
		<div style="font:Arial, Helvetica, sans-serif; font-style:italic; color:##999999; font-size:14px">
		<p align="center">Se Presentaron Errores en la validación inicial que impiden que se complete el proceso.</p>
		<p align="center">Por favor verique la siguiente lista antes de ejecutar nuevamente</p>
		</div>
		<cfloop condition="i LTE LvarCantidadErrores">
			<p><cfoutput>#LarrErrores[i]#</cfoutput></p>
			<cfset i = i + 1>
		</cfloop>
	</cffunction>
    
	<!---Debug--->
	<cffunction name="verDebugFinal" output="yes" access="private" returntype="any">
		<cfargument name="Ecodigo" type="numeric" required="yes">
		<cfargument name="AGTPid"  type="numeric" required="yes">
		<cfargument name="Conexion" type="string" required="yes">
		
		<cfquery name="rsTemp" datasource="#Arguments.Conexion#">
			select * 
			from TransaccionesActivos 
			where AGTPid = #Arguments.AGTPid#
		</cfquery>
		<cfdump var="#rsTemp#" label="TransaccionesActivos">
		<cfquery name="rsTemp" datasource="#Arguments.Conexion#">
			select * 
			from AFSaldos
			where Ecodigo = #Arguments.Ecodigo#
			and AFSperiodo = #rsPeriodo.value#
			and AFSmes = #rsMes.value#
			and Aid in (
				select Aid 
				from TransaccionesActivos 
				where AGTPid = #Arguments.AGTPid#
			)
		</cfquery>
		<cfdump var="#rsTemp#" label="AFSaldos">
		<cfquery name="rsTemp" datasource="#Arguments.Conexion#">
			select * 
			from AFSaldos
			where Ecodigo = #Arguments.Ecodigo#
			and AFSperiodo = #rsPeriodo.value#
			and AFSmes = #rsMes.value#
			and Aid in (
				select Aiddestino 
				from TransaccionesActivos 
				where AGTPid = #Arguments.AGTPid#
			)
		</cfquery>
		<cfdump var="#rsTemp#" label="AFSaldos">
		<cfquery name="rsTemp" datasource="#Arguments.Conexion#">
			select * 
			from AFResponsables
			where Ecodigo = #Arguments.Ecodigo#
			and Aid in (
				select Aid 
				from TransaccionesActivos 
				where AGTPid = #Arguments.AGTPid#
			)
		</cfquery>
		<cfdump var="#rsTemp#" label="AFResponsables">
		<cfquery name="rsTemp" datasource="#Arguments.Conexion#">
			select * 
			from AFResponsables
			where Ecodigo = #Arguments.Ecodigo#
			and Aid in (
				select Aiddestino 
				from TransaccionesActivos 
				where AGTPid = #Arguments.AGTPid#
			)
		</cfquery>
		<cfdump var="#rsTemp#" label="AFResponsables">
		<cfquery name="rsTemp" datasource="#Arguments.Conexion#">
			select * 
			from ADTProceso
			where AGTPid = #Arguments.AGTPid#
		</cfquery>
		<cfdump var="#rsTemp#" label="ADTProceso">
		<cfquery name="rsTemp" datasource="#Arguments.Conexion#">
			select * 
			from AGTProceso
			where AGTPid = #Arguments.AGTPid#
		</cfquery>
		<cfdump var="#rsTemp#" label="AGTProceso">
		<cftransaction action="rollback" />
		<cf_abort errorInterfaz="">
	</cffunction>

	<!--- Activos Origen de la transferencia contenidos en la tabla ADTProceso--->
	<cffunction name="fnCreaTablaTemporal1" access="private" output="no" hint="Crea la Tabla tempoal para procesar los activos origen" returntype="string">
	    <cfargument name="Conexion" type="string"	 required="yes">	
		<cf_dbtemp name="ADTProceso_ori" returnvariable="ADTProceso_ori" datasource="#Arguments.Conexion#">
			<cf_dbtempcol name="Aid"       		type="numeric"  mandatory="yes">
			<cf_dbtempcol name="Ecodigo"   		type="int"      mandatory="yes">
			<cf_dbtempcol name="TAperiodo" 		type="int"		mandatory="yes">
			<cf_dbtempcol name="TAmes"     		type="int"     	mandatory="yes">
			<cf_dbtempcol name="TAvaladq"		type="money"  	mandatory="yes">
			<cf_dbtempcol name="TAmontolocadq"	type="money"  	mandatory="yes">
			<cf_dbtempcol name="TAmontolocmej"  type="money"    mandatory="yes">
			<cf_dbtempcol name="TAmontolocrev"  type="money"    mandatory="yes">
			<cf_dbtempcol name="TAmontodepadq"  type="money"  	mandatory="yes">
			<cf_dbtempcol name="TAmontodepmej"  type="money"   	mandatory="yes">
			<cf_dbtempcol name="TAmontodeprev"  type="money"    mandatory="yes">
		</cf_dbtemp>
        <cfreturn ADTProceso_ori>
	</cffunction>

	<!--- Activos Nuevos que se generan en la transferencia --->
    <cffunction name="fnCreaTablaTemporal2" access="private" output="no" hint="Crea la Tabla tempoal para procesar los activos Nuevos" returntype="string">
	    <cfargument name="Conexion" type="string"	 required="yes">	
		<cf_dbtemp name="ACT_NUEVOS" returnvariable="ACT_NUEVOS" datasource="#Arguments.Conexion#">
			<cf_dbtempcol name="Aid" 		type="numeric"		mandatory="yes">
			<cf_dbtempcol name="Placa" 		type="varchar(20)"	mandatory="yes">
			<cf_dbtempcol name="AidOri" 	type="numeric"		mandatory="yes">
			<cf_dbtempcol name="ADTPlinea" 	type="numeric"		mandatory="yes">
		</cf_dbtemp>
		<cfreturn ACT_NUEVOS>
	</cffunction>
</cfcomponent>



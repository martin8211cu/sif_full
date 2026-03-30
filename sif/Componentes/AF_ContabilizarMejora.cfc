<cfcomponent>
	<cffunction name="AF_ContabilizarMejora" access="public" returntype="boolean" output="true">
		<cfargument name="Ecodigo" 	 		 type="numeric" required="no" 	default="0" ><!--- Código de Empresa (sif) --->
		<cfargument name="Usucodigo" 		 type="numeric" required="no" 	default="0" ><!--- Código de Usuario (asp) --->
		<cfargument name="Conexion"  		 type="string"  required="no" 	default=""  ><!--- IP de PC de Usuario --->

		<cfargument name="AGTPid" 	 		 type="numeric" required="yes">
		<cfargument name="Programar" 		 type="boolean" required="no" 	default="false" ><!---Si es verdadero se requiere la fecha de programación y solo se programa y no se calcula--->
		<cfargument name="FechaProgramacion" type="date"    required="no" 	default="#CreateDate(1900,01,01)#" >

		<cfargument name="Periodo" 			 type="numeric" required="no" 	default="0" ><!---Si se envían No se sacan de la tabla de parámetros--->
		<cfargument name="Mes" 				 type="numeric" required="no" 	default="0" ><!---Si se envían No se sacan de la tabla de parámetros--->
		<cfargument name="debug" 			 type="boolean" required="no" 	default="false" ><!--- si se prende simula la transacción, pinta los resultados y desahace los cambios --->

		<cfargument name="contabilizar" 	 type="boolean" required="no" 	default="true" ><!--- si se apaga no contabiliza pero si aplica la mejora, por ahora solo se utiliza para las pruebas iniciales del sistema --->
		<cfargument name="descripcion" 		 type="string"  required="no" 	default="Activo Fijo: Mejora" ><!--- Descripción de la transacción --->
		<cfargument name="IDcontable" 		 type="numeric" required="no" 	default="0" ><!--- IDcontable se utiliza para enviar el número interno de asiento contable cuando se envía el parámetro de no contabilizar para guardarlo en la tabla transaccionesactivos --->
		
		<cfargument name="TransaccionActiva" type="boolean" required="false" default="false">
		
		<cfif Arguments.TransaccionActiva>
			<cfinvoke 
				method="AF_ContabilizarMejoraPrivate"
			    returnvariable="res"
				
				Ecodigo="#Arguments.Ecodigo#"
				Usucodigo="#Arguments.Usucodigo#"
				Conexion="#Arguments.Conexion#"
				AGTPid="#Arguments.AGTPid#"
				Programar="#Arguments.Programar#"
				FechaProgramacion="#Arguments.FechaProgramacion#"
				Periodo="#Arguments.Periodo#"
				Mes="#Arguments.Mes#"
				debug="#Arguments.debug#"
				contabilizar="#Arguments.contabilizar#"
				descripcion="#Arguments.descripcion#"
				IDcontable="#Arguments.IDcontable#"
			/>
		<cfelse>
			<cftransaction>
				<cfinvoke 
					method="AF_ContabilizarMejoraPrivate"
					returnvariable="res"
					
					Ecodigo="#Arguments.Ecodigo#"
					Usucodigo="#Arguments.Usucodigo#"
					Conexion="#Arguments.Conexion#"
					AGTPid="#Arguments.AGTPid#"
					Programar="#Arguments.Programar#"
					FechaProgramacion="#Arguments.FechaProgramacion#"
					Periodo="#Arguments.Periodo#"
					Mes="#Arguments.Mes#"
					debug="#Arguments.debug#"
					contabilizar="#Arguments.contabilizar#"
					descripcion="#Arguments.descripcion#"
					IDcontable="#Arguments.IDcontable#"
				/>
			</cftransaction>
		</cfif>
		<cfreturn res>
	</cffunction>

	<cffunction name="AF_ContabilizarMejoraPrivate" access="private" returntype="boolean" output="true">
		<cfargument name="Ecodigo" 			 type="numeric" required="no" default="0" ><!--- Código de Empresa (sif) --->
		<cfargument name="Usucodigo" 		 type="numeric" required="no" default="0" ><!--- Código de Usuario (asp) --->
		<cfargument name="Conexion" 		 type="string" 	required="no" default="" ><!--- IP de PC de Usuario --->

		<cfargument name="AGTPid" 			 type="numeric" required="yes">
		<cfargument name="Programar" 		 type="boolean" required="no" default="false" ><!---Si es verdadero se requiere la fecha de programación y solo se programa y no se calcula--->
		<cfargument name="FechaProgramacion" type="date" 	required="no" default="#CreateDate(1900,01,01)#" >

		<cfargument name="Periodo" 			 type="numeric" required="no" default="0" ><!---Si se envían No se sacan de la tabla de parámetros--->
		<cfargument name="Mes" 				 type="numeric" required="no" default="0" ><!---Si se envían No se sacan de la tabla de parámetros--->
		<cfargument name="debug" 			 type="boolean" required="no" default="false" ><!--- si se prende simula la transacción, pinta los resultados y desahace los cambios --->

		<cfargument name="contabilizar" 	 type="boolean" required="no" default="true" ><!--- si se apaga no contabiliza pero si aplica la mejora, por ahora solo se utiliza para las pruebas iniciales del sistema --->
		<cfargument name="descripcion" 	 	 type="string" 	required="no" default="Activo Fijo: Mejora" ><!--- Descripción de la transacción --->
		<cfargument name="IDcontable" 		 type="numeric" required="no" default="0" ><!--- IDcontable se utiliza para enviar el número interno de asiento contable cuando se envía el parámetro de no contabilizar para guardarlo en la tabla transaccionesactivos --->
		
		
		<!---Valida Fecha de Programación Vrs Programar--->
		<cfif (Arguments.Programar) and (DateCompare(Arguments.FechaProgramacion, Now()) eq -1)>
			<cfset Arguments.Programar = false>
		</cfif>

		<!---Cuando Arguments.AGTPid estos valores no son necesarios--->
		<cfif Arguments.Ecodigo eq 0>
			<cfset Arguments.Ecodigo = session.Ecodigo >
			<cfset Arguments.Conexion = session.dsn >
			<cfset Arguments.Usucodigo = session.Usucodigo >
			<cfset Arguments.IPregistro = session.sitio.ip >
		</cfif>

		<!---Valida que el AGTPid corresponda a un Proceso Válido--->
		<cfquery name="rsAGTProceso" datasource="#Arguments.Conexion#">
			select count(1) as cuantos from AGTProceso
			where AGTPid = #Arguments.AGTPid#
			and AGTPestadp in (0,2)
		</cfquery>
		
		<cfif rsAGTProceso.cuantos is not 1>
			<cf_errorCode	code = "50911" msg = "El Grupo de Transacciones seleccionado es inválido!, Proceso Cancelado!">
		</cfif>
		
		<!---Antes de iniciar la transacción hace algunos calculos--->
		<!--- Obtiene el Periodo y Mes de Auxiliares --->
		<cfif Arguments.Periodo neq 0>
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
		<cfif Arguments.Mes neq 0>
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

		<cfif len(LvarMes) LT 2>
			<cfset LvarMes = '0' & LvarMes>
		</cfif>

		<!--- Valida que si va mejorar solamente el monto y no la vida útil, la vida util se mayor que cero --->
		<cfquery name="rsValidaVuitl" datasource="#Arguments.Conexion#">
			select count(1) as Cantidad 
			from ADTProceso
				inner join AFSaldos
						inner join AClasificacion
						on 	AClasificacion.ACcodigo = AFSaldos.ACcodigo
						and AClasificacion.ACid = AFSaldos.ACid
						and AClasificacion.Ecodigo = AFSaldos.Ecodigo
						and AClasificacion.ACdepreciable = 'S' 
				on AFSaldos.Aid         = ADTProceso.Aid
				and AFSaldos.AFSperiodo = ADTProceso.TAperiodo
				and AFSaldos.AFSmes     = ADTProceso.TAmes
				and AFSaldos.Ecodigo    = ADTProceso.Ecodigo 
				and AFSaldos.AFSperiodo = #rsPeriodo.value#
				and AFSaldos.AFSmes     = #LvarMes#
				and AFSaldos.Ecodigo    = #Arguments.Ecodigo#
				
			where ADTProceso.AGTPid = #Arguments.AGTPid#
			  and AFSsaldovutiladq = 0
			  and TAvutil = 0
		</cfquery>
		<cfif rsValidaVuitl.Cantidad gt 0>
			<cf_errorCode	code = "50914" msg = "Cuando el Activo Tiene la Vida Util en Cero toda mejora debe aumentar la vida Util!, Proceso Cancelado!">
		</cfif>
		
		<!--- Obtiene la Moneda Local --->
		<cfquery name="rsMoneda" datasource="#Arguments.Conexion#">
			select Mcodigo as value
			from Empresas 
			where Ecodigo = #Arguments.Ecodigo#
		</cfquery>

		<!--- Obtiene la Cuenta de Activos en Transito --->
		<cfquery name="rsCuentaActivos" datasource="#session.dsn#">
			select Pvalor as value
			from Parametros
			where Ecodigo = #Arguments.Ecodigo#
				and Pcodigo = 240
		</cfquery>

		<!--- Crea la FechaAux a partir del periodo / mes de auxiliares y le pone el último día del mes --->
		<cfset rsFechaAux.value = CreateDate(fnIsNull(rsPeriodo.value,01), fnIsNull(LvarMes,01), 01)>
		<cfset rsFechaAux.value = DateAdd("m",1,rsFechaAux.value)>
		<cfset rsFechaAux.value = DateAdd("d",-1,rsFechaAux.value)>
		<cfif Arguments.debug>
			<!--- Pinta los valores obtenidos hasta el momento para debug --->
			<cfoutput>
				<h1>DEBUG</h1><br>
				<p>
				<strong>Periodo</strong> = #rsPeriodo.value#<br>
				<strong>Mes</strong> = #LvarMes#<br>
				<strong>Moneda</strong> = #rsMoneda.value#<br>
				<strong>FechaAux</strong> = #rsFechaAux.value#<br>
				<strong>Fecha del Sistema</strong> = #Now()#<br>
				</p>
			</cfoutput>
			<cfdump var="#Arguments#" label="Arguments">
		</cfif>
		
		<!--- Obtiene el número de Documento --->
		<cfquery name="rsAGTProcesoDoc" datasource="#Arguments.Conexion#">
			select AGTPdocumento 
			from AGTProceso 
			where AGTPid = #Arguments.AGTPid#
		</cfquery>
		<cfif rsAGTProcesoDoc.recordcount eq 0 or (rsAGTProcesoDoc.recordcount and len(trim(rsAGTProcesoDoc.AGTPdocumento)) eq 0) or rsAGTProcesoDoc.AGTPdocumento eq 0>
			<cf_errorCode	code = "50915" msg = "Error obteniendo el Documento, No se pudo obtener el documento de la transacción de Mejora, Proceso Cancelado!">
		</cfif>
		
		<!--- Validaciones Iniciales, valida periodo, mes, moneda --->
		<cfif len(trim(rsPeriodo.value)) eq 0><cf_errorCode	code = "50031" msg = "No se ha definido el parámetro Periodo para los Sistemas Auxiliares! Proceso Cancelado!"></cfif>
		<cfif len(trim(LvarMes)) eq 0><cf_errorCode	code = "50032" msg = "No se ha definido el parámetro Mes para los Sistemas Auxiliares! Proceso Cancelado!"></cfif>
		<cfif len(trim(rsMoneda.value)) eq 0><cf_errorCode	code = "50909" msg = "No se ha definido el parámetro Moneda Local para la Empresa! Proceso Cancelado!"></cfif>
		<cfif len(trim(rsCuentaActivos.value)) eq 0><cf_errorCode	code = "50916" msg = "No se pudo obtener la Cuenta de Activos Adquiridos. Proceso Cancelado!"></cfif>
		<!--- Si programar --->
		<cfif (Arguments.Programar)>
			<cfquery name="rsActualizaProceso" datasource="#Arguments.Conexion#">
				Update AGTProceso 
				set AGTPestadp = 2,
				AGTPfechaprog = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.FechaProgramacion#" null="#DateCompare(Arguments.FechaProgramacion, Now()) eq -1#">
				where AGTPid = #Arguments.AGTPid#
			</cfquery>
		<cfelse>
<!---**************************PROCESO DE MEJORA********************************************
		1-Verifica que la relacion, tenga Activos a mejorar
		2-Inserta las transacciones de Mejora para cada uno de los Activos
		3-Actualiza los montos de los Activos con el monto de la mejora
		4-Se retiran los Activos que quedaron con montos en cero, por motivo de una desmejora
		5-Genera el Asiento Contable de la mejora
		6-Borrar las tablas de trabajo
*****************************************************************************************--->

<!---1-Verifica que la relacion, tenga Activos a mejorar--->		
				<cfquery name="rsPruebaTransaccionesActivos" datasource="#Arguments.Conexion#">
					select count(1) as Cantidad
					from ADTProceso a
						inner join Activos b 
							on b.Aid = a.Aid
					where a.AGTPid = #Arguments.AGTPid#
				</cfquery>
				<cfif rsPruebaTransaccionesActivos.Cantidad Eq 0>
					<cf_errorCode	code = "50917" msg = "No se logró encontrar ningún registro para realizar la inserción en TransaccionesActivos, Proceso Cancelado!">
				</cfif>
<!---2-Inserta las transacciones de Mejora para cada uno de los Activos--->
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
						
						TAsuperavit,
						Mcodigo,
						TAtipocambio,
						Ccuenta,
						AGTPid,
						Usucodigo,

						TAfechainidep,
						TAvalrescate,
						TAvutil,
						TAfechainirev,
						TAmeses,
						
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
						
						a.TAsuperavit,
						a.Mcodigo,
						a.TAtipocambio,
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
						
						a.ADTPrazon
					from ADTProceso a
						inner join Activos b 
							on b.Ecodigo = a.Ecodigo
							and b.Aid = a.Aid
					where a.AGTPid = #Arguments.AGTPid#
				</cfquery>
				
<!---3-Actualiza los montos de los Activos con el monto de la mejora--->
			<cfset FechaAuxiliar = CreateDate(rsPeriodo.value, LvarMes, 01)>
		
				<cfquery name="PorActualizar" datasource="#Arguments.Conexion#">
					select d.AFSid, ad.TAmontolocmej, ad.TAvutil, a.Afechainidep
					  from ADTProceso ad
							inner join Activos a
								on ad.Aid = a.Aid 
							inner join AFSaldos d 
								on  d.Aid        = ad.Aid 
								and d.AFSperiodo = ad.TAperiodo
								and d.AFSmes     = ad.TAmes
								and d.Ecodigo    = ad.Ecodigo 
								and d.AFSperiodo = #rsPeriodo.value#
								and d.AFSmes 	 = #LvarMes#
					where ad.AGTPid = #Arguments.AGTPid#			
				</cfquery>
				<cfloop query="PorActualizar">
					<cfquery name="rsAFSaldos" datasource="#Arguments.Conexion#">
						Update AFSaldos
						set AFSvalmej = AFSvalmej + #PorActualizar.TAmontolocmej#
						,   AFSvutiladq = case when AFSsaldovutiladq > 0 then AFSvutiladq + #PorActualizar.TAvutil# else #PorActualizar.TAvutil# + <cf_dbfunction name="datediff" args="#lsparsedatetime(PorActualizar.Afechainidep)#, #FechaAuxiliar#,MM"> end   
						,   AFSvutilrev = case when AFSsaldovutiladq > 0 then AFSvutiladq + #PorActualizar.TAvutil# else #PorActualizar.TAvutil# + <cf_dbfunction name="datediff" args="#lsparsedatetime(PorActualizar.Afechainidep)#, #FechaAuxiliar#,MM"> end  
						,   AFSsaldovutiladq = AFSsaldovutiladq + #PorActualizar.TAvutil#
						,   AFSsaldovutilrev = AFSsaldovutilrev + #PorActualizar.TAvutil#
						where AFSid = #PorActualizar.AFSid#
					</cfquery>
				</cfloop>
<!---4-Se retiran los Activos que quedaron con montos en cero, por motivo de una desmejora--->
				<cfquery name="PorEliminar" datasource="#Arguments.Conexion#">
					select a.Aid
					from ADTProceso a
						inner join AFSaldos b
							on  b .Aid 		 = a.Aid
					  		and b.AFSperiodo = a.TAperiodo
					  		and b.AFSmes 	 = a.TAmes
					  		and b.Ecodigo  	 = a.Ecodigo
					where a.AGTPid  = #Arguments.AGTPid#
					  and b.Ecodigo   = #Arguments.Ecodigo#
					  and b.AFSperiodo= #rsPeriodo.value#
					  and b.AFSmes    = #LvarMes#
					  and b.AFSvaladq - b.AFSdepacumadq = 0
					  and b.AFSvalmej - b.AFSdepacummej = 0
					  and b.AFSvalrev - b.AFSdepacumrev = 0
				</cfquery>
				<cfloop query="PorEliminar">
					<cfquery name="rsActivos" datasource="#Arguments.Conexion#">
						Update Activos 
							set Astatus = 60
								where Aid = #PorEliminar.Aid#
					</cfquery>
				</cfloop>
				<cfif Arguments.debug>
					<cfdump var="#PorEliminar#">
				</cfif>
<!---5-Genera el Asiento Contable de la mejora--->		

				<!--- ****************** C O N T A B I L I Z A C I O N ****************** --->
				<cfif Arguments.contabilizar is true>
					<cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="CreaIntarc" returnvariable="INTARC">
							<cfinvokeargument name="Conexion" value="#Arguments.Conexion#"/>
					</cfinvoke>
					
					<cfquery name="rsPruebatemp" datasource="#Arguments.Conexion#">
						select count(1) cantidad
						from ADTProceso a
							inner join Activos b
								on b.Ecodigo = a.Ecodigo
								and b.Aid = a.Aid
							inner join AClasificacion c
								on c.Ecodigo = b.Ecodigo
								and c.ACid = b.ACid
								and c.ACcodigo = b.ACcodigo
							inner join CFuncional d
								on d.Ecodigo = a.Ecodigo
								and d.CFid = a.CFid
						where a.AGTPid = #Arguments.AGTPid#
					</cfquery>
					<cfif rsPruebatemp.cantidad Eq 0>
						<cf_errorCode	code = "50918" msg = "No se logró encontrar ningún registro para realizar la inserción en INTARC, Puede deberse por que la información de la Clasificación y/o el Centro Funcional para uno o mas activos incluidos en la relación está incompleta o incosistente. Proceso Cancelado!">
					</cfif>
					<cf_dbfunction name="string_part"   args="b.Adescripcion,1,65" returnvariable="Adescripcion">
					<cf_dbfunction name="concat" 		args="'Mejora de '+#PreserveSingleQuotes(Adescripcion)#" returnvariable="INTDES01" delimiters="+">	
					
					<cfquery name="rstemp" datasource="#Arguments.Conexion#">
						insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, CFid)
						select 
								'AFME',
								1,
								<cf_dbfunction name="to_char" args="g.AGTPdocumento">, 
								'MJ',
								a.TAmontolocmej,
								'D',
								#PreserveSingleQuotes(INTDES01)#,
								'#DateFormat(now(),'YYYYMMDD')#',
								1.00,
								#rsPeriodo.value#, 
								#LvarMes#,
								c.ACcadq, 
								#rsMoneda.value#,
								d.Ocodigo,
								a.TAmontolocmej,
                                a.CFid
						from ADTProceso a
							inner join Activos b
								on b.Ecodigo = a.Ecodigo
								and b.Aid = a.Aid
							inner join AClasificacion c
								on c.Ecodigo = b.Ecodigo
								and c.ACid = b.ACid
								and c.ACcodigo = b.ACcodigo
							inner join CFuncional d
								on d.CFid = a.CFid
							inner join AGTProceso g
								on g.AGTPid = a.AGTPid
						where a.Ecodigo = #Arguments.Ecodigo#
							and a.AGTPid = #Arguments.AGTPid#
					</cfquery>
					<cfif Arguments.debug>
						<cfquery name="rstemp" datasource="#Arguments.Conexion#">
							select * from #INTARC#
						</cfquery>
						<cfdump var="#rstemp#" label="1rst Insert">
					</cfif>					

					<cfquery name="rstemp" datasource="#Arguments.Conexion#">
						insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, CFid)
						select 
								'AFME',
								1,
								<cf_dbfunction name="to_char" args="g.AGTPdocumento">, 
								'MJ',
								a.TAmontolocmej,
								'C',
								#PreserveSingleQuotes(INTDES01)#,
								'#DateFormat(now(),'YYYYMMDD')#',
								1,
								#rsPeriodo.value#, 
								#LvarMes#,
								#rsCuentaActivos.value#,
								#rsMoneda.value#,
								d.Ocodigo,
								a.TAmontolocmej,
                                a.CFid
						from ADTProceso a
							inner join Activos b
								on b.Ecodigo = a.Ecodigo
								and b.Aid = a.Aid
							inner join AClasificacion c
								on c.Ecodigo = b.Ecodigo
								and c.ACid = b.ACid
								and c.ACcodigo = b.ACcodigo
							inner join CFuncional d
								on d.CFid = a.CFid
							inner join AGTProceso g
								on g.AGTPid = a.AGTPid
						where a.Ecodigo = #Arguments.Ecodigo#
						  and a.AGTPid  = #Arguments.AGTPid#
					</cfquery>

					<!---==Obtiene la minima oficina del Asiento, si no tienen entonces la minina Oficina para la empresa==---> 
					<!---==============La oficina se le manda al genera asiento para que agrupe)===========================--->
					<cfquery name="rsMinOficinaINTARC" datasource="#session.dsn#">
						Select Min(Ocodigo) as MinOcodigo
							from #INTARC#
					</cfquery>
					<cfquery name="rsMinOficina" datasource="#session.dsn#">
						Select Min(Ocodigo) as MinOcodigo
							from Oficinas
							where Ecodigo = #Arguments.Ecodigo#
					</cfquery>
					<cfif isdefined("rsMinOficinaINTARC") and rsMinOficinaINTARC.recordcount GT 0>
						<cfset LvarOcodigo = rsMinOficinaINTARC.MinOcodigo>
					<cfelseif isdefined("rsMinOficina") and rsMinOficina.recordcount GT 0>
						<cfset LvarOcodigo = rsMinOficina.MinOcodigo>
					<cfelse>
						<cfset LvarOcodigo = -100>
					</cfif>								

					<!--- Genera Asiento --->
					<cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="GeneraAsiento" returnvariable="res_GeneraAsiento">
						<cfinvokeargument name="Conexion" 		value="#Arguments.Conexion#"/>
						<cfinvokeargument name="Ecodigo" 		value="#Arguments.Ecodigo#"/>
						<cfinvokeargument name="Oorigen" 		value="AFMJ"/>
						<cfinvokeargument name="Eperiodo" 		value="#rsPeriodo.value#"/>
						<cfinvokeargument name="Emes" 			value="#LvarMes#"/>
						<cfinvokeargument name="Efecha" 		value="#rsFechaAux.value#"/>
						<cfinvokeargument name="Edescripcion" 	value="#Arguments.descripcion#"/>
						<cfinvokeargument name="Edocbase" 		value="#rsAGTProcesoDoc.AGTPdocumento#"/>
						<cfinvokeargument name="Ereferencia" 	value="MJ"/>
						<cfinvokeargument name="Ocodigo" 		value="#LvarOcodigo#"/>
						<cfinvokeargument name="Debug" 			value="#Arguments.Debug#"/>
					</cfinvoke>
				</cfif>
				<cfif isdefined("res_GeneraAsiento") or Arguments.IDcontable GT 0>
					<cfquery name="rstemp" datasource="#session.dsn#">
						update TransaccionesActivos 
						set IDcontable = 
							<cfif isdefined("res_GeneraAsiento")>
								#res_GeneraAsiento#
							<cfelseif Arguments.IDcontable GT 0>
								#Arguments.IDcontable#
							</cfif>
						where Ecodigo = #Arguments.Ecodigo#
						and AGTPid = #Arguments.AGTPid#
					</cfquery>
				</cfif>				
				<cfif Arguments.debug>
					<cfquery name="rsTemp" datasource="#Arguments.Conexion#">
						select * 
						from TransaccionesActivos 
						where Ecodigo = #Arguments.Ecodigo#
						and AGTPid = #Arguments.AGTPid#
					</cfquery>
					<cfdump var="#rsTemp#" label="TransaccionesActivos">
					<cfquery name="rsTemp" datasource="#Arguments.Conexion#">
						select Aplaca, AFSvalmej
						from AFSaldos a inner join Activos b on a.Aid = b.Aid and a.Ecodigo = b. Ecodigo
						where a.Ecodigo = #Arguments.Ecodigo#
						and a.AFSperiodo = #rsPeriodo.value#
						and a.AFSmes = #LvarMes#
						and a.Aid in (
							select Aid 
							from ADTProceso
							where Ecodigo = #Arguments.Ecodigo#
								and AGTPid = #Arguments.AGTPid#
						)
					</cfquery>
					<cfdump var="#rsTemp#" label="AFSaldos">
					<cfquery name="rsTemp" datasource="#Arguments.Conexion#">
						select * 
						from ADTProceso
						where Ecodigo = #Arguments.Ecodigo#
						and AGTPid = #Arguments.AGTPid#
						and Aid in (
							select Aid from ADTProceso
							where Ecodigo = #Arguments.Ecodigo#
								and AGTPid = #Arguments.AGTPid#
						)
					</cfquery>
					<cfdump var="#rsTemp#" label="ADTProceso">
					<cfquery name="rsTemp" datasource="#Arguments.Conexion#">
						select * 
						from AGTProceso
						where Ecodigo = #Arguments.Ecodigo#
						and AGTPid = #Arguments.AGTPid#
					</cfquery>
					<cfdump var="#rsTemp#" label="AGTProceso">
					<cf_abort errorInterfaz="">
				</cfif>

				<!---6-Borrar las tablas de trabajo	--->			
				<!---Borra ADTProceso--->
				<cfquery datasource="#Arguments.Conexion#">
					delete from ADTProceso
					where Ecodigo = #Arguments.Ecodigo#
						and AGTPid = #Arguments.AGTPid#
				</cfquery>

				<!---Actualiza estado a AGTProceso--->
				<cfquery name="rsUpdateAGTProceso" datasource="#Arguments.Conexion#">
					Update AGTProceso set 
					  AGTPestadp   = 4,
					  AGTPfaplica  = <cf_dbfunction name="now">,
					  AGTPipaplica = '#arguments.ipregistro#',
					  Usuaplica    = #Arguments.Usucodigo#
					where AGTPid   = #Arguments.AGTPid#
				</cfquery>
							
		</cfif>
		<!---Si llega hasta aquí todo salió bien--->
		<cfreturn true>
	</cffunction>

	<cffunction name="fnIsNull" access="private" returntype="boolean" output="false">
		<cfargument name="lValue" required="yes" type="any">
		<cfargument name="IValueIfNull" required="yes" type="any">
		<cfif len(trim(lValue))>
			<cfreturn lValue>
		<cfelse>
			<cfreturn lValueIfNull>
		</cfif>
	</cffunction>

</cfcomponent>
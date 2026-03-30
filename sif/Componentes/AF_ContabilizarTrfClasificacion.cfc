<cfcomponent>

	<cffunction name="AF_ContabilizarTrfClasificacion" access="public" returntype="boolean" output="true">
		<cfargument name="Ecodigo" 		type="numeric" 	default="0" 	required="no"><!--- Código de Empresa (sif) --->
		<cfargument name="Usucodigo" 	type="numeric" 	default="0" 	required="no"><!--- Código de Usuario (asp) --->
		<cfargument name="Conexion" 	type="string" 	default="" 		required="no"><!--- IP de PC de Usuario --->

		<cfargument name="IPaplica" 	type="string" 	default="" 		required="no"><!--- IP de PC de Usuario --->
		<cfargument name="AGTPid" 		type="numeric" 	required="yes">

		<cfargument name="Periodo" 		type="numeric" 	default="0" 	required="no"><!---Si se envían No se sacan de la tabla de parámetros--->
		<cfargument name="Mes" 			type="numeric" 	default="0" 	required="no"><!---Si se envían No se sacan de la tabla de parámetros--->
		<cfargument name="debug" 		type="boolean" 	default="false" required="no"><!--- si se prende simula la transacción, pinta los resultados y desahace los cambios --->

		<cfargument name="contabilizar" type="boolean" 	default="true" 	required="no"><!--- si se apaga no contabiliza pero si aplica la transferencia de categoría clase, por ahora solo se utiliza para las pruebas iniciales del sistema --->
		<cfargument name="descripcion" 	type="string" 	default="Activo Fijo: Transferencia Categoría Clasificación" required="no"><!--- Descripción de la transacción --->

		<!--- Sí Aún se encuentra en etapa de desarrollo --->

		<!---Cuando Arguments.AGTPid estos valores no son necesarios--->
		<cfif Arguments.Ecodigo eq 0>
			<cfset Arguments.Ecodigo = session.Ecodigo >
			<cfset Arguments.Conexion = session.dsn >
			<cfset Arguments.Usucodigo = session.Usucodigo >
			<cfset Arguments.IPaplica = session.sitio.ip >
		</cfif>

		<!--- Antes de iniciar la transacción obtiene algunos valores requeridos --->
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
		<cfset rsFechaAux.value = CreateDate(fnIsNull(rsPeriodo.value,01), fnIsNull(rsMes.value,01), 01)>
		<cfset rsFechaAux.value = DateAdd("m",1,rsFechaAux.value)>
		<cfset rsFechaAux.value = DateAdd("d",-1,rsFechaAux.value)>
		
		<!--- Obtiene el Número de documento --->
		<cfquery name="rsAGTProceso" datasource="#Arguments.Conexion#">
			select a.AGTPdocumento
			from AGTProceso a
			where a.Ecodigo = #Arguments.Ecodigo#
				and a.AGTPid = #Arguments.AGTPid#
		</cfquery>
		<cfif rsAGTProceso.recordcount eq 0 or (rsAGTProceso.recordcount and len(trim(rsAGTProceso.AGTPdocumento)) eq 0)>
			<cf_errorCode	code = "50930" msg = "Error al obtener numero de documento, No se pudo obtener el numero de documento. Proceso Cancelado!">
		</cfif>


		<cfif Arguments.debug>
			<!--- Pinta los valores obtenidos hasta el momento para debug --->
			<cfoutput>
				<h1>DEBUG</h1><br>
				<p>
				<strong>Periodo</strong> = #rsPeriodo.value#<br>
				<strong>Mes</strong> = #rsMes.value#<br>
				<strong>Moneda</strong> = #rsMoneda.value#<br>
				<strong>FechaAux</strong> = #rsFechaAux.value#<br>
				<strong>Fecha del Sistema</strong> = #Now()#<br>
				</p>
			</cfoutput>
			<cfdump var="#Arguments#" label="Arguments">
		</cfif>

		<!--- Validaciones Iniciales, valida periodo, mes, moneda --->
		<cfif len(trim(rsPeriodo.value)) eq 0><cf_errorCode	code = "50031" msg = "No se ha definido el parámetro Periodo para los Sistemas Auxiliares! Proceso Cancelado!"></cfif>
		<cfif len(trim(rsMes.value)) eq 0><cf_errorCode	code = "50032" msg = "No se ha definido el parámetro Mes para los Sistemas Auxiliares! Proceso Cancelado!"></cfif>
		<cfif len(trim(rsMoneda.value)) eq 0><cf_errorCode	code = "50909" msg = "No se ha definido el parámetro Moneda Local para la Empresa! Proceso Cancelado!"></cfif>

		<!---Inicio Aplicación de la Transferencia de Categoria Clase--->
			<cftransaction>
				<!---Inserta en TransaccionesActivos--->
				<cfquery name="rsTransaccionesActivos" datasource="#Arguments.Conexion#">
					insert into TransaccionesActivos 
					(Aid, 
					Ecodigo, 
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
					Mcodigo, 
					TAtipocambio, 
					Ccuenta,
					AGTPid, 
					Usucodigo, 
					BMUsucodigo, 
					TAdepacumadq, 
					TAdepacummej, 
					TAdepacumrev, 
					TAvaladq, 
					TAvalmej, 
					TAvalrev, 
					TAmontodepadq, 
					TAmontodepmej, 
					TAmontodeprev, 
					ACcodigoori, 
					ACidori, 
					ACcodigodest, 
					ACiddest,
					TAvalrescate)
					select 
						a.Aid, 
						a.Ecodigo, 
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
						#rsMoneda.value#,
						1.00, 
						a.Ccuenta,
						AGTPid, 
						#Arguments.Usucodigo#,
						#Arguments.Usucodigo#,
						TAdepacumadq, 
						TAdepacummej, 
						TAdepacumrev, 
						TAvaladq, 
						TAvalmej, 
						TAvalrev, 
						TAmontodepadq, 
						TAmontodepmej, 
						TAmontodeprev, 
						ACcodigoori, 
						ACidori, 
						ACcodigodest, 
						ACiddest,
						TAvalrescate
					from ADTProceso a
						inner join Activos b 
							on b.Aid = a.Aid
					where a.Ecodigo = #Arguments.Ecodigo#
						and a.AGTPid = #Arguments.AGTPid#
				</cfquery>
	
				<!--- ****************** C O N T A B I L I Z A C I O N ****************** --->
				
				<!--- Contabiliza la Transferencia de Categoría Clase--->
				<cfif Arguments.contabilizar is true>
					<!--- Crea tabla temportal TAG para crear tablas temporales, devuelve un string con el nombre de la tabla creada en la variable "temp_table"--->
					
					<cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="CreaIntarc" returnvariable="INTARC">
							<cfinvokeargument name="Conexion" value="#Arguments.Conexion#"/>
					</cfinvoke>

					<cf_dbfunction name="to_sdate" args="#now()#" returnvariable="INTFEC">
					<cf_dbfunction name="concat" args="'Retiro por Transferencia de Adq. de ', b.Aplaca" returnvariable="INTDES1">
					<cf_dbfunction name="concat" args="'Retiro por Transferencia de Mej. de ', b.Aplaca" returnvariable="INTDES2">
					<cf_dbfunction name="concat" args="'Retiro por Transferencia de Rev. de ', b.Aplaca" returnvariable="INTDES3">
					<cf_dbfunction name="concat" args="'Retiro por Dep. Acum. de Adq. de ', b.Aplaca"    returnvariable="INTDES4">
					<cf_dbfunction name="concat" args="'Retiro por Dep. Acum. de Mej. de ', b.Aplaca" 	 returnvariable="INTDES5">
					<cf_dbfunction name="concat" args="'Retiro por Dep. Acum. de Rev. de ', b.Aplaca" 	 returnvariable="INTDES6">
					
					<cf_dbfunction name="concat" args="'Transferencia de Adq. de ', b.Aplaca" 	 		returnvariable="INTDES7">
					<cf_dbfunction name="concat" args="'Transferencia de Mej. de ', b.Aplaca" 	 		returnvariable="INTDES8">
					<cf_dbfunction name="concat" args="'Transferencia de Rev. de ', b.Aplaca" 	 		returnvariable="INTDES9">
					<cf_dbfunction name="concat" args="'Dep. Acum. de Adq. de ', b.Aplaca" 	 			returnvariable="INTDES10">
					<cf_dbfunction name="concat" args="'Dep. Acum. de Mej. de ', b.Aplaca" 	 			returnvariable="INTDES11">
					<cf_dbfunction name="concat" args="'Dep. Acum. de Rev. de ', b.Aplaca" 	 			returnvariable="INTDES12">
					
					
					<!--- 1. Crédito del Valor de Adquisicion de la Categoría Clase Origen --->
					<cfquery name="rstemp" datasource="#Arguments.Conexion#">
						insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, CFid)
						select 
								'AFCC',
								1,
								<cf_dbfunction name="to_char" args="g.AGTPdocumento">, 
								'CC',
								a.TAmontolocadq,
								'C',
								#PreserveSingleQuotes(INTDES1)#,
								#PreserveSingleQuotes(INTFEC)#,
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

					<!--- 2. Crédito del Valor de Mejoras de la Categoría Clase Origen --->
					<cfquery name="rstemp" datasource="#Arguments.Conexion#">
						insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, CFid)
						select 
								'AFCC',
								1,
								<cf_dbfunction name="to_char" args="g.AGTPdocumento">, 
								'CC',
								a.TAmontolocmej,
								'C',
								#PreserveSingleQuotes(INTDES2)#,
								#PreserveSingleQuotes(INTFEC)#,
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
								and c.ACid = b.ACid
								and c.ACcodigo = b.ACcodigo
							inner join CFuncional d
								on d.CFid = a.CFid
							inner join AGTProceso g
								on g.AGTPid = a.AGTPid
						where a.Ecodigo = #Arguments.Ecodigo#
							and a.AGTPid = #Arguments.AGTPid#
					</cfquery>
					
					<!--- 3. Crédito del Valor de Revaluación de la Categoría Clase Origen --->
					<cfquery name="rstemp" datasource="#Arguments.Conexion#">
						insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, CFid)
						select 
								'AFCC',
								1,
								<cf_dbfunction name="to_char" args="g.AGTPdocumento">, 
								'CC',
								a.TAmontolocrev,
								'C',
								#PreserveSingleQuotes(INTDES3)#,
								#PreserveSingleQuotes(INTFEC)#,
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

					<!--- 4. Débito de la Depreciación Acumulada de la Adquisición de la Categoría Clase Origen --->
					<cfquery name="rstemp" datasource="#Arguments.Conexion#">
						insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, CFid)
						select 
								'AFCC',
								1,
								<cf_dbfunction name="to_char" args="g.AGTPdocumento">, 
								'CC',
								a.TAmontodepadq,
								'D',
								#PreserveSingleQuotes(INTDES4)#,
								#PreserveSingleQuotes(INTFEC)#,
								1.00,
								#rsPeriodo.value#, 
								#rsMes.value#,
								c.ACcdepacum,
								#rsMoneda.value#,
								d.Ocodigo,
								a.TAmontodepadq,
                                a.CFid
						from ADTProceso a
							inner join Activos b 
								on b.Aid = a.Aid
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
					
					<!--- 5. Débito de la Depreciación Acumulada de las Mejoras de la Categoría Clase Origen --->
					<cfquery name="rstemp" datasource="#Arguments.Conexion#">
						insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, CFid)
						select 
								'AFCC',
								1,
								<cf_dbfunction name="to_char" args="g.AGTPdocumento">, 
								'CC',
								a.TAmontodepmej,
								'D',
								#PreserveSingleQuotes(INTDES5)#,
								#PreserveSingleQuotes(INTFEC)#,
								1.00,
								#rsPeriodo.value#, 
								#rsMes.value#,
								c.ACcdepacum,
								#rsMoneda.value#,
								d.Ocodigo,
								a.TAmontodepmej,
                                a.CFid
						from ADTProceso a
							inner join Activos b 
								on b.Aid = a.Aid
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
					
					<!--- 6. Débito de la Depreciación Acumulada de la Revaluación de la Categoría Clase Origen --->
					<cfquery name="rstemp" datasource="#Arguments.Conexion#">
						insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, CFid)
						select 
								'AFCC',
								1,
								<cf_dbfunction name="to_char" args="g.AGTPdocumento">, 
								'CC',
								a.TAmontodeprev,
								'D',
								#PreserveSingleQuotes(INTDES6)#,
								#PreserveSingleQuotes(INTFEC)#,
								1.00,
								#rsPeriodo.value#, 
								#rsMes.value#,
								c.ACcdepacumrev,
								#rsMoneda.value#,
								d.Ocodigo,
								a.TAmontodeprev,
                                a.CFid
						from ADTProceso a
							inner join Activos b 
								on b.Aid = a.Aid
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
					
				</cfif>
				<!---Modificar la categoria-Clase en Activos--->
				<cfquery name="PorModificar" datasource="#Arguments.Conexion#">
					select Aid, Ecodigo, a.ACcodigodest, a.ACiddest
					from ADTProceso a
					where Ecodigo = #Arguments.Ecodigo#
					  and AGTPid  = #Arguments.AGTPid#
				</cfquery>
				<cfloop query="PorModificar">
					<cfquery datasource="#Arguments.Conexion#">
						Update Activos 
						  set ACcodigo = #PorModificar.ACcodigodest#
						     ,ACid 	   = #PorModificar.ACiddest#		
						where Aid = #PorModificar.Aid#
						and Ecodigo  	= #Arguments.Ecodigo#
					</cfquery>
				</cfloop>
				<!---Modificar la categoria-Clase en Saldos--->
				<cfloop query="PorModificar">
					<cfquery datasource="#Arguments.Conexion#">
						Update AFSaldos 
						  set ACcodigo  = #PorModificar.ACcodigodest#
						     ,ACid 	    = #PorModificar.ACiddest#		
						where Aid 		= #PorModificar.Aid#
						 and AFSperiodo = #rsPeriodo.value#
						and AFSmes 		= #rsMes.value#
						and Ecodigo  	= #Arguments.Ecodigo#
					</cfquery>
				</cfloop>
	
				<cfif Arguments.contabilizar is true>

					<!--- 7. Débito del Valor de Adquisicion de la Categoría Clase Destino --->
					<cfquery name="rstemp" datasource="#Arguments.Conexion#">
						insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, CFid)
						select 
								'AFCC',
								1,
								<cf_dbfunction name="to_char" args="g.AGTPdocumento">, 
								'CC',
								a.TAmontolocadq,
								'D',
								#PreserveSingleQuotes(INTDES7)#,
								#PreserveSingleQuotes(INTFEC)#,
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

					<!--- 8. Débito del Valor de Mejoras de la Categoría Clase Origen --->
					<cfquery name="rstemp" datasource="#Arguments.Conexion#">
						insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, CFid)
						select 
								'AFCC',
								1,
								<cf_dbfunction name="to_char" args="g.AGTPdocumento">, 
								'CC',
								a.TAmontolocmej,
								'D',
								#PreserveSingleQuotes(INTDES8)#,
								#PreserveSingleQuotes(INTFEC)#,
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
								and c.ACid = b.ACid
								and c.ACcodigo = b.ACcodigo
							inner join CFuncional d
								on d.CFid = a.CFid
							inner join AGTProceso g
								on g.AGTPid = a.AGTPid
						where a.Ecodigo = #Arguments.Ecodigo#
							and a.AGTPid = #Arguments.AGTPid#
					</cfquery>
					
					<!--- 9. Débito del Valor de Revaluación de la Categoría Clase Origen --->
					<cfquery name="rstemp" datasource="#Arguments.Conexion#">
						insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, CFid)
						select 
								'AFCC',
								1,
								<cf_dbfunction name="to_char" args="g.AGTPdocumento">, 
								'CC',
								a.TAmontolocrev,
								'D',
								#PreserveSingleQuotes(INTDES9)#,
								#PreserveSingleQuotes(INTFEC)#,
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

					<!--- 10. Crédito de la Depreciación Acumulada de la Adquisición de la Categoría Clase Origen --->
					<cfquery name="rstemp" datasource="#Arguments.Conexion#">
						insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, CFid)
						select 
								'AFCC',
								1,
								<cf_dbfunction name="to_char" args="g.AGTPdocumento">, 
								'CC',
								a.TAmontodepadq,
								'C',
								#PreserveSingleQuotes(INTDES10)#,
								#PreserveSingleQuotes(INTFEC)#,
								1.00,
								#rsPeriodo.value#, 
								#rsMes.value#,
								c.ACcdepacum,
								#rsMoneda.value#,
								d.Ocodigo,
								a.TAmontodepadq,
                                a.CFid
						from ADTProceso a
							inner join Activos b 
								on b.Aid = a.Aid
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
					
					<!--- 11. Crédito de la Depreciación Acumulada de las Mejoras de la Categoría Clase Origen --->
					<cfquery name="rstemp" datasource="#Arguments.Conexion#">
						insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, CFid)
						select 
								'AFCC',
								1,
								<cf_dbfunction name="to_char" args="g.AGTPdocumento">, 
								'CC',
								a.TAmontodepmej,
								'C',
								#PreserveSingleQuotes(INTDES11)#,
								#PreserveSingleQuotes(INTFEC)#,
								1.00,
								#rsPeriodo.value#, 
								#rsMes.value#,
								c.ACcdepacum,
								#rsMoneda.value#,
								d.Ocodigo,
								a.TAmontodepmej,
                                a.CFid
						from ADTProceso a
							inner join Activos b 
								on b.Aid = a.Aid
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
					
					<!--- 12. Crédito de la Depreciación Acumulada de la Revaluación de la Categoría Clase Origen --->
					<cfquery name="rstemp" datasource="#Arguments.Conexion#">
						insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, CFid)
						select 
								'AFCC',
								1,
								<cf_dbfunction name="to_char" args="g.AGTPdocumento">, 
								'CC',
								a.TAmontodeprev,
								'C',
								#PreserveSingleQuotes(INTDES12)#,
								#PreserveSingleQuotes(INTFEC)#,
								1.00,
								#rsPeriodo.value#, 
								#rsMes.value#,
								c.ACcdepacumrev,
								#rsMoneda.value#,
								d.Ocodigo,
								a.TAmontodeprev,
                                a.CFid
						from ADTProceso a
							inner join Activos b 
								on b.Aid = a.Aid
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
						<cfinvokeargument name="Oorigen" value="AFCC"/>
						<cfinvokeargument name="Eperiodo" value="#rsPeriodo.value#"/>
						<cfinvokeargument name="Emes" value="#rsMes.value#"/>
						<cfinvokeargument name="Efecha" value="#rsFechaAux.value#"/>
						<cfinvokeargument name="Edescripcion" value="#Arguments.descripcion#"/>
						<cfinvokeargument name="Edocbase" value="#rsAGTProceso.AGTPdocumento#"/>
						<cfinvokeargument name="Ereferencia" value="CC"/>
						<cfinvokeargument name="Ocodigo" value="#LvarOcodigo#"/>
						<cfinvokeargument name="Debug" value="#Arguments.Debug#"/>
					</cfinvoke>
					<cfquery name="rstemp" datasource="#Arguments.Conexion#">
						update TransaccionesActivos 
						set IDcontable = #res_GeneraAsiento#
						where Ecodigo = #Arguments.Ecodigo#
						and AGTPid = #Arguments.AGTPid#
					</cfquery>

				</cfif> <!--- <cfif Arguments.contabilizar is true> --->
				
				<!---Borra ADTProceso--->
				<cfquery name="rsDelteADTProceso" datasource="#Arguments.Conexion#">
					delete from ADTProceso
					where Ecodigo = #Arguments.Ecodigo#
						and AGTPid = #Arguments.AGTPid#
				</cfquery>
				
				<!---Actualiza estado a AGTProceso--->
				<cfquery name="rsUpdateAGTProceso" datasource="#Arguments.Conexion#">
					Update AGTProceso
					set AGTPestadp = 4,
					AGTPfaplica = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					AGTPipaplica = '#Arguments.IPaplica#',
					Usuaplica = #Arguments.Usucodigo#
					where AGTPid = #Arguments.AGTPid#
				</cfquery>

				<cfif Arguments.Debug>
					<cfquery name="rsdebug" datasource="#Arguments.Conexion#" maxrows="10">
						select * from AGTProceso where AGTPid = #Arguments.AGTPid#
					</cfquery>
					<cfdump var="#rsdebug#" label="AGTProceso">
					<cfquery name="rsdebug" datasource="#Arguments.Conexion#" maxrows="10">
						select  * from ADTProceso where AGTPid = #Arguments.AGTPid#
					</cfquery>
					<cfdump var="#rsdebug#" label="ADTProceso" maxrows="10">
					<cfquery name="rsdebug" datasource="#Arguments.Conexion#">
						select * from TransaccionesActivos where AGTPid = #Arguments.AGTPid#
					</cfquery>
					<cfdump var="#rsdebug#" label="TransaccionesActivos">
					<cfquery name="rsdebug" datasource="#Arguments.Conexion#" maxrows="10">
						select* from AFSaldos 
						where Ecodigo = #Arguments.Ecodigo#
						and AFSperiodo = #rsPeriodo.value#
						and AFSmes = #rsMes.value#
						and Aid in (
						select Aid from TransaccionesActivos where AGTPid = #Arguments.AGTPid#
						)
					</cfquery>
					<cfdump var="#rsdebug#" label="AFSaldos">
					<h3>Ejecuta Rollback por Debug</h3>
					<cftransaction action="rollback"/>
					<cf_abort errorInterfaz="">
				</cfif>
			</cftransaction>
		<!---Si llega hasta aquí todo salió bien--->
		<cfreturn true>
	</cffunction>

	<cffunction name="fnIsNull" access="private" returntype="boolean" output="false">
		<cfargument name="lValue" required="yes" type="any">
		<cfargument name="IValueIfNull" required="yes" type="any">
		<cfif len(trim(lValue))>
			<cfreturn lValue>
		<cfelse>
			<cfreturn IValueIfNull>
		</cfif>
	</cffunction>
</cfcomponent>


<cfcomponent>
	<cffunction name="AF_ContabilizarRetiro" access="public" returntype="boolean" output="true">
		<cfargument name="Ecodigo" 			 type="numeric" 	required="no" 	default="0"><!--- Código de Empresa (sif) --->
		<cfargument name="Usucodigo" 		 type="numeric" 	required="no" 	default="0"><!--- Código de Usuario (asp) --->
		<cfargument name="Conexion" 		 type="string" 		required="no" 	default=""><!--- IP de PC de Usuario --->

		<cfargument name="AGTPid" 			 type="numeric" 	required="yes">
		<cfargument name="Programar" 		 type="boolean" 	required="no" 	default="false"><!---Si es verdadero se requiere la fecha de programación y solo se programa y no se calcula--->
		<cfargument name="FechaProgramacion" type="date" 		required="no" 	default="#CreateDate(1900,01,01)#">

		<cfargument name="Periodo" 			 type="numeric" 	required="no" 	default="0"><!---Si se envían No se sacan de la tabla de parámetros--->
		<cfargument name="Mes" 				 type="numeric" 	required="no" 	default="0"><!---Si se envían No se sacan de la tabla de parámetros--->
		<cfargument name="debug" 			 type="boolean" 	required="no" 	default="false"><!--- si se prende simula la transacción, pinta los resultados y desahace los cambios --->

		<cfargument name="contabilizar" 	 type="boolean" 	required="no" 	default="true"><!--- si se apaga no contabiliza pero si aplica el retiro, por ahora solo se utiliza para las pruebas iniciales del sistema --->
		<cfargument name="descripcion" 		 type="string" 		required="no" 	default="Activo Fijo: Retiro"><!--- Descripción de la transacción --->
		<cfargument name="IDcontable" 		 type="numeric" 	required="no" 	default="0"><!--- IDcontable se utiliza para enviar el número interno de asiento contable cuando se envía el parámetro de no contabilizar para guardarlo en la tabla transaccionesactivos --->
	
		<cfargument name="TransaccionActiva" type="boolean" 	required="no" 	default="false">
		<cfargument name="IPregistro" 		 type="string" 		required="no" 	default="">
		<!--- Para contabiliozar los retiros del proceso de traslados entre compañias--->
		<cfargument name="AstInter" 		 type="boolean" 	required="no" 	default="false">
		<cfargument name="EmpresaOrigen" 	 type="numeric" 	required="no" 	default="0"><!--- Código de Empresa Origen. Si no viene se pone el de session --->
		
		<cfif Arguments.TransaccionActiva>
			<cfinvoke 
				method="AF_ContabilizarRetiroPrivate"
				returnvariable="private_results"
				Ecodigo="#Arguments.Ecodigo#"
				Usucodigo="#Arguments.Usucodigo#"
				Conexion="#Arguments.Conexion#"
				AGTPid="#Arguments.AGTPid#"
				Programar="#Arguments.Programar#"
				FechaProgramacion="#Arguments.FechaProgramacion#"
				Mes="#Arguments.Mes#"
				debug="#Arguments.debug#"
				contabilizar="#Arguments.contabilizar#"					
				descripcion="#Arguments.descripcion#"
				IDcontable="#Arguments.IDcontable#"
				IPregistro="#Arguments.IPregistro#"
				AstInter="#Arguments.AstInter#"
				EmpresaOrigen="#Arguments.EmpresaOrigen#"/>
		<cfelse>
			<cftransaction>
				<cfinvoke 
					method="AF_ContabilizarRetiroPrivate"
					returnvariable="private_results"
					Ecodigo="#Arguments.Ecodigo#"
					Usucodigo="#Arguments.Usucodigo#"
					Conexion="#Arguments.Conexion#"
					AGTPid="#Arguments.AGTPid#"
					Programar="#Arguments.Programar#"
					FechaProgramacion="#Arguments.FechaProgramacion#"
					Mes="#Arguments.Mes#"
					debug="#Arguments.debug#"
					contabilizar="#Arguments.contabilizar#"
					descripcion="#Arguments.descripcion#"
					IDcontable="#Arguments.IDcontable#"
					IPregistro="#Arguments.IPregistro#"
					AstInter="#Arguments.AstInter#"
					EmpresaOrigen="#Arguments.EmpresaOrigen#"/>
			</cftransaction>
		</cfif>
		
		<cfreturn private_results>
		
	</cffunction>

	<cffunction name="AF_ContabilizarRetiroPrivate" access="private" returntype="boolean" output="true">
		<cfargument name="Ecodigo" 			 type="numeric" required="no" default="0" ><!--- Código de Empresa (sif) --->
		<cfargument name="Usucodigo" 		 type="numeric" required="no" default="0" ><!--- Código de Usuario (asp) --->
		<cfargument name="Conexion" 		 type="string"  required="no" default=""  ><!--- IP de PC de Usuario --->

		<cfargument name="AGTPid" 			 type="numeric" required="yes">
		<cfargument name="Programar" 		 type="boolean" required="no" default="false" ><!---Si es verdadero se requiere la fecha de programación y solo se programa y no se calcula--->
		<cfargument name="FechaProgramacion" type="date"    required="no" default="#CreateDate(1900,01,01)#">

		<cfargument name="Periodo" 			 type="numeric" required="no" default="0" ><!---Si se envían No se sacan de la tabla de parámetros--->
		<cfargument name="Mes" 				 type="numeric" required="no" default="0" ><!---Si se envían No se sacan de la tabla de parámetros--->
		<cfargument name="debug" 			 type="boolean" required="no" default="false" ><!--- si se prende simula la transacción, pinta los resultados y desahace los cambios --->
		<cfargument name="detaildebug" 		 type="boolean" required="no" default="#Arguments.debug#" >

		<cfargument name="contabilizar" 	 type="boolean" required="no" default="true" ><!--- si se apaga no contabiliza pero si aplica el retiro, por ahora solo se utiliza para las pruebas iniciales del sistema --->
		<cfargument name="descripcion" 		 type="string"  required="no" default="Activo Fijo: Retiro" ><!--- Descripción de la transacción --->
		<cfargument name="IDcontable" 		 type="numeric" required="no" default="0" ><!--- IDcontable se utiliza para enviar el número interno de asiento contable cuando se envía el parámetro de no contabilizar para guardarlo en la tabla transaccionesactivos --->
		
		<cfargument name="IPregistro" 		 type="string"  required="no"  default="" >
		
		<!--- Este parametro determina si es un asiento de retiro intercompany --->
		<cfargument name="AstInter" 		type="boolean" required="no"   default="false" >
		<cfargument name="EmpresaOrigen" 	type="numeric" required="no"   default="0" >
		
		<cfset var lVarComplemento = ''>
		<cfset var lVarErrorCta = 0>
		<cfset var lVarCtasError = ''>
		<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
		
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
		<cfelse>
		
			<!---
			Como los componentes pueden ser utilizados con o sin session, cada vez que el 
			Ecodigo venga en cero, se sabe que existe session, ya que no existe un Ecodigo
			en la aplicacion que sea cero. En caso de que se envía un Ecodigo, se pregunta
			individualmente por los argumentos pertinentes, para garantizar de que vienen con
			un valor.
			--->
			<cfif Arguments.Conexion eq "">
				<cf_errorCode	code = "50919" msg = "No se definió el nombre de la conexión">
			</cfif>
			<cfif Arguments.Usucodigo eq "0">
				<cf_errorCode	code = "50920" msg = "No se definió el usuario que realizó el proceso de contabilización del retiro">
			</cfif>
			<cfif Arguments.IPregistro eq "">
				<cf_errorCode	code = "50921" msg = "No se definió la dirección IP del equipo desde donde se realizó la contabilización del retiro">
			</cfif>
			
		</cfif>

		<!--- En caso de no venir la empresa se le asigna la misma del Ecodigo --->
		<cfif Arguments.EmpresaOrigen eq 0>
			<cfset Arguments.EmpresaOrigen = Arguments.Ecodigo>
		</cfif>
				
		<!---Valida que el AGTPid corresponda a un Proceso Válido--->
		<cfquery name="rsAGTProcesov" datasource="#Arguments.Conexion#">
			select count(1) as cuantos 
			   from AGTProceso
			where AGTPid = #Arguments.AGTPid#
			and AGTPestadp in (0,2)
		</cfquery>
		<cfif rsAGTProcesov.cuantos is not 1>
			<cf_errorCode	code = "50911" msg = "El Grupo de Transacciones seleccionado es inválido!, Proceso Cancelado!">
		</cfif>

		<!---Antes de iniciar la transacción hace algunos calculos--->
		<!--- Obtiene el tipo de Retiro --->
		<cfquery name="rsAGTProceso" datasource="#Arguments.Conexion#">
			select d.AFResventa
			  from AGTProceso a
				inner join AFRetiroCuentas d 
					on d.Ecodigo = a.Ecodigo 
					and d.AFRmotivo = a.AFRmotivo
			where AGTPid = #Arguments.AGTPid#
			and a.AGTPestadp in (0,2)
		</cfquery>
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
		
		<cfif Arguments.debug>
			<!--- Pinta los valores obtenidos hasta el momento para debug --->
			<cfoutput>
				<cfflush interval="1">
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
		
		<!--- Obtiene el número de Documento --->
		<cfquery name="rsAGTProcesoDoc" datasource="#Arguments.Conexion#">
			select AGTPdocumento, AGTPperiodo, AGTPmes 
			from AGTProceso 
			where AGTPid = #Arguments.AGTPid#
		</cfquery>
               
		<cfif rsAGTProcesoDoc.recordcount eq 0 or (rsAGTProcesoDoc.recordcount and len(trim(rsAGTProcesoDoc.AGTPdocumento)) eq 0) or rsAGTProcesoDoc.AGTPdocumento eq 0>
			<cf_errorCode	code = "50922" msg = "Error obteniendo el Documento, No se pudo obtener el documento de la transacción de retiro, Proceso Cancelado!">
		</cfif>

		<!--- Validaciones Iniciales, valida periodo, mes, moneda --->
		<cfif len(trim(rsPeriodo.value)) eq 0><cf_errorCode	code = "50031" msg = "No se ha definido el parámetro Periodo para los Sistemas Auxiliares! Proceso Cancelado!"></cfif>
		<cfif len(trim(rsMes.value)) eq 0><cf_errorCode	code = "50032" msg = "No se ha definido el parámetro Mes para los Sistemas Auxiliares! Proceso Cancelado!"></cfif>
		<cfif len(trim(rsMoneda.value)) eq 0><cf_errorCode	code = "50909" msg = "No se ha definido el parámetro Moneda Local para la Empresa! Proceso Cancelado!"></cfif>
		
		<!--- Validación de Periodo Auxiliar y Mes Auxiliar con el Periodo y Mes del registro --->
		<cfif rsAGTProcesoDoc.AGTPperiodo neq rsPeriodo.value>
			<cf_errorCode	code = "50923" msg = "Error comparando Periodo, El Periodo no puede ser diferente al Periodo Auxiliar, Proceso Cancelado!">
		</cfif>
		<cfif rsAGTProcesoDoc.AGTPmes neq rsMes.value>
			<cf_errorCode	code = "50924" msg = "Error comparando Mes, El Mes no puede ser diferente al Mes Auxiliar, Proceso Cancelado!">
		</cfif>
		<!--- Valida el valor residual con respecto al monto de adquisición --->
		<cfquery name="rsValRescate" datasource="#Arguments.Conexion#">
			select count(1) as total
			from ADTProceso a
				inner join Activos b
				  on a.Aid = b.Aid 
			where ( a.TAvaladq - a.TAmontolocadq) < b.Avalrescate
			  and ( a.TAvaladq - a.TAmontolocadq) > 0
			  and a.AGTPid = #Arguments.AGTPid#
		</cfquery>
		
		<cfif rsValRescate.total gt 0>
			<cfset LvarMessage = "">
			<cfquery name="rsValRescate" datasource="#Arguments.Conexion#">
				select b.Aplaca
				from ADTProceso a
					inner join Activos b
					  on a.Aid = b.Aid 
				where ( a.TAvaladq - a.TAmontolocadq) < b.Avalrescate
				  and ( a.TAvaladq - a.TAmontolocadq) > 0
				  and a.AGTPid = #Arguments.AGTPid#
			</cfquery>
			<cfloop query="rsValRescate">
				<cfset LvarMessage = LvarMessage & " #rsValRescate.Aplaca#,">
			</cfloop>
			<cf_errorCode	code = "50925"
							msg  = "El monto de adquisición del activo es menor al correspondiente valor residual ó valor de rescate: @errorDat_1@"
							errorDat_1="#left(LvarMessage, len(LvarMessage) - 1)#"
			>
		</cfif>
		<!--- Si programar --->
		<cfif (Arguments.Programar)>
			<cfquery name="rsActualizaProceso" datasource="#Arguments.Conexion#">
				Update AGTProceso 
				set AGTPestadp = 2,
				AGTPfechaprog = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.FechaProgramacion#" null="#DateCompare(Arguments.FechaProgramacion, Now()) eq -1#">
				where AGTPid = #Arguments.AGTPid#
			</cfquery>
		<cfelse>
			<!---Inicio Aplicación del Retiro --->
			<!--- <cftransaction> --->
				
				<!--- Contabiliza el retiro --->
				<cfif Arguments.contabilizar is true>
					<!--- *************************** F O R M A  L A S  C U E N T A S *************************** --->
					
					<!--- Pone todas las cuentas en -1 porque a este punto no puede haber ninguna definida --->
					<cfquery datasource="#Arguments.Conexion#">
						update ADTProceso
						set Ccuenta = -1
						where AGTPid = #Arguments.AGTPid#
					</cfquery>
					
					<!--- Pone la cuenta de Gasto/Ingreso del Motivo de Retiro si esta definida --->					
				    <cfquery name="PorActulizar" datasource="#Arguments.Conexion#">
						select 	b.ADTPlinea, c.AFSvaladq,c.AFSvalmej,c.AFSvalrev,c.AFSdepacumadq,c.AFSdepacummej,c.AFSdepacumrev, d.AFRgasto,d.AFRingreso, d.AFRgasto, d.AFRingreso
							from AGTProceso a
								inner join ADTProceso b
									on a.AGTPid = b.AGTPid
								inner join AFSaldos c
									on 	b.Aid	    = c.Aid
									and b.Ecodigo   = c.Ecodigo 
									and b.TAperiodo = c.AFSperiodo 
									and b.TAmes 	= c.AFSmes 
								inner join AFRetiroCuentas d
									on a.AFRmotivo  = d.AFRmotivo
							    	and a.Ecodigo   = d.Ecodigo
					 	where  a.AGTPid = #Arguments.AGTPid#
						and b.Ccuenta < 0			
					</cfquery>
					<cfloop query="PorActulizar">
						<cfquery datasource="#Arguments.Conexion#">
							update ADTProceso
								set Ccuenta = 
									 	coalesce(case when (coalesce(TAmontolocventa,0.00) - ((#PorActulizar.AFSvaladq# + #PorActulizar.AFSvalmej# + #PorActulizar.AFSvalrev#)
												 - (#PorActulizar.AFSdepacumadq# +  #PorActulizar.AFSdepacummej#+  #PorActulizar.AFSdepacumrev#)
												  )) < 0 
											then #iif(len(trim(PorActulizar.AFRgasto)),PorActulizar.AFRgasto,-1)# 
											else #iif(len(trim(PorActulizar.AFRingreso)),PorActulizar.AFRingreso,-1)# 
											end,-1)
							where ADTPlinea = #PorActulizar.ADTPlinea#
						</cfquery>
					</cfloop>
					
					<!--- Obtiene las cuentas que aún no han sido asignadas --->
					<cfquery name="rsTADTProceso" datasource="#Arguments.Conexion#">
						select distinct a.CFid, d.CFcodigo, 
						case when (coalesce(round(a.TAmontolocventa,2),0.00)-((round(e.AFSvaladq,2)+round(e.AFSvalmej,2)+round(e.AFSvalrev,2))-(round(e.AFSdepacumadq,2)+round(e.AFSdepacummej,2)+round(e.AFSdepacumrev,2)))) <= 0 
						then coalesce(d.CFcuentagastoretaf,d.CFcuentaaf, d.CFcuentac)
						else coalesce(d.CFcuentaingresoretaf,d.CFcuentaaf, d.CFcuentac) end as FormatoCta,
						c.ACcodigo, c.ACid, c.ACcodigodesc as Clase, ct.ACcodigodesc as Categoria,
						case when (coalesce(round(a.TAmontolocventa,2),0.00)-((round(e.AFSvaladq,2)+round(e.AFSvalmej,2)+round(e.AFSvalrev,2))-(round(e.AFSdepacumadq,2)+round(e.AFSdepacummej,2)+round(e.AFSdepacumrev,2)))) <= 0 
						then c.ACgastoret else c.ACingresoret end as ACgastoingreso
							from ADTProceso a
							inner join Activos b
								on b.Aid = a.Aid
							inner join AClasificacion c
								on c.Ecodigo = b.Ecodigo
								and c.ACcodigo = b.ACcodigo
								and c.ACid = b.ACid
							inner join ACategoria ct
								on ct.Ecodigo = b.Ecodigo
								and ct.ACcodigo = b.ACcodigo
							inner join CFuncional d
								on d.CFid = a.CFid
							inner join AFSaldos e
								on e.Aid = a.Aid
								and e.Ecodigo = a.Ecodigo
								and e.AFSperiodo = a.TAperiodo
								and e.AFSmes = a.TAmes
							inner join AGTProceso f
								on f.AGTPid = a.AGTPid
							inner join AFRetiroCuentas g
								on g.AFRmotivo = f.AFRmotivo
								and g.Ecodigo = f.Ecodigo
						where a.AGTPid = #Arguments.AGTPid#
							and a.Ccuenta < 0
					</cfquery>
					<!--- Procesar las cuentas distintas --->
					<cfquery name="rsADTProceso" dbtype="query">
						select distinct CFid, CFcodigo, FormatoCta, ACgastoingreso
						from rsTADTProceso
					</cfquery>
					<!--- Inicia el procesamiento por las cuentas distintas --->
					<cfloop query="rsADTProceso">
						<cfset lVarCFid = rsADTProceso.CFid>
						<cfset lVarCFcodigo = rsADTProceso.CFcodigo>
						<cfset lVarACgastoingreso = rsADTProceso.ACgastoingreso>
						<cfset lVarCuentagastoingreso = AplicarMascara(rsADTProceso.FormatoCta,rsADTProceso.ACgastoingreso)>
                        

						<cfinvoke component="PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" returnvariable="LvarError">
							<cfinvokeargument name="Lprm_Cmayor" 			value="#Left(lVarCuentagastoingreso,4)#"/>							
							<cfinvokeargument name="Lprm_Cdetalle" 			value="#mid(lVarCuentagastoingreso,6,100)#"/>
							<cfinvokeargument name="Lprm_TransaccionActiva" value="true"/>
							<cfinvokeargument name="Lprm_DSN" 				value="#Arguments.Conexion#"/>
							<cfinvokeargument name="Lprm_Ecodigo" 			value="#Arguments.Ecodigo#"/>
						</cfinvoke>
			
						<cfif LvarError NEQ "OLD" AND LvarError NEQ "NEW">
								<cfquery name="rsClaseCategoria" dbtype="query">
									select distinct Categoria, Clase
									from rsTADTProceso
									where CFid = #lVarCFid#
									  <cfif len(trim(lVarACgastoingreso)) eq 0>
										and ACgastoingreso is null 
									  <cfelse>
										and ACgastoingreso = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lVarACgastoingreso#">
									  </cfif>
								</cfquery>
								<cfloop query="rsClaseCategoria">
									<cfset lVarCtasError = lVarCtasError & "<li>Cuenta Centro Funcional: " & lVarCFcodigo & ' Cat/Clase ' & rsClaseCategoria.Categoria & '-' & rsClaseCategoria.Clase & ' Cuenta:' & lVarCuentagastoingreso & " no es correcta: " & LvarError & "</li>">
								</cfloop>
								<cfset lVarErrorCta = 1>
						</cfif>
                        
                        
						<cfif lVarErrorCta EQ 0>
						    <!---Actualiza las cuentas que no se han asignado aun y que no tiene errores--->
							<cfquery name="ActCuenta" datasource="#Arguments.Conexion#">
								select ADTPlinea											  
								from ADTProceso d
								  inner join AFSaldos e
									 on e.Aid        = d.Aid
									and e.Ecodigo    = d.Ecodigo
									and e.AFSperiodo = d.TAperiodo
									and e.AFSmes     = d.TAmes
								inner join AGTProceso f
									on f.AGTPid = d.AGTPid
								inner join AFRetiroCuentas g
									on g.AFRmotivo = f.AFRmotivo
								   and g.Ecodigo   = f.Ecodigo
								
							   where d.AGTPid = #Arguments.AGTPid#
								 and d.CFid   = #lVarCFid#
								 and d.Ccuenta < 0
								 and exists(select 1 
											from Activos a
											  inner join AClasificacion c 
											  	on c.Ecodigo  = a.Ecodigo
											   and c.ACcodigo = a.ACcodigo
											   and c.ACid     = a.ACid
											where a.Aid = d.Aid
											  and case when (coalesce(round(d.TAmontolocventa,2),0.00)-((round(e.AFSvaladq,2)+round(e.AFSvalmej,2)+round(e.AFSvalrev,2))-(round(e.AFSdepacumadq,2)+round(e.AFSdepacummej,2)+round(e.AFSdepacumrev,2)))) <= 0
													then c.ACgastoret else c.ACingresoret end = '#lVarACgastoingreso#')
							</cfquery>
							<cfloop query="ActCuenta">
								<cfquery datasource="#Arguments.Conexion#">
									Update ADTProceso
									  set Ccuenta = 
									    coalesce((select Ccuenta from CFinanciera where Ecodigo=#Arguments.Ecodigo# and CFformato='#lVarCuentagastoingreso#'),-1)	
									where ADTPlinea=#ActCuenta.ADTPlinea#
								</cfquery>
							</cfloop>
						</cfif>
					</cfloop>
				
					<cfif Lvarerrorcta eq 1>
						<p><h3>Error A! Existen Cuentas inválidas! Proceso Cancelado!</h3></p>
						<cfoutput>
						<ul>
						#Replace(lVarCtasError,'<br>','</li><li>','all')#
						</ul>
						</cfoutput>
						<cf_abort errorInterfaz="">
					</cfif>
					
					<cfquery name="rsCount" datasource="#Arguments.Conexion#">
						select 1 
						from ADTProceso 
						where AGTPid = #Arguments.AGTPid#
						and Ccuenta < 1
					</cfquery>
					
					<cfif rsCount.recordcount GT 0>
						<p><h3>Error B! No se pudo crear la cuenta para los siguientes Centros Funcionales / Categorías / Clases! Proceso Cancelado!</h3></p>
						<cfquery name="rsErrores" datasource="#Arguments.Conexion#">
							select distinct d.CFcodigo, c.ACcodigodesc as Clase, ct.ACcodigodesc as Categoria
							from ADTProceso a
								inner join Activos b
									on b.Aid = a.Aid
								inner join AClasificacion c
									on c.Ecodigo = b.Ecodigo
									and c.ACcodigo = b.ACcodigo
									and c.ACid = b.ACid
								inner join ACategoria ct
									on ct.Ecodigo = b.Ecodigo
									and ct.ACcodigo = b.ACcodigo
								
								inner join CFuncional d
									on d.CFid = a.CFid
							where a.AGTPid = #Arguments.AGTPid#
								and a.Ccuenta < 0
						</cfquery>

						<cfoutput query="rsErrores">
							<ul>
							<li>Centro Funcional #CFcodigo#, Categoria #Categoria#, Clase #Clase#.</li><br>
							</ul>
						</cfoutput>
						<cf_abort errorInterfaz="">
					</cfif>
					
					<!--- 
					Actualiza el centro funcional, con el que tiene la tabla de saldos para el
					periodo-mes del auxiliar actual. Esto porque la cola pudo haber hecho movimientos
					y la transaccion de retiro estaba pendiente desde antes que se hicieran esos
					movimientos.
					--->
					<cfquery datasource="#Arguments.Conexion#">
						Update ADTProceso 
						set CFid = (select afs.CFid
										from AFSaldos afs
									where ADTProceso.Aid 	= afs.Aid
						  			and ADTProceso.Ecodigo  = afs.Ecodigo
						  			and afs.AFSperiodo 	    = #rsPeriodo.value#
						  			and afs.AFSmes 	 	    = #rsMes.value#
									and ADTProceso.AGTPid   = #Arguments.AGTPid#)
						  Where AGTPid = #Arguments.AGTPid#
					</cfquery>			
					
                    <!--- Verifica las Cuentas de los Clientes para Retiros de Venta --->
                    TAmontolocventa
                    <cfquery datasource="#session.dsn#" name="rsVerificaC">
                    	select 1
                        from ADTProceso a
                            left join SNegocios sn
                                on a.Ecodigo = sn.Ecodigo 
                                and a.SNcodigo = sn.SNcodigo
                            left join SNCCTcuentas snc
                                inner join CFinanciera scf
                                    on snc.Ecodigo = scf.Ecodigo 
                                    and snc.CFcuenta =scf.CFcuenta
                                on a.Ecodigo = snc.Ecodigo 
                                and a.SNcodigo = snc.SNcodigo	
                                and a.CCTcodigo = snc.CCTcodigo
                        where AGTPid = #Arguments.AGTPid#
                        and TAmontolocventa > 0
                        and TipoCuentaRetiro = 1
                        and sn.SNcuentacxc is null
                        and scf.Ccuenta is null
                    </cfquery>
                    <cfif rsVerificaC.recordcount GT 0>
                    	<cfthrow message="Existe un Socio de Negocios en Retiro por Venta que no tiene Cuenta Cliente">
                    </cfif>
                    													
					<!--- **************************** C O N T A B I L I Z A C I O N **************************** --->
					
					<!--- Crea tabla temportal TAG para crear tablas temporales, devuelve un string con el nombre de la tabla creada en la variable "temp_table"--->
					<cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="CreaIntarc" returnvariable="INTARC">
							<cfinvokeargument name="Conexion" value="#Arguments.Conexion#"/>
					</cfinvoke>
					
						<cf_dbfunction name="string_part"  args="b.Adescripcion,1,40" returnvariable= "DesActivo">
                        <cf_dbfunction name="string_part"  args="g.AFRdescripcion,1,15" returnvariable= "DesAFRetiroCuentas">
                        
						<cf_dbfunction name="concat"       args="'RT: ', b.Aplaca"    returnvariable= "INTREF">
						<cf_dbfunction name="concat"       args="'Retiro de Adquisición de ';#PreserveSingleQuotes(DesActivo)#" returnvariable= "INTDES" delimiters=";">
						<cf_dbfunction name="concat"       args="'Retiro de Mejoras de ';#PreserveSingleQuotes(DesActivo)#" returnvariable= "INTDES2" delimiters=";">
						<cf_dbfunction name="concat"       args="'Retiro de Revaluación de ';#PreserveSingleQuotes(DesActivo)#" returnvariable= "INTDES3" delimiters=";">
						<cf_dbfunction name="concat"       args="'Retiro de la Dep.Acumulada de Adq.';#PreserveSingleQuotes(DesActivo)#" returnvariable= "INTDES4" delimiters=";"> 
						<cf_dbfunction name="concat"       args="'Retiro de la Dep.Acumul. de Mejoras ';#PreserveSingleQuotes(DesActivo)#" returnvariable= "INTDES5" delimiters=";">
						<cf_dbfunction name="concat"       args="'Retiro de la Dep.Acum.Revaluación de ';#PreserveSingleQuotes(DesActivo)#" returnvariable= "INTDES6" delimiters=";"> 
						<cf_dbfunction name="concat"       args="'Cuenta por Cobrar Intercompañia - Placa: ';b.Aplaca" returnvariable= "INTDES7" delimiters=";"> 
						<cf_dbfunction name="concat"       args="'Venta del Activo ';#PreserveSingleQuotes(DesActivo)#" returnvariable= "INTDES8" delimiters=";"> 
						<cf_dbfunction name="concat"       args="'Impuesto de Venta del Activo ';#PreserveSingleQuotes(DesActivo)#" returnvariable= "INTDES9" delimiters=";"> 
						<cf_dbfunction name="concat"       args="'Gasto por Retiro por ';#PreserveSingleQuotes(DesAFRetiroCuentas)#; ' de ';#PreserveSingleQuotes(DesActivo)#" returnvariable= "INTDES10" delimiters=";"> 

					 	<cf_dbfunction name="concat"       args="'Gasto por Retiro por ';#PreserveSingleQuotes(DesAFRetiroCuentas)#; ' de ';#PreserveSingleQuotes(DesActivo)#" returnvariable= "INTDES12" delimiters=";"> 
						<cf_dbfunction name="concat"       args="'Ingreso por Retiro ';#PreserveSingleQuotes(DesAFRetiroCuentas)#; ' de ';#PreserveSingleQuotes(DesActivo)#" returnvariable= "INTDES13" delimiters=";"> 
					<!---Retiro Adiquisicion--->							
					<cfquery datasource="#Arguments.Conexion#">
						insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, CFid)
						select 
								'AFRT',
								1,
								<cf_dbfunction name="to_char" args="g.AGTPdocumento">, 
								#PreserveSingleQuotes(INTREF)#,
								round(a.TAmontolocadq,2) as TAmontolocadq,
								'C',
								#PreserveSingleQuotes(INTDES)#,
								'#DateFormat(now(),'YYYYMMDD')#',
								1.00,
								#rsPeriodo.value#, 
								#rsMes.value#,
								c.ACcadq,
								#rsMoneda.value#,
								d.Ocodigo,
								round(a.TAmontolocadq,2) as TAmontolocadq1,
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
					</cfquery>
					<cfif Arguments.detaildebug>
						<cfquery name="rstemp" datasource="#Arguments.Conexion#">
							select * from #INTARC#
						</cfquery>
						<cfdump var="#rstemp#" label="1rst Insert">
					</cfif>
					<!---Retiro Mejoras --->
					<cfquery datasource="#Arguments.Conexion#">
						insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, CFid)
						select 
								'AFRT',
								1,
								<cf_dbfunction name="to_char" args="g.AGTPdocumento">, 
								#PreserveSingleQuotes(INTREF)#,
								round(a.TAmontolocmej,2) as TAmontolocmej,
								'C',
								#PreserveSingleQuotes(INTDES2)#,
								'#DateFormat(now(),'YYYYMMDD')#',
								1.00,
								#rsPeriodo.value#, 
								#rsMes.value#,
								c.ACcadq,
								#rsMoneda.value#,
								d.Ocodigo,
								round(a.TAmontolocmej,2) as TAmontolocmej1,
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
					</cfquery>
					<cfif Arguments.detaildebug>
						<cfquery name="rstemp" datasource="#Arguments.Conexion#">
							select * from #INTARC#
						</cfquery>
						<cfdump var="#rstemp#" label="2nd Insert">
					</cfif>
					<!---Retiro Reevaluacion--->
					<cfquery datasource="#Arguments.Conexion#">
						insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, CFid)
						select 
								'AFRT',
								1,
								<cf_dbfunction name="to_char" args="g.AGTPdocumento">, 
								#PreserveSingleQuotes(INTREF)#,
								round(a.TAmontolocrev,2) as TAmontolocrev,
								'C',
								#PreserveSingleQuotes(INTDES3)#,
								'#DateFormat(now(),'YYYYMMDD')#',
								1.00,
								#rsPeriodo.value#, 
								#rsMes.value#,
								c.ACcrevaluacion,
								#rsMoneda.value#,
								d.Ocodigo,
								round(a.TAmontolocrev,2) as TAmontolocrev1,
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
					</cfquery>
					<cfif Arguments.detaildebug>
						<cfquery name="rstemp" datasource="#Arguments.Conexion#">
							select * from #INTARC#
						</cfquery>
						<cfdump var="#rstemp#" label="3rd Insert">
					</cfif>
					<!---Retiro Depreciación--->
					<cfquery datasource="#Arguments.Conexion#">
						insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, CFid)
						select 
								'AFRT',
								1,
								<cf_dbfunction name="to_char" args="g.AGTPdocumento">, 
								#PreserveSingleQuotes(INTREF)#,
								round(TAmontodepadq,2) as TAmontodepadq,
								'D',
								#PreserveSingleQuotes(INTDES4)#,
								'#DateFormat(now(),'YYYYMMDD')#',
								1.00,
								#rsPeriodo.value#, 
								#rsMes.value#,
								c.ACcdepacum,
								#rsMoneda.value#,
								d.Ocodigo,
								round(TAmontodepadq,2) as TAmontodepadq1,
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
							inner join AFSaldos e
								on e.Aid = a.Aid
								and e.Ecodigo = a.Ecodigo
								and e.AFSperiodo = a.TAperiodo
								and e.AFSmes = a.TAmes
							inner join AGTProceso g
								on g.AGTPid = a.AGTPid
						where a.AGTPid = #Arguments.AGTPid#
					</cfquery>
					<cfif Arguments.detaildebug>
						<cfquery name="rstemp" datasource="#Arguments.Conexion#">
							select * from #INTARC#
						</cfquery>
						<cfdump var="#rstemp#" label="4th Insert">
						<cfoutput><h1>#Arguments.Conexion#</h1><br>
							select e.AFSid, e.AFSvaladq
							from ADTProceso a
								inner join AFSaldos e
									on e.Aid = a.Aid
									and e.Ecodigo = a.Ecodigo
									and e.AFSperiodo = a.TAperiodo
									and e.AFSmes = a.TAmes
							where a.AGTPid = #Arguments.AGTPid#
						</cfoutput>
						<cfquery name="rsTempxxxx" datasource="#Arguments.Conexion#">
							select e.AFSid, (e.AFSvaladq * 10000) as valor
							from ADTProceso a, AFSaldos e
							where a.AGTPid = #Arguments.AGTPid#
								and e.Aid = a.Aid
									and e.Ecodigo = a.Ecodigo
									and e.AFSperiodo = a.TAperiodo
									and e.AFSmes = a.TAmes
						</cfquery>
						<cfdump var="#rsTempxxxx#" label="This is it">
					</cfif>
					<!--- Retiro Depreciacion Mejoras--->
					<cfquery datasource="#Arguments.Conexion#">
						insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, CFid)
						select 
								'AFRT',
								1,
								<cf_dbfunction name="to_char" args="g.AGTPdocumento">, 
								#PreserveSingleQuotes(INTREF)#,
								round(TAmontodepmej,2) as TAmontodepmej,
								'D',
								#PreserveSingleQuotes(INTDES5)#,
								'#DateFormat(now(),'YYYYMMDD')#',
								1.00,
								#rsPeriodo.value#, 
								#rsMes.value#,
								c.ACcdepacum,
								#rsMoneda.value#,
								d.Ocodigo,
								round(TAmontodepmej,2) as TAmontodepmej1,
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
							inner join AFSaldos e
								on e.Aid = a.Aid
								and e.Ecodigo = a.Ecodigo
								and e.AFSperiodo = a.TAperiodo
								and e.AFSmes = a.TAmes
							inner join AGTProceso g
								on g.AGTPid = a.AGTPid
						where a.AGTPid = #Arguments.AGTPid#
					</cfquery>
					<cfif Arguments.detaildebug>
						<cfquery name="rstemp" datasource="#Arguments.Conexion#">
							select * from #INTARC#
						</cfquery>
						<cfdump var="#rstemp#" label="5th Insert">
					</cfif>
					<!--- Retiro Depreciacion Revaluacion --->
					<cfquery datasource="#Arguments.Conexion#">
						insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, CFid)
						select 
								'AFRT',
								1,
								<cf_dbfunction name="to_char" args="g.AGTPdocumento">, 
								#PreserveSingleQuotes(INTREF)#,
								round(TAmontodeprev,2) as TAmontodeprev,
								'D',
								#PreserveSingleQuotes(INTDES6)#,
								'#DateFormat(now(),'YYYYMMDD')#',
								1.00,
								#rsPeriodo.value#, 
								#rsMes.value#,
								c.ACcdepacumrev,
								#rsMoneda.value#,
								d.Ocodigo,
								round(TAmontodeprev,2) as TAmontodeprev1,
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
							inner join AFSaldos e
								on e.Aid = a.Aid
								and e.Ecodigo = a.Ecodigo
								and e.AFSperiodo = a.TAperiodo
								and e.AFSmes = a.TAmes
							inner join AGTProceso g
								on g.AGTPid = a.AGTPid
						where a.AGTPid = #Arguments.AGTPid#
					</cfquery>
					<cfif Arguments.detaildebug>
						<cfquery name="rstemp" datasource="#Arguments.Conexion#">
							select * from #INTARC#
						</cfquery>
						<cfdump var="#rstemp#" label="6th Insert">
					</cfif>
					<!--- Manejo Intercompañias Segun la Funcionalidad del Sistema, y solo si se han configurado Intercompañias --->
					<cfif (Arguments.AstInter)>
					
						<!--- INCLUYE EL DEBITO CON LA CXC Intercompañía siempre y cuando compañia origen sea diferente a destino--->
						<cfif Arguments.EmpresaOrigen neq Arguments.Ecodigo>
							
							<cfset Lvalor_empresa = Arguments.Ecodigo>
							
							<cfquery name="rsCxCInter" datasource="#Arguments.Conexion#">
								Select cf.Ccuenta
								from CIntercompany ic
										inner join CFinanciera cf
											on cf.CFcuenta = ic.CFcuentacxc
											
								where ic.Ecodigo = #Lvalor_empresa#
								  and ic.Ecodigodest = #Arguments.EmpresaOrigen#
							</cfquery>
							
							<cfif  rsCxCInter.recordcount eq 0>
								<cf_errorCode	code = "50926" msg = "No hay una cuenta intercompañía definida entre la empresa origen y la empresa destino">
							</cfif>
							
							<cfset ccuenta_cxc = rsCxCInter.Ccuenta>
							
							<!--- Cuenta x Cobrar Intercompañía--->					
							<cfquery datasource="#Arguments.Conexion#">
								insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, 
												  INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, CFid)
								select 
										'AFRT',
										1,
										<cf_dbfunction name="to_char" args="f.AGTPdocumento">, 
										#PreserveSingleQuotes(INTREF)#,
										(( round(e.AFSvaladq,2)+round(e.AFSvalmej,2)+round(e.AFSvalrev,2))-(round(e.AFSdepacumadq,2)+round(e.AFSdepacummej,2)+round(e.AFSdepacumrev,2))),
										'D',
										#PreserveSingleQuotes(INTDES7)#,
										'#DateFormat(now(),'YYYYMMDD')#',
										1.00,
										#rsPeriodo.value#, 
										#rsMes.value#,
										#ccuenta_cxc#,
										#rsMoneda.value#,
										d.Ocodigo,
										((round(e.AFSvaladq,2)+round(e.AFSvalmej,2)+round(e.AFSvalrev,2))-(round(e.AFSdepacumadq,2)+round(e.AFSdepacummej,2)+round(e.AFSdepacumrev,2))),
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
									inner join AFSaldos e
										on e.Aid = a.Aid
										and e.Ecodigo = a.Ecodigo
										and e.AFSperiodo = a.TAperiodo
										and e.AFSmes = a.TAmes
									inner join AGTProceso f
										on f.AGTPid = a.AGTPid					
								where a.AGTPid = #Arguments.AGTPid#
							</cfquery>
							
						
						<cfelse>
							<cf_errorCode	code = "50927" msg = "No es posible trasladar activos cuando la empresa origen y la destino son iguales. Proceso Cancelado">
						</cfif>
						
					<cfelse>
					
						<!--- 
						INCLUYE VENTA, GASTO E IMPUESTOS
						--->
                        
                        <!---Verifica el Parametro 200030 para seleccionar la Cuenta de Impuestos Correcta--->
                        <cfquery name="rsParametroCta" datasource="#Session.DSN#">
                            select Pvalor
                            from Parametros
                            where Ecodigo = #Session.Ecodigo#  
                              and Pcodigo = '200020'
                        </cfquery>
                        <cfif isdefined("rsParametroCta") and rsParametroCta.recordcount GT 0 and rsParametroCta.Pvalor NEQ "">
                            <cfset ParametroCta = rsParametroCta.Pvalor>
                        <cfelse>
                            <cfset ParametroCta = 1>
                        </cfif>
						
						<!--- Inserta Linea Dinero en Transito --->
						<cfquery datasource="#Arguments.Conexion#">
							insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, CFid)
							select 
									'AFRT',
									1,
									<cf_dbfunction name="to_char" args="f.AGTPdocumento">, 
									#PreserveSingleQuotes(INTREF)#,
									(coalesce(round(a.TAmontolocventa,2),0.00)+round(coalesce(round(a.TAmontolocventa,2),0.00)*coalesce(round(i.Iporcentaje,2),0.00)/100.00,2)),
									'D',
									#PreserveSingleQuotes(INTDES8)#,
									'#DateFormat(now(),'YYYYMMDD')#',
									1.00,
									#rsPeriodo.value#, 
									#rsMes.value#,
									case a.TipoCuentaRetiro
                                    when 0 then g.AFRtransito
                                    when 1 then coalesce(scf.Ccuenta, sn.SNcuentacxc)
                                    else g.AFRtransito end,
									#rsMoneda.value#,
									d.Ocodigo,
									(coalesce(round(a.TAmontolocventa,2),0.00)+round(coalesce(round(a.TAmontolocventa,2),0.00)*coalesce(round(i.Iporcentaje,2),0.00)/100.00,2)),
                                    a.CFid
								from ADTProceso a
                                left join SNegocios sn
                                	on a.Ecodigo = sn.Ecodigo 
                                    and a.SNcodigo = sn.SNcodigo
                                left join SNCCTcuentas snc
                                    inner join CFinanciera scf
                                        on snc.Ecodigo = scf.Ecodigo 
                                        and snc.CFcuenta =scf.CFcuenta
                                    on a.Ecodigo = snc.Ecodigo 
                                    and a.SNcodigo = snc.SNcodigo
                                    and a.CCTcodigo = snc.CCTcodigo
								inner join Activos b
									on b.Aid = a.Aid
								inner join AClasificacion c
									on c.Ecodigo = b.Ecodigo
									and c.ACcodigo = b.ACcodigo
									and c.ACid = b.ACid
								inner join CFuncional d
									on d.CFid = a.CFid
								inner join AFSaldos e
									on e.Aid = a.Aid
									and e.Ecodigo = a.Ecodigo
									and e.AFSperiodo = a.TAperiodo
									and e.AFSmes = a.TAmes
								inner join AGTProceso f
									on f.AGTPid = a.AGTPid
								inner join AFRetiroCuentas g
									on g.AFRmotivo = f.AFRmotivo
									and g.Ecodigo = f.Ecodigo
									and g.AFResventa = 'S'
								inner join Impuestos i
									on i.Ecodigo = a.Ecodigo
									and i.Icodigo = a.Icodigo
							where a.AGTPid = #Arguments.AGTPid#
						</cfquery>
						<!--- Inserta Linea de Impuestos cuando haya --->
						<cfquery datasource="#Arguments.Conexion#">
							insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, CFid)
							select 
									'AFRT',
									1,
									<cf_dbfunction name="to_char" args="f.AGTPdocumento">, 
									#PreserveSingleQuotes(INTREF)#,
									(round(coalesce(round(a.TAmontolocventa,2),0.00)*coalesce(round(i.Iporcentaje,2),0.00)/100.00,2)),
									'C',
									#PreserveSingleQuotes(INTDES9)#,
									'#DateFormat(now(),'YYYYMMDD')#',
									1.00,
									#rsPeriodo.value#, 
									#rsMes.value#,
									cfi.Ccuenta,
									#rsMoneda.value#,
									d.Ocodigo,
									(round(coalesce(round(a.TAmontolocventa,2),0.00)*coalesce(round(i.Iporcentaje,2),0.00)/100.00,2)),
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
								inner join AFSaldos e
									on e.Aid = a.Aid
									and e.Ecodigo = a.Ecodigo
									and e.AFSperiodo = a.TAperiodo
									and e.AFSmes = a.TAmes
								inner join AGTProceso f
									on f.AGTPid = a.AGTPid
								inner join AFRetiroCuentas g
									on g.AFRmotivo = f.AFRmotivo
									and g.Ecodigo = f.Ecodigo
									and g.AFResventa = 'S'
								inner join Impuestos i
                                	inner join CFinanciera cfi
                                    	on i.Ecodigo = cfi.Ecodigo 
                                        and cfi.CFcuenta =
                                        <cfif ParametroCta EQ 1>
                                        	i.CFcuenta
                                        <cfelseif ParametroCta EQ 2>
                                        	i.CFcuentaCxPAcred
                                        <cfelseif ParametroCta EQ 3>
                                        	i.CFcuentaCxC
                                        <cfelseif ParametroCta EQ 4>
                                        	i.CFcuentaCxCAcred
                                        <cfelse>
                                        	i.CFcuenta
                                        </cfif>
                                        
									on i.Ecodigo = a.Ecodigo
									and i.Icodigo = a.Icodigo
							where a.AGTPid = #Arguments.AGTPid#
							and coalesce(i.Iporcentaje,0) > 0
							and i.Ccuenta is not null
						</cfquery>
						
						<!--- La diferencia del costo se va contra gasto --->
						<cfquery datasource="#Arguments.Conexion#">
							insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, CFid)
							select 
									'AFRT',
									1,
									<cf_dbfunction name="to_char" args="f.AGTPdocumento">, 
									#PreserveSingleQuotes(INTREF)#,
									(round(a.TAmontolocadq,2) +
									round(a.TAmontolocmej,2))
									-
									(round(a.TAmontodepadq,2) +
									round(a.TAmontodepmej,2)),
									'D',
									#PreserveSingleQuotes(INTDES10)#,
									'#DateFormat(now(),'YYYYMMDD')#',
									1.00,
									#rsPeriodo.value#, 
									#rsMes.value#,
									a.Ccuenta,
									#rsMoneda.value#,
									d.Ocodigo,
									(round(a.TAmontolocadq,2) +
									round(a.TAmontolocmej,2))
									-
									(round(a.TAmontodepadq,2) +
									round(a.TAmontodepmej,2)),
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
								inner join AFSaldos e
									on e.Aid = a.Aid
									and e.Ecodigo = a.Ecodigo
									and e.AFSperiodo = a.TAperiodo
									and e.AFSmes = a.TAmes
								inner join AGTProceso f
									on f.AGTPid = a.AGTPid
								inner join AFRetiroCuentas g
									on g.AFRmotivo = f.AFRmotivo
									and g.Ecodigo = f.Ecodigo
									and g.AFResventa <> 'S'
							where a.AGTPid = #Arguments.AGTPid#
						</cfquery>
						
						<!--- La diferencia de la revaluacion se va contra el superavit --->
						<cfquery datasource="#Arguments.Conexion#">
							insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, CFid)
							select 
									'AFRT',
									1,
									<cf_dbfunction name="to_char" args="f.AGTPdocumento">, 
									#PreserveSingleQuotes(INTREF)#,								
									(round(a.TAmontolocrev,2) - round(a.TAmontodeprev,2)),
									'D',
									<cf_dbfunction name="string_part" args="'Cta Reserva Revaluacion ' #_Cat# g.AFRdescripcion #_Cat#' de ' #_Cat# b.Adescripcion;1;80" delimiters=";">,
									'#DateFormat(now(),'YYYYMMDD')#',
									1.00,
									#rsPeriodo.value#, 
									#rsMes.value#,
									c.ACcsuperavit,
									#rsMoneda.value#,
									d.Ocodigo,
									(round(a.TAmontolocrev,2) - round(a.TAmontodeprev,2)),
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
								inner join AFSaldos e
									on e.Aid = a.Aid
									and e.Ecodigo = a.Ecodigo
									and e.AFSperiodo = a.TAperiodo
									and e.AFSmes = a.TAmes
								inner join AGTProceso f
									on f.AGTPid = a.AGTPid
								inner join AFRetiroCuentas g
									on g.AFRmotivo = f.AFRmotivo
									and g.Ecodigo = f.Ecodigo
									and g.AFResventa <> 'S'
							where a.AGTPid = #Arguments.AGTPid#
						</cfquery>						
						
						<!--- Diferencia a Favor a Cuenta de Ingreso --->
						<cfquery datasource="#Arguments.Conexion#" name="rsPrueba">
							insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, CFid)
							select 
									'AFRT',
									1,
									<cf_dbfunction name="to_char" args="f.AGTPdocumento">, 
									#PreserveSingleQuotes(INTREF)#,
									abs(coalesce(round(a.TAmontolocventa,2),0.00)-((round(e.AFSvaladq,2)+round(e.AFSvalmej,2)+round(e.AFSvalrev,2))-(round(e.AFSdepacumadq,2)+round(e.AFSdepacummej,2)+round(e.AFSdepacumrev,2)))),
									case when (coalesce(a.TAmontolocventa,0.00)-((e.AFSvaladq+e.AFSvalmej+e.AFSvalrev)-(e.AFSdepacumadq+e.AFSdepacummej+e.AFSdepacumrev))) < 0 
									then 'D' else 'C' end ,
									case when (coalesce(a.TAmontolocventa,0.00)-((e.AFSvaladq+e.AFSvalmej+e.AFSvalrev)-(e.AFSdepacumadq+e.AFSdepacummej+e.AFSdepacumrev))) < 0 
									then #PreserveSingleQuotes(INTDES12)# else #PreserveSingleQuotes(INTDES13)# end,
									'#DateFormat(now(),'YYYYMMDD')#',
									1.00,
									#rsPeriodo.value#, 
									#rsMes.value#,
									a.Ccuenta,
									#rsMoneda.value#,
									d.Ocodigo,
									abs(coalesce(round(a.TAmontolocventa,2),0.00)-((round(e.AFSvaladq,2)+round(e.AFSvalmej,2)+round(e.AFSvalrev,2))-(round(e.AFSdepacumadq,2)+round(e.AFSdepacummej,2)+round(e.AFSdepacumrev,2)))),
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
								inner join AFSaldos e
									on e.Aid = a.Aid
									and e.Ecodigo = a.Ecodigo
									and e.AFSperiodo = a.TAperiodo
									and e.AFSmes = a.TAmes
								inner join AGTProceso f
									on f.AGTPid = a.AGTPid
								inner join AFRetiroCuentas g
									on g.AFRmotivo = f.AFRmotivo
									and g.Ecodigo = f.Ecodigo
									and g.AFResventa = 'S'
							where a.AGTPid = #Arguments.AGTPid#
						</cfquery>
					</cfif>					

					<!--- Actualiza los montos a dos decimales --->
					<cfquery datasource="#Arguments.Conexion#">
						UPDATE #INTARC# 
						set INTMON = round(INTMON,2), 
						INTMOE = round(INTMOE,2)
					</cfquery> 

					<cfif Arguments.detaildebug>
						<h1>INTARC</h1><BR>
						<cfquery datasource="#Arguments.Conexion#">
							select * from #INTARC#
						</cfquery>
						<cfdump var="#rstemp#" label="7th Insert">
					</cfif>
					
					<!--- Obtiene la minima oficina para la empresa. (La oficina se le manda al genera asiento para que agrupe) --->
					<cfquery name="rsMinOficina" datasource="#Arguments.Conexion#">
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
						<cfinvokeargument name="Conexion" 	  value="#Arguments.Conexion#"/>
						<cfinvokeargument name="Ecodigo" 	  value="#Arguments.Ecodigo#"/>
						<cfinvokeargument name="Oorigen" 	  value="AFRT"/>
						<cfinvokeargument name="Eperiodo" 	  value="#rsPeriodo.value#"/>
						<cfinvokeargument name="Emes" 		  value="#rsMes.value#"/>
						<cfinvokeargument name="Efecha"		  value="#rsFechaAux.value#"/>
						<cfinvokeargument name="Edescripcion" value="#Arguments.descripcion#"/>
						<cfinvokeargument name="Edocbase" 	  value="#rsAGTProcesoDoc.AGTPdocumento#"/>
						<cfinvokeargument name="Ereferencia"  value="RT"/>
						<cfinvokeargument name="Ocodigo" 	  value="#LvarOcodigo#"/>
						<cfinvokeargument name="Debug" 		  value="#Arguments.Debug#"/>
					</cfinvoke>
				</cfif>
								
				<!---Inserta en TransaccionesActivos--->
				<cfquery datasource="#Arguments.Conexion#">
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
						<cfif isdefined("res_GeneraAsiento")>
							#res_GeneraAsiento#,
						<cfelseif Arguments.IDcontable GT 0>
							#Arguments.IDcontable#,
						<cfelse>
							<CF_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">,
						</cfif>
						a.Ccuenta,
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
							on b.Aid = a.Aid
					where a.AGTPid = #Arguments.AGTPid#
				</cfquery>
	
				<!--- Actualiza AFSaldos --->
				<cfquery name="PorActulizarAFS" datasource="#Arguments.Conexion#">
					select AFSid, TAmontolocadq,TAmontolocmej,TAmontolocrev,TAmontodepadq,TAmontodepmej,TAmontodeprev
					from ADTProceso a
						inner join AFSaldos b
							on  b.Ecodigo    = a.Ecodigo
							and b.Aid 		 = a.Aid
							and b.AFSperiodo = a.TAperiodo
							and b.AFSmes 	 = a.TAmes
					where a.Ecodigo    = #Arguments.Ecodigo#
					  and a.TAperiodo  = #rsPeriodo.value#
					  and a.TAmes      = #rsMes.value#
					  and a.AGTPid     = #Arguments.AGTPid#			
				</cfquery>
				<cfloop query="PorActulizarAFS">
					<cfquery name="rsAFSaldos" datasource="#Arguments.Conexion#">
						Update AFSaldos
							set AFSvaladq  = AFSvaladq     - #PorActulizarAFS.TAmontolocadq#
							,AFSvalmej     = AFSvalmej     - #PorActulizarAFS.TAmontolocmej#
							,AFSvalrev     = AFSvalrev     - #PorActulizarAFS.TAmontolocrev#
							,AFSdepacumadq = AFSdepacumadq - #PorActulizarAFS.TAmontodepadq#
							,AFSdepacummej = AFSdepacummej - #PorActulizarAFS.TAmontodepmej#
							,AFSdepacumrev = AFSdepacumrev - #PorActulizarAFS.TAmontodeprev#
						where AFSid = #PorActulizarAFS.AFSid#
					</cfquery>
				</cfloop>
				<cfquery name="PorRetirar" datasource="#Arguments.Conexion#">
					select a.Aid, a.Ecodigo
						from ADTProceso a
							inner join AFSaldos b
								on b.Aid        = a.Aid
							   and b.Ecodigo    = a.Ecodigo
							   and b.AFSperiodo = a.TAperiodo
							   and b.AFSmes     = a.TAmes
					where a.AGTPid   = #Arguments.AGTPid#
					and b.Ecodigo    = #Arguments.Ecodigo#
					and b.AFSperiodo = #rsPeriodo.value#
					and b.AFSmes     = #rsMes.value#
					and round(b.AFSvaladq,2) 	 <= 0
					and round(b.AFSdepacumadq,2) <= 0
					and round(b.AFSvalmej,2) 	 <= 0
					and round(b.AFSdepacummej,2) <= 0
					and round(b.AFSvalrev,2) 	 <= 0
					and round(b.AFSdepacumrev,2) <= 0
				</cfquery>
				<cfloop query="PorRetirar">
					<cfquery datasource="#Arguments.Conexion#">
						Update Activos 
							set Astatus = 60
						 where Aid   = #PorRetirar.Aid#
						 and Ecodigo = #PorRetirar.Ecodigo#
					</cfquery>
				</cfloop>
		       <!---Se mata el vale a los Activos Retirados--->
			   <cf_dbfunction name="now" returnvariable="now">
			   <cfloop query="PorRetirar">
					<cfquery datasource="#Arguments.conexion#">
						update AFResponsables
						   set AFRffin = <cf_dbfunction name="dateadd" args="-1, #now#">
						 where Aid   = #PorRetirar.Aid#
						 and Ecodigo = #PorRetirar.Ecodigo#	
						 and #now# between AFRfini and AFRffin
					</cfquery>
			   </cfloop>
				<cfif Arguments.debug>
					<cfquery name="rsActivosDeleted" datasource="#Arguments.conexion#">
						select * 
						from Activos where Astatus = 60
						and Ecodigo = #Arguments.Ecodigo#
						and Aid in (
						select Aid 
						from TransaccionesActivos 
						where AGTPid = #Arguments.AGTPid#
						)
					</cfquery>
					<cfdump var="#rsActivosDeleted#">
				</cfif>
				
				<!---Borra ADTProceso--->
				<cfquery name="rsDeleteADTProceso" datasource="#Arguments.Conexion#">
					delete from ADTProceso
					where AGTPid = #Arguments.AGTPid#
				</cfquery>
				
				<!---Actualiza estado a AGTProceso--->
				<cfquery name="rsUpdateAGTProceso" datasource="#Arguments.Conexion#">
					Update AGTProceso
					set AGTPestadp = 4,
					AGTPfaplica = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					AGTPipaplica = '#arguments.ipregistro#',
					Usuaplica = #Arguments.Usucodigo#
					where AGTPid = #Arguments.AGTPid#
				</cfquery>
				
				<cfif Arguments.debug>
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
						and AFSperiodo =#rsPeriodo.value#
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
						from ADTProceso
						where AGTPid = #Arguments.AGTPid#
						and Aid in (
						select Aid 
						from TransaccionesActivos 
						where AGTPid = #Arguments.AGTPid#
						)
					</cfquery>
					<cfdump var="#rsTemp#" label="ADTProceso">
					<cfquery name="rsTemp" datasource="#Arguments.Conexion#">
						select * 
						from AGTProceso
						where AGTPid = #Arguments.AGTPid#
					</cfquery>
					<cfdump var="#rsTemp#" label="AGTProceso">
					<!--- <cftransaction action="rollback"/> --->
					<cf_abort errorInterfaz="">
				</cfif>
			<!--- </cftransaction> --->
		</cfif>

		<!---Si llega hasta aquí todo salió bien--->
		<cfreturn true>
	</cffunction>

	<cffunction name="fnIsNull" access="private" returntype="boolean" output="false">
		<cfargument name="lValue"       required="yes" type="any">
		<cfargument name="IValueIfNull" required="yes" type="any">
		<cfif len(trim(lValue))>
			<cfreturn lValue>
		<cfelse>
			<cfreturn IValueIfNull>
		</cfif>		
		
	</cffunction>

	<cffunction name="AplicarMascara" access="public" output="true" returntype="string">
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
</cfcomponent>


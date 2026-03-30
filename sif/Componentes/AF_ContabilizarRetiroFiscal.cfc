<cfcomponent>
	<cffunction name="fnIsNull" access="private" returntype="boolean" output="false">
		<cfargument name="lValue" required="yes" type="any">
		<cfargument name="IValueIfNull" required="yes" type="any">
		<cfif len(trim(lValue))>
			<cfreturn lValue>
		<cfelse>
			<cfreturn lValueIfNull>
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
	
	<cffunction name="AF_ContabilizarRetiroFiscal" access="public" returntype="boolean" output="true">
		<cfargument name="Ecodigo" 				type="numeric" 	required="no"  	default="0">	<!--- Código de Empresa (sif) --->
		<cfargument name="Usucodigo" 			type="numeric" 	required="no"  	default="0">	<!--- Código de Usuario (asp) --->
		<cfargument name="Usuario" 				type="string" 	required="no"  	default="">		<!--- Login de Usuario (asp) --->
		<cfargument name="Conexion" 			type="string" 	required="no"	default="">		<!--- Conexion para consulta la BD --->
		<cfargument name="IPaplica" 			type="string" 	required="no"	default="">		<!--- IP de PC de Usuario --->
		<cfargument name="AGTPid" 				type="numeric" 	required="yes">
		<cfargument name="Programar" 			type="boolean" 	required="no"	default="false" ><!---Si es verdadero se requiere la fecha de programación y solo se programa y no se calcula--->
		<cfargument name="FechaProgramacion" 	type="date" 	required="no"	default="#CreateDate(1900,01,01)#" >
		<cfargument name="Periodo" 				type="numeric" 	required="no"	default="0">	<!---Si se envían No se sacan de la tabla de parámetros--->
		<cfargument name="Mes" 					type="numeric" 	required="no"	default="0">	<!---Si se envían No se sacan de la tabla de parámetros--->
		<cfargument name="debug" 				type="boolean" 	required="no"	default="false"><!--- si se prende simula la transacción, pinta los resultados y desahace los cambios --->
		<cfargument name="contabilizar" 		type="boolean" 	required="no"	default="true"><!--- si se apaga no contabiliza peroi si aplica la depreciación, por ahora solo se utiliza para las pruebas iniciales del sistema --->
		<cfargument name="descripcion" 			type="string" 	required="no"	default="Activo Fijo: Depreciación"><!--- Descripción de la transacción --->

		<!---Variables locales --->
		<cfset var lVarCuentaDep = ''>
		<cfset var lVarCuentaRev = ''>
		<cfset var lVarErrorCta = 0>
		<cfset var lVarCtasError = ''>

		<!---Valida Fecha de Programación Vrs Programar--->
		<cfif (Arguments.Programar) and (DateCompare(Arguments.FechaProgramacion, Now()) eq -1)>
			<cfset Arguments.Programar = false>
		</cfif>
		<!---Cuando Arguments.AGTPid estos valores no son necesarios--->
		<cfif Arguments.Ecodigo eq 0>
			<cfset Arguments.Ecodigo 	= session.Ecodigo >
			<cfset Arguments.Conexion 	= session.dsn >
			<cfset Arguments.Usucodigo 	= session.Usucodigo >
			<cfset Arguments.Usuario 	= session.Usuario >
			<cfset Arguments.IPaplica 	= session.sitio.ip >
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
		
		<!---====Verifican si tienen lineas de detalle======--->
		<cfquery name="rsADTProceso" datasource="#Arguments.Conexion#">
			select count(1) as cuantos from ADTProceso
			where AGTPid = #Arguments.AGTPid#
		</cfquery>
		<cfif rsADTProceso.cuantos EQ 0>
			<cfthrow message="La transacción no tienen líneas de detalle.">
		</cfif>
		
		<!--- Obtiene el Periodo y Mes de Auxiliares --->
		<cfif Arguments.Periodo neq 0>
			<cfset rsPeriodo.value = Arguments.Periodo>
		<cfelse>
			<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnGetPeriodoAux" returnvariable="rsPeriodo.value"/>
		</cfif>
		<cfif Arguments.Mes neq 0>
			<cfset rsMes.value = Arguments.Mes>
		<cfelse>
			<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnGetMesAux"     returnvariable="rsMes.value"/>
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
			select AGTPdocumento 
			from AGTProceso 
			where AGTPid = #Arguments.AGTPid#
		</cfquery>
		<cfif rsAGTProcesoDoc.recordcount eq 0 or (rsAGTProcesoDoc.recordcount and len(trim(rsAGTProcesoDoc.AGTPdocumento)) eq 0) or rsAGTProcesoDoc.AGTPdocumento eq 0>
			<cf_errorCode	code = "50912" msg = "Error obteniendo el Documento, No se pudo obtener el documento de la transacción de depreciación, Proceso Cancelado!">
		</cfif>
		
		<!--- Validaciones Iniciales, valida periodo, mes, moneda --->
		<cfif len(trim(rsPeriodo.value)) eq 0><cf_errorCode	code = "50031" msg = "No se ha definido el parámetro Periodo para los Sistemas Auxiliares! Proceso Cancelado!"></cfif>
		<cfif len(trim(rsMes.value)) eq 0><cf_errorCode	code = "50032" msg = "No se ha definido el parámetro Mes para los Sistemas Auxiliares! Proceso Cancelado!"></cfif>
		<cfif len(trim(rsMoneda.value)) eq 0><cf_errorCode	code = "50909" msg = "No se ha definido el parámetro Moneda Local para la Empresa! Proceso Cancelado!"></cfif>

		<!--- Si programar --->
		<cfif (Arguments.Programar)>
			<cfquery name="rsActualizaProceso" datasource="#Arguments.Conexion#">
				Update AGTProceso 
				set AGTPestadp = 2,
					AGTPfechaprog = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.FechaProgramacion#" null="#DateCompare(Arguments.FechaProgramacion, Now()) eq -1#">,
					AGTPipaplica = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.IPaplica#">
				where AGTPid = #Arguments.AGTPid#
			</cfquery>
		<cfelse>		 			
			<cftransaction>
            	<!--- Se elimina la insercion a la tabla AFSaldosFiscales--->
				<!---
                <cfquery name="rsTransaccionesActivos" datasource="#Arguments.Conexion#">
					insert into AFSaldosFiscales(
                        AFSid, 	
                        AFSvaladqact,
                        AFSvalmejact, 
                        AFSdepacumadqact,
                        AFSdepacummejact,
                        AFSdepacumadqfiscal,
                        AFSdepacummejfiscal,
                        AFSsaldovutilfis
                     )
                     select 
                     af.AFSid,
                     ap.TAmontolocadq,
                     ap.TAmontolocmej,
                     ap.TAmontodepadq,
                     ap.TAmontodepmej,
                     ap.TAmontodepadqFiscal,
                     ap.TAmontodepmejFiscal,
                     ap.TAvutil
                     from ADTProceso ap
                     inner join AFSaldos af
                     	on af.Aid = ap.Aid
                        and af.Ecodigo = ap.Ecodigo
                        and af.AFSperiodo = ap.TAperiodo 
                        and af.AFSmes = ap.TAmes
                     where ap.Ecodigo = #Arguments.Ecodigo#
                     	and ap.AGTPid = #Arguments.AGTPid#
				</cfquery>
                --->
                
				<!---Inserta en TransaccionesActivos--->
				<cfquery name="rsTransaccionesActivos" datasource="#Arguments.Conexion#">
					insert into TransaccionesActivos(
						Ecodigo,							<!---1--->
						Aid,								<!---2--->	
						IDtrans,							<!---3--->
						CFid,								<!---4--->
						TAperiodo,							<!---5--->
						TAmes,								<!---6--->
						TAfecha,							<!---7--->
						TAfalta,							<!---8--->
						TAmontooriadq,						<!---9--->	
						TAmontolocadq,						<!---10--->	
						TAmontoorimej,						<!---11--->	
						TAmontolocmej,						<!---12--->
						TAmontoorirev,						<!---13--->
						TAmontolocrev,						<!---14--->
						
						TAmontodepadq,						<!---15--->
						TAmontodepmej,						<!---16--->
						TAmontodeprev,						<!---17--->
                        
                        TAmontodepadqFiscal,				<!---18--->
                        TAmontodepmejFiscal,				<!---19--->

						TAvaladq,							<!---20--->
						TAvalmej,							<!---21--->
						TAvalrev,							<!---22--->
						
						TAdepacumadq,						<!---23--->
						TAdepacummej,						<!---24--->
						TAdepacumrev,						<!---25--->
							
						Mcodigo,							<!---26--->	
						TAtipocambio,						<!---27--->
						
						AGTPid,								<!---29--->		
						Usucodigo,							<!---30--->	
						TAfechainidep,						<!---31--->	
						TAvalrescate,						<!---32--->
						TAvutil,							<!---33--->
						TAsuperavit,						<!---34--->
						TAfechainirev,						<!---35--->
						TAmeses								<!---36--->	
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
						a.TAmontooriadq,
						a.TAmontolocadq,
						a.TAmontoorimej,
						a.TAmontolocmej,
						a.TAmontoorirev,
						a.TAmontolocrev,
						
						a.TAmontodepadq,
						a.TAmontodepmej,
						a.TAmontodeprev,
                        
                        a.TAmontodepadqFiscal,
                        a.TAmontodepmejFiscal,
                        
						a.TAvaladq,
						a.TAvalmej,
						a.TAvalrev,
						
						a.TAdepacumadq,
						a.TAdepacummej,
						a.TAdepacumrev,
						
						#rsMoneda.value#,
						1.00,
						
						a.AGTPid,
						#Arguments.Usucodigo#,
						b.Afechainidep,
						b.Avalrescate,
						a.TAvutil,
						0.00,
						b.Afechainirev,
						a.TAmeses				
					from ADTProceso a
						inner join Activos b 
							on b.Aid = a.Aid
					where a.AGTPid = #Arguments.AGTPid#
				</cfquery>
	
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
					AGTPipaplica = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.IPaplica#">,
					Usuaplica = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
					where AGTPid = #Arguments.AGTPid#
				</cfquery>
				
				<cfif Arguments.debug>
					<cfquery name="rsTemp" datasource="#Arguments.Conexion#">
						select * 
						from TransaccionesActivos 
						where Ecodigo = #Arguments.Ecodigo#
						and AGTPid = #Arguments.AGTPid#
					</cfquery>
					<cfdump var="#rsTemp#" label="TransaccionesActivos">
					<cfquery name="rsTemp" datasource="#Arguments.Conexion#">
						select * 
						from ADTProceso
						where Ecodigo = #Arguments.Ecodigo#
						and AGTPid = #Arguments.AGTPid#
					</cfquery>
					<cfdump var="#rsTemp#" label="ADTProceso">
					<cfquery name="rsTemp" datasource="#Arguments.Conexion#">
						select * 
						from AGTProceso
						where AGTPid = #Arguments.AGTPid#
					</cfquery>
					<cfdump var="#rsTemp#" label="AGTProceso">
					<cftransaction action="rollback"/>
					<cf_abort errorInterfaz="">
				</cfif>
			</cftransaction>
		</cfif>
		<!---Si llega hasta aquí todo salió bien--->
		<cfreturn true>
	</cffunction>
</cfcomponent>

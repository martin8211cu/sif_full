<!---     -----------------------------------------------------------------
ATENCION MUCHA ATENCION

En caso de que se modifique el proceso de contabilizacion de traslados de Activos, será
nacecesario tocar 2 funciones, debido a que el proceso contable esta repetido en 2 metodos:

		1. AplicarPrivate: Proceso normal de contabilización de un traslado.
		2. SoloContabilizar: Contabilización de las transacciones, cuando se procesa la cola, al abrir
		   el control en AF. 
		
Poner atencion a este punto. (28/11/2006 - MAC)
--->
<cfcomponent>
	<!--- Genera el registro(s) de transferencia --->
	<cffunction name="Transferir" access="public" returntype="numeric">
		<cfargument name="AFRid" 	type="numeric" 	required="true">
		<cfargument name="DEid" 	type="numeric" 	required="false" default="-1">
		<cfargument name="Alm_Aid" 	type="numeric" 	required="false" default="-1">
		<cfargument name="CRCCid" 	type="numeric" 	required="false" default="-1">
		<cfargument name="Fecha" 	type="date" 	required="false" default="#LSDateFormat(Now(),'dd/mm/yyyy')#">
		<cfargument name="Estado" 	type="numeric" 	required="false" default="30"> 
		<!--- Estado del Traslado
				Value	Label
				0	Registro Autogestión
				10	Proceso Autogestión
				20	Rechazo Autogestión
				30	Registro Centro Custodia
				40	Proceso Centro Custodia
				50	Rechazo Centro Custodia --->
		<cfargument name="Tipo" type="numeric" required="false" default="1">
		<!--- Tipo de Traslado
				Value	Label
				1	Responsable
				2	Centro de Custodia --->
		<cfargument name="Ecodigo" 			 type="numeric" required="false" default="#Session.Ecodigo#">
		<cfargument name="Usucodigo" 		 type="numeric" required="false" default="#Session.Usucodigo#">
		<cfargument name="Conexion" 		 type="string" 	required="false" default="#Session.Dsn#">
		<cfargument name="TransaccionActiva" type="boolean" required="false" default="false">
		<cfargument name="CRTDid" 			 type="numeric" required="false" default="-1">        
		<cfif Arguments.TransaccionActiva>
			<cfinvoke 
				method="Transferir_private"
				returnvariable="result"
				AFRid="#Arguments.AFRid#"
				DEid="#Arguments.DEid#"
				Alm_Aid="#Arguments.Alm_Aid#"
				CRCCid="#Arguments.CRCCid#"
				Fecha="#Arguments.Fecha#"
				Estado="#Arguments.Estado#"
				Tipo="#Arguments.Tipo#"
				Ecodigo="#Arguments.Ecodigo#"
				Usucodigo="#Arguments.Usucodigo#"
                CRTDid="#Arguments.CRTDid#"
				Conexion="#Arguments.Conexion#"/>
		<cfelse>
			<cftransaction>
				<cfinvoke 
					method="Transferir_private"
					returnvariable="result"
					AFRid="#Arguments.AFRid#"
					DEid="#Arguments.DEid#"
					Alm_Aid="#Arguments.Alm_Aid#"
					CRCCid="#Arguments.CRCCid#"
					Fecha="#Arguments.Fecha#"
					Estado="#Arguments.Estado#"
					Tipo="#Arguments.Tipo#"
					Ecodigo="#Arguments.Ecodigo#"
					Usucodigo="#Arguments.Usucodigo#"
                    CRTDid="#Arguments.CRTDid#"
					Conexion="#Arguments.Conexion#"/>
			</cftransaction>	
		</cfif>
		<cfreturn result>
	</cffunction>
	
	<cffunction name="Transferir_private" access="private" returntype="numeric">
		<cfargument name="AFRid" 	type="numeric" 	required="true">
		<cfargument name="DEid" 	type="numeric" 	required="false" default="-1">
		<cfargument name="Alm_Aid" 	type="numeric" 	required="false" default="-1">
		<cfargument name="CRCCid" 	type="numeric" 	required="false" default="-1">
		<cfargument name="Fecha" 	type="date" 	required="false" default="#LSDateFormat(Now(),'dd/mm/yyyy')#">
		<cfargument name="Estado" 	type="numeric" 	required="false" default="30"> 
		<!--- Estado del Traslado
				Value	Label
				0	Registro Autogestión
				10	Proceso Autogestión
				20	Rechazo Autogestión
				30	Registro Centro Custodia
				40	Proceso Centro Custodia
				50	Rechazo Centro Custodia --->
		<cfargument name="Tipo" type="numeric" required="false" default="1">
		<!--- Tipo de Traslado
				Value	Label
				1	Responsable
				2	Centro de Custodia --->
		<cfargument name="Ecodigo" 	 type="numeric" required="false" default="#Session.Ecodigo#">
		<cfargument name="Usucodigo" type="numeric" required="false" default="#Session.Usucodigo#">
		<cfargument name="Conexion"  type="string"  required="false" default="#Session.Dsn#">
		<cfargument name="CRTDid"	 type="numeric" required="false" default="-1">        
			
		<cfquery name="AFResponsables" datasource="#Arguments.Conexion#">
			select a.CRCCid, a.DEid, b.Aplaca
			  from AFResponsables a
              	inner join Activos b
                	on a.Aid = b.Aid
			where a.Ecodigo =  #Session.Ecodigo# 
			and a.AFRid = #Arguments.AFRid#
		</cfquery>
		<cfif AFResponsables.recordcount eq 0>
			<cf_errorCode	code = "50895" msg = "Error Al Transferir Documento. No se encontró el Documento a Trasnsferir. Proceso Cancelado.">
		<cfelseif len(trim(AFResponsables.CRCCid)) eq 0>
			<cf_errorCode	code = "50896"
							msg  = "Error Al Transferir Documento (Placa: @errorDat_1@). El Documento no tiene Centro de Custodia. Proceso Cancelado."
							errorDat_1="#AFResponsables.Aplaca#"
			>
		<cfelseif len(trim(AFResponsables.DEid)) eq 0>
			<cf_errorCode	code = "50897"
							msg  = "Error Al Transferir Documento (Placa: @errorDat_1@). El Documento no tiene Responsable. Proceso Cancelado."
							errorDat_1="#AFResponsables.Aplaca#"
			>
		</cfif>
		
		
		<cfquery name="rsi" datasource="#Arguments.Conexion#">
			insert into AFTResponsables (AFRid, DEid, Aid, CRCCid, AFTRfini, AFTRestado, AFTRtipo, Usucodigo, Ulocalizacion, BMUsucodigo,CRTDid)		
			values(	
				#Arguments.AFRid#, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#" null="#Arguments.DEid  lt 0#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Alm_Aid#" null="#Arguments.Alm_Aid lt 0#">, 
				<cfif Arguments.CRCCid gt 0>
					#Arguments.CRCCid#, 
				<cfelse>
					#AFResponsables.CRCCid#, 
				</cfif>
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Arguments.Fecha)#">, 
				#Arguments.Estado#,
				#Arguments.Tipo#,
				#Arguments.Usucodigo#, '00',
				#Arguments.Usucodigo#,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CRTDid#" null="#Arguments.CRTDid  lt 0#">
			)
			<cf_dbidentity1 conexion="#Arguments.Conexion#" verificar_transaccion="false">
		</cfquery>
		<cf_dbidentity2 name="rsi" conexion="#Arguments.Conexion#" verificar_transaccion="false">
		<cfif Arguments.Estado eq 10><!--- Cuando se crea un documento 10, en proceso de Autogestion se requiere procesamiento adicional --->
			
			<cfset rsCFs = getCFs(rsi.identity)>
			<cfif (rsCFs.recordcount eq 0) or (len(trim(rsCFs.CFid1)) eq 0) or (len(trim(rsCFs.CFid2)) eq 0)>
				<cf_errorCode	code = "50898" msg = "Error AFCR000. Al dar de alta la transferencia. No se pudo obtener los centros funcionales a los que están asignados los empleados (origen y destino). Proceso Cancelado!">
			</cfif>
			<cfset Lvar_DEid1 = AFResponsables.DEid>
			<cfset Lvar_CRCCid1 = AFResponsables.CRCCid>
			<cfset Lvar_CFResponsable1 = getResponsableCF(rsCFs.CFid1)>
			<cfset Lvar_CFResponsable2 = getResponsableCF(rsCFs.CFid2)>		
			
			
			<!--- Verifica mediante el parametro de la aplicación si se sigue la jerarquía
			de jefes de centros funcionales, o se hace la aprobación por medio del encargado
			del centro de custodia --->	
			<cfquery name="rsTipoAprobacion" datasource="#session.dsn#">
				select Pvalor as TAprob
				  from Parametros
				where Ecodigo =  #Session.Ecodigo# 
				and Pcodigo = 990
				and Mcodigo = 'AF'
			</cfquery>			
			<cfif rsTipoAprobacion.recordcount eq 0>
				<cfset TAprob = 0>
			<cfelse>
				<cfset TAprob = rsTipoAprobacion.TAprob>
			</cfif>
			
			<!--- Aprobacion por los jefes de los Centros Funcionales --->	
			<cfif isdefined("TAprob") and TAprob eq 0>
				<cfquery datasource="#Arguments.Conexion#">
					update AFTResponsables
					set AFTRCFid1 = #rsCFs.CFid1#,
						AFTRCFid2 = #rsCFs.CFid2#
					<cfif Lvar_CFResponsable1 and Lvar_DEid1 eq Lvar_CFResponsable1>
						,AFTRaprobado1 = 1
						,AFTRfaprobado1 = <cf_dbfunction name="now">
					</cfif>
					<cfif Lvar_CFResponsable1 and Lvar_DEid1 eq Lvar_CFResponsable1 and Lvar_CFResponsable2 and Lvar_CFResponsable1 eq Lvar_CFResponsable2>
						,AFTRaprobado2 = 1
						,AFTRfaprobado2 = <cf_dbfunction name="now">
						</cfif>
					where AFTRid = #rsi.identity#
				</cfquery>	
			
			<!--- Aprobacion por el responsable del Centro de Custodia --->	
			<cfelse>
				<cfset Lvar_CRCCResponsable1=-1>
				<cfquery datasource="#Arguments.Conexion#" name="RespCRCC">
					Select count(1) as Resp
					  from CRCentroCustodia a
					where a.CRCCid = #Lvar_CRCCid1#
					and a.DEid = #Lvar_DEid1#
					and a.Ecodigo =  #Session.Ecodigo# 
				</cfquery>
				
				<cfif RespCRCC.Resp gt 0>
					<cfset Lvar_CRCCResponsable1 = Lvar_DEid1>
				</cfif>
			
				<cfquery datasource="#Arguments.Conexion#">
					update AFTResponsables
					set AFTRCFid1 = #rsCFs.CFid1#,
						AFTRCFid2 = #rsCFs.CFid2#,
						AFTRaprobado1 = 1,
						AFTRfaprobado1 = <cf_dbfunction name="now">
						<!--- Si el vale pertenece al encargado del centro de custodia,hace la aprobacion de una vez.--->
					<cfif Lvar_DEid1 eq Lvar_CRCCResponsable1>
						,AFTRaprobado2 = 1
						,AFTRfaprobado2 = <cf_dbfunction name="now">
					</cfif>
					where AFTRid = #rsi.identity#
				</cfquery>			
		   </cfif>
			
		</cfif>
		<cfreturn rsi.identity>
	</cffunction>
	<!--- Genera el registro(s) de transferencia --->
	<cffunction name="TransferirMasivo" access="public" returntype="string">
		<!--- 0. 	Parámetros de la función --->
		<!--- 0.1	Parámetros de Búsqueda de Responsables --->
		<!--- 0.1.1	Reglas para la Búsqueda 
					0.1.1.1 Debe venir el CRCCid (Origen)
					0.1.1.2 Debe venir el DEid (Origen) o (la Aplacai y la Aplacaf)
					0.1.1.3 Puede venir el CRTDid
					0.1.1.3 Puede venir el CFid
		--->
		<cfargument name="CRCCid" 	type="numeric" required="true"> 				<!--- R 0.1.1.1 --->
		<cfargument name="DEid" 	type="numeric" required="false" default="-1">	<!--- Opcional ---><!--- R 0.1.1.2a --->
		<cfargument name="Aplacai" 	type="string"  required="false" default="">		<!--- Opcional ---><!--- R 0.1.1.2a --->
		<cfargument name="Aplacaf" 	type="string"  required="false" default="">		<!--- Opcional ---><!--- R 0.1.1.2a --->
		<cfargument name="CRTDid" 	type="numeric" required="false" default="-1">	<!--- Opcional ---><!--- R 0.1.1.3 --->
		<cfargument name="CFid" 	type="numeric" required="false" default="-1">	<!--- Opcional ---><!--- R 0.1.1.4 --->
		<!--- 0.2	Parámetros de Datos de la Tranferencia --->
		<!--- 0.2.1	Reglas para los Datos de la Transferencia
					0.2.1.1 Puede venir el CRTDid2 (Destino) permite modificar el tipo
					0.2.1.1 Debe venir el CRCCid2 (Destino)
					0.2.1.2 Debe venir el DEid2 (Destino)
					0.2.1.3 Debe nenir la Fecha (Destino)
		--->
		<cfargument name="CRTDid2" type="numeric" required="false" default="-1"><!--- Opcional ---><!--- R 0.2.1.1 --->
		<cfargument name="CRCCid2" type="numeric" required="true"><!--- R 0.2.1.1 --->
		<cfargument name="DEid2"   type="numeric" required="true"><!--- R 0.2.1.2 --->
		<cfargument name="Fecha"   type="date"    required="false" default="#LSDateFormat(Now(),'dd/mm/yyyy')#"><!--- R 0.2.1.3 --->
		<!--- 0.3	Parámetros Generales de la Tranferencia --->
		<cfargument name="Estado" type="numeric" required="false" default="30"> 
		<!--- Estado del Traslado
				Value	Label
				0	Registro Autogestión
				10	Proceso Autogestión
				20	Rechazo Autogestión
				30	Registro Centro Custodia
				40	Proceso Centro Custodia
				50	Rechazo Centro Custodia --->
		<cfargument name="Tipo" type="numeric" required="false" default="1">
		<!--- Tipo de Traslado
				Value	Label
				1	Responsable
				2	Centro de Custodia --->
		<cfargument name="Ecodigo"   type="numeric" required="false" default="#Session.Ecodigo#">
		<cfargument name="Usucodigo" type="numeric" required="false" default="#Session.Usucodigo#">
		<cfargument name="Conexion"  type="string"  required="false" default="#Session.Dsn#">
		<cfargument name="Debug"     type="numeric" required="false" default="0"> 
		
		<!--- Parámetro que controla cuanta es la cantidad maxima de registros que permitirá la tabla por usuario --->
		<cfargument name="CantRegUsu" type="numeric" required="false" default="500"> 
		
		<cfif debug gt 0>
			<cfdump var="#Arguments#">
		</cfif>
		<!--- R 0.1.1.2b
		<cfif Arguments.DEid lt 0>
			<cfif len(trim(Arguments.Aplacai)) eq 0 or len(trim(Arguments.Aplacaf)) eq 0>
				<cf_errorCode	code = "50899" msg = "Error en parámetros de Busqueda para inserción masiva de datos de transferencia de responsable, los parámetros requeridos no estan completos, El error se presentó porque no llenó el Empleado ni el rango de Placas, debe llenar al menos el empleado para poder traer los registros del responsable actual, como alternativa puede brindar un rango de placas y no dar el Empleado Responsable Actual y se traerán todos los registros de responsabilidad que cumplan con las placas en el rango indicado, sin tomar en cuenta el responsable.">
			</cfif>		
		</cfif> --->
		<!--- 1.	Consulta --->
		
		<cfquery name="TotReg" datasource="#Arguments.Conexion#">
		Select count(1) as cuentaReg
		from AFTResponsables aftr
		where aftr.Usucodigo = #Arguments.Usucodigo# 
		  and aftr.AFTRtipo = 1 
		  and aftr.AFTRestado in ( 30, 50 )
		</cfquery>
		
		<!--- 
		Si la totalidad de registros insertados, es menor al valor maximo, es posible insertar
		la cantidad de registros que hagan llegar a la tabla a su valor máximo--->
		<cfif TotReg.cuentaReg lt Arguments.CantRegUsu>
		
			<!--- Obitiene la cantidad de registros a insertar, tomando en cuenta los ya insertados --->
			<cfset RegistrosPerm = (Arguments.CantRegUsu - TotReg.cuentaReg)>
		
			<cfquery datasource="#Arguments.Conexion#">
			
				<cf_dbrowcount1 rows="#RegistrosPerm#" datasource="#Arguments.Conexion#">
			
				insert into AFTResponsables (AFRid, DEid, CRCCid, AFTRfini, AFTRestado, AFTRtipo, CRTDid, Usucodigo, Ulocalizacion, BMUsucodigo)		
				select
					AFRid, 
					#Arguments.DEid2#, 
					#Arguments.CRCCid2#, 
					<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Arguments.Fecha)#">, 
					#Arguments.Estado#,
					#Arguments.Tipo#,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.CRTDid2#" null="#Arguments.CRTDid2 lte 0#">,
					#Arguments.Usucodigo#, '00',
					#Arguments.Usucodigo#
				from
					AFResponsables
				where Ecodigo = #Arguments.Ecodigo#
					and CRCCid = #Arguments.CRCCid#
					and <cf_dbfunction name="now"> between AFRfini and AFRffin
					and (select count(1)
						  from AFTResponsables
						where AFTResponsables.AFRid = AFResponsables.AFRid
						and AFTResponsables.Usucodigo = #Arguments.Usucodigo#
						and AFTResponsables.AFTRtipo = #Arguments.Tipo#
					) < 1
					
					<cfif Arguments.DEid gt 0>
						and DEid = #Arguments.DEid#
					</cfif>
	
					<cfif len(#Arguments.Aplacai#) gt 0 or len(#Arguments.Aplacaf#) gt 0>
						and exists (
							select 1
							from Activos 
							where Activos.Aid = AFResponsables.Aid
							and  Activos.Ecodigo = AFResponsables.Ecodigo
							
							<cfif len(#Arguments.Aplacai#) gt 0>
								and Activos.Aplaca >= '#Arguments.Aplacai#'
							</cfif>
							
							<cfif len(#Arguments.Aplacaf#) gt 0>
								and Activos.Aplaca <= '#Arguments.Aplacaf#'
							</cfif>
						)
					</cfif>		
						
					<cfif Arguments.CFid gt 0>
						and CFid = #Arguments.CFid#
					</cfif>		
					
					<cfif Arguments.CRTDid gt 0>
						and CRTDid = #Arguments.CRTDid#
					</cfif>		
					and not exists (Select 1 from ADTProceso ADT where ADT.Ecodigo = AFResponsables.Ecodigo and ADT.Aid = AFResponsables.Aid)
						
				<cf_dbrowcount2 rows="#RegistrosPerm#" datasource="#Arguments.Conexion#">
				
				<cfif debug gt 1>
					<cf_abort errorInterfaz="">
				</cfif>
			
			</cfquery>

		<cfelse>
			<cf_errorCode	code = "50900" msg = "La cantidad de registros a insertar, excede la cantidad permitida. Proceso Cancelado.">
		</cfif>

	</cffunction>
	<!--- Elimina el registro(s) de transferencia --->
	<cffunction name="Anular" access="public" returntype="string">
		<cfargument name="AFTRid" 	 type="numeric" required="true">
		<cfargument name="Tipo" 	 type="numeric" required="false"  default="1">
		<cfargument name="Ecodigo" 	 type="numeric" required="false"  default="#Session.Ecodigo#">
		<cfargument name="Usucodigo" type="numeric" required="false"  default="#Session.Usucodigo#">
		<cfargument name="Conexion"  type="string"  required="false"  default="#Session.Dsn#">
		<cfquery datasource="#Arguments.Conexion#">
			delete from AFTResponsables
			where AFTRid = #Arguments.AFTRid#
			and AFTRtipo = #Arguments.Tipo#
			and AFTRestado in (0,20,30,50)
		</cfquery>
	</cffunction>
	
	<!--- Elimina el registro(s) de transferencia que ya contiene consecutivo --->
	<cffunction name="AnularConse" access="public" returntype="string">
		<cfargument name="AFTRid" 	 		type="numeric" required="true">
		<cfargument name="Tipo" 	 		type="numeric" required="false"  default="1">
		<cfargument name="Ecodigo" 	 	type="numeric" required="false"  default="#Session.Ecodigo#">
		<cfargument name="Usucodigo" 		type="numeric" required="false"  default="#Session.Usucodigo#">
		<cfargument name="Conexion"  		type="string"  required="false"  default="#Session.Dsn#">
		<cfargument name="AFTRazon"  		type="string"  required="true">
		<cfargument name="AFTRechazado"  type="numeric" required="false" default="0">
				
		<cfquery datasource="#session.dsn#">
			insert into AFTBResponsables 
			(AFTRid, AFRid, DEid, Aid, CRCCid, Usucodigo, Ulocalizacion, AFTRfini, AFTRestado, AFTRtipo, BMUsucodigo, CRCCidanterior, 
			  AFTRCFid1, AFTRCFid2, AFTRaprobado1, AFTRaprobado2, AFTRfaprobado1, AFTRfaprobado2, Usucodigoaplica,AFTRazon,AFTRechazado)
			select a.AFTRid, a.AFRid, a.DEid, a.Aid, a.CRCCid, a.Usucodigo, a.Ulocalizacion, a.AFTRfini, a.AFTRestado, a.AFTRtipo, a.BMUsucodigo, b.CRCCid, 
			  AFTRCFid1, AFTRCFid2, AFTRaprobado1, AFTRaprobado2, AFTRfaprobado1, AFTRfaprobado2,#Arguments.Usucodigo#,
				<cf_jdbcquery_param value="#Arguments.AFTRazon#" cfsqltype="cf_sql_varchar">,
				  #Arguments.AFTRechazado#
			from AFTResponsables a
				 inner join AFResponsables b
				on a.AFRid = b.AFRid
			where AFTRid = #Arguments.AFTRid#
		</cfquery>
		
		<cfquery datasource="#Arguments.Conexion#">
			delete from AFTResponsables
			where AFTRid = #Arguments.AFTRid#
			and AFTRtipo = #Arguments.Tipo#
			and AFTRestado in (0,20,30,50)
		</cfquery>
	</cffunction>
	
	<!--- Elimina el registro(s) de transferencia --->
	<cffunction name="AnularMasivo" access="public" returntype="string">
		<cfargument name="AFTRidlist"type="string"  required="true">
		<cfargument name="Tipo" 	 type="numeric" required="false" default="1">
		<cfargument name="Ecodigo"   type="numeric" required="false" default="#Session.Ecodigo#">
		<cfargument name="Usucodigo" type="numeric" required="false" default="#Session.Usucodigo#">
		<cfargument name="Conexion"  type="string"  required="false" default="#Session.Dsn#">
		<cfquery datasource="#Arguments.Conexion#">
			delete from AFTResponsables
			where AFTRid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AFTRidlist#" list="true">)
			and AFTRtipo = #Arguments.Tipo#
			and AFTRestado in (0,20,30,50)
		</cfquery>
	</cffunction>
	<!--- Elimina el registro(s) de transferencia --->
	<cffunction name="AnularByUsucodigo" access="public" returntype="string">
		<cfargument name="Tipo"      type="numeric" required="false" default="1">
		<cfargument name="Ecodigo"   type="numeric" required="false" default="#Session.Ecodigo#">
		<cfargument name="Usucodigo" type="numeric" required="false" default="#Session.Usucodigo#">
		<cfargument name="Conexion"  type="string"  required="false" default="#Session.Dsn#">
		<cfquery datasource="#Arguments.Conexion#">
			delete from AFTResponsables 
			where Usucodigo = #Arguments.Usucodigo#
			and AFTRtipo = #Arguments.Tipo#
			and AFTRestado in (0,20,30,50)
			and not exists
					(
					select 1
					from TransConsecutivo a 
						inner join AFTResponsables b 
							 on b.AFTRid = a.AFTRid			
						inner join AFResponsables afr
							on afr.AFRid = b.AFRid
						left outer join Activos act
							on act.Aid = afr.Aid
					where  a.AFTRid = AFTResponsables.AFTRid
					) 	
		</cfquery>
	</cffunction>
	<!--- Elimina el registro(s) de transferencia --->
	<cffunction name="AnularByErrorNum" access="public" returntype="string">
		<cfargument name="ErrorNum" 	type="numeric" required="true"  default="1">
		<cfargument name="Tipo" 		type="numeric" required="false" default="1">
		<cfargument name="Ecodigo" 		type="numeric" required="false" default="#Session.Ecodigo#">
		<cfargument name="Usucodigo"	type="numeric" required="false" default="#Session.Usucodigo#">
		<cfargument name="Conexion" 	type="string"  required="false" default="#Session.Dsn#">
		
		<cfquery datasource="#Arguments.Conexion#">
			delete from AFTResponsables
			where (select count(1)
			from AFResponsables afr
				inner join Activos act
				on act.Aid = afr.Aid
				and act.Ecodigo = afr.Ecodigo
			where AFTResponsables.AFRid = afr.AFRid
			and AFTResponsables.Usucodigo =  #Arguments.Usucodigo#
			and AFTResponsables.AFTRtipo = #Arguments.Tipo#
			and AFTResponsables.AFTRestado in (0,20,30,50)
			<cfif Arguments.ErrorNum eq 1>
			and exists (select 1 from AFTResponsables aftr where aftr.AFTRid <> AFTResponsables.AFTRid and aftr.AFRid = AFTResponsables.AFRid)
			</cfif>
			<cfif Arguments.ErrorNum eq 2>
			and AFTResponsables.AFTRestado = 50
			</cfif>
			<cfif Arguments.ErrorNum eq 3>
			and not exists (
				select 1 
				from CRCCCFuncionales 
				where CRCCid = AFTResponsables.CRCCid 
				and CFid = afr.CFid
			)
			</cfif>
			<cfif Arguments.ErrorNum eq 4>
			and case 
				when exists (	
					select 1 
					from CRAClasificacion 
					where CRCCid = AFTResponsables.CRCCid
				) then 
					case 
						when not exists ( 
							select 1 
							from CRAClasificacion 
							where CRCCid = AFTResponsables.CRCCid
								and ACcodigo = act.ACcodigo 
								and ACid = act.ACid 
						) then 1
					else 0
					end
				when exists ( 
					select 1 
					from CRAClasificacion 
					where CRCCid <> AFTResponsables.CRCCid
						and ACcodigo = act.ACcodigo 
						and ACid = act.ACid 
				) then 1
				else 0
			end = 1
			</cfif>
			<cfif Arguments.ErrorNum eq 5>
				and exists 
					( select 1 from AFResponsables afr2
					where <cf_dbfunction name="now"> between afr2.AFRfini and afr2.AFRffin
					and afr2.Aid = afr.Aid                                                            
					group by afr2.Aid 
					having count(1) >1) 		
			</cfif>
			)>0
		</cfquery>
	</cffunction>
	<!--- Envia a procesar el registro(s) de transferencia --->
	<cffunction name="Procesar" access="public" returntype="string">
		<cfargument name="AFTRid" type="numeric" required="true">
		<cfargument name="Tipo"   type="numeric" required="false" default="1">
		<cfargument name="Estado" type="numeric" required="false" default="40"> 
		<!--- Estado del Traslado
				Value	Label
				10	Proceso Autogestión
				40	Proceso Centro Custodia
		--->
		<cfargument name="Ecodigo" 		type="numeric" required="false" default="#Session.Ecodigo#">
		<cfargument name="Usucodigo" 	type="numeric" required="false" default="#Session.Usucodigo#">
		<cfargument name="Conexion" 	type="string"  required="false" default="#Session.Dsn#">
		<cfargument name="AprobarTrasCenCust"type="boolean" required="false" default="false">
        
		<cfquery name="CRCCAntyDes" datasource="#Arguments.Conexion#">
			select aftr.AFTRid, aftr.CRCCid as CRCCidnuevo, afr.CRCCid as CRCCidanterior 
			from AFTResponsables aftr
				inner join AFResponsables afr
				on afr.AFRid = aftr.AFRid
			where AFTRid = #Arguments.AFTRid#
			and AFTRtipo = #Arguments.Tipo#
		</cfquery>
		<cfif CRCCAntyDes.Recordcount EQ 0>
			<cfthrow message="No se encontró el Traslado a procesar.">
		</cfif>
		<cfquery datasource="#Arguments.Conexion#">
			update AFTResponsables
			set AFTRestado = #Arguments.Estado#
			where AFTRid = #Arguments.AFTRid#
			and AFTRtipo = #Arguments.Tipo#
			and AFTRestado in (0,20,30,50)
		</cfquery>
		<cfif CRCCAntyDes.CRCCidnuevo eq CRCCAntyDes.CRCCidanterior and ListFind('10,40',Arguments.Estado) GT 0>
			<cfinvoke method="Aplicar"
				AFTRid="#AFTRid#"
				AbrirTransaccion="False"
                Usucodigo="#Usucodigo#"
				returnvariable="ret"/>
        
		<cfelseif #Arguments.AprobarTrasCenCust# and ListFind('10,40',Arguments.Estado) GT 0>
        <!---Este validacion del aplicar es para la interfaz200--->
			<cfinvoke method="Aplicar"
				AFTRid="#AFTRid#"
				AbrirTransaccion="False"
                Usucodigo="#Usucodigo#"
				returnvariable="ret"/>
		</cfif>
        
	</cffunction>
	<!--- Envia a procesar el registro(s) de transferencia --->
	<cffunction name="ProcesarMasivo" access="public" returntype="string">
		<cfargument name="AFTRidlist" type="string"  required="true">
		<cfargument name="Tipo" 	  type="numeric" required="false" default="1">
		<cfargument name="Estado" 	  type="numeric" required="false" default="40"> 
		<!--- Estado del Traslado
				Value	Label
				10	Proceso Autogestión
				40	Proceso Centro Custodia
		--->
		<cfargument name="Ecodigo" type="numeric" required="false" default="#Session.Ecodigo#">
		<cfargument name="Usucodigo" type="numeric" required="false" default="#Session.Usucodigo#">
		<cfargument name="Conexion"  type="string"  required="false" default="#Session.Dsn#">
		<cfquery name="CRCCAntyDes" datasource="#Arguments.Conexion#">
			select aftr.AFTRid, aftr.CRCCid as CRCCidnuevo, afr.CRCCid as CRCCidanterior 
			from AFTResponsables aftr
				inner join AFResponsables afr
				on afr.AFRid = aftr.AFRid
			where AFTRid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AFTRidlist#" list="true">)
			and AFTRtipo = #Arguments.Tipo#
		</cfquery>
		<cfloop query="CRCCAntyDes">
			<cftransaction>
				<cfquery datasource="#Arguments.Conexion#">
					update AFTResponsables
					set AFTRestado = #Arguments.Estado#
					where AFTRid = #AFTRid#
					and AFTRtipo = #Arguments.Tipo#
					and AFTRestado in (0,20,30,50)
				</cfquery>
                
<!---Realiza traslado directo si el empleado que traslada es el encargado de Centro de Custodia--->
                <cfquery name="rs4402" datasource="#session.dsn#">
                    select Pvalor from Parametros where Ecodigo = #session.Ecodigo# and Pcodigo = 4402
                </cfquery>
				<cfif rs4402.recordcount GT 0 and rs4402.Pvalor EQ 1>
                    <cfif CRCCidnuevo eq CRCCidanterior and ListFind('10,40',Arguments.Estado) GT 0>
                        <cfinvoke method="Aplicar"
                            AFTRid="#AFTRid#"
                            AbrirTransaccion="False"
                            returnvariable="ret"/>
                    </cfif>
                </cfif>
			</cftransaction>
		</cfloop>
	</cffunction>
	<!--- Aprobar --->
	<cffunction name="AprobarMasivo" access="public" returntype="string">
		<cfargument name="AFTRidlist" type="string"  required="true">
		<cfargument name="Tipo" 	  type="numeric" required="false" default="1">
		<cfargument name="Aprobacion" type="numeric" required="false" default="1"> <!--- 1,2 --->
		<cfargument name="Ecodigo" 	  type="numeric" required="false" default="#Session.Ecodigo#">
		<cfargument name="Usucodigo"  type="numeric" required="false" default="#Session.Usucodigo#">
		<cfargument name="Conexion"   type="string"  required="false" default="#Session.Dsn#">
		<cfquery name="rsAprobar" datasource="#Arguments.Conexion#">
			select AFTRid, aftr.AFTRCFid1, aftr.AFTRCFid2, afr.DEid as DEid1, aftr.DEid as DEid2
			from AFTResponsables aftr
				inner join AFResponsables afr
				on afr.AFRid = aftr.AFRid
			where AFTRid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AFTRidlist#" list="true">)
			and AFTRtipo = #Arguments.Tipo#
		</cfquery>
		<cfloop query="rsAprobar">
			<cfset Lvar_DEid1 = rsAprobar.DEid1>
			<cfset Lvar_DEid2 = rsAprobar.DEid2>
			<cfset Lvar_CFResponsable1 = getResponsableCF(rsAprobar.AFTRCFid1)>
			<cfset Lvar_CFResponsable2 = getResponsableCF(rsAprobar.AFTRCFid2)>
			<cfif NOT (Arguments.Aprobacion eq 1 or Arguments.Aprobacion eq 2)>
				<cf_errorCode	code = "50901" msg = "Aprobación Inválida. Proceso Cancelado">
			</cfif>
			<cftransaction>
				<cfquery datasource="#Arguments.Conexion#">
					update AFTResponsables
					set AFTRaprobado1 = 1
					<cfif Arguments.Aprobacion eq 1>
						, AFTRfaprobado1 = <cf_dbfunction name="now">
					</cfif>
					<cfif Arguments.Aprobacion eq 2 or (Arguments.Aprobacion eq 1 and Lvar_CFResponsable1 and Lvar_CFResponsable2 and Lvar_CFResponsable1 eq Lvar_CFResponsable2)>
						, AFTRaprobado2 = 1
						, AFTRfaprobado2 = <cf_dbfunction name="now">
					</cfif>
					where AFTRid = #rsAprobar.AFTRid#
					and AFTRtipo = #Arguments.Tipo#
					and AFTRestado = 10
				</cfquery>
				<cfif (Arguments.Aprobacion eq 2 or (Arguments.Aprobacion eq 1 and Lvar_CFResponsable1 and Lvar_CFResponsable2 and Lvar_CFResponsable1 eq Lvar_CFResponsable2))
					and (Lvar_CFResponsable2 and Lvar_CFResponsable2 eq Lvar_DEid2)>
					<cfinvoke method="Aplicar"
						AFTRid="#AFTRid#"
						AbrirTransaccion="False"
						returnvariable="ret"/>
				</cfif>
			</cftransaction>
		</cfloop>
	</cffunction>
	<!--- Rechazar --->
	<cffunction name="RechazarMasivo" access="public" returntype="string">
		<cfargument name="AFTRidlist" type="string"  required="true">
		<cfargument name="Tipo" 	  type="numeric" required="false" default="1">
		<cfargument name="Estado"     type="numeric" required="false" default="40"> 
		<!--- Estado del Traslado
				Value	Label
				20	Rechazo Autogestión
				50	Rechazo Centro Custodia
		--->
		<cfargument name="Ecodigo"   type="numeric" required="false" default="#Session.Ecodigo#">
		<cfargument name="Usucodigo" type="numeric" required="false" default="#Session.Usucodigo#">
		<cfargument name="Conexion"  type="string"  required="false" default="#Session.Dsn#">
		<cfif ListFind('20,50',Arguments.Estado) EQ 0>
			<cf_errorCode	code = "50902" msg = "Estado No permitido para realizar un rechazo">
		</cfif>
		<cftransaction>
			<cfquery datasource="#Arguments.Conexion#">
				update AFTResponsables
				set AFTRestado = #Arguments.Estado#
				where AFTRid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AFTRidlist#" list="true">)
				and AFTRtipo = #Arguments.Tipo#
				and AFTRestado in (10, 40)
			</cfquery>
		</cftransaction>
	</cffunction>
	
	<!--- Rechazar --->
	<cffunction name="Rechazar" access="public" returntype="string">
		<cfargument name="AFTRidlist" type="string"  required="true">
		<cfargument name="Tipo" 	  type="numeric" required="false" default="1">
		<cfargument name="Estado"     type="numeric" required="false" default="50"> 
		<cfargument name="Ecodigo"   type="numeric" required="false" default="#Session.Ecodigo#">
		<cfargument name="Usucodigo" type="numeric" required="false" default="#Session.Usucodigo#">
		<cfargument name="Conexion"  type="string"  required="false" default="#Session.Dsn#">
		<cfif ListFind('20,50',Arguments.Estado) EQ 0>
			<cf_errorCode	code = "50902" msg = "Estado No permitido para realizar un rechazo">
		</cfif>
			<cfquery datasource="#session.dsn#">
				insert into AFTBResponsables 
				(AFTRid, AFRid, DEid, Aid, CRCCid, Usucodigo, Ulocalizacion, AFTRfini, AFTRestado, AFTRtipo, BMUsucodigo, CRCCidanterior, 
				  AFTRCFid1, AFTRCFid2, AFTRaprobado1, AFTRaprobado2, AFTRfaprobado1, AFTRfaprobado2, Usucodigoaplica, AFTRazon , AFTRechazado)
				select a.AFTRid, a.AFRid, a.DEid, a.Aid, a.CRCCid, a.Usucodigo, a.Ulocalizacion, a.AFTRfini, a.AFTRestado, a.AFTRtipo, a.BMUsucodigo, b.CRCCid, 
				  AFTRCFid1, AFTRCFid2, AFTRaprobado1, AFTRaprobado2, AFTRfaprobado1, AFTRfaprobado2,#session.Usucodigo#,
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CPDEmsgrechazo#">,  1
				from AFTResponsables a
					 inner join AFResponsables b
					on a.AFRid = b.AFRid
				where AFTRid in (#form.CHK#) 
			</cfquery>
			
			<cfquery datasource="#session.dsn#">
				delete from AFTResponsables
				where AFTRid in (#form.CHK#) 
				and AFTRtipo = 1
				and AFTRestado in (0,20,30,50)
			</cfquery>
	</cffunction>
	
	<!--- Envia a procesar el registro(s) de transferencia --->
	<cffunction name="ProcesarByUsucodigo" access="public" returntype="string">
		<cfargument name="Tipo" 	type="numeric" required="false" default="1">
		<cfargument name="Ecodigo" 	type="numeric" required="false" default="#Session.Ecodigo#">
		<cfargument name="Estado" 	type="numeric" required="false" default="40"> 
		<!--- Estado del Traslado
				Value	Label
				10	Proceso Autogestión
				40	Proceso Centro Custodia
		--->
		<cfargument name="Usucodigo" type="numeric" required="false" default="#Session.Usucodigo#">
		<cfargument name="Conexion" type="string" required="false" default="#Session.Dsn#">
		<cfquery name="CRCCAntyDes" datasource="#Arguments.Conexion#">
			select aftr.AFTRid, aftr.CRCCid as CRCCidnuevo, afr.CRCCid as CRCCidanterior 
			from AFTResponsables aftr
				inner join AFResponsables afr
				on afr.AFRid = aftr.AFRid
			where aftr.Usucodigo =  #Arguments.Usucodigo#
			and aftr.AFTRtipo = #Arguments.Tipo#
		</cfquery>
		<cfloop query="CRCCAntyDes">
			<cftransaction>
				<cfquery name="rsError" datasource="#Session.Dsn#">
					select	act.Aid,
						coalesce ( case when exists ( select 1 from AFTResponsables aftr2 where aftr2.AFTRid <> aftr.AFTRid and aftr2.AFRid = aftr.AFRid ) 
							then 1 else 0 end ,0 )+
						coalesce ( case aftr.AFTRestado when 50 
							then 1 else 0 end, 0 ) +
						coalesce ( case when exists (select 1 from CRAClasificacion where CRCCid = aftr.CRCCid) 
							then case when not exists ( select 1 from CRAClasificacion where CRCCid = aftr.CRCCid and ACcodigo = act.ACcodigo and ACid = act.ACid ) 
							then 1 else 0 end else 0 end +
							case when exists ( select 1 from CRAClasificacion where CRCCid <> aftr.CRCCid and ACcodigo = act.ACcodigo and ACid = act.ACid ) 
							then 1 else 0 end,0 ) +
						coalesce ( 	
							case when exists 
							( select 1 from AFResponsables afr2
							where <cf_dbfunction name="now"> between afr2.AFRfini and afr2.AFRffin
							    and afr2.Aid = afr.Aid                                                            
							group by afr2.Aid 
							having count(1) >1) 
							then 1 else 0 
							end ,0 
							) as Errores

					from AFTResponsables aftr
						inner join AFResponsables afr
							on afr.AFRid = aftr.AFRid
							and afr.Ecodigo = #Session.Ecodigo#
						inner join Activos act
							on act.Aid = afr.Aid
					where aftr.Usucodigo = #Session.Usucodigo# 
						and aftr.AFTRtipo = 1 
						and aftr.AFTRestado in ( 30, 50 )
						and AFTRid = #AFTRid#
				</cfquery>
			<cfif #rsError.Errores# NEQ 1>
				<cfquery datasource="#Arguments.Conexion#">
					update AFTResponsables
					set AFTRestado = #Arguments.Estado#
					where Usucodigo =  #Arguments.Usucodigo#
					and AFTRtipo = #Arguments.Tipo#
					and AFTRestado in (0,20,30,50)
					and AFTRid = #AFTRid#
				</cfquery>
				<cfif CRCCidnuevo eq CRCCidanterior and ListFind('10,40',Arguments.Estado) GT 0>
					<cfinvoke method="Aplicar"
						AFTRid="#AFTRid#"
						AbrirTransaccion="False"
						returnvariable="ret"/>
				</cfif>
			</cfif>
			</cftransaction>
		</cfloop>
	</cffunction>	
	<!--- Aplica el registro(s) de transferencia --->
	<cffunction name="Aplicar" access="public" returntype="string">
		<cfargument name="AFTRid" 			type="numeric" 	required="true">
		<cfargument name="Tipo" 			type="numeric" 	required="false" default="1">
		<cfargument name="Ecodigo" 			type="numeric" 	required="false" default="#Session.Ecodigo#">
		<cfargument name="Usucodigo"		type="numeric" 	required="false" default="#Session.Usucodigo#">
		<cfargument name="Conexion" 	   	type="string" 	required="false" default="#Session.Dsn#">
		<cfargument name="AbrirTransaccion" type="boolean" 	required="false" default="true">
		<cfargument name="Debug" 			type="boolean" 	required="false" default="False">
		<cfif AbrirTransaccion>
			<cftransaction>
				<cfinvoke method="AplicarPrivate"
					AFTRid="#AFTRid#"
					Tipo="#Tipo#"
					Ecodigo="#Ecodigo#"
					Usucodigo="#Usucodigo#"
					Conexion="#Conexion#"
					Debug="#Debug#"
					returnvariable="ret"/>
			</cftransaction>
		<cfelse>
			<cfinvoke method="AplicarPrivate"
				AFTRid="#AFTRid#"
				Tipo="#Tipo#"
				Ecodigo="#Ecodigo#"
				Usucodigo="#Usucodigo#"
				Conexion="#Conexion#"
				Debug="#Debug#" 
				returnvariable="ret"/>
		</cfif>
		<cfreturn ret>
	</cffunction>
	<cffunction name="getCFs" access="private" returntype="query">
		<cfargument name="AFTRid" 		type="numeric" 	required="true">
		<cfargument name="Usucodigo" 	type="numeric" 	required="false" default="#Session.Usucodigo#">
		<cfargument name="Conexion" 	type="string" 	required="false" default="#Session.Dsn#">
		<cfargument name="Debug" 		type="boolean" 	required="false" default="False">

		<cfquery name="rsCFs" datasource="#Arguments.Conexion#">
			select 
					cf1.CFid as CFid1, cf1.Ocodigo as Ocodigo1, 
					cf2.CFid as CFid2, cf2.Ocodigo as Ocodigo2
			from AFTResponsables aftr
				inner join AFResponsables afr
					inner join CFuncional cf1
					on cf1.CFid = afr.CFid
				on afr.AFRid = aftr.AFRid
								
				inner join EmpleadoCFuncional ecf2
					inner join CFuncional cf2
					on cf2.CFid = ecf2.CFid
				on ecf2.DEid = aftr.DEid
				and <cf_dbfunction name="now"> between ecf2.ECFdesde and ecf2.ECFhasta
			where aftr.AFTRid = #Arguments.AFTRid#
		</cfquery>

		<cfif rsCFs.recordcount eq 0>
			<cfquery name="rsCFs" datasource="#Arguments.Conexion#">
				select 
						cf1.CFid as CFid1, cf1.Ocodigo as Ocodigo1, 
						cf2.CFid as CFid2, cf2.Ocodigo as Ocodigo2
				from AFTResponsables aftr
					inner join AFResponsables afr
						inner join CFuncional cf1
						on cf1.CFid = afr.CFid
					on afr.AFRid = aftr.AFRid
				
					inner join LineaTiempo lt2
						inner join RHPlazas rhp2
							inner join CFuncional cf2
							on cf2.CFid = rhp2.CFid
						on rhp2.RHPid = lt2.RHPid
					 on lt2.DEid = aftr.DEid
					and <cf_dbfunction name="now"> between lt2.LTdesde and lt2.LThasta
				where aftr.AFTRid = #Arguments.AFTRid#
			</cfquery>
		</cfif>
		
		<cfreturn rsCFs>
	</cffunction>
	
	<cffunction name="getResponsableCF" access="private" returntype="numeric">
		<cfargument name="CFid" 		type="numeric" 	required="true">
		<cfargument name="Usucodigo" 	type="numeric" 	required="false" default="#Session.Usucodigo#">
		<cfargument name="Conexion" 	type="string" 	required="false" default="#Session.Dsn#">
		<cfargument name="Debug" 		type="boolean" 	required="false" default="False">
		<cfset Lvar_DEid = 0>
		<!--- Obtiene el Reponsable de un Centro Funcional por el CFuresponsable: Usuario Responsable del Centro Funcional --->
		<cfquery name="rsResponsableCF" datasource="#Arguments.Conexion#">
			select RHPid, CFuresponsable from CFuncional where CFid = #Arguments.CFid#
		</cfquery>
		<cfif rsResponsableCF.recordcount eq 0>
			<cf_errorCode	code = "50827" msg = "Error (getResponsableCF). Centro Funcional Inválido. Proceso Cancelado">
		</cfif>
		<cfif len(trim(rsResponsableCF.CFuresponsable)) GT 0 and rsResponsableCF.CFuresponsable GT 0>
			<cfquery name="rsDatosEmpleado" datasource="#Arguments.Conexion#">
				select DEid 
				from DatosEmpleado 
				where Ecodigo =  #Session.Ecodigo# 
				and DEusuarioportal = #rsResponsableCF.CFuresponsable#
			</cfquery>
			<cfif rsDatosEmpleado.recordcount>
				<cfset Lvar_DEid = rsDatosEmpleado.DEid>
			<cfelse>
				<cfquery name="rsDatosEmpleado" datasource="#Arguments.Conexion#">
					select llave
					from UsuarioReferencia
					where Usucodigo = #rsResponsableCF.CFuresponsable#
					and Ecodigo = #Session.EcodigoSDC#
					and STabla = 'DatosEmpleado'
				</cfquery>
				<cfif rsDatosEmpleado.recordcount and len(trim(rsDatosEmpleado.llave))>
					<cfset Lvar_DEid = rsDatosEmpleado.llave>
				</cfif>
			</cfif>
		</cfif>
		<cfif Lvar_DEid eq 0 and len(trim(rsResponsableCF.RHPid)) GT 0 and rsResponsableCF.RHPid GT 0>
			<cfquery name="rsLineaTiempo" datasource="#Arguments.Conexion#">
				select min(DEid) as DEid
				from LineaTiempo 
				where RHPid = #rsResponsableCF.RHPid#
				and <cf_dbfunction name="now"> between LTdesde and LThasta
			</cfquery>
			<cfif rsLineaTiempo.recordcount and len(trim(rsLineaTiempo.DEid))>
				<cfset Lvar_DEid = rsLineaTiempo.DEid>
			</cfif>
		</cfif>
		<cfif Lvar_DEid eq 0>
			<cfquery name="rsEmpleadoCFuncional" datasource="#Arguments.Conexion#">	
				select DEid 
				from EmpleadoCFuncional 
				where Ecodigo = #session.Ecodigo# 
				and CFid = #Arguments.CFid# 
				and <cf_dbfunction name="now"> between ECFdesde and ECFhasta	
			</cfquery>
			<cfif rsEmpleadoCFuncional .recordcount and len(trim(rsEmpleadoCFuncional .DEid))>
				<cfset Lvar_DEid = rsEmpleadoCFuncional .DEid>
			</cfif>
		</cfif>
		<cfreturn Lvar_DEid>
	</cffunction>

	<cffunction name="AplicarPrivate" access="private" returntype="string">	
		<cfargument name="AFTRid" 		type="numeric" 	required="true">
		<cfargument name="Tipo" 		type="numeric" 	required="false" default="1">
		<cfargument name="Ecodigo" 		type="numeric" 	required="false" default="#Session.Ecodigo#">
		<cfargument name="Usucodigo" 	type="numeric" 	required="false" default="#Session.Usucodigo#">
		<cfargument name="Conexion" 	type="string" 	required="false" default="#Session.Dsn#">
		<cfargument name="Debug" 		type="boolean" 	required="false" default="False">
		<cfargument name="AFTRechazado"  type="numeric" required="false" default="0">
		
		<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
		
		<!--- <cfset Arguments.debug = true> --->
		
		<!--- 1. Validaciones Generales y Consultas Generales --->
		<!--- 1.1 Validaciones Generales --->
		<!--- 1.1.1 Valida la existencia del registro de transferencia --->
		<cfquery name="rsAFTResponsables" datasource="#Arguments.Conexion#">
			select aftr.AFTRid, aftr.DEid, aftr.Aid as Alm_Aid, aftr.AFTRfini, act.Aplaca, aftr.AFTRtipo
			from AFTResponsables aftr
				inner join AFResponsables afr
					on afr.AFRid = aftr.AFRid
				inner join Activos act
					on act.Aid = afr.Aid
					and act.Ecodigo = afr.Ecodigo
			where aftr.AFTRid = #Arguments.AFTRid#
			  and aftr.AFTRestado in (10,40)
			  and afr.Ecodigo = #Arguments.Ecodigo#
		</cfquery>		
		<!--- 1.1.2 Valida que el tipo sea 1 sino de momento únicamente no hace nada --->
		<cfif rsAFTResponsables.AFTRtipo neq 1>
			<cfreturn "NA">
		</cfif>
		<cfif rsAFTResponsables.recordcount eq 0>
			<cf_errorCode	code = "50903"
							msg  = "Error AFCR001. No se encontró el registro de transferencia (AFTRid=@errorDat_1@). Proceso Cancelado!"
							errorDat_1="#Arguments.AFTRid#"
			>>
		</cfif>
		
		<!--- VALIDACIONES--->
		<cfquery name="RSActivos" datasource="#session.dsn#">
		  Select b.Aid, a.DEid
			from AFTResponsables a
					inner join AFResponsables b
						on a.AFRid = b.AFRid
				where AFTRid = #Arguments.AFTRid#			
		 </cfquery>
		 

		 <cfloop query="RSActivos">
			<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_ExisteAF" 	  Aid="#RSActivos.Aid#"/>
			<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Saldos" 	  Aid="#RSActivos.Aid#" validamontos="false"/>
			<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Revaluacion"  Aid="#RSActivos.Aid#"/> 
			<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Depreciacion" Aid="#RSActivos.Aid#"/> 
			<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Mejora" 	  Aid="#RSActivos.Aid#"/> 
			<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Retiro" 	  Aid="#RSActivos.Aid#"/> 
			<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_CambioCatCls" Aid="#RSActivos.Aid#"/> 
			<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Traslado"     Aid="#RSActivos.Aid#"/> 
			<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Cola"         Aid="#RSActivos.Aid#"/> 
			<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Empleado"     DEid="#RSActivos.DEid#"/> 
		</cfloop>
			<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnGetPeriodoAux" returnvariable="rsPeriodo.Periodo"/>
			<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnGetMesAux" 	returnvariable="rsMes.Mes"/>
		
		<cfquery name="rsEmpresa" datasource="#session.dsn#">
			select Mcodigo
			from Empresas 
			where Ecodigo = #Arguments.Ecodigo#
		</cfquery>
		<cfif rsEmpresa.recordcount eq 0 or (rsEmpresa.recordcount and rsEmpresa.Mcodigo eq 0)>
			<cf_errorCode	code = "50906" msg = "Error AFCR004. No se pudo obtener la moneda local. Proceso Cancelado!">
		</cfif>
		<!--- Obtiene la Moneda Local --->
		<cfquery name="rsMoneda" datasource="#Arguments.Conexion#">
			select Mcodigo as value
			from Empresas 
			where Ecodigo = #Arguments.Ecodigo#
		</cfquery>
		<!--- 1.2.1 Averigua Centro Funcional Anterior y Nuevo Por Empleado --->
		<cfset rsCFs = getCFs(Arguments.AFTRid)>
		<cfif (rsCFs.recordcount eq 0) or (len(trim(rsCFs.CFid1)) eq 0) or (len(trim(rsCFs.CFid2)) eq 0)>
			<!--- No se ha programado la funcionalidad para cambiar por Almacen, la limitante esta en que el Almacen no tiene Centro Funcional, habría que analizar la posibilidad de Fijarce únicamente en la oficina --->
			<cf_errorCode	code = "50907" msg = "Error AFCR005. Aplicando Cambio de Responsable. No se pudo Completar el Cambio de Responsable Obteniendo el Centro Funcional. Proceso Cancelado!">
		</cfif>
		<!--- 2. Procesa --->
		<!--- 2.1 Procesa el traslado de responsable --->
		<!--- 2.1.1 Actualiza el responsable anterior --->
		<cfquery name="ActulizarVale"  datasource="#Arguments.Conexion#">
			select re.AFRid, AFTRfini, re.Aid 
			from AFTResponsables aftr 
			inner join 	AFResponsables re
				on re.AFRid = aftr.AFRid
			where aftr.AFTRid = #Arguments.AFTRid#
		</cfquery>
		
        <cfquery datasource="#Arguments.Conexion#">
            update AFResponsables 
            set AFRffin       = <cf_dbfunction name="dateadd" args="-1, #LSparsedatetime(ActulizarVale.AFTRfini)#" >,
                Usucodigo 	  = #Arguments.Usucodigo#,
                Ulocalizacion = '00'
            where AFRffin  >=  #LSparsedatetime(ActulizarVale.AFTRfini)#
				and Aid = #ActulizarVale.Aid#
        </cfquery>
		  
		<!--- 2.1.2 Crea nuevo responsable --->
		<!--- 2.1.2b Cambia el tipo si no es nulo el tipo de la transferencia --->
		
		<cfquery name="rs_InsertaAFResponsables" datasource="#session.dsn#">
			select 
				afr.Ecodigo, 
				aftr.DEid, 
				aftr.Aid as Aid, 
				afr.Aid as Aid2, 
				coalesce(aftr.CRCCid,afr.CRCCid) as CRCCid, 
				coalesce(aftr.CRTDid,afr.CRTDid) as CRTDid, 
				afr.CRDRdescripcion, 
				afr.CRDRdescdetallada, 
				afr.CRDRtipodocori, 
				afr.CRDRdocori, 
				aftr.AFTRfini, 
				afr.AFRdocumento,
				'00',
				afr.CRTCid, 		
				afr.EOidorden, 		
				afr.DOlinea, 			
				afr.CRDRlindocori, 	
				afr.Monto, 		
				afr.CRDRid
			from AFTResponsables aftr
				inner join AFResponsables afr
				on afr.AFRid = aftr.AFRid
			where aftr.AFTRid = #Arguments.AFTRid#
		</cfquery>
		
			<cfquery datasource="#session.dsn#" name="rs_insert_afr">
				insert into AFResponsables 
					( 
						Ecodigo, 
						DEid, 
						Alm_Aid, 
						Aid, 
						CRCCid, 
						CRTDid, 
						CRDRdescripcion, 
						CRDRdescdetallada, 
						CRDRtipodocori, 
						CRDRdocori, 
						AFRfini, 
						AFRffin, 
						AFRdocumento, 
						CFid, 
						Usucodigo, 
						Ulocalizacion, 
						BMUsucodigo, 
						CRTCid, 
						EOidorden, 
						DOlinea, 
						CRDRlindocori, 
						Monto, 
						CRDRid 
					)
				values
					( 
						#rs_InsertaAFResponsables.Ecodigo#, 
						<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rs_InsertaAFResponsables.DEid#" null="#(len(trim(rs_InsertaAFResponsables.DEid)) eq 0)#">, 
						<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rs_InsertaAFResponsables.Aid#" null="#(len(trim(rs_InsertaAFResponsables.Aid)) eq 0)#">, 
						<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rs_InsertaAFResponsables.Aid2#" null="#(len(trim(rs_InsertaAFResponsables.Aid2)) eq 0)#">, 
						#rs_InsertaAFResponsables.CRCCid#, 
						#rs_InsertaAFResponsables.CRTDid#, 
						'#rs_InsertaAFResponsables.CRDRdescripcion#', 
						'#rs_InsertaAFResponsables.CRDRdescdetallada#', 
						<cf_jdbcquery_param cfsqltype="cf_sql_char" 			value="#rs_InsertaAFResponsables.CRDRtipodocori#" null="#(len(trim(rs_InsertaAFResponsables.CRDRtipodocori)) eq 0)#">, 
						<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#rs_InsertaAFResponsables.CRDRdocori#" null="#(len(trim(rs_InsertaAFResponsables.CRDRdocori)) eq 0)#">, 
						#LSParseDateTime(rs_InsertaAFResponsables.AFTRfini)#,
						<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" 	value="#LSParseDateTime('01/01/6100')#">,
						<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#rs_InsertaAFResponsables.AFRdocumento#" null="#(len(trim(rs_InsertaAFResponsables.AFRdocumento)) eq 0)#">, 
						#rsCFs.CFid2#, 
						 #Arguments.Usucodigo# ,
						'00',
						 #Session.Usucodigo# ,
						<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rs_InsertaAFResponsables.CRTCid#" null="#(len(trim(rs_InsertaAFResponsables.CRTCid)) eq 0)#">, 
						<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rs_InsertaAFResponsables.EOidorden#" null="#(len(trim(rs_InsertaAFResponsables.EOidorden)) eq 0)#">, 
						<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rs_InsertaAFResponsables.DOlinea#" null="#(len(trim(rs_InsertaAFResponsables.DOlinea)) eq 0)#">, 
						<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rs_InsertaAFResponsables.CRDRlindocori#" null="#(len(trim(rs_InsertaAFResponsables.CRDRlindocori)) eq 0)#">, 
						#rs_InsertaAFResponsables.Monto#, 
						<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rs_InsertaAFResponsables.CRDRid#" null="#(len(trim(rs_InsertaAFResponsables.CRDRid)) eq 0)#"> 
			)
				<cf_dbidentity1 verificar_transaccion="false">
			</cfquery>
			<cf_dbidentity2 name="rs_insert_afr" verificar_transaccion="false">
				
		<!---Se verifica que la transacción no genero duplicidad de vales--->
		<cfquery datasource="#session.dsn#" name="rs_Activo">
			select Aid from AFResponsables where AFRid = #rs_insert_afr.IDENTITY#
		</cfquery>
	
		<cftry>
			<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Documentos" Aid="#rs_Activo.Aid#"/> 	
			<cfcatch type="any">
				<cfset Error= "<br><table><tr><td>#cfcatch.Message#</td></tr></table>">
				<cfthrow detail="La Aplicación de la transacción, genera la siguiente inconsistencia en el Activo:#Error#">
			</cfcatch>
		</cftry>
		
		<!---******* Aqui se hace el alta a la tabla de bitacoras ******--->
		<cfset LvarDEid_dest = rsAFTResponsables.DEid>
		<cfset LvarCFid_dest = rsCFs.CFid2>
		<cfquery datasource="#session.dsn#" name="selectbitacora">
			select
				act.Aplaca as CRBPlaca,
				afr.AFRid,
				afr.Aid,
				cc.CRCCcodigo
			from AFResponsables afr
				inner join Activos act
					on act.Ecodigo = afr.Ecodigo
					and act.Aid = afr.Aid
				inner join CRCentroCustodia cc
					on cc.CRCCid = afr.CRCCid					
			where afr.AFRid= #rs_insert_afr.identity#	
		</cfquery>
		<cfquery datasource="#session.dsn#" name="rsinsertabitacora">
			insert into CRBitacoraTran(
				Ecodigo, 
				CRBfecha,
				Usucodigo,
				CRBmotivo,
				CRBPlaca,  
				AFRid,         
				Aid,               
				BMUsucodigo,
				CRCCcodigo,
				DEid_dest,
				CFid_dest,
				AFTRid)
			VALUES(
				   #session.Ecodigo#,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#now()#">,
				   #Arguments.Usucodigo#,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="3">,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="20"  value="#selectbitacora.CRBPlaca#"    	voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectbitacora.AFRid#"       	voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectbitacora.Aid#"         	voidNull>,
				   #session.Usucodigo#,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="10"  value="#selectbitacora.CRCCcodigo#"  	voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#LvarDEid_dest#"   				voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#LvarCFid_dest#"   				voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#Arguments.AFTRid#"      		voidNull>
			)
			<cf_dbidentity1 verificar_transaccion="false">
		</cfquery>
		<cf_dbidentity2 name="rsinsertabitacora" verificar_transaccion="false">
		
		<cfset LvarCRBid = rsinsertabitacora.identity>
		
		<!--- Si cambia el centro funcional:
			1. Contabiliza el cambio de Centro Funcional.
			2. Actualiza el Centro Funcional al Activo en la tabla de saldos.
			3. Inserta una Transacción Aplicada en AGProceso.
			4. Inserta detalles de la Transacción en TransaccionesActivos.
		  --->
		<cfif rsCFs.CFid1 neq rsCFs.CFid2>
		
			<!--- Obtiene el parámetro para identificar si AF esta abierto para recibir transacciones --->
			<cfquery datasource="#session.dsn#" name="RSParamTran">
			Select Pvalor 
			from Parametros 
			where Pcodigo=970 
			  and Ecodigo =  #Session.Ecodigo# 
			</cfquery>
			
			<cfif RSParamTran.recordcount eq 0>
				<cfset Paramvalor = 0>		
			<cfelse>
				<cfset Paramvalor = RSParamTran.Pvalor>	
			</cfif>				
			
			
					
			<cfif Paramvalor eq 1 or Paramvalor eq 2>
			
				<!--- Si AF está cerrado se mete el traslado en la cola --->
				<cfquery name="rsNumRel" datasource="#session.dsn#">
				Select max(Relacion) as Final
				from CRColaTransacciones
				where Ecodigo =  #Session.Ecodigo# 
				</cfquery>

				<cfif isdefined("rsNumRel") and rsNumRel.recordcount GT 0 and rsNumRel.Final neq "">
					<cfset Lvarnrel = rsNumRel.Final+1>
				<cfelse>
					<cfset Lvarnrel = 1>
				</cfif>  
					
							
				<!--- Insercion en la cola --->
				<cfquery datasource="#session.dsn#">
				INSERT into CRColaTransacciones (Ecodigo, Aid, Type, CRBid, Relacion)
				Select act.Ecodigo, act.Aid, 2 as Type, #LvarCRBid# as CRBid, #Lvarnrel# as Relacion
				from AFTResponsables a
						inner join AFResponsables b
							inner join Activos act
								inner join AFSaldos afs
									on afs.Ecodigo = act.Ecodigo
									and afs.Aid = act.Aid
									and afs.AFSperiodo = #rsPeriodo.Periodo#
									and afs.AFSmes = #rsMes.Mes#
								on act.Ecodigo = b.Ecodigo
								and act.Aid = b.Aid
							on a.AFRid = b.AFRid
					where AFTRid = #Arguments.AFTRid#			
				</cfquery>
		
			<cfelse>
			
				<!--- Si AF está abierto se contabiliza --->
				<cfinvoke component = "sif.Componentes.OriRefNextVal" method="nextVal" returnvariable="LvarNumDoc" ORI="AFTA" REF="TA"/>
				
				<cfquery name="rs_agtp_insert" datasource="#session.dsn#">
					insert into AGTProceso(Ecodigo, IDtrans, AGTPdescripcion, AGTPperiodo, 
					AGTPmes, Usucodigo, AGTPfalta, AGTPestadp, AGTPecodigo, AGTPdocumento)
					values(
						#Arguments.Ecodigo#,
						9, <cfqueryparam cfsqltype="cf_sql_char" value="Transferencia de C.F. x Transferencia de Responsables #LvarNumDoc#.">,
						#rsPeriodo.Periodo#, 
						#rsMes.Mes#,
						 #Session.Usucodigo#,
						<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">, 
						4, #Arguments.Ecodigo#,
						#LvarNumDoc#
					)
					<cf_dbidentity1 verificar_transaccion="false">
				</cfquery>
				<cf_dbidentity2 name="rs_agtp_insert" verificar_transaccion="false">
				<cfquery name="rstemp" datasource="#session.dsn#">
					insert into TransaccionesActivos (
						Ecodigo,
						Aid,
						IDtrans,
						CFid,
						CFiddest,
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
						
						Mcodigo,
						TAtipocambio,
						IDcontable,
						Ccuenta,
						Usucodigo,
						TAdocumento,
						TAreferencia,
						TAfechainidep,
						TAvalrescate,
						TAvutil,
						TAsuperavit,
						TAfechainirev,
						TAmeses,
						AGTPid)
					select 
						#Arguments.Ecodigo#,
						act.Aid,
						9,
						#rsCFs.CFid1#,
						#rsCFs.CFid2#,
						#rsPeriodo.Periodo#,
						#rsMes.Mes#,
						a.AFTRfini,
						<cf_jdbcquery_param cfsqltype="cf_sql_date" value="#now()#">, 
						
						0.00,
						0.00,
						0.00,
						0.00,
						0.00,
						0.00,
						
						0.00,
						0.00,
						0.00,
	
						AFSvaladq,
						AFSvalmej,
						AFSvalrev,
						
						AFSdepacumadq,
						AFSdepacummej,
						AFSdepacumrev,
						
						#rsMoneda.value#,
						1.00,
						<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">,
						
						(Select ACcadq
						from AClasificacion acl
						where acl.ACid = afs.ACid
						   and acl.ACcodigo = afs.ACcodigo
						   and acl.Ecodigo = afs.Ecodigo
							and afs.AFSperiodo = #rsPeriodo.Periodo#
							and afs.AFSmes = #rsMes.Mes#
						   ) as Ccuenta,			
						
						#Arguments.Usucodigo#,
						<cf_jdbcquery_param cfsqltype="cf_sql_char" value="null">,
						<cf_jdbcquery_param cfsqltype="cf_sql_char" value="null">,
						act.Afechainidep,
						act.Avalrescate,
						act.Avutil,
						0.00,
						act.Afechainirev,
						0,					
						#rs_agtp_insert.identity#
						from AFTResponsables a
							inner join AFResponsables b
								inner join Activos act
									inner join AFSaldos afs
									on afs.Ecodigo = act.Ecodigo
									and afs.Aid = act.Aid
									
								on act.Ecodigo = b.Ecodigo
								and act.Aid = b.Aid
							on a.AFRid = b.AFRid
					where AFTRid = #Arguments.AFTRid#
					and afs.AFSperiodo = #rsPeriodo.Periodo#
					and afs.AFSmes = #rsMes.Mes#
				</cfquery>
				<!--- Obtiene las descripciones de las Oficinas --->
				<cfquery name="rsOdescripcion1" datasource="#session.dsn#">
					select Odescripcion as Odescripcion1
					from Oficinas 
					where Ecodigo = #Arguments.Ecodigo#
					and Ocodigo = #rsCFs.Ocodigo1#
				</cfquery>
				<cfif rsOdescripcion1.recordcount and len(trim(rsOdescripcion1.Odescripcion1)) gt 0>
					<cfset Odescripcion1 = rsOdescripcion1.Odescripcion1>
				<cfelse>
					<cfset Odescripcion1 = "Oficina Origen">
				</cfif>
				<cfquery name="rsOdescripcion2" datasource="#session.dsn#">
					select Odescripcion as Odescripcion2
					from Oficinas 
					where Ecodigo = #Arguments.Ecodigo#
					and Ocodigo = #rsCFs.Ocodigo2#
				</cfquery>
				<cfif rsOdescripcion2.recordcount and len(trim(rsOdescripcion2.Odescripcion2)) gt 0>
					<cfset Odescripcion2 = rsOdescripcion2.Odescripcion2>
				<cfelse>
					<cfset Odescripcion2 = "Oficina Destino">
				</cfif>
				<!--- 2.2 (solo si cambio el Centro Funcional) Actualiza Centro Funcional en AFSaldos --->
				<cfquery name="_rsObtieneActivosAModificar" datasource="#Arguments.Conexion#">
				  select  distinct afr.Aid as Aid
					 from AFTResponsables aftr
					   inner join AFResponsables afr
						  on afr.AFRid = aftr.AFRid
					  where aftr.AFTRid = #Arguments.AFTRid#
				</cfquery>
				<cfloop query="_rsObtieneActivosAModificar">
					<cfquery datasource="#Arguments.Conexion#">
						update AFSaldos
							set CFid = #rsCFs.CFid2#,
						  Ocodigo = #rsCFs.Ocodigo2#
						where Aid = #_rsObtieneActivosAModificar.Aid#
						and AFSperiodo = #rsPeriodo.Periodo#
						and AFSmes     = #rsMes.Mes#
						and Ecodigo		= #Arguments.Ecodigo#
					</cfquery>
				</cfloop>
				
				<!--- 2.3 Asiento (solo si cambio el Centro Funcional) Hago asiento contable para trasladar el valor del Activo --->
				<cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="CreaIntarc" returnvariable="INTARC"/>
				<!--- 2.3.1 Débito de Valor de Adq, y Mej, para Oficina 2 a la cuenta de adq (cat/clas) --->
				<cfquery datasource="#Arguments.Conexion#">
					insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, CFid)
					select 
							'AFTA', 
							1, 
							<cf_dbfunction name="sPart"	args="'#LvarNumDoc#';1;20" delimiters=";">, 
							'TA',
							afs.AFSvaladq + afs.AFSvalmej, 
							'D', 
							<cf_dbfunction name="sPart"	args="'TA. Debito Adq. + Mej., Oficina 2 #Odescripcion2#, Activo ' #_Cat# act.Aplaca #_Cat# '.';1;80" delimiters=";">, 
							<cf_dbfunction name="to_sdate" args="aftr.AFTRfini">, 
							1.00,  
							#rsPeriodo.Periodo#, 
							#rsMes.Mes#, 
							cls.ACcadq, 
							#rsEmpresa.Mcodigo#,
							#rsCFs.Ocodigo2#, 
							afs.AFSvaladq + afs.AFSvalmej,
                            afs.CFid
					from AFTResponsables aftr
					inner join AFResponsables afr
						on aftr.AFRid = afr.AFRid
					inner join Activos act
						on afr.Aid = act.Aid
					inner join AClasificacion cls
							on act.Ecodigo = cls.Ecodigo
							and act.ACid = cls.ACid
							and act.ACcodigo = cls.ACcodigo
					inner join AFSaldos afs
						on act.Aid = afs.Aid
					where AFTRid       = #Arguments.AFTRid#
					and afs.Ecodigo    = #Arguments.Ecodigo#
					and afs.AFSperiodo = #rsPeriodo.Periodo#
					and afs.AFSmes     = #rsMes.Mes#
				</cfquery>
				<!--- 2.3.2 Crédito de Valor de Adq, y Mej, para Oficina 1 a la cuenta de adq (cat/clas) --->
				<cfquery datasource="#Arguments.Conexion#" name="x">
					insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, CFid)
					select 
							'AFTA', 
							1, 
							<cf_dbfunction name="sPart"	args="'#LvarNumDoc#',1,20">, 
							'TA',
							afs.AFSvaladq + afs.AFSvalmej, 
							'C', 
							<cf_dbfunction name="sPart"	args="'TA. Credito Adq. + Mej., Oficina 1(#Odescripcion1#), Activo ' #_Cat# act.Aplaca #_Cat# '.';1;80" delimiters=";">, 
							<cf_dbfunction name="to_sdate" args="aftr.AFTRfini">, 
							1.00,  
							#rsPeriodo.Periodo#, 
							#rsMes.Mes#, 
							cls.ACcadq, 
							#rsEmpresa.Mcodigo#,
							#rsCFs.Ocodigo1#, 
							afs.AFSvaladq + afs.AFSvalmej,
                            afs.CFid
					from AFTResponsables aftr
					inner join AFResponsables afr
						on aftr.AFRid = afr.AFRid
					inner join Activos act
						on afr.Aid = act.Aid
					inner join AClasificacion cls
							on act.Ecodigo = cls.Ecodigo
							and act.ACid = cls.ACid
							and act.ACcodigo = cls.ACcodigo
					inner join AFSaldos afs
						on act.Aid = afs.Aid
					where AFTRid = #Arguments.AFTRid#
					and afs.Ecodigo = #Arguments.Ecodigo#
					and afs.AFSperiodo = #rsPeriodo.Periodo#
					and afs.AFSmes = #rsMes.Mes#
				</cfquery>
				<!--- 2.3.3 Crédito de Valor Dep. Acum de Adq, y Mej, para Oficina 2 a la cuenta de dep. acum. de adq. (cat/clas) --->
				<cfquery datasource="#Arguments.Conexion#">
					insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, CFid)
					select 
							'AFTA', 
							1, 
							<cf_dbfunction name="sPart"	args="'#LvarNumDoc#',1,20">, 
							'TA',
							afs.AFSdepacumadq + afs.AFSdepacummej, 
							'C', 
							<cf_dbfunction name="sPart"	args="'TA. Credito Dep. Acum. Adq. + Dep. Acum. Mej., Oficina 2(#Odescripcion2#), Activo '#_Cat# act.Aplaca #_Cat# '.';1;80" delimiters=";">, 
							<cf_dbfunction name="to_sdate" args="aftr.AFTRfini">, 
							1.00,  
							#rsPeriodo.Periodo#, 
							#rsMes.Mes#, 
							cls.ACcdepacum, 
							#rsEmpresa.Mcodigo#,
							#rsCFs.Ocodigo2#, 
							afs.AFSdepacumadq + afs.AFSdepacummej,
                            afs.CFid
					from AFTResponsables aftr
					inner join AFResponsables afr
						on aftr.AFRid = afr.AFRid
					inner join Activos act
						on afr.Aid = act.Aid
					inner join AClasificacion cls
							on act.Ecodigo = cls.Ecodigo
							and act.ACid = cls.ACid
							and act.ACcodigo = cls.ACcodigo
					inner join AFSaldos afs
						on act.Aid = afs.Aid
					where AFTRid = #Arguments.AFTRid#
					and afs.Ecodigo = #Arguments.Ecodigo#
					and afs.AFSperiodo = #rsPeriodo.Periodo#
					and afs.AFSmes = #rsMes.Mes#
				</cfquery>
				<!--- 2.3.4 Dédito de Valor Dep. Acum de Adq, y Mej, para Oficina 1 a la cuenta de dep. acum. de adq. (cat/clas) --->
				<cfquery datasource="#Arguments.Conexion#">
					insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, CFid)
					select 
							'AFTA', 
							1, 
							<cf_dbfunction name="sPart" args="'#LvarNumDoc#',1,20">,  
							'TA',
							afs.AFSdepacumadq + afs.AFSdepacummej, 
							'D', 
							<cf_dbfunction name="sPart"	args="'TA. Debito Dep. Acum. Adq. + Dep. Acum. Mej., Oficina 1(#Odescripcion1#), Activo '#_Cat# act.Aplaca #_Cat# '.';1;80" delimiters=";">, 
							<cf_dbfunction name="to_sdate" args="aftr.AFTRfini">, 
							1.00,  
							#rsPeriodo.Periodo#, 
							#rsMes.Mes#, 
							cls.ACcdepacum, 
							#rsEmpresa.Mcodigo#,
							#rsCFs.Ocodigo1#, 
							afs.AFSdepacumadq + afs.AFSdepacummej,
                            afs.CFid
					from AFTResponsables aftr
					inner join AFResponsables afr
						on aftr.AFRid = afr.AFRid
					inner join Activos act
						on afr.Aid = act.Aid
					inner join AClasificacion cls
							on act.Ecodigo = cls.Ecodigo
							and act.ACid = cls.ACid
							and act.ACcodigo = cls.ACcodigo
					inner join AFSaldos afs
						on act.Aid = afs.Aid
					where AFTRid = #Arguments.AFTRid#
					and afs.Ecodigo = #Arguments.Ecodigo#
					and afs.AFSperiodo = #rsPeriodo.Periodo#
					and afs.AFSmes = #rsMes.Mes#
				</cfquery>
				<!--- 2.3.5 Dédito de Valor Rev., para Oficina 2 a la cuenta de revaluación. (cat/clas) --->
				<cfquery datasource="#Arguments.Conexion#">
					insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, CFid)
					select 
							'AFTA', 
							1, 
							<cf_dbfunction name="sPart" args="'#LvarNumDoc#',1,20">, 
							'TA',
							afs.AFSvalrev, 
							'D', 
							<cf_dbfunction name="sPart"	args="'TA. Debito Rev., Oficina 2(#Odescripcion2#), Activo '#_Cat# act.Aplaca#_Cat# '.';1;80" delimiters=";">,
							<cf_dbfunction name="to_sdate" args="aftr.AFTRfini">, 
							1.00,  
							#rsPeriodo.Periodo#, 
							#rsMes.Mes#, 
							cls.ACcrevaluacion, 
							#rsEmpresa.Mcodigo#,
							#rsCFs.Ocodigo2#, 
							afs.AFSvalrev,
                            afs.CFid
					from AFTResponsables aftr
					inner join AFResponsables afr
						on aftr.AFRid = afr.AFRid
					inner join Activos act
						on afr.Aid = act.Aid
					inner join AClasificacion cls
							on act.Ecodigo = cls.Ecodigo
							and act.ACid = cls.ACid
							and act.ACcodigo = cls.ACcodigo
					inner join AFSaldos afs
						on act.Aid = afs.Aid
					where AFTRid = #Arguments.AFTRid#
					and afs.Ecodigo = #Arguments.Ecodigo#
					and afs.AFSperiodo = #rsPeriodo.Periodo#
					and afs.AFSmes = #rsMes.Mes#
				</cfquery>
				<!--- 2.3.6 Crédito de Valor Rev., para Oficina 1 a la cuenta de revaluación. (cat/clas) --->
				<cfquery datasource="#Arguments.Conexion#">
					insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, CFid)
					select 
							'AFTA', 
							1, 
							<cf_dbfunction name="sPart" args="'#LvarNumDoc#',1,20">,  
							'TA',
							afs.AFSvalrev, 
							'C', 
							<cf_dbfunction name="sPart"	args="'TA. Credito Rev., Oficina 1(#Odescripcion1#), Activo '#_Cat# act.Aplaca#_Cat#'.';1;80" delimiters=";">, 
							<cf_dbfunction name="to_sdate" args="aftr.AFTRfini">, 
							1.00,  
							#rsPeriodo.Periodo#, 
							#rsMes.Mes#, 
							cls.ACcrevaluacion, 
							#rsEmpresa.Mcodigo#,
							#rsCFs.Ocodigo1#, 
							afs.AFSvalrev,
                            afs.CFid
					from AFTResponsables aftr
					inner join AFResponsables afr
						on aftr.AFRid = afr.AFRid
					inner join Activos act
						on afr.Aid = act.Aid
					inner join AClasificacion cls
							on act.Ecodigo = cls.Ecodigo
							and act.ACid = cls.ACid
							and act.ACcodigo = cls.ACcodigo
					inner join AFSaldos afs
						on act.Aid = afs.Aid
					where AFTRid = #Arguments.AFTRid#
					and afs.Ecodigo = #Arguments.Ecodigo#
					and afs.AFSperiodo = #rsPeriodo.Periodo#
					and afs.AFSmes = #rsMes.Mes#
				</cfquery>
				<!--- 2.3.7 Crédito por Dep. Acum. Rev., para Oficina 2 a la cuenta de revaluación. (cat/clas) --->
				<cfquery datasource="#Arguments.Conexion#">
					insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, CFid)
					select 
							'AFTA', 
							1, 
							<cf_dbfunction name="sPart" args="'#LvarNumDoc#',1,20">, 
							'TA',
							afs.AFSdepacumrev, 
							'C', 
							<cf_dbfunction name="sPart"	args="'TA. Credito Dep. Acum. Rev., Oficina 2(#Odescripcion2#), Activo '#_Cat# act.Aplaca #_Cat#'.';1;80" delimiters=";">, 
							<cf_dbfunction name="to_sdate" args="aftr.AFTRfini">, 
							1.00,  
							#rsPeriodo.Periodo#, 
							#rsMes.Mes#, 
							cls.ACcdepacumrev, 
							#rsEmpresa.Mcodigo#,
							#rsCFs.Ocodigo2#, 
							afs.AFSdepacumrev,
                            afs.CFid
					from AFTResponsables aftr
					inner join AFResponsables afr
						on aftr.AFRid = afr.AFRid
					inner join Activos act
						on afr.Aid = act.Aid
					inner join AClasificacion cls
							on act.Ecodigo = cls.Ecodigo
							and act.ACid = cls.ACid
							and act.ACcodigo = cls.ACcodigo
					inner join AFSaldos afs
						on act.Aid = afs.Aid
					where AFTRid = #Arguments.AFTRid#
					and afs.Ecodigo = #Arguments.Ecodigo#
					and afs.AFSperiodo = #rsPeriodo.Periodo#
					and afs.AFSmes = #rsMes.Mes#
				</cfquery>
				<!--- 2.3.8 Dédito por Dep. Acum. Rev., para Oficina 1 a la cuenta de revaluación. (cat/clas) --->
				<cfquery datasource="#Arguments.Conexion#">
					insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, CFid)
					select 
							'AFTA', 
							1, 
							<cf_dbfunction name="sPart" args="'#LvarNumDoc#',1,20">,  
							'TA',
							afs.AFSdepacumrev, 
							'D', 

							<cf_dbfunction name="sPart"	args="'TA. Debito Dep. Acum. Rev., Oficina 1(#Odescripcion1#), Activo '#_Cat# act.Aplaca#_Cat# '.';1;80" delimiters=";">,
							<cf_dbfunction name="to_sdate" args="aftr.AFTRfini">, 
							1.00,  
							#rsPeriodo.Periodo#, 
							#rsMes.Mes#, 
							cls.ACcdepacumrev, 
							#rsEmpresa.Mcodigo#,
							#rsCFs.Ocodigo1#, 
							afs.AFSdepacumrev,
                            afs.CFid
					from AFTResponsables aftr
					inner join AFResponsables afr
						on aftr.AFRid = afr.AFRid
					inner join Activos act
						on afr.Aid = act.Aid
					inner join AClasificacion cls
							on act.Ecodigo = cls.Ecodigo
							and act.ACid = cls.ACid
							and act.ACcodigo = cls.ACcodigo
					inner join AFSaldos afs
						on act.Aid = afs.Aid
					where AFTRid = #Arguments.AFTRid#
					and afs.Ecodigo = #Arguments.Ecodigo#
					and afs.AFSperiodo = #rsPeriodo.Periodo#
					and afs.AFSmes = #rsMes.Mes#
				</cfquery>
				<!--- ********************************************************************************************
				** BALANCE POR OFICINAS: Si las oficinas origen y destino son distintas busca en la tabla CuentaBalanceOficina **
				*********************************************************************************************--->
				<cfif rsCFs.Ocodigo1 neq rsCFs.Ocodigo2>
					
					<cfquery name="rsHayCuentasBalanceOficina" datasource="#Arguments.Conexion#">
						select 1
						from CuentaBalanceOficina
						where Ecodigo = #Arguments.Ecodigo#
					</cfquery>
					<cfif rsHayCuentasBalanceOficina.recordcount GT 0>
						<cfquery name="rsCuentaPorCobrarFrom1To2" datasource="#Arguments.Conexion#">
							select CFcuentacxc
							from CuentaBalanceOficina a
								inner join ConceptoContable b
								on b.Ecodigo = a.Ecodigo
								and b.Cconcepto = a.Cconcepto
								and b.Oorigen = 'AFTA'
							where a.Ecodigo = #Arguments.Ecodigo#
							and Ocodigoori = #rsCFs.Ocodigo1#
							and Ocodigodest = #rsCFs.Ocodigo2#
						</cfquery>
						<cfquery name="rsCuentaPorPagarFrom2To1" datasource="#Arguments.Conexion#">
							select CFcuentacxp
							from CuentaBalanceOficina a
								inner join ConceptoContable b
								on b.Ecodigo = a.Ecodigo
								and b.Cconcepto = a.Cconcepto
								and b.Oorigen = 'AFTA'
							where a.Ecodigo = #Arguments.Ecodigo#
							and Ocodigoori = #rsCFs.Ocodigo2#
							and Ocodigodest = #rsCFs.Ocodigo1#
						</cfquery>								
						<cfset ErrorCuentaBalance = 0>
						<cfif (rsCuentaPorCobrarFrom1To2.recordcount 
							and len(trim(rsCuentaPorCobrarFrom1To2.CFcuentacxc)) gt 0 
							and rsCuentaPorCobrarFrom1To2.CFcuentacxc)
							and not (rsCuentaPorPagarFrom2To1.recordcount 
							and len(trim(rsCuentaPorPagarFrom2To1.CFcuentacxp)) gt 0 
							and rsCuentaPorPagarFrom2To1.CFcuentacxp)>
							
							<cfset ErrorCuentaBalance = 1>
							<cfset ErrorCuentaBalanceDesc = "No se encontró la Cuenta por Pagar, de Balance Por Oficina, Entre la Oficina #Odescripcion2# y la Oficina #Odescripcion1#.">
		
						<cfelseif not (rsCuentaPorCobrarFrom1To2.recordcount 
							and len(trim(rsCuentaPorCobrarFrom1To2.CFcuentacxc)) gt 0 
							and rsCuentaPorCobrarFrom1To2.CFcuentacxc)
							and (rsCuentaPorPagarFrom2To1.recordcount 
							and len(trim(rsCuentaPorPagarFrom2To1.CFcuentacxp)) gt 0 
							and rsCuentaPorPagarFrom2To1.CFcuentacxp)>
		
							<cfset ErrorCuentaBalance = 2>
							<cfset ErrorCuentaBalanceDesc = "No se encontró la Cuenta por Cobrar, de Balance Por Oficina, Entre la Oficina #Odescripcion1# y la Oficina #Odescripcion2#.">
							
						<cfelseif not (rsCuentaPorCobrarFrom1To2.recordcount 
							and len(trim(rsCuentaPorCobrarFrom1To2.CFcuentacxc)) gt 0 
							and rsCuentaPorCobrarFrom1To2.CFcuentacxc)
							and not (rsCuentaPorPagarFrom2To1.recordcount 
							and len(trim(rsCuentaPorPagarFrom2To1.CFcuentacxp)) gt 0 
							and rsCuentaPorPagarFrom2To1.CFcuentacxp)>
		
							<cfset ErrorCuentaBalance = 3>
							<cfset ErrorCuentaBalanceDesc = "No se encontró la Cuenta por Cobrar, de Balance Por Oficina, Entre la Oficina #Odescripcion1# y la Oficina #Odescripcion2# y No se encontró la Cuenta por Pagar, de Balance Por Oficina, Entre la Oficina #Odescripcion2# y la Oficina #Odescripcion1#">
						</cfif>
						<cfif ErrorCuentaBalance GT 0>
							<cf_errorCode	code = "50363"
											msg  = "Error de definición de Cuenta de Balance por Oficina. @errorDat_1@ Proceso Cancelado!"
											errorDat_1="#ErrorCuentaBalanceDesc#"
							>
						</cfif>
						<!--- 2.3.9 Debito Oficina 1(#Odescripcion1#), Balance Oficina, Cuenta por Cobrar a la Oficina 2 --->
						<cfquery datasource="#Arguments.Conexion#">
							insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, CFcuenta, Ccuenta, Mcodigo, Ocodigo, INTMOE, CFid)
							select 
									'AFTA', 
									1, 
									<cf_dbfunction name="sPart" args="'#LvarNumDoc#',1,20">,  
									'TA',
									afs.AFSvaladq + afs.AFSvalmej + afs.AFSvalrev - 
									afs.AFSdepacumadq - afs.AFSdepacummej - afs.AFSdepacumrev, 
									'D', 
									<cf_dbfunction name="sPart"	args="'Debito Oficina 1(#Odescripcion1#), Balance Oficina, Cuenta por Cobrar a la Oficina 2(#Odescripcion2#), Activo '#_Cat# act.Aplaca#_Cat#'.';1;80" delimiters=";">, 
									<cf_dbfunction name="to_sdate" args="aftr.AFTRfini">, 
									1.00,  
									#rsPeriodo.Periodo#, 
									#rsMes.Mes#, 
									#rsCuentaPorCobrarFrom1To2.CFcuentacxc#, 0,
									#rsEmpresa.Mcodigo#,
									#rsCFs.Ocodigo1#, 
									afs.AFSvaladq + afs.AFSvalmej + afs.AFSvalrev - 
									afs.AFSdepacumadq - afs.AFSdepacummej - afs.AFSdepacumrev,
		                            afs.CFid
							from AFTResponsables aftr
							inner join AFResponsables afr
								on aftr.AFRid = afr.AFRid
							inner join Activos act
								on afr.Aid = act.Aid
							inner join AClasificacion cls
									on act.Ecodigo = cls.Ecodigo
									and act.ACid = cls.ACid
									and act.ACcodigo = cls.ACcodigo
							inner join AFSaldos afs
								on act.Aid = afs.Aid
							where AFTRid = #Arguments.AFTRid#
							and afs.Ecodigo = #Arguments.Ecodigo#
							and afs.AFSperiodo = #rsPeriodo.Periodo#
							and afs.AFSmes = #rsMes.Mes#
						</cfquery>
						<!--- 2.3.10 Crédito, Balance Oficina, Cuenta Pagar a la Oficina 1 --->
						<cfquery datasource="#Arguments.Conexion#">
							insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, CFcuenta, Ccuenta, Mcodigo, Ocodigo, INTMOE, CFid)
							select 
									'AFTA', 
									1, 
									<cf_dbfunction name="sPart" args="'#LvarNumDoc#',1,20">,  
									'TA',
									afs.AFSvaladq + afs.AFSvalmej + afs.AFSvalrev - 
									afs.AFSdepacumadq - afs.AFSdepacummej - afs.AFSdepacumrev, 
									'C', 
									<cf_dbfunction name="sPart"	args="'Credito Oficina 2(#Odescripcion2#), Balance Oficina, Cuenta Pagar a la Oficina 1(#Odescripcion1#), Activo '#_Cat# act.Aplaca#_Cat# '.';1;80" delimiters=";">, 
									<cf_dbfunction name="to_sdate" args="aftr.AFTRfini">, 
									1.00,  
									#rsPeriodo.Periodo#, 
									#rsMes.Mes#, 
									#rsCuentaPorPagarFrom2To1.CFcuentacxp#, 0,
									#rsEmpresa.Mcodigo#,
									#rsCFs.Ocodigo2#, 
									afs.AFSvaladq + afs.AFSvalmej + afs.AFSvalrev - 
									afs.AFSdepacumadq - afs.AFSdepacummej - afs.AFSdepacumrev,
		                            afs.CFid
							from AFTResponsables aftr
							inner join AFResponsables afr
								on aftr.AFRid = afr.AFRid
							inner join Activos act
								on afr.Aid = act.Aid
							inner join AClasificacion cls
									on act.Ecodigo = cls.Ecodigo
									and act.ACid = cls.ACid
									and act.ACcodigo = cls.ACcodigo
							inner join AFSaldos afs
								on act.Aid = afs.Aid
							where AFTRid = #Arguments.AFTRid#
							and afs.Ecodigo = #Arguments.Ecodigo#
							and afs.AFSperiodo = #rsPeriodo.Periodo#
							and afs.AFSmes = #rsMes.Mes#
						</cfquery>
				
					</cfif>
										
				</cfif>
				
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
				
				<!--- 3.5 Genera Asiento --->
				<cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="GeneraAsiento" returnvariable="res_GeneraAsiento">
					<cfinvokeargument name="Ecodigo"  		value="#Arguments.Ecodigo#"/>
					<cfinvokeargument name="Oorigen"  		value="AFTA"/>
					<cfinvokeargument name="Eperiodo" 		value="#rsPeriodo.Periodo#"/>
					<cfinvokeargument name="Emes" 			value="#rsMes.Mes#"/>
					<cfinvokeargument name="Efecha" 		value="#rsAFTResponsables.AFTRfini#"/>
					<cfinvokeargument name="Edescripcion" 	value="Transferencia de Activo"/>
					<cfinvokeargument name="Edocbase" 		value="#LvarNumDoc#"/>
					<cfinvokeargument name="Ereferencia" 	value="TA"/>
					<cfinvokeargument name="Ocodigo" 		value="#LvarOcodigo#"/>
					<cfinvokeargument name="Debug" 			value="#Arguments.Debug#"/>
				</cfinvoke>
				<cfquery name="rstemp" datasource="#session.dsn#">
					update TransaccionesActivos 
					set IDcontable = #res_GeneraAsiento#
					where Ecodigo = #Arguments.Ecodigo#
					and AGTPid = #rs_agtp_insert.identity#
				</cfquery>
					
			</cfif><!--- Fin del if del parámetro --->
		
		</cfif>
		<!--- 2.4 Inserta en la Bitácora de transferencias --->
		<cfquery datasource="#session.dsn#">
			insert into AFTBResponsables 
			(AFTRid, AFRid, DEid, Aid, CRCCid, Usucodigo, Ulocalizacion, AFTRfini, AFTRestado, AFTRtipo, BMUsucodigo, CRCCidanterior, 
			  AFTRCFid1, AFTRCFid2, AFTRaprobado1, AFTRaprobado2, AFTRfaprobado1, AFTRfaprobado2, Usucodigoaplica,AFTRechazado)
			select a.AFTRid, a.AFRid, a.DEid, a.Aid, a.CRCCid, a.Usucodigo, a.Ulocalizacion, a.AFTRfini, a.AFTRestado, a.AFTRtipo, a.BMUsucodigo, b.CRCCid, 
			  AFTRCFid1, AFTRCFid2, AFTRaprobado1, AFTRaprobado2, AFTRfaprobado1, AFTRfaprobado2,
			#Arguments.Usucodigo#,
			#Arguments.AFTRechazado#
			from AFTResponsables a
				 inner join AFResponsables b
				on a.AFRid = b.AFRid
			where AFTRid = #Arguments.AFTRid#
		</cfquery>
		<!--- 2.5 Borrar registro de transferencia --->
		<cfquery datasource="#session.dsn#">
			delete from AFTResponsables
			where AFTRid = #Arguments.AFTRid#
		</cfquery>
		<cfif Arguments.Debug>
			<cfquery name="rsTemp" datasource="#Arguments.Conexion#">
				select * 
				from TransaccionesActivos 
				where Ecodigo = #Arguments.Ecodigo#
				and AGTPid = #rs_agtp_insert.identity#
			</cfquery>
			<cfdump var="#rsTemp#" label="TransaccionesActivos">
			<cfquery name="rsTemp" datasource="#Arguments.Conexion#">
				select * 
				from AFSaldos
				where Ecodigo = #Arguments.Ecodigo#
				and AFSperiodo = #rsPeriodo.Periodo#
				and AFSmes = #rsMes.Mes#
				and Aid in (
				select Aid
				from TransaccionesActivos 
				where Ecodigo = #Arguments.Ecodigo#
				and AGTPid = #rs_agtp_insert.identity#)
			</cfquery>
			<cfdump var="#rsTemp#" label="AFSaldos">
			<cfquery name="rsTemp" datasource="#Arguments.Conexion#">
				select * 
				from AFResponsables
				where Ecodigo = #Arguments.Ecodigo#
				and Aid in (
				select Aid
				from TransaccionesActivos 
				where Ecodigo = #Arguments.Ecodigo#
				and AGTPid = #rs_agtp_insert.identity#)
			</cfquery>
			<cfdump var="#rsTemp#" label="AFResponsables">
			<cfquery name="rsTemp" datasource="#Arguments.Conexion#">
				select a.* 
				from AFTResponsables a
					inner join AFResponsables b
					on b.AFRid = a.AFRid
					and b.Aid in (
					select Aid
					from TransaccionesActivos 
					where AGTPid = #rs_agtp_insert.identity#)
			</cfquery>
			<cfdump var="#rsTemp#" label="AFTResponsables">
			<cfquery name="rsTemp" datasource="#Arguments.Conexion#">
				select a.* 
				from AFTBResponsables a
					inner join AFResponsables b
					on b.AFRid = a.AFRid
					and b.Aid in (
					select Aid
					from TransaccionesActivos 
					where AGTPid = #rs_agtp_insert.identity#)
			</cfquery>
			<cfdump var="#rsTemp#" label="AFTBResponsables">
			<cftransaction action="rollback"/>
			<cf_abort errorInterfaz="">
		</cfif>
		<cfreturn "OK">
	</cffunction>
	
	<cffunction name="SoloContabilizar" access="public" returntype="string">	
		<cfargument name="CRBid" 		type="numeric" 	required="true">
		<cfargument name="Ecodigo" 		type="numeric" 	required="false" default="#Session.Ecodigo#">
		<cfargument name="Usucodigo" 	type="numeric" 	required="false" default="#Session.Usucodigo#">
		<cfargument name="Conexion" 	type="string" 	required="false" default="#Session.Dsn#">
		<cfargument name="Debug" 		type="boolean" 	required="false" default="False">	
	
		<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
		<cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="CreaIntarc" 		returnvariable="INTARC"/>
		<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnGetPeriodoAux" returnvariable="rsPeriodo.Periodo"/>
		<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnGetMesAux" 	returnvariable="rsMes.Mes"/>
		
		<cfquery name="rsEmpresa" datasource="#session.dsn#">
			select Mcodigo
			from Empresas 
			where Ecodigo = #Arguments.Ecodigo#
		</cfquery>
		<cfif rsEmpresa.recordcount eq 0 or (rsEmpresa.recordcount and rsEmpresa.Mcodigo eq 0)>
			<cf_errorCode	code = "50906" msg = "Error AFCR004. No se pudo obtener la moneda local. Proceso Cancelado!">
		</cfif>		
		
		<!--- Obtiene la Moneda Local --->
		<cfquery name="rsMoneda" datasource="#Arguments.Conexion#">
			select Mcodigo as value
			from Empresas 
			where Ecodigo = #Arguments.Ecodigo#
		</cfquery>
				
		<!--- Si AF está abierto se contabiliza --->
		<cfinvoke component="sif.Componentes.OriRefNextVal" method="nextVal" returnvariable="LvarNumDoc" ORI="AFTA" REF="TA"/>
		
		<cftransaction>
		
		<cfquery name="rs_agtp_insert" datasource="#session.dsn#">
			insert into AGTProceso(Ecodigo, IDtrans, AGTPdescripcion, AGTPperiodo, 
			AGTPmes, Usucodigo, AGTPfalta, AGTPestadp, AGTPecodigo, AGTPdocumento)
			values(
				#Arguments.Ecodigo#,
				9, <cfqueryparam cfsqltype="cf_sql_char" value="Transferencia de C.F. x Transferencia de Responsables #LvarNumDoc#.">,
				#rsPeriodo.Periodo#, 
				#rsMes.Mes#,
				 #Session.Usucodigo# ,
				<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">, 
				4, #Arguments.Ecodigo#,
				#LvarNumDoc#
			)
			<cf_dbidentity1 verificar_transaccion="false">
		</cfquery>
		<cf_dbidentity2 name="rs_agtp_insert" verificar_transaccion="false">
		
		
		<cfquery name="rstemp" datasource="#session.dsn#">
			insert into TransaccionesActivos (
				Ecodigo,
				Aid,
				IDtrans,
				CFid,
				CFiddest,
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
				
				Mcodigo,
				TAtipocambio,
				IDcontable,
				Ccuenta,
				Usucodigo,
				TAdocumento,
				TAreferencia,
				TAfechainidep,
				TAvalrescate,
				TAvutil,
				TAsuperavit,
				TAfechainirev,
				TAmeses,
				AGTPid)
			
			
			Select 	b.Ecodigo, 
					b.Aid, 
					9 as IDtrans, 
					e.CFid,	
					b.CFid_dest as CFiddest, 
					e.AFSperiodo as TAperiodo,
					e.AFSmes as TAmes,
			
					f.AFTRfini as TAfecha,
					<cf_jdbcquery_param cfsqltype="cf_sql_date" value="#now()#"> as TAfalta,
			
					0.00 as TAmontooriadq,
					0.00	as TAmontolocadq,
					0.00 as TAmontoorimej,
					0.00 as TAmontolocmej,
					0.00 as TAmontoorirev,
					0.00 as TAmontolocrev,
			
					0.00 as TAmontodepadq,
					0.00 as TAmontodepmej,
					0.00 as TAmontodeprev,
			
					e.AFSvaladq as TAvaladq,
					e.AFSvalmej as TAvalmej,
					e.AFSvalrev as TAvalrev,
			
					e.AFSdepacumadq as TAdepacumadq,
					e.AFSdepacummej as TAdepacummej,
					e.AFSdepacumrev as TAdepacumrev,
			
					#rsMoneda.value# as Mcodigo,
					1.00 as TAtipocambio,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null"> as IDcontable,
			
					(Select ACcadq
					from AClasificacion acl
					where acl.ACid = e.ACid
					   and acl.ACcodigo = e.ACcodigo
					   and acl.Ecodigo = e.Ecodigo
					   and e.AFSperiodo = #rsPeriodo.Periodo#
					   and e.AFSmes = #rsMes.Mes#
					) as Ccuenta,			
			
					#Arguments.Usucodigo# as Usucodigo,
					<cf_jdbcquery_param cfsqltype="cf_sql_char" value="null"> as TAdocumento,
					<cf_jdbcquery_param cfsqltype="cf_sql_char" value="null"> as TAreferencia,
					d.Afechainidep as TAfechainidep,
					d.Avalrescate as TAvalrescate,
					d.Avutil as TAvutil,
					0.00 as TAsuperavit,
					d.Afechainirev as TAfechainirev,
					0 as TAmeses,
					#rs_agtp_insert.identity# as AGTPid
			
			from CRColaTransacciones a 
			
					inner join CRBitacoraTran b
						on a.CRBid = b.CRBid
			
					inner join AFResponsables c
						on c.AFRid = b.AFRid
			
					inner join Activos d
						on c.Aid = d.Aid
						and c.Ecodigo = d.Ecodigo
			
					inner join AFSaldos e
						on d.Aid = e.Aid
						and d.Ecodigo = e.Ecodigo
						
					inner join AFTBResponsables f
						on f.AFTRid = b.AFTRid
			
				where a.CRBid 	 = #Arguments.CRBid#
				and e.AFSperiodo = #rsPeriodo.Periodo#
				and e.AFSmes 	 = #rsMes.Mes#
		</cfquery>
		
		
		<!--- Obtiene los datos desde la Bitacora --->
		<cfquery datasource="#session.dsn#" name="rsDatosDest">
		Select CFid_dest , c.Ocodigo as Ocodigo_dest, d.AFTRid, e.CFid, f.Ocodigo, d.AFTRfini
		from CRColaTransacciones a 
				inner join CRBitacoraTran b
					on a.CRBid = b.CRBid
		
				inner join CFuncional c
					on b.CFid_dest = c.CFid
		
				inner join AFTBResponsables d
					on d.AFTRid = b.AFTRid
		
				inner join AFResponsables e
					on d.AFRid = e.AFRid
		
				inner join CFuncional f
					on f.CFid = e.CFid
		
		where b.CRBid = #Arguments.CRBid#
		</cfquery>
		
		<cfif rsDatosDest.recordcount eq 0>
			<cf_errorCode	code = "50908" msg = "No se encontraron los datos destino. No es posible generar el asiento contable">
		</cfif>
		
		<cfset CFid1=rsDatosDest.CFid>
		<cfset Ocodigo1=rsDatosDest.Ocodigo>
		<cfset CFid2=rsDatosDest.CFid_dest>
		<cfset Ocodigo2=rsDatosDest.Ocodigo_dest>
		<cfset AFTRid_ant=rsDatosDest.AFTRid>
		<cfset LvarAFTRfini = rsDatosDest.AFTRfini>
				
		<!--- Obtiene las descripciones de las Oficinas --->
		<cfquery name="rsOdescripcion1" datasource="#session.dsn#">
			select Odescripcion as Odescripcion1
			from Oficinas 
			where Ecodigo = #Arguments.Ecodigo#
			and Ocodigo = #Ocodigo1#
		</cfquery>
		<cfif rsOdescripcion1.recordcount and len(trim(rsOdescripcion1.Odescripcion1)) gt 0>
			<cfset Odescripcion1 = rsOdescripcion1.Odescripcion1>
		<cfelse>
			<cfset Odescripcion1 = "Oficina Origen">
		</cfif>
		<cfquery name="rsOdescripcion2" datasource="#session.dsn#">
			select Odescripcion as Odescripcion2
			from Oficinas 
			where Ecodigo = #Arguments.Ecodigo#
			and Ocodigo = #Ocodigo2#
		</cfquery>
		<cfif rsOdescripcion2.recordcount and len(trim(rsOdescripcion2.Odescripcion2)) gt 0>
			<cfset Odescripcion2 = rsOdescripcion2.Odescripcion2>
		<cfelse>
			<cfset Odescripcion2 = "Oficina Destino">
		</cfif>			
		
		<!--- 2.2 (solo si cambio el Centro Funcional) Actualiza Centro Funcional en AFSaldos --->
		<cfquery name="_rsObtieneActivosAModificar" datasource="#Arguments.Conexion#">
			select distinct afr.Aid as Aid
			  from AFTBResponsables aftr
				 inner join AFResponsables afr
				    on afr.AFRid = aftr.AFRid
			  where aftr.AFTRid = #AFTRid_ant#
		</cfquery>
		<cfloop query="_rsObtieneActivosAModificar">
			<cfquery datasource="#Arguments.Conexion#">
				update AFSaldos
					set CFid = #CFid2#,
					 Ocodigo = #Ocodigo2#
				where Aid       = #_rsObtieneActivosAModificar.Aid#
				and AFSperiodo  = #rsPeriodo.Periodo#
				and AFSmes      = #rsMes.Mes#
				and Ecodigo		= #Arguments.Ecodigo#
			</cfquery>
		</cfloop>


		<!--- 2.3 Asiento (solo si cambio el Centro Funcional) Hago asiento contable para trasladar el valor del Activo --->
		<!--- 2.3.1 Débito de Valor de Adq, y Mej, para Oficina 2 a la cuenta de adq (cat/clas) --->
		<cfquery datasource="#Arguments.Conexion#">
			insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, CFid)
			select 
					'AFTA', 
					1, 
					<cf_dbfunction name="to_char" args="#LvarNumDoc#">, 
					'TA',
					afs.AFSvaladq + afs.AFSvalmej, 
					'D', 
					'TA. Debito Adq. + Mej., Oficina 2 #Odescripcion2#, Activo ' #_Cat# act.Aplaca #_Cat# '.', 
					'#DateFormat(LvarAFTRfini,'YYYYMMDD')#',
					1.00,  
					#rsPeriodo.Periodo#, 
					#rsMes.Mes#, 
					cls.ACcadq, 
					#rsEmpresa.Mcodigo#,
					#Ocodigo2#, 
					afs.AFSvaladq + afs.AFSvalmej,
                    afs.CFid
			from AFTBResponsables aftr
				inner join AFResponsables afr
					on aftr.AFRid = afr.AFRid
				inner join Activos act
					on afr.Aid = act.Aid
				inner join AClasificacion cls
						on act.Ecodigo = cls.Ecodigo
						and act.ACid = cls.ACid
						and act.ACcodigo = cls.ACcodigo
				inner join AFSaldos afs
					on act.Aid = afs.Aid
			where AFTRid 	   = #AFTRid_ant#
			and afs.Ecodigo    = #Arguments.Ecodigo#
			and afs.AFSperiodo = #rsPeriodo.Periodo#
			and afs.AFSmes     = #rsMes.Mes#
		</cfquery>
		<!--- 2.3.2 Crédito de Valor de Adq, y Mej, para Oficina 1 a la cuenta de adq (cat/clas) --->
		<cfquery datasource="#Arguments.Conexion#" name="x">
			insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, CFid)
			select 
					'AFTA', 
					1, 
					<cf_dbfunction name="to_char" args="#LvarNumDoc#">, 
					'TA',
					afs.AFSvaladq + afs.AFSvalmej, 
					'C', 
					'TA.Credito Adq. + Mej., Ofi 1(#Odescripcion1#), Activo '#_Cat# act.Aplaca, 
					'#DateFormat(LvarAFTRfini,'YYYYMMDD')#',
					1.00,  
					#rsPeriodo.Periodo#, 
					#rsMes.Mes#, 
					cls.ACcadq, 
					#rsEmpresa.Mcodigo#,
					#Ocodigo1#, 
					afs.AFSvaladq + afs.AFSvalmej,
                    afs.CFid 
			from AFTBResponsables aftr
			inner join AFResponsables afr
				on aftr.AFRid = afr.AFRid
			inner join Activos act
				on afr.Aid = act.Aid
			inner join AClasificacion cls
					on act.Ecodigo = cls.Ecodigo
					and act.ACid = cls.ACid
					and act.ACcodigo = cls.ACcodigo
			inner join AFSaldos afs
				on act.Aid = afs.Aid
			where AFTRid       = #AFTRid_ant#
			and afs.Ecodigo    = #Arguments.Ecodigo#
			and afs.AFSperiodo = #rsPeriodo.Periodo#
			and afs.AFSmes     = #rsMes.Mes#
		</cfquery>
		<!--- 2.3.3 Crédito de Valor Dep. Acum de Adq, y Mej, para Oficina 2 a la cuenta de dep. acum. de adq. (cat/clas) --->
		<cfquery datasource="#Arguments.Conexion#">
			insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, CFid)
			select 
					'AFTA', 
					1, 
					<cf_dbfunction name="to_char" args="#LvarNumDoc#">, 
					'TA',
					afs.AFSdepacumadq + afs.AFSdepacummej, 
					'C', 
					'TA.Cred Dep.Acum. Adq. + Dep.Acum. Mej.,Ofi 2(#Odescripcion2#),Activo '#_Cat# act.Aplaca, 
					'#DateFormat(LvarAFTRfini,'YYYYMMDD')#',
					1.00,  
					#rsPeriodo.Periodo#, 
					#rsMes.Mes#, 
					cls.ACcdepacum, 
					#rsEmpresa.Mcodigo#,
					#Ocodigo2#, 
					afs.AFSdepacumadq + afs.AFSdepacummej,
                    afs.CFid
			from AFTBResponsables aftr
			inner join AFResponsables afr
				on aftr.AFRid = afr.AFRid
			inner join Activos act
				on afr.Aid = act.Aid
			inner join AClasificacion cls
					on act.Ecodigo = cls.Ecodigo
					and act.ACid = cls.ACid
					and act.ACcodigo = cls.ACcodigo
			inner join AFSaldos afs
				on act.Aid = afs.Aid
			where AFTRid       = #AFTRid_ant#
			and afs.Ecodigo    = #Arguments.Ecodigo#
			and afs.AFSperiodo = #rsPeriodo.Periodo#
			and afs.AFSmes     = #rsMes.Mes#
		</cfquery>
		<!--- 2.3.4 Dédito de Valor Dep. Acum de Adq, y Mej, para Oficina 1 a la cuenta de dep. acum. de adq. (cat/clas) --->
		<cfquery datasource="#Arguments.Conexion#">
			insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, CFid)
			select 
					'AFTA', 
					1, 
					<cf_dbfunction name="to_char" args="#LvarNumDoc#">, 
					'TA',
					afs.AFSdepacumadq + afs.AFSdepacummej, 
					'D', 
					'TA.Deb Dep.Acum. Adq. + Dep.Acum. Mej.,Ofi 1(#Odescripcion1#), Activo '#_Cat# act.Aplaca, 
					'#DateFormat(LvarAFTRfini,'YYYYMMDD')#',
					1.00,  
					#rsPeriodo.Periodo#, 
					#rsMes.Mes#, 
					cls.ACcdepacum, 
					#rsEmpresa.Mcodigo#,
					#Ocodigo1#, 
					afs.AFSdepacumadq + afs.AFSdepacummej,
                    afs.CFid
			from AFTBResponsables aftr
			inner join AFResponsables afr
				on aftr.AFRid = afr.AFRid
			inner join Activos act
				on afr.Aid = act.Aid
			inner join AClasificacion cls
					on act.Ecodigo = cls.Ecodigo
					and act.ACid = cls.ACid
					and act.ACcodigo = cls.ACcodigo
			inner join AFSaldos afs
				on act.Aid = afs.Aid
			where AFTRid       = #AFTRid_ant#
			and afs.Ecodigo    = #Arguments.Ecodigo#
			and afs.AFSperiodo = #rsPeriodo.Periodo#
			and afs.AFSmes     = #rsMes.Mes#
		</cfquery>
		<!--- 2.3.5 Dédito de Valor Rev., para Oficina 2 a la cuenta de revaluación. (cat/clas) --->
		<cfquery datasource="#Arguments.Conexion#">
			insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, CFid)
			select 
					'AFTA', 
					1, 
					<cf_dbfunction name="to_char" args="#LvarNumDoc#">, 
					'TA',
					afs.AFSvalrev, 
					'D', 
					'TA. Debito Rev., Ofi 2(#Odescripcion2#), Activo '#_Cat# act.Aplaca, 
					'#DateFormat(LvarAFTRfini,'YYYYMMDD')#',
					1.00,  
					#rsPeriodo.Periodo#, 
					#rsMes.Mes#, 
					cls.ACcrevaluacion, 
					#rsEmpresa.Mcodigo#,
					#Ocodigo2#, 
					afs.AFSvalrev,
                    afs.CFid
			from AFTBResponsables aftr
			inner join AFResponsables afr
				on aftr.AFRid = afr.AFRid
			inner join Activos act
				on afr.Aid = act.Aid
			inner join AClasificacion cls
					on act.Ecodigo = cls.Ecodigo
					and act.ACid = cls.ACid
					and act.ACcodigo = cls.ACcodigo
			inner join AFSaldos afs
				on act.Aid = afs.Aid
			where AFTRid       = #AFTRid_ant#
			and afs.Ecodigo    = #Arguments.Ecodigo#
			and afs.AFSperiodo = #rsPeriodo.Periodo#
			and afs.AFSmes     = #rsMes.Mes#
		</cfquery>
		<!--- 2.3.6 Crédito de Valor Rev., para Oficina 1 a la cuenta de revaluación. (cat/clas) --->
		<cfquery datasource="#Arguments.Conexion#">
			insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, CFid)
			select 
					'AFTA', 
					1, 
					<cf_dbfunction name="to_char" args="#LvarNumDoc#">, 
					'TA',
					afs.AFSvalrev, 
					'C', 
					'TA. Credito Rev., Ofi 1(#Odescripcion1#), Activo '#_Cat# act.Aplaca, 
					'#DateFormat(LvarAFTRfini,'YYYYMMDD')#',
					1.00,  
					#rsPeriodo.Periodo#, 
					#rsMes.Mes#, 
					cls.ACcrevaluacion, 
					#rsEmpresa.Mcodigo#,
					#Ocodigo1#, 
					afs.AFSvalrev,
                    afs.CFid
			from AFTBResponsables aftr
			inner join AFResponsables afr
				on aftr.AFRid = afr.AFRid
			inner join Activos act
				on afr.Aid = act.Aid
			inner join AClasificacion cls
					on act.Ecodigo = cls.Ecodigo
					and act.ACid = cls.ACid
					and act.ACcodigo = cls.ACcodigo
			inner join AFSaldos afs
				on act.Aid = afs.Aid
			where AFTRid       = #AFTRid_ant#
			and afs.Ecodigo    = #Arguments.Ecodigo#
			and afs.AFSperiodo = #rsPeriodo.Periodo#
			and afs.AFSmes     = #rsMes.Mes#
		</cfquery>
		<!--- 2.3.7 Crédito por Dep. Acum. Rev., para Oficina 2 a la cuenta de revaluación. (cat/clas) --->
		<cfquery datasource="#Arguments.Conexion#">
			insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, CFid)
			select 
					'AFTA', 
					1, 
					<cf_dbfunction name="to_char" args="#LvarNumDoc#">, 
					'TA',
					afs.AFSdepacumrev, 
					'C', 
					'TA. Credito Dep. Acum. Rev., Ofi 2(#Odescripcion2#), Activo '#_Cat# act.Aplaca, 
					'#DateFormat(LvarAFTRfini,'YYYYMMDD')#',
					1.00,  
					#rsPeriodo.Periodo#, 
					#rsMes.Mes#, 
					cls.ACcdepacumrev, 
					#rsEmpresa.Mcodigo#,
					#Ocodigo2#, 
					afs.AFSdepacumrev,
                    afs.CFid
			from AFTBResponsables aftr
			inner join AFResponsables afr
				on aftr.AFRid = afr.AFRid
			inner join Activos act
				on afr.Aid = act.Aid
			inner join AClasificacion cls
					on act.Ecodigo = cls.Ecodigo
					and act.ACid = cls.ACid
					and act.ACcodigo = cls.ACcodigo
			inner join AFSaldos afs
				on act.Aid = afs.Aid
			where AFTRid       = #AFTRid_ant#
			and afs.Ecodigo    = #Arguments.Ecodigo#
			and afs.AFSperiodo = #rsPeriodo.Periodo#
			and afs.AFSmes     = #rsMes.Mes#
		</cfquery>
		<!--- 2.3.8 Dédito por Dep. Acum. Rev., para Oficina 1 a la cuenta de revaluación. (cat/clas) --->
		<cfquery datasource="#Arguments.Conexion#">
			insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, CFid)
			select 
					'AFTA', 
					1, 
					<cf_dbfunction name="to_char" args="#LvarNumDoc#">, 
					'TA',
					afs.AFSdepacumrev, 
					'D', 
					'TA. Debito Dep. Acum. Rev., Oficina 1(#Odescripcion1#), Activo '#_Cat# act.Aplaca #_Cat# '.', 
					'#DateFormat(LvarAFTRfini,'YYYYMMDD')#',
					1.00,  
					#rsPeriodo.Periodo#, 
					#rsMes.Mes#, 
					cls.ACcdepacumrev, 
					#rsEmpresa.Mcodigo#,
					#Ocodigo1#, 
					afs.AFSdepacumrev,
                    afs.CFid
			from AFTBResponsables aftr
			inner join AFResponsables afr
				on aftr.AFRid = afr.AFRid
			inner join Activos act
				on afr.Aid = act.Aid
			inner join AClasificacion cls
					on act.Ecodigo = cls.Ecodigo
					and act.ACid = cls.ACid
					and act.ACcodigo = cls.ACcodigo
			inner join AFSaldos afs
				on act.Aid = afs.Aid
			where AFTRid = #AFTRid_ant#
			and afs.Ecodigo = #Arguments.Ecodigo#
			and afs.AFSperiodo = #rsPeriodo.Periodo#
			and afs.AFSmes = #rsMes.Mes#
		</cfquery>
		<!--- ********************************************************************************************
		** BALANCE POR OFICINAS: Si las oficinas origen y destino son distintas busca en la tabla CuentaBalanceOficina **
		*********************************************************************************************--->
		<cfif Ocodigo1 neq Ocodigo2>
			
			<cfquery name="rsHayCuentasBalanceOficina" datasource="#Arguments.Conexion#">
				select 1
				from CuentaBalanceOficina
				where Ecodigo = #Arguments.Ecodigo#
			</cfquery>
			<cfif rsHayCuentasBalanceOficina.recordcount GT 0>
				<cfquery name="rsCuentaPorCobrarFrom1To2" datasource="#Arguments.Conexion#">
					select CFcuentacxc
					from CuentaBalanceOficina a
						inner join ConceptoContable b
						on b.Ecodigo = a.Ecodigo
						and b.Cconcepto = a.Cconcepto
						and b.Oorigen = 'AFTA'
					where a.Ecodigo = #Arguments.Ecodigo#
					and Ocodigoori = #Ocodigo1#
					and Ocodigodest = #Ocodigo2#
				</cfquery>
				<cfquery name="rsCuentaPorPagarFrom2To1" datasource="#Arguments.Conexion#">
					select CFcuentacxp
					from CuentaBalanceOficina a
						inner join ConceptoContable b
						on b.Ecodigo = a.Ecodigo
						and b.Cconcepto = a.Cconcepto
						and b.Oorigen = 'AFTA'
					where a.Ecodigo = #Arguments.Ecodigo#
					and Ocodigoori = #Ocodigo2#
					and Ocodigodest = #Ocodigo1#
				</cfquery>								
				<cfset ErrorCuentaBalance = 0>
				<cfif (rsCuentaPorCobrarFrom1To2.recordcount 
					and len(trim(rsCuentaPorCobrarFrom1To2.CFcuentacxc)) gt 0 
					and rsCuentaPorCobrarFrom1To2.CFcuentacxc)
					and not (rsCuentaPorPagarFrom2To1.recordcount 
					and len(trim(rsCuentaPorPagarFrom2To1.CFcuentacxp)) gt 0 
					and rsCuentaPorPagarFrom2To1.CFcuentacxp)>
					
					<cfset ErrorCuentaBalance = 1>
					<cfset ErrorCuentaBalanceDesc = "No se encontró la Cuenta por Pagar, de Balance Por Oficina, Entre la Oficina #Odescripcion2# y la Oficina #Odescripcion1#.">

				<cfelseif not (rsCuentaPorCobrarFrom1To2.recordcount 
					and len(trim(rsCuentaPorCobrarFrom1To2.CFcuentacxc)) gt 0 
					and rsCuentaPorCobrarFrom1To2.CFcuentacxc)
					and (rsCuentaPorPagarFrom2To1.recordcount 
					and len(trim(rsCuentaPorPagarFrom2To1.CFcuentacxp)) gt 0 
					and rsCuentaPorPagarFrom2To1.CFcuentacxp)>

					<cfset ErrorCuentaBalance = 2>
					<cfset ErrorCuentaBalanceDesc = "No se encontró la Cuenta por Cobrar, de Balance Por Oficina, Entre la Oficina #Odescripcion1# y la Oficina #Odescripcion2#.">
					
				<cfelseif not (rsCuentaPorCobrarFrom1To2.recordcount 
					and len(trim(rsCuentaPorCobrarFrom1To2.CFcuentacxc)) gt 0 
					and rsCuentaPorCobrarFrom1To2.CFcuentacxc)
					and not (rsCuentaPorPagarFrom2To1.recordcount 
					and len(trim(rsCuentaPorPagarFrom2To1.CFcuentacxp)) gt 0 
					and rsCuentaPorPagarFrom2To1.CFcuentacxp)>

					<cfset ErrorCuentaBalance = 3>
					<cfset ErrorCuentaBalanceDesc = "No se encontró la Cuenta por Cobrar, de Balance Por Oficina, Entre la Oficina #Odescripcion1# y la Oficina #Odescripcion2# y No se encontró la Cuenta por Pagar, de Balance Por Oficina, Entre la Oficina #Odescripcion2# y la Oficina #Odescripcion1#">
				</cfif>
				<cfif ErrorCuentaBalance GT 0>
					<cf_errorCode	code = "50363"
									msg  = "Error de definición de Cuenta de Balance por Oficina. @errorDat_1@ Proceso Cancelado!"
									errorDat_1="#ErrorCuentaBalanceDesc#"
					>
				</cfif>
				<!--- 2.3.9 Debito Oficina 1(#Odescripcion1#), Balance Oficina, Cuenta por Cobrar a la Oficina 2 --->
				<cfquery datasource="#Arguments.Conexion#">
					insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, CFcuenta, Ccuenta, Mcodigo, Ocodigo, INTMOE, CFid)
					select 
							'AFTA', 
							1, 
							<cf_dbfunction name="to_char" args="#LvarNumDoc#">, 
							'TA',
							afs.AFSvaladq + afs.AFSvalmej + afs.AFSvalrev - 
							afs.AFSdepacumadq - afs.AFSdepacummej - afs.AFSdepacumrev, 
							'D', 
							'Debito Oficina 1(#Odescripcion1#), Balance Oficina, Cuenta por Cobrar a la Oficina 2(#Odescripcion2#), Activo '#_Cat# act.Aplaca#_Cat#'.', 
							'#DateFormat(LvarAFTRfini,'YYYYMMDD')#',
							1.00,  
							#rsPeriodo.Periodo#, 
							#rsMes.Mes#, 
							#rsCuentaPorCobrarFrom1To2.CFcuentacxc#, 0,
							#rsEmpresa.Mcodigo#,
							#Ocodigo1#, 
							afs.AFSvaladq + afs.AFSvalmej + afs.AFSvalrev - 
							afs.AFSdepacumadq - afs.AFSdepacummej - afs.AFSdepacumrev,
                            afs.CFid
					from AFTBResponsables aftr
					inner join AFResponsables afr
						on aftr.AFRid = afr.AFRid
					inner join Activos act
						on afr.Aid = act.Aid
					inner join AClasificacion cls
							on act.Ecodigo = cls.Ecodigo
							and act.ACid = cls.ACid
							and act.ACcodigo = cls.ACcodigo
					inner join AFSaldos afs
						on act.Aid = afs.Aid
					where AFTRid       = #AFTRid_ant#
					and afs.Ecodigo    = #Arguments.Ecodigo#
					and afs.AFSperiodo = #rsPeriodo.Periodo#
					and afs.AFSmes     = #rsMes.Mes#
				</cfquery>
				<!--- 2.3.10 Crédito, Balance Oficina, Cuenta Pagar a la Oficina 1 --->
				<cfquery datasource="#Arguments.Conexion#">
					insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, CFcuenta, Ccuenta, Mcodigo, Ocodigo, INTMOE, CFid)
					select 
							'AFTA', 
							1, 
							<cf_dbfunction name="to_char" args="#LvarNumDoc#">, 
							'TA',
							afs.AFSvaladq + afs.AFSvalmej + afs.AFSvalrev - 
							afs.AFSdepacumadq - afs.AFSdepacummej - afs.AFSdepacumrev, 
							'C', 
							'Credito Oficina 2(#Odescripcion2#), Balance Oficina, Cuenta Pagar a la Oficina 1(#Odescripcion1#), Activo '#_Cat# act.Aplaca #_Cat#'.', 
							'#DateFormat(LvarAFTRfini,'YYYYMMDD')#',
							1.00,  
							#rsPeriodo.Periodo#, 
							#rsMes.Mes#, 
							#rsCuentaPorPagarFrom2To1.CFcuentacxp#, 0,
							#rsEmpresa.Mcodigo#,
							#Ocodigo2#, 
							afs.AFSvaladq + afs.AFSvalmej + afs.AFSvalrev - 
							afs.AFSdepacumadq - afs.AFSdepacummej - afs.AFSdepacumrev,
                            afs.CFid
					from AFTBResponsables aftr
					inner join AFResponsables afr
						on aftr.AFRid = afr.AFRid
					inner join Activos act
						on afr.Aid = act.Aid
					inner join AClasificacion cls
							on act.Ecodigo = cls.Ecodigo
							and act.ACid = cls.ACid
							and act.ACcodigo = cls.ACcodigo
					inner join AFSaldos afs
						on act.Aid = afs.Aid
					where AFTRid = #AFTRid_ant#
					and afs.Ecodigo = #Arguments.Ecodigo#
					and afs.AFSperiodo = #rsPeriodo.Periodo#
					and afs.AFSmes = #rsMes.Mes#
				</cfquery>
		
			</cfif>
								
		</cfif>
		
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
		
		<!--- 3.5 Genera Asiento --->
		<cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="GeneraAsiento" returnvariable="res_GeneraAsiento">
			<cfinvokeargument name="Ecodigo" 		value="#Arguments.Ecodigo#"/>
			<cfinvokeargument name="Oorigen" 		value="AFTA"/>
			<cfinvokeargument name="Eperiodo" 		value="#rsPeriodo.Periodo#"/>
			<cfinvokeargument name="Emes" 			value="#rsMes.Mes#"/>
			<cfinvokeargument name="Efecha" 		value="#LvarAFTRfini#"/>
			<cfinvokeargument name="Edescripcion" 	value="Transferencia de Activo"/>
			<cfinvokeargument name="Edocbase" 		value="#LvarNumDoc#"/>
			<cfinvokeargument name="Ereferencia" 	value="TA"/>
			<cfinvokeargument name="Ocodigo" 		value="#LvarOcodigo#"/>
			<cfinvokeargument name="Debug" 			value="#Arguments.Debug#"/>
		</cfinvoke>
		<cfquery name="rstemp" datasource="#session.dsn#">
			update TransaccionesActivos 
				set IDcontable = #res_GeneraAsiento#
			where Ecodigo = #Arguments.Ecodigo#
			and AGTPid = #rs_agtp_insert.identity#
		</cfquery>	
			<!---Se usa el modo debug para simular el posteo y capturar el error exacto en la lista de errores de la Cola--->
			<cfif #Arguments.Debug#>
				<cftransaction action="rollback">
			</cfif>
		</cftransaction>

		<cfreturn "OK">
	</cffunction>
</cfcomponent>



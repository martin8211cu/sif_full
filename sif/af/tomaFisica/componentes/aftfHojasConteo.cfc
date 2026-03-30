<cfcomponent>

	<cffunction name="getHojaConteoById" access="public" returntype="query">
		<cfargument name="AFTFid_hoja" type="string" required="yes">
		<cfquery name="rs" datasource="#session.dsn#">
			select a.AFTFid_hoja, a.AFTFdescripcion_hoja, a.AFTFfecha_hoja, a.AFTFfecha_conteo_hoja, a.AFTFfecha_aplicacion, 
				a.AFTFestatus_hoja, a.AFTFresponsable_hoja, a.ts_rversion, 
				b.AFTFid_dispositivo, b.AFTFcodigo_dispositivo, b.AFTFnombre_dispositivo, c.DEid, c.DEidentificacion,
				{fn concat(c.DEapellido1, {fn concat(' ', {fn concat(c.DEapellido2, {fn concat(' ', c.DEnombre)})})})} as DEnombre
			from AFTFHojaConteo a
				left outer join AFTFDispositivo b
				on b.AFTFid_dispositivo = a.AFTFid_dispositivo
				left outer join DatosEmpleado c
				on c.DEid = a.DEid
			where a.AFTFid_hoja = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AFTFid_hoja#">
		</cfquery>
		<cfif rs.recordCount neq 1>
			<cf_errorCode	code = "50817" msg = "No se pudo obtener la Hoja de Conteo, ¡Proceso Cancelado!.">>
		</cfif>
		<cfreturn rs>
	</cffunction>
	
	<cffunction name="insertHojaConteo" access="public" returntype="numeric">
		<cfargument name="AFTFdescripcion_hoja" 	type="string" required="yes">
		<cfargument name="AFTFid_dispositivo" 		type="string" required="no">
		<cfargument name="DEid" 							type="string" required="no">
		<cfargument name="AFTFfecha_hoja" 			type="string" required="yes">
		<cfargument name="AFTFresponsable_hoja" 	type="string" required="yes">		
		<cftransaction>
			<cfquery name="rs" datasource="#session.dsn#">
				insert into AFTFHojaConteo (DEid, AFTFid_dispositivo, AFTFdescripcion_hoja, AFTFfecha_hoja, 
						AFTFfecha_conteo_hoja, AFTFfecha_aplicacion, AFTFresponsable_hoja, AFTFestatus_hoja, 
						CEcodigo, Ecodigo, AFTFusuario_generacion, AFTFusuario_aplicacion, AFTFfalta, BMUsucodigo)
				values(
						<cfif isdefined("Arguments.DEid") and len(trim(Arguments.DEid)) gt 0><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#"><cfelse>null</cfif>,
						<cfif isdefined("Arguments.AFTFid_dispositivo") and len(trim(Arguments.AFTFid_dispositivo)) gt 0><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AFTFid_dispositivo#"><cfelse>null</cfif>,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.AFTFdescripcion_hoja#">, 
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Arguments.AFTFfecha_hoja)#">, 
						
						null, 
						null, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.AFTFresponsable_hoja#">, 
						0, 
						
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">, 
						 #Session.Ecodigo# , 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
						null, 
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
				)
				<cf_dbidentity1>
			</cfquery>
			<cf_dbidentity2 name="rs">
		</cftransaction>
		<cfreturn rs.identity>
	</cffunction>
	
	<cffunction name="updateHojaConteo" access="public" returntype="numeric">
		<cfargument name="AFTFid_hoja" 				type="string" required="yes">
		<cfargument name="AFTFdescripcion_hoja" 	type="string" required="yes">
		<cfargument name="AFTFid_dispositivo" 		type="string" required="yes">
		<cfargument name="DEid" 							type="string" required="no">
		<cfargument name="AFTFfecha_hoja" 			type="string" required="yes">
		<cfargument name="AFTFresponsable_hoja" 	type="string" required="yes">		
		<cfquery name="rs" datasource="#session.dsn#">
			select AFTFid_hoja, AFTFdescripcion_hoja
			from AFTFHojaConteo 
			where <cf_whereinlist column="AFTFid_hoja" valuelist="#Arguments.AFTFid_hoja#">
			and AFTFestatus_hoja > 0
		</cfquery>
		<cfif rs.recordcount gt 0>
			<cfset x = ""><cfset y = "">
			<cfif rs.recordcount gt 1>
				<cfset x = "s"><cfset y = "n">
			</cfif>
			<cf_errorCode	code = "50818"
							msg  = "La@errorDat_1@ hoja@errorDat_2@ de conteo: @errorDat_3@, se encuentra@errorDat_4@ en <BR> un estado no permitido para realizar esta acción, ¡Proceso Cancelado!."
							errorDat_1="#x#"
							errorDat_2="#x#"
							errorDat_3="#ValueList(rs.AFTFdescripcion_hoja)#"
							errorDat_4="#y#"
			>>
		</cfif>
		<cfquery name="rs" datasource="#session.dsn#">
			update AFTFHojaConteo 
			set DEid = <cfif isdefined("Arguments.DEid") and len(trim(Arguments.DEid)) gt 0><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#"><cfelse>null</cfif>,
				AFTFid_dispositivo = <cfif isdefined("Arguments.AFTFid_dispositivo") and len(trim(Arguments.AFTFid_dispositivo)) gt 0><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AFTFid_dispositivo#"><cfelse>null</cfif>,
				AFTFdescripcion_hoja = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.AFTFdescripcion_hoja#">, 
				AFTFfecha_hoja = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Arguments.AFTFfecha_hoja)#">, 
				AFTFresponsable_hoja = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.AFTFresponsable_hoja#">
			where <cf_whereinlist column="AFTFid_hoja" valuelist="#Arguments.AFTFid_hoja#">
			and AFTFestatus_hoja = 0
		</cfquery>
		<cfreturn Arguments.AFTFid_hoja>
	</cffunction>
	
	<cffunction name="deleteHojaConteo" access="public" returntype="string">
		<cfargument name="AFTFid_hoja" type="string" required="yes">
		<cfquery name="rs" datasource="#session.dsn#">
			select AFTFid_hoja, AFTFdescripcion_hoja
			from AFTFHojaConteo 
			where <cf_whereinlist column="AFTFid_hoja" valuelist="#Arguments.AFTFid_hoja#">
			and AFTFestatus_hoja > 0
		</cfquery>
		<cfif rs.recordcount gt 0>
			<cfset x = ""><cfset y = "">
			<cfif rs.recordcount gt 1>
				<cfset x = "s"><cfset y = "n">
			</cfif>
			<cf_errorCode	code = "50818"
							msg  = "La@errorDat_1@ hoja@errorDat_2@ de conteo: @errorDat_3@, se encuentra@errorDat_4@ en <BR> un estado no permitido para realizar esta acción, ¡Proceso Cancelado!."
							errorDat_1="#x#"
							errorDat_2="#x#"
							errorDat_3="#ValueList(rs.AFTFdescripcion_hoja)#"
							errorDat_4="#y#"
			>>
		</cfif>
		<cfquery name="rs" datasource="#session.dsn#">
			delete from AFTFDHojaConteo 
			where <cf_whereinlist column="AFTFid_hoja" valuelist="#Arguments.AFTFid_hoja#">
		</cfquery>
		<cfquery name="rs" datasource="#session.dsn#">
			delete from AFTFHojaConteo 
			where <cf_whereinlist column="AFTFid_hoja" valuelist="#Arguments.AFTFid_hoja#">
			and AFTFestatus_hoja = 0
		</cfquery>
		<cfreturn Arguments.AFTFid_hoja>
	</cffunction>
	
	<cffunction name="aplicarHojaConteo" access="public" returntype="query">
		<cfargument name="AFTFid_hoja" type="string" required="yes">
		<!--- ************************************************************************************************
		*************************************Sección de Validaciónes antes de Aplicar******************************
		************************************************************************************************* --->

		<cfset LvarMensaje = "">

		<!--- Validación 1: Valida que la hoja no este aplicada ni cancelada --->
		<cfquery name="rs" datasource="#session.dsn#">
			select AFTFid_hoja, AFTFdescripcion_hoja
			from AFTFHojaConteo 
			where <cf_whereinlist column="AFTFid_hoja" valuelist="#Arguments.AFTFid_hoja#">
			and AFTFestatus_hoja > 2
		</cfquery>
		<cfif rs.recordcount gt 0>
			<cfset LvarMensaje = LvarMensaje & "<BR>" & "Error: Hojas de Conteo con Estado Incorrecto:">
			<cfloop query="rs">
				<cfset LvarMensaje = LvarMensaje & "<BR>      #rs.AFTFdescripcion_hoja#">
			</cfloop>
		</cfif>

		<!--- Validación 2: Valida que la hoja tenga activos relacionados --->
		<cfquery name="rs" datasource="#session.dsn#">
			select a.AFTFid_hoja, a.AFTFdescripcion_hoja
			from AFTFHojaConteo a
			where <cf_whereinlist column="AFTFid_hoja" valuelist="#Arguments.AFTFid_hoja#">
			and not exists(select 1 from AFTFDHojaConteo b where b.AFTFid_hoja = a.AFTFid_hoja)
		</cfquery>
		<cfif rs.recordcount gt 0>
			<cfset LvarMensaje = LvarMensaje & "<BR>" & "Error: Hojas de Conteo sin Activos:">
			<cfloop query="rs">
				<cfset LvarMensaje = LvarMensaje & "<BR>      #rs.AFTFdescripcion_hoja#">
			</cfloop>
		</cfif>
		
		<!--- 
			Validación 3: Sí en la tabla AFTFHojaConteoD 
			existen registros con AFTF_banderaproceso valor 0, 
			enviar mensaje Existen registros sin definir condición; no puede aplicarse la hoja de conteo 
			y detener el proceso 
		--->
		<cfquery name="rs" datasource="#session.dsn#">
			select a.AFTFid_hoja, a.AFTFdescripcion_hoja
			from AFTFHojaConteo a
			where <cf_whereinlist column="AFTFid_hoja" valuelist="#Arguments.AFTFid_hoja#">
			and AFTFestatus_hoja > 1
			and exists(
				select 1 
				from AFTFDHojaConteo b 
				where b.AFTFid_hoja = a.AFTFid_hoja 
				and b.AFTFbanderaproceso = 0
				)
		</cfquery>
		<cfif rs.recordcount gt 0>
			<cfset LvarMensaje = LvarMensaje & "<BR>" & "Error: Hojas de Conteo con Activos sin definir Condicion:">
			<cfloop query="rs">
				<cfset LvarMensaje = LvarMensaje & "<BR>      #rs.AFTFdescripcion_hoja#">
			</cfloop>
		</cfif>
		
		<!--- 
			Validación 4: Para los registros que AFTF_banderaproceso = 1, 
			revisar los registros de la tabla AFTFHojaConteoD que tengan 
			valor en los campos DEid_lectura y CFid_lectura 
			y verificar que el empleado indicado pertenezca al centro funcional.  
			Sí no es consistente, enviar mensaje de error y detener el proceso. 
		--->
		<cfquery name="rs" datasource="#session.dsn#">
			select a.AFTFid_hoja, a.AFTFdescripcion_hoja
			from AFTFHojaConteo a
			where <cf_whereinlist column="AFTFid_hoja" valuelist="#Arguments.AFTFid_hoja#">
			and exists
				(select 1 from AFTFDHojaConteo b 
				where b.AFTFid_hoja = a.AFTFid_hoja 
				and b.AFTFbanderaproceso = 1
				and b.DEid_lectura is not null 
				and b.CFid_lectura is not null
				and not exists	(
								select 1 
								from DatosEmpleado c
								where c.DEid = b.DEid_lectura
								and
								(
								exists (
											select 1
											from LineaTiempo d
											where d.DEid = c.DEid
											and <cf_dbfunction name="now"> between d.LTdesde and d.LThasta
										)
								or exists	(
											select 1
											from EmpleadoCFuncional d
											where d.DEid = c.DEid
											and <cf_dbfunction name="now"> between d.ECFdesde and d.ECFhasta								
										)
								)
								)
							)

		</cfquery>
		<cfif rs.recordcount gt 0>
			<cfset LvarMensaje = LvarMensaje & "<BR>" & "Error: Hojas de Conteo con Activos en Condicion Normal sin Empleado Asociado o Inconsistente:">
			<cfloop query="rs">
				<cfset LvarMensaje = LvarMensaje & "<BR>      #rs.AFTFdescripcion_hoja#">
			</cfloop>
		</cfif>
		
		<!--- 
			Validación 5: Para los registros que AFTF_banderaproceso = 1, 
			revisar que los registros que tengan dato en CFid_lectura y no en DEid_lectura 
			tengan un empleado responsable en el catálogo de Centros Funcionales.  Sí no tiene, 
			enviar mensaje de error y detener el proceso. 

			Nota: Primero Obtiene los DEid_lectura de los Registros que cumplan la condición requerida 
			y los actualiza, si para algun registro con esa condición no lo obtiene, 
			da el error y los que si pudo obtener quedan actualizados.
		--->
		<!--- Asigna Empleado responsable del CF si no se indico el empleado --->

		<cfquery name="rs" datasource="#session.dsn#">
			select distinct CFid_lectura
			from AFTFDHojaConteo
			where <cf_whereinlist column="AFTFid_hoja" valuelist="#Arguments.AFTFid_hoja#">
			and AFTFbanderaproceso = 1
			and DEid_lectura is null 
			and CFid_lectura is not null
		</cfquery>

		<cfloop query="rs">
		
			<cfset Lvar_DEid_lectura = getResponsableCF(rs.CFid_lectura)>

			<cfif len(trim(Lvar_DEid_lectura))>
				<cfquery datasource="#session.dsn#">
					update AFTFDHojaConteo
					set DEid_lectura = #Lvar_DEid_lectura#
					where <cf_whereinlist column="AFTFid_hoja" valuelist="#Arguments.AFTFid_hoja#">
					  and AFTFbanderaproceso = 1
					  and DEid_lectura is null 
					  and CFid_lectura is not null
					  and CFid_lectura = #rs.CFid_lectura#
				</cfquery>
			</cfif>
		</cfloop>

		<cfquery name="rs" datasource="#session.dsn#">
			select a.AFTFid_hoja, a.AFTFdescripcion_hoja, act.Aplaca, cf.CFcodigo
			from AFTFHojaConteo a
				inner join AFTFDHojaConteo b
				on b.AFTFid_hoja = a.AFTFid_hoja
				
				inner join Activos act
				on act.Aid = b.Aid
				
				inner join CFuncional cf
				on cf.CFid = b.CFid_lectura
				
			where <cf_whereinlist column="a.AFTFid_hoja" valuelist="#Arguments.AFTFid_hoja#">
			and b.AFTFbanderaproceso = 1
			and b.DEid_lectura is null 
			and b.CFid_lectura is not null

		</cfquery>
		<cfif rs.recordcount gt 0>
			<cfset LvarMensaje = LvarMensaje & "<BR>" & "Error: Hojas de Conteo con Centro Funcional sin Responsable:">
			<cfloop query="rs">
				<cfset LvarMensaje = LvarMensaje & "<BR>      #rs.AFTFdescripcion_hoja#  Activo: #rs.Aplaca# CF: #rs.CFcodigo#">
			</cfloop>
		</cfif>
		
		<!--- 
			Validación 6: Para los registros que AFTF_banderaproceso = 1 
			y que haya que registrar un vale de traslado, 
			revisar que el activo en su último vale registre un centro de custodia 
			y un tipo de documento, de lo contrario, enviar 
			mensaje de error y detener el proceso
		--->
		<cfquery name="rs" datasource="#session.dsn#">
			select a.AFTFid_hoja, a.AFTFdescripcion_hoja, act.Aplaca
			from AFTFHojaConteo a
				inner join AFTFDHojaConteo b
				on b.AFTFid_hoja = a.AFTFid_hoja
				
				inner join Activos act
				on act.Aid = b.Aid
			where <cf_whereinlist column="a.AFTFid_hoja" valuelist="#Arguments.AFTFid_hoja#">
			  and b.AFTFbanderaproceso = 1
			  and b.DEid_lectura is not null 
			  and b.CFid_lectura is not null
			  and ((
			  		select count(1)
					from AFResponsables c
					where c.Aid = b.Aid
					  and <cf_dbfunction name="now"> between c.AFRfini and c.AFRffin
					  and CRCCid is not null
					  and CRTDid is not null
				)) = 0
		</cfquery>

		<cfif rs.recordcount gt 0>
			<cfset LvarMensaje = LvarMensaje & "<BR>" & "Error: Hojas de Conteo con Vales Inconsistentes:">
			<cfloop query="rs">
				<cfset LvarMensaje = LvarMensaje & "<BR>      #rs.AFTFdescripcion_hoja#  Activo: #rs.Aplaca#">
			</cfloop>
		</cfif>
		
		<!---
			Se Agrega nueva validacion para AFTFbanderaproceso = 4, por Berman
			Validación 7: Para los registros que AFTF_banderaproceso = 4, 
			revisar los registros de la tabla AFTFHojaConteoD que tengan valor 
			en los campos DEid_lectura o CFid_lectura y el activo pertenezca a la empresa 
			de la session.
			Sí no es consistente, enviar mensaje de error y detener el proceso. 
		--->
		<cfquery name="rs" datasource="#session.dsn#">
			select a.AFTFid_hoja, a.AFTFdescripcion_hoja, act.Aplaca
			from AFTFHojaConteo a
				inner join AFTFDHojaConteo b 
				on b.AFTFid_hoja = a.AFTFid_hoja
				
				inner join Activos act
				on act.Aid = b.Aid
				
			where <cf_whereinlist column="a.AFTFid_hoja" valuelist="#Arguments.AFTFid_hoja#">
			  and b.AFTFbanderaproceso = 4
			  and ( b.DEid_lectura is not null  or b.CFid_lectura is not null )
			  and act.Ecodigo <> #session.Ecodigo#
		</cfquery>
		<cfif rs.recordcount gt 0>
			<cfset LvarMensaje = LvarMensaje & "<BR>" & "Error: Hojas de Conteo con Activos de Otras Empresas:">
			<cfloop query="rs">
				<cfset LvarMensaje = LvarMensaje & "<BR>      #rs.AFTFdescripcion_hoja#  Activo: #rs.Aplaca#">
			</cfloop>
		</cfif>
		
		<cfif len(LvarMensaje) GT 2>
			<!--- Presentar mensaje --->
			<cfoutput>#LvarMensaje#</cfoutput>
			<cfabort>
		</cfif>

		<!--- 
			************************************************************************************************
			*************************************A P L I C A R (Aplicar)************************************
			************************************************************************************************

			Para los registros que AFTF_banderaproceso = 1, 
			generar un Vale sin aplicar en Control de Responsables donde se registra 
			el traslado del activo fijo al empleado del campo DEid_lectura
			
			Para los registros que AFTF_banderaproceso = 1, para los registros que no tienen 
			valor en DEid_lectura pero sí en CFid_lectura, 
			generar un Vale sin aplicar en Control de Responsables a la identificación del 
			empleado responsable del CFid_lectura según el catálogo de Centros Funcionales

			Si AFTFestatus_hoja es 2 (Aplicar Definitivo) 
			Cambiar el campo AFTFestatus_hoja de la tabla AFTFHojaConteo a 3. 
			Actualizar elcampo AFTFfecha_aplicacion de la tabla AFTFHojaConteo al now()
			
			Nota:
				Como en el caso en que se defina solamente el nuevo centro funcional 
				se actualiza el nuevo empleado, este nuevo empleado podría ser el mismo 
				no generar el traslado si no cambió el empleado
		--->

		<cftransaction>
		
		<cfquery name="rs" datasource="#session.dsn#">
			select AFRid, DEid_lectura
			from AFTFDHojaConteo a
				inner join AFResponsables b
				on b.Ecodigo = a.Ecodigo
				and b.Aid = a.Aid
				and <cf_dbfunction name="now"> between b.AFRfini and b.AFRffin	
			where <cf_whereinlist column="AFTFid_hoja" valuelist="#Arguments.AFTFid_hoja#">
			and a.AFTFbanderaproceso = 1
            and (a.DEid_lectura is not null or a.CFid_lectura is not null)
			and a.DEid_lectura <> a.DEid
		</cfquery>
		
		<cfloop query="rs">
			<cfinvoke component="sif.Componentes.AF_CambioResponsable" method="Transferir">
				<cfinvokeargument name="AFRid" value="#rs.AFRid#">
				<cfinvokeargument name="DEid" value="#rs.DEid_lectura#">
				<cfinvokeargument name="TransaccionActiva" value="true">
			</cfinvoke>
		</cfloop>
		
		<!----Para AFTFbanderaproceso = 4 (Agregado a la hoja) que tenga (DEid_lectura||CFid_lectura)---->
		<cfquery name="rs" datasource="#session.dsn#">
			select AFRid, DEid_lectura
			from AFTFDHojaConteo a
				inner join AFResponsables b
				on b.Ecodigo = a.Ecodigo
				and b.Aid = a.Aid
				and <cf_dbfunction name="now"> between b.AFRfini and b.AFRffin	
			where <cf_whereinlist column="AFTFid_hoja" valuelist="#Arguments.AFTFid_hoja#">
			and a.AFTFbanderaproceso = 4
			and a.DEid_lectura <> a.DEid
			and (a.DEid_lectura is not null or a.CFid_lectura is not null)
			
		</cfquery>
		
		<cfloop query="rs">
			<cfinvoke component="sif.Componentes.AF_CambioResponsable" method="Transferir">
				<cfinvokeargument name="AFRid" value="#rs.AFRid#">
				<cfinvokeargument name="DEid" value="#rs.DEid_lectura#">
				<cfinvokeargument name="TransaccionActiva" value="true">
			</cfinvoke>
		</cfloop>
		<!----Fin de Cambio hecho por Berman---->
		
		<cfquery name="rs" datasource="#session.dsn#">
			update AFTFHojaConteo 
			set AFTFestatus_hoja = 
				case AFTFestatus_hoja 
					when 0 then 
						case 
							when AFTFid_dispositivo is not null then 
								1
							else
								2
						end
					when 1 then
						2
					when 2 then
						3
				end
				, AFTFfecha_conteo_hoja = 
				case AFTFestatus_hoja 
					when 0 then 
						<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#Now()#">
					else 
						AFTFfecha_conteo_hoja
				end
				, AFTFfecha_aplicacion = 
				case AFTFestatus_hoja 
					when 2 then 
						<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#Now()#">
					else 
						<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="null"> 
				end
				, AFTFusuario_aplicacion = 
				case AFTFestatus_hoja 
					when 2 then 
						#Session.Usucodigo#
					else 
						<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null"> 
				end
			where  <cf_whereinlist column="AFTFid_hoja" valuelist="#Arguments.AFTFid_hoja#">
			and AFTFestatus_hoja < 3
		</cfquery>
		
		</cftransaction>
		
		<cfquery name="rs" datasource="#session.dsn#">
			select a.AFTFid_hoja, a.AFTFdescripcion_hoja, a.AFTFestatus_hoja
			from AFTFHojaConteo a
			where <cf_whereinlist column="AFTFid_hoja" valuelist="#Arguments.AFTFid_hoja#">
		</cfquery>
		<cfreturn rs>
	</cffunction>
	
	<cffunction name="cancelarHojaConteo" access="public" returntype="numeric">
		<cfargument name="AFTFid_hoja" type="string" required="yes">
		<cfquery name="rs" datasource="#session.dsn#">
			select AFTFid_hoja, AFTFdescripcion_hoja
			from AFTFHojaConteo 
			where <cf_whereinlist column="AFTFid_hoja" valuelist="#Arguments.AFTFid_hoja#">
			and not (AFTFestatus_hoja > 0
			and AFTFestatus_hoja < 3)
		</cfquery>
		<cfif rs.recordcount gt 0>
			<cfset x = ""><cfset y = "">
			<cfif rs.recordcount gt 1>
				<cfset x = "s"><cfset y = "n">
			</cfif>
			<cf_errorCode	code = "50818"
							msg  = "La@errorDat_1@ hoja@errorDat_2@ de conteo: @errorDat_3@, se encuentra@errorDat_4@ en <BR> un estado no permitido para realizar esta acción, ¡Proceso Cancelado!."
							errorDat_1="#x#"
							errorDat_2="#x#"
							errorDat_3="#ValueList(rs.AFTFdescripcion_hoja)#"
							errorDat_4="#y#"
			>>
		</cfif>
		<cfquery name="rs" datasource="#session.dsn#">
			update AFTFHojaConteo 
			set AFTFestatus_hoja = 9
			where  <cf_whereinlist column="AFTFid_hoja" valuelist="#Arguments.AFTFid_hoja#">
			and AFTFestatus_hoja > 0
			and AFTFestatus_hoja < 3
		</cfquery>
		<cfreturn Arguments.AFTFid_hoja>
	</cffunction>
	
	<cffunction name="getDHojaConteoById" access="public" returntype="query">
		<cfargument name="AFTFid_detallehoja" type="string" required="yes">
		<cfquery name="rs" datasource="#session.dsn#">
			select a.AFTFid_detallehoja, a.AFTFid_hoja, a.Aid, a.Ecodigo
				, a.AFMid, a.AFMMid, a.ACcodigo, a.ACid, a.AFCcodigo
				, a.DEid, a.DEid_lectura, a.CFid, a.CFid_lectura
				, a.Aplaca, a.Aserie, a.Adescripcion, a.Astatus, a.Avutil, a.Avalrescate
				, a.AFTForigen, a.AFTFcantidad, a.AFTFobservaciondetalle
				, a.AFTFbanderaproceso, a.AFTFfalta, a.BMUsucodigo, a.ts_rversion
				, b.AFMcodigo, b.AFMdescripcion
				, c.AFMMcodigo, c.AFMMdescripcion
				, d.ACcodigodesc, d.ACdescripcion
				, e.ACcodigodesc as ACcodigodesc_clas, e.ACdescripcion as ACdescripcion_clas
				, f.AFCcodigoclas, f.AFCdescripcion
				, g.DEidentificacion, {fn concat({fn concat({fn concat({fn concat(g.DEapellido1 , ' ' )}, g.DEapellido2 )}, ' ' )}, g.DEnombre)} as DEnombre
				, h.DEidentificacion as DEidentificacion_lectura, {fn concat({fn concat({fn concat({fn concat(h.DEapellido1 , ' ' )}, h.DEapellido2 )}, ' ' )}, h.DEnombre)} as DEnombre_lectura
				, i.CFcodigo, i.CFdescripcion
				, j.CFcodigo as CFcodigo_lectura, j.CFdescripcion as CFdescripcion_lectura
				, a.Adescripcion as Adescripcionx
			from AFTFDHojaConteo a
				left join AFMarcas b
					on b.AFMid = a.AFMid
				left join AFMModelos c
					on c.AFMMid = a.AFMMid
				left join ACategoria d
					on d.Ecodigo = a.Ecodigo
					and d.ACcodigo = a.ACcodigo
				left join AClasificacion e
					on e.Ecodigo = a.Ecodigo
					and e.ACid = a.ACid
					and e.ACcodigo = a.ACcodigo
				left join AFClasificaciones f
					on f.Ecodigo = a.Ecodigo
					and f.AFCcodigo = a.AFCcodigo
				inner join DatosEmpleado g
					on g.DEid = a.DEid
				left outer join DatosEmpleado h
					on h.DEid = a.DEid_lectura
				inner join CFuncional i
					on i.CFid = a.CFid
				left outer join CFuncional j
					on j.CFid = a.CFid_lectura
			where a.AFTFid_detallehoja = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AFTFid_detallehoja#">
		</cfquery>
		<cfif rs.recordCount neq 1>
			<cf_errorCode	code = "50819" msg = "No se pudo obtener el detalle de la Hoja de Conteo, ¡Proceso Cancelado!.">>
		</cfif>
		<cfreturn rs>
	</cffunction>
	
	<cffunction name="insertDHojaConteoWFilters" access="public" returntype="numeric">
		<cfargument name="AFTFid_hoja" type="string" required="yes">
		<cfargument name="Aid" 				type="string" required="no">
		<cfargument name="AFCcodigo"	type="string" required="no">
		<cfargument name="CFid" 			type="string" required="no">
		<cfargument name="Ocodigo" 		type="string" required="no">
		<cfargument name="ACcodigo" 	type="string" required="no">
		<cfargument name="ACid" 			type="string" required="no">
		<cfargument name="DEid" 			type="string" required="no">
		
		<cfargument name="AFTForigen" 			type="string" required="no" default="0">
		<cfargument name="AFTFcantidad" 		type="string" required="no" default="0">
		<cfargument name="AFTFobservaciondetalle" 			type="string" required="no" default="">
		<cfargument name="AFTFbanderaproceso" 				type="string" required="no" default="0">
		
		<cfif isdefined("Arguments.Aid") and len(trim(Arguments.Aid)) eq 0 
			and isdefined("Arguments.AFCcodigo") and len(trim(Arguments.AFCcodigo)) eq 0 
			and isdefined("Arguments.CFid") and len(trim(Arguments.CFid)) eq 0 
			and isdefined("Arguments.Ocodigo") and len(trim(Arguments.Ocodigo)) eq 0 
			and isdefined("Arguments.ACcodigo") and len(trim(Arguments.ACcodigo)) eq 0 
			and isdefined("Arguments.ACid") and len(trim(Arguments.ACid)) eq 0
			and isdefined("Arguments.DEid") and len(trim(Arguments.DEid)) eq 0>
				<cf_errorCode	code = "50820" msg = "Debe definir al menos un criterio de filtro para generar la lista de activos asociados <BR> a la hoja, ¡Proceso Cancelado!.">>
		</cfif>
		
		<cfquery name="rs" datasource="#session.dsn#">
			select AFTFid_hoja, AFTFdescripcion_hoja
			from AFTFHojaConteo 
			where AFTFid_hoja = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AFTFid_hoja#">
			and AFTFestatus_hoja > 2
		</cfquery>
		<cfif rs.recordcount gt 0>
			<cfset x = ""><cfset y = "">
			<cfif rs.recordcount gt 1>
				<cfset x = "s"><cfset y = "n">
			</cfif>
			<cf_errorCode	code = "50818"
							msg  = "La@errorDat_1@ hoja@errorDat_2@ de conteo: @errorDat_3@, se encuentra@errorDat_4@ en <BR> un estado no permitido para realizar esta acción, ¡Proceso Cancelado!."
							errorDat_1="#x#"
							errorDat_2="#x#"
							errorDat_3="#ValueList(rs.AFTFdescripcion_hoja)#"
							errorDat_4="#y#"
			>>
		</cfif>
		
		<cfquery name="rs" datasource="#session.dsn#">
			insert into AFTFDHojaConteo 
				(AFTFid_hoja, 
				Aid, Ecodigo, AFMid, AFMMid, ACcodigo, ACid, AFCcodigo, 
				DEid, DEid_lectura, 
				CFid, CFid_lectura, 
				Aplaca, Aserie, Adescripcion, Astatus, Avutil, Avalrescate, 
				AFTForigen, AFTFcantidad, AFTFobservaciondetalle, AFTFbanderaproceso, 
				AFTFfalta, BMUsucodigo)
			select <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.AFTFid_hoja#">,
				a.Aid, a.Ecodigo, a.AFMid, 	a.AFMMid, a.ACcodigo, a.ACid, a.AFCcodigo, 
				(select min(DEid) from AFResponsables x where x.Ecodigo = a.Ecodigo and x.Aid = a.Aid 
						and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> between x.AFRfini and x.AFRffin), <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">, 
				b.CFid, <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">, 
				a.Aplaca, a.Aserie, a.Adescripcion, a.Astatus, a.Avutil, a.Avalrescate, 
				
				<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#Arguments.AFTForigen#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#Arguments.AFTFcantidad#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Arguments.AFTFobservaciondetalle#" null="#len(trim(Arguments.AFTFobservaciondetalle)) eq 0#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#Arguments.AFTFbanderaproceso#">,				
				
				<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#Now()#">, 
				#Session.Usucodigo#
			from Activos a
				inner join AFSaldos b
				on b.Ecodigo = a.Ecodigo
				and b.Aid = a.Aid
                inner join AFResponsables r
                	on r.Aid = a.Aid
				<cfif isdefined("Arguments.AFCcodigo") and len(trim(Arguments.AFCcodigo)) gt 0>and b.AFCcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AFCcodigo#"></cfif>
				<cfif isdefined("Arguments.CFid") and len(trim(Arguments.CFid)) gt 0>and b.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CFid#"></cfif>
				<cfif isdefined("Arguments.Ocodigo") and len(trim(Arguments.Ocodigo)) gt 0>and b.Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ocodigo#"></cfif>
				<cfif isdefined("Arguments.ACcodigo") and len(trim(Arguments.ACcodigo)) gt 0>and b.ACcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ACcodigo#"></cfif>
				<cfif isdefined("Arguments.ACid") and len(trim(Arguments.ACid)) gt 0>and b.ACid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ACid#"></cfif>
				<cfif isdefined("Arguments.DEid") and len(trim(Arguments.DEid)) gt 0>and r.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#"></cfif>
            where a.Ecodigo =  #Session.Ecodigo# 
				<cfif isdefined("Arguments.Aid") and len(trim(Arguments.Aid)) gt 0>and <cf_whereinlist column="a.Aid" valuelist="#Arguments.Aid#"></cfif>
				and Astatus = 0
				and exists(
					select 1 from AFResponsables
					where Ecodigo = a.Ecodigo
					and Aid = a.Aid 
					and <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#Now()#"> between AFRfini and AFRffin
				)
				and not exists(
					select 1 from AFTFDHojaConteo x
						inner join AFTFHojaConteo y 
						on y.AFTFid_hoja = x.AFTFid_hoja
						and y.AFTFestatus_hoja < 3
					where x.Aid = a.Aid
					and x.Ecodigo = a.Ecodigo
				)
				and b.AFSperiodo = (select <cf_dbfunction name="to_number" args="Pvalor"> from Parametros where Ecodigo = a.Ecodigo and Pcodigo = 50)
				and b.AFSmes = 		(select <cf_dbfunction name="to_number" args="Pvalor"> from Parametros where Ecodigo = a.Ecodigo and Pcodigo = 60)
		</cfquery>
		<cfreturn Arguments.AFTFid_hoja>
	</cffunction>
	
	<cffunction name="insertDHojaConteo" access="public" returntype="numeric">
		<cfargument name="AFTFid_hoja" type="string" required="yes">

		<cfargument name="Aid" type="string" required="no">
		<cfargument name="AFMid" type="string" required="yes">
		<cfargument name="AFMMid" type="string" required="yes">
		<cfargument name="ACcodigo" type="string" required="yes">
		<cfargument name="ACid" type="string" required="yes">
		
		<cfargument name="AFCcodigo" type="string" required="yes">
		<cfargument name="CFid" type="string" required="yes">
		<cfargument name="DEid" type="string" required="yes">
		<cfargument name="DEid_lectura" type="string" required="no">
		<cfargument name="CFid_lectura" type="string" required="no">
		<cfargument name="Aplaca" type="string" required="no">
		
		<cfargument name="Aserie" type="string" required="no">
		<cfargument name="Adescripcion" type="string" required="yes">
		<cfargument name="Avutil" type="string" required="yes">
		<cfargument name="Avalrescate" type="string" required="yes">
		
		<cfargument name="AFTFobservaciondetalle" type="string" required="no">
		
		<cfquery name="rs" datasource="#session.dsn#">
			select AFTFid_hoja, AFTFdescripcion_hoja
			from AFTFHojaConteo 
			where AFTFid_hoja = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AFTFid_hoja#">
			and AFTFestatus_hoja <> 2
		</cfquery>
		<cfif rs.recordcount gt 0>
			<cfset x = ""><cfset y = "">
			<cfif rs.recordcount gt 1>
				<cfset x = "s"><cfset y = "n">
			</cfif>
			<cf_errorCode	code = "50818"
							msg  = "La@errorDat_1@ hoja@errorDat_2@ de conteo: @errorDat_3@, se encuentra@errorDat_4@ en <BR> un estado no permitido para realizar esta acción, ¡Proceso Cancelado!."
							errorDat_1="#x#"
							errorDat_2="#x#"
							errorDat_3="#ValueList(rs.AFTFdescripcion_hoja)#"
							errorDat_4="#y#"
			>>
		</cfif>

		<cfif isdefined("Arguments.Aid") and len(trim(Arguments.Aid)) gt 0>
	
			<cfquery name="rsv0" datasource="#session.dsn#">
				select 1
				from Activos a
				where a.Ecodigo =  #Session.Ecodigo# 
					and a.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Aid#">
			</cfquery>
			
			<cfquery name="rsv1" datasource="#session.dsn#">
				select 1
				from Activos a
				where a.Ecodigo =  #Session.Ecodigo# 
					and a.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Aid#">
					and Astatus = 0
			</cfquery>
			
			<cfquery name="rsv2" datasource="#session.dsn#">
				select 1
				from Activos a
					inner join AFSaldos b
					on b.Ecodigo = a.Ecodigo
					and b.Aid = a.Aid
					and b.AFSperiodo = (select <cf_dbfunction name="to_number" args="Pvalor"> from Parametros where Ecodigo = a.Ecodigo and Pcodigo = 50)
					and b.AFSmes = 		(select <cf_dbfunction name="to_number" args="Pvalor"> from Parametros where Ecodigo = a.Ecodigo and Pcodigo = 60)
				where a.Ecodigo =  #Session.Ecodigo# 
					and a.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Aid#">
					and Astatus = 0
			</cfquery>
			
			<cfquery name="rsv3" datasource="#session.dsn#">
				select 1
				from Activos a
					inner join AFSaldos b
					on b.Ecodigo = a.Ecodigo
					and b.Aid = a.Aid
					and b.AFSperiodo = (select <cf_dbfunction name="to_number" args="Pvalor"> from Parametros where Ecodigo = a.Ecodigo and Pcodigo = 50)
					and b.AFSmes = 		(select <cf_dbfunction name="to_number" args="Pvalor"> from Parametros where Ecodigo = a.Ecodigo and Pcodigo = 60)
				where a.Ecodigo =  #Session.Ecodigo# 
					and a.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Aid#">
					and Astatus = 0
					and exists(
						select 1 from AFResponsables
						where Ecodigo = a.Ecodigo
						and Aid = a.Aid 
						and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> between AFRfini and AFRffin
					)
			</cfquery>

			<cfquery name="rsv4" datasource="#session.dsn#">
				select 1
				from Activos a
					inner join AFSaldos b
					on b.Ecodigo = a.Ecodigo
					and b.Aid = a.Aid
					and b.AFSperiodo = (select <cf_dbfunction name="to_number" args="Pvalor"> from Parametros where Ecodigo = a.Ecodigo and Pcodigo = 50)
					and b.AFSmes = 		(select <cf_dbfunction name="to_number" args="Pvalor"> from Parametros where Ecodigo = a.Ecodigo and Pcodigo = 60)
				where a.Ecodigo =  #Session.Ecodigo# 
					and a.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Aid#">
					and Astatus = 0
					and exists(
						select 1 from AFResponsables
						where Ecodigo = a.Ecodigo
						and Aid = a.Aid 
						and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> between AFRfini and AFRffin
					)
					and not exists(
						select 1 from AFTFDHojaConteo x
							inner join AFTFHojaConteo y 
							on y.AFTFid_hoja = x.AFTFid_hoja
							and y.AFTFestatus_hoja < 3
						where x.Aid = a.Aid
						and x.Ecodigo = a.Ecodigo
						and x.AFTFid_hoja <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AFTFid_hoja#">
					)
			</cfquery>
			
			<cfquery name="rsv5" datasource="#session.dsn#">
				select 1
				from Activos a
					inner join AFSaldos b
					on b.Ecodigo = a.Ecodigo
					and b.Aid = a.Aid
					and b.AFSperiodo = (select <cf_dbfunction name="to_number" args="Pvalor"> from Parametros where Ecodigo = a.Ecodigo and Pcodigo = 50)
					and b.AFSmes = 		(select <cf_dbfunction name="to_number" args="Pvalor"> from Parametros where Ecodigo = a.Ecodigo and Pcodigo = 60)
				where a.Ecodigo =  #Session.Ecodigo# 
					and a.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Aid#">
					and Astatus = 0
					and exists(
						select 1 from AFResponsables
						where Ecodigo = a.Ecodigo
						and Aid = a.Aid 
						and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> between AFRfini and AFRffin
					)
					and not exists(
						select 1 from AFTFDHojaConteo x
							inner join AFTFHojaConteo y 
							on y.AFTFid_hoja = x.AFTFid_hoja
							and y.AFTFestatus_hoja < 3
						where x.Aid = a.Aid
						and x.Ecodigo = a.Ecodigo
						and x.AFTFid_hoja = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AFTFid_hoja#">
					)
			</cfquery>
		
			<cfif rsv0.recordcount eq 0>
				<cf_errorCode	code = "50821"
								msg  = "El Activo @errorDat_1@ no existe para la Empresa @errorDat_2@, ¡Proceso Cancelado!."
								errorDat_1="#Arguments.Aplaca#"
								errorDat_2="#Session.Enombre#"
				>>
			</cfif>
		
			<cfif rsv1.recordcount eq 0>
				<cf_errorCode	code = "50822"
								msg  = "El Activo @errorDat_1@ está inactivo, ¡Proceso Cancelado!."
								errorDat_1="#Arguments.Aplaca#"
				>>
			</cfif>
			
			<cfif rsv2.recordcount eq 0>
				<cf_errorCode	code = "50823"
								msg  = "El Activo @errorDat_1@ no tiene saldos para el periodo / mes en que se encuentran los auxiliares, ¡Proceso Cancelado!."
								errorDat_1="#Arguments.Aplaca#"
				>>
			</cfif>
			
			<cfif rsv3.recordcount eq 0>
				<cf_errorCode	code = "50824"
								msg  = "El Activo @errorDat_1@ no tiene responsable definido, ¡Proceso Cancelado!."
								errorDat_1="#Arguments.Aplaca#"
				>>
			</cfif>
			
			<cfif rsv4.recordcount eq 0>
				<cf_errorCode	code = "50825"
								msg  = "El Activo @errorDat_1@ está en otra hoja de conteo activa, ¡Proceso Cancelado!."
								errorDat_1="#Arguments.Aplaca#"
				>>
			</cfif>
			
			<cfif rsv5.recordcount eq 0>
				<cf_errorCode	code = "50826"
								msg  = "El Activo @errorDat_1@ ya está en la hoja de conteo, ¡Proceso Cancelado!."
								errorDat_1="#Arguments.Aplaca#"
				>>
			</cfif>
		
			<cftransaction>
				<cfquery name="select" datasource="#session.dsn#">
					select <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AFTFid_hoja#"> as AFTFid_hoja,
						a.Aid, a.AFMid, 	
						a.AFMMid, a.ACcodigo, 
						a.ACid, a.AFCcodigo, 
						(select min(DEid) from AFResponsables x where x.Ecodigo = a.Ecodigo and x.Aid = a.Aid 
								and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> between x.AFRfini and x.AFRffin) as DEid, 
						<cfif isdefined("Arguments.DEid_lectura") and len(trim(Arguments.DEid_lectura)) gt 0><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid_lectura#"><cfelse>null</cfif> as DEid_lectura, 
						b.CFid, 
						<cfif isdefined("Arguments.CFid_lectura") and len(trim(Arguments.CFid_lectura)) gt 0><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CFid_lectura#"><cfelse>null</cfif> as CFid_lectura, 
						a.Aplaca, a.Aserie, a.Adescripcion, a.Astatus, a.Avutil, a.Avalrescate, 
						0 as AFTForigen, 0 as AFTFcantidad, 
						<cfif isdefined("Arguments.AFTFobservaciondetalle") and len(trim(Arguments.AFTFobservaciondetalle)) gt 0><cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.AFTFobservaciondetalle#"><cfelse>null</cfif> as AFTFobservaciondetalle,  
						4 as AFTFbanderaproceso
					from Activos a
						inner join AFSaldos b
						on b.Ecodigo = a.Ecodigo
						and b.Aid = a.Aid
						and b.AFSperiodo = (select <cf_dbfunction name="to_number" args="Pvalor"> from Parametros where Ecodigo = a.Ecodigo and Pcodigo = 50)
						and b.AFSmes = 		(select <cf_dbfunction name="to_number" args="Pvalor"> from Parametros where Ecodigo = a.Ecodigo and Pcodigo = 60)
					where a.Ecodigo =  #Session.Ecodigo# 
						and a.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Aid#">
						and Astatus = 0
						and exists(
							select 1 from AFResponsables
							where Ecodigo = a.Ecodigo
							and Aid = a.Aid 
							and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> between AFRfini and AFRffin
						)
						and not exists(
							select 1 from AFTFDHojaConteo x
								inner join AFTFHojaConteo y 
								on y.AFTFid_hoja = x.AFTFid_hoja
								and y.AFTFestatus_hoja < 3
							where x.Aid = a.Aid
							and x.Ecodigo = a.Ecodigo
						)
				</cfquery>
				<cfquery name="rs" datasource="#session.dsn#">
					insert into AFTFDHojaConteo 
						(AFTFid_hoja, 
						Aid, Ecodigo, AFMid, AFMMid, ACcodigo, ACid, AFCcodigo, 
						DEid, DEid_lectura, 
						CFid, CFid_lectura, 
						Aplaca, Aserie, Adescripcion, Astatus, Avutil, Avalrescate, 
						AFTForigen, AFTFcantidad, AFTFobservaciondetalle, AFTFbanderaproceso, 
						AFTFfalta, BMUsucodigo)
						VALUES(
						   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#select.AFTFid_hoja#"            voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#select.Aid#"                    voidNull>,
						   #session.Ecodigo#,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#select.AFMid#"                  voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#select.AFMMid#"                 voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#select.ACcodigo#"               voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#select.ACid#"                   voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#select.AFCcodigo#"              voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#select.DEid#"                   voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#select.DEid_lectura#"           voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#select.CFid#"                   voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#select.CFid_lectura#"           voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="20"  value="#select.Aplaca#"                 voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="50"  value="#select.Aserie#"                 voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="100" value="#select.Adescripcion#"           voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#select.Astatus#"                voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#select.Avutil#"                 voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_money"             value="#select.Avalrescate#"            voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#select.AFTForigen#"             voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#select.AFTFcantidad#"           voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="1024" value="#select.AFTFobservaciondetalle#" voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#select.AFTFbanderaproceso#"     voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#Now()#">,
						   #session.Usucodigo#
					)
					
					<cf_dbidentity1>
				</cfquery>
				<cf_dbidentity2 name="rs">
			</cftransaction>
			
		<cfelse>
		
			<cftransaction>
				<cfquery name="rs" datasource="#session.dsn#">
					insert into AFTFDHojaConteo 
						(AFTFid_hoja, Aid, 
						Ecodigo, AFMid, AFMMid, ACcodigo, ACid, AFCcodigo, 
						DEid, DEid_lectura, CFid, CFid_lectura, 
						Aserie, Adescripcion, Astatus, Avutil, Avalrescate, 
						AFTForigen, AFTFcantidad, AFTFobservaciondetalle, AFTFbanderaproceso, 
						AFTFfalta, BMUsucodigo)
					values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AFTFid_hoja#">, null
						
						,  #Session.Ecodigo# 
						, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AFMid#">
						, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AFMMid#">
						, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ACcodigo#">
						, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ACid#">
						, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AFCcodigo#">
						
						, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
						, <cfif isdefined("Arguments.DEid_lectura") and len(trim(Arguments.DEid_lectura)) gt 0><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid_lectura#"><cfelse>null</cfif>
						, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CFid#">
						, <cfif isdefined("Arguments.CFid_lectura") and len(trim(Arguments.CFid_lectura)) gt 0><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CFid_lectura#"><cfelse>null</cfif>
						
						, <cfif isdefined("Arguments.Aserie") and len(trim(Arguments.Aserie)) gt 0><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Aserie#"><cfelse>null</cfif>
						, <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Adescripcion#">
						, 0
						, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Avutil#">
						, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Avalrescate#">
						
						, 0, 0, <cfif isdefined("Arguments.AFTFobservaciondetalle") and len(trim(Arguments.AFTFobservaciondetalle)) gt 0><cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.AFTFobservaciondetalle#"><cfelse>null</cfif>, 4
						, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
						, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
						)
				
					<cf_dbidentity1>
				</cfquery>
				<cf_dbidentity2 name="rs">
			</cftransaction>
			
		</cfif>
		<cfreturn rs.identity>
	</cffunction>
	
	<cffunction name="updateDHojaConteo" access="public" returntype="numeric">
		<cfargument name="AFTFid_hoja" type="string" required="yes">
		<cfargument name="AFTFid_detallehoja" type="string" required="yes">
		
		<cfargument name="Aid" type="string" required="no">
		<cfargument name="AFMid" type="string" required="yes">
		<cfargument name="AFMMid" type="string" required="yes">
		<cfargument name="ACcodigo" type="string" required="yes">
		<cfargument name="ACid" type="string" required="yes">
		
		<cfargument name="AFCcodigo" type="string" required="yes">
		<cfargument name="DEid" type="string" required="yes">
		<cfargument name="CFid" type="string" required="yes">
		<cfargument name="DEid_lectura" type="string" required="no">
		<cfargument name="CFid_lectura" type="string" required="no">
		<cfargument name="Aplaca" type="string" required="no">
		
		<cfargument name="Aserie" type="string" required="no">
		<cfargument name="Adescripcion" type="string" required="yes">
		<cfargument name="Avutil" type="string" required="yes">
		<cfargument name="Avalrescate" type="string" required="yes">
		
		<cfargument name="AFTFobservaciondetalle" type="string" required="no">
			
		<!--- valida el estado de la hoja de conteo --->
		<cfquery name="rs" datasource="#session.dsn#">
			select AFTFid_hoja, AFTFdescripcion_hoja
			from AFTFHojaConteo 
			where AFTFid_hoja = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AFTFid_hoja#">
			and AFTFestatus_hoja <> 2
		</cfquery>
		<cfif rs.recordcount gt 0>
			<cfset x = ""><cfset y = "">
			<cfif rs.recordcount gt 1>
				<cfset x = "s"><cfset y = "n">
			</cfif>
			<cf_errorCode	code = "50818"
							msg  = "La@errorDat_1@ hoja@errorDat_2@ de conteo: @errorDat_3@, se encuentra@errorDat_4@ en <BR> un estado no permitido para realizar esta acción, ¡Proceso Cancelado!."
							errorDat_1="#x#"
							errorDat_2="#x#"
							errorDat_3="#ValueList(rs.AFTFdescripcion_hoja)#"
							errorDat_4="#y#"
			>>
		</cfif>
		<cfquery name="rs" datasource="#session.dsn#">
				update AFTFDHojaConteo 
				set BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
				<cfif isdefined("Arguments.Aid") and len(trim(Arguments.Aid)) eq 0>
				
					, AFMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AFMid#">
					, AFMMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AFMMid#">
					, ACcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ACcodigo#">
					, ACid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ACid#">
					, AFCcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AFCcodigo#">
					
					, DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
					, CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CFid#">
					, Aserie = <cfif isdefined("Arguments.Aserie") and len(trim(Arguments.Aserie)) gt 0><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Aserie#"><cfelse>null</cfif>
					, Adescripcion = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Adescripcion#">
					, Avutil = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Avutil#">
					, Avalrescate = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Avalrescate#">
				
				</cfif>
				
					, DEid_lectura = <cfif isdefined("Arguments.DEid_lectura") and len(trim(Arguments.DEid_lectura)) gt 0><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid_lectura#"><cfelse>null</cfif>
					, CFid_lectura = <cfif isdefined("Arguments.CFid_lectura") and len(trim(Arguments.CFid_lectura)) gt 0><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CFid_lectura#"><cfelse>null</cfif>
					, AFTFobservaciondetalle = <cfif isdefined("Arguments.AFTFobservaciondetalle") and len(trim(Arguments.AFTFobservaciondetalle)) gt 0><cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.AFTFobservaciondetalle#"><cfelse>null</cfif>
				where AFTFid_hoja = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AFTFid_hoja#">
				and AFTFid_detallehoja = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AFTFid_detallehoja#">
			</cfquery>
		<cfreturn Arguments.AFTFid_detallehoja>
	</cffunction>
	
	<cffunction name="updatebDHojaConteo" access="public" returntype="numeric">
		<cfargument name="AFTFid_hoja" type="string" required="yes">
		<cfargument name="AFTFid_detallehoja" type="string" required="yes">
		<cfargument name="AFTFbanderaproceso" type="string" required="yes">
		<!--- valida el estado de la hoja de conteo --->
		<cfquery name="rs" datasource="#session.dsn#">
			select AFTFid_hoja, AFTFdescripcion_hoja
			from AFTFHojaConteo 
			where AFTFid_hoja = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AFTFid_hoja#">
			and AFTFestatus_hoja <> 2
		</cfquery>
		<cfif rs.recordcount gt 0>
			<cfset x = ""><cfset y = "">
			<cfif rs.recordcount gt 1>
				<cfset x = "s"><cfset y = "n">
			</cfif>
			<cf_errorCode	code = "50818"
							msg  = "La@errorDat_1@ hoja@errorDat_2@ de conteo: @errorDat_3@, se encuentra@errorDat_4@ en <BR> un estado no permitido para realizar esta acción, ¡Proceso Cancelado!."
							errorDat_1="#x#"
							errorDat_2="#x#"
							errorDat_3="#ValueList(rs.AFTFdescripcion_hoja)#"
							errorDat_4="#y#"
			>>
		</cfif>
		<cfquery name="rs" datasource="#session.dsn#">
			update AFTFDHojaConteo 
				set AFTFbanderaproceso = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.AFTFbanderaproceso#">
			where AFTFid_hoja = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AFTFid_hoja#">
				and <cf_whereinlist column="AFTFid_detallehoja" valuelist="#Arguments.AFTFid_detallehoja#">
				and AFTFbanderaproceso < 4
		</cfquery>
		<cfreturn Arguments.AFTFid_hoja>
	</cffunction>
	
	<cffunction name="deleteDHojaConteo" access="public" returntype="numeric">
		<cfargument name="AFTFid_hoja" type="string" required="yes">
		<cfargument name="AFTFid_detallehoja" type="string" required="no">
		<cfquery name="rs" datasource="#session.dsn#">
			select AFTFid_hoja, AFTFdescripcion_hoja
			from AFTFHojaConteo 
			where AFTFid_hoja = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AFTFid_hoja#">
			and AFTFestatus_hoja > 2
		</cfquery>
		<cfif rs.recordcount gt 0>
			<cfset x = ""><cfset y = "">
			<cfif rs.recordcount gt 1>
				<cfset x = "s"><cfset y = "n">
			</cfif>
			<cf_errorCode	code = "50818"
							msg  = "La@errorDat_1@ hoja@errorDat_2@ de conteo: @errorDat_3@, se encuentra@errorDat_4@ en <BR> un estado no permitido para realizar esta acción, ¡Proceso Cancelado!."
							errorDat_1="#x#"
							errorDat_2="#x#"
							errorDat_3="#ValueList(rs.AFTFdescripcion_hoja)#"
							errorDat_4="#y#"
			>>
		</cfif>
		<cfquery name="rs" datasource="#session.dsn#">
			delete from AFTFDHojaConteo 
			where AFTFid_hoja = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AFTFid_hoja#">
			<cfif isdefined("Arguments.AFTFid_detallehoja") and len(trim(Arguments.AFTFid_detallehoja)) gt 0>
				and <cf_whereinlist column="AFTFid_detallehoja" valuelist="#Arguments.AFTFid_detallehoja#">
			</cfif>
		</cfquery>
		<cfreturn Arguments.AFTFid_hoja>
	</cffunction>
	
	<cffunction name="getResponsableCF" access="private" returntype="numeric">
		<cfargument name="CFid" type="numeric" required="true">
		<cfargument name="Usucodigo" type="numeric" required="false" default="#Session.Usucodigo#">
		<cfargument name="Conexion" type="string" required="false" default="#Session.Dsn#">
		<cfargument name="Debug" type="boolean" required="false" default="False">
		<cfset Lvar_DEid = 0>
		<!--- Obtiene el Reponsable de un Centro Funcional por el CFuresponsable: Usuario Responsable del Centro Funcional --->
		<cfquery name="rsResponsableCF" datasource="#Arguments.Conexion#">
			select RHPid, CFuresponsable from CFuncional where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CFid#">
		</cfquery>
		<cfif rsResponsableCF.recordcount eq 0>
			<cf_errorCode	code = "50827" msg = "Error (getResponsableCF). Centro Funcional Inválido. Proceso Cancelado">
		</cfif>
		<cfif len(trim(rsResponsableCF.CFuresponsable)) GT 0 and rsResponsableCF.CFuresponsable GT 0>
			<cfquery name="rsDatosEmpleado" datasource="#Arguments.Conexion#">
				select DEid 
				from DatosEmpleado 
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and DEusuarioportal = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsResponsableCF.CFuresponsable#">
			</cfquery>
			<cfif rsDatosEmpleado.recordcount>
				<cfset Lvar_DEid = rsDatosEmpleado.DEid>
			<cfelse>
				<cfquery name="rsDatosEmpleado" datasource="#Arguments.Conexion#">
					select llave
					from UsuarioReferencia
					where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsResponsableCF.CFuresponsable#">
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.EcodigoSDC#">
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
				where RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsResponsableCF.RHPid#">
				and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> 
				between LTdesde and LThasta
			</cfquery>
			<cfif rsLineaTiempo.recordcount and len(trim(rsLineaTiempo.DEid))>
				<cfset Lvar_DEid = rsLineaTiempo.DEid>
			</cfif>
		</cfif>
		<cfif Lvar_DEid eq 0>
			<cfquery name="rsEmpleadoCFuncional" datasource="#Arguments.Conexion#">	
				select DEid 
				from EmpleadoCFuncional 
				where Ecodigo =  #Session.Ecodigo#  
				and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CFid#"> 
				and <cf_dbfunction name="now"> between ECFdesde and ECFhasta	
			</cfquery>
			<cfif rsEmpleadoCFuncional .recordcount and len(trim(rsEmpleadoCFuncional .DEid))>
				<cfset Lvar_DEid = rsEmpleadoCFuncional .DEid>
			</cfif>
		</cfif>
		<cfreturn Lvar_DEid>
	</cffunction>
	
</cfcomponent>


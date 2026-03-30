<!--- Proceso de Inserción y Modificación --->
<cfset params="">
<cfif not isdefined("Form.Nuevo")>

	<cfif isdefined("Form.Alta") or isdefined("Form.Baja")>
		<!--- VERIFICAR QUE EL EMPLEADO ESTE ACTIVO --->
		<cfquery name="rsEmpleadoActivo" datasource="#session.DSN#">
			select 1
			from LineaTiempo
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			  and <cf_dbfunction name="to_date" args="'#LSDateFormat(now(), "dd/mm/yyyy")#'"> between LTdesde and LThasta
		</cfquery>

		<cfquery name="rsExisteEmpelado" datasource="#Session.DSN#">
			select ACAid,DEid
			from ACAsociados
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
		</cfquery>

		<cfif isdefined("rsExisteEmpelado") and rsExisteEmpelado.recordcount GT 0 >
			
			<!--- Observaciones --->
			<cfset vObservaciones = Replace(Form.ACAobservaciones,'<p>&nbsp;</p>','','all')>
			<cfset vObservaciones = Replace(vObservaciones,'<p><font face="Times New Roman" size="3">&nbsp;</font></p>','<font face="Times New Roman" size="3">&nbsp;</font>','all')>
		
			<cftransaction>
				<cfquery name="rsUpdateACAsociados" datasource="#Session.DSN#">
					update ACAsociados
					set ACAestado = <cfif isdefined("Form.Baja")>0<cfelse>1</cfif>,
						ACAobservaciones = <cfqueryparam cfsqltype="cf_sql_varchar" value="#vObservaciones#">
					where ACAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ACAid#">
				</cfquery>

			
				<!--- Revisar si asociado esta vigente --->
				<cfquery name="rs_vigente" datasource="#session.DSN#">
					select ACLTAid as id
					from ACLineaTiempoAsociado
					where ACAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsExisteEmpelado.ACAid#">
					  and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.ACAfechaIngreso)#"> between ACLTAfdesde and ACLTAfhasta
				</cfquery>
				<!--- activo o desactivo el empleado --->
				<cfif len(trim(rs_vigente.id))>
					<cfif isdefined("Form.Baja")> <!--- usuario activado --->
						<!--- VERIFICAR CUALES DEDUCCIONES Y CARGAS ESTAN RELACIONADAS CON EL SOCIA PARA INACTIVARLAS --->
						<cfquery name="rsDeducciones" datasource="#session.DSN#">
							select Did
							from ACAportesAsociado
							where ACAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsExisteEmpelado.ACAid#">
							  and Did is not null
							  and DClinea is null
						</cfquery>
						<cfquery name="rsCargas" datasource="#session.DSN#">
							select DClinea
							from ACAportesAsociado
							where ACAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsExisteEmpelado.ACAid#">
							  and Did is null
							  and DClinea is not null
						</cfquery>
						<cfloop query="rsDeducciones">
							<cfquery name="updateDeduccion" datasource="#session.DSN#">
								update DeduccionesEmpleado
								set Dfechafin = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.ACAfechaIngreso)#">,
									Dactivo = 0
								where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsExisteEmpelado.DEid#">
								  and Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDeducciones.Did#">
							</cfquery>
						</cfloop>
						<cfloop query="rsCargas">
							<cfquery name="updateCargas" datasource="#session.DSN#">
								update CargasEmpleado
								set CEhasta = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.ACAfechaIngreso)#">
								where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsExisteEmpelado.DEid#">
								  and DClinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCargas.DClinea#">
							</cfquery>
						</cfloop>
						<!--- corta la linea de tiempo del asociado a la fecha digitada--->
						<cfquery datasource="#session.DSN#">
							update ACLineaTiempoAsociado
							set ACLTAfhasta = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.ACAfechaIngreso)#">
							where ACLTAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_vigente.id#" >
						</cfquery>
						<!--- modifica las fechas de ingreso/egreso del asociado para mantener actualizado con el corte vigente --->
						<cfquery datasource="#session.DSN#">
							update ACAsociados
							set ACAfechaEgreso = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.ACAfechaIngreso)#">
							where ACAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ACAid#">
						</cfquery>
					<cfelse>
						<cfif isdefined('rsEmpleadoActivo') and rsEmpleadoActivo.RecordCount>
							<!--- REGRESO A LA ASOCIACION --->
							<!--- borra cortes cuya fecha desde es menos a la fecha digitada. Esto hay que analizarlo, podria borrar la historia(ingresos,egresos) del asociado  --->
							<cfquery datasource="#session.DSN#">
								delete ACLineaTiempoAsociado
								where ACAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsExisteEmpelado.ACAid#">
								  and ACLTAfdesde > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.ACAfechaIngreso)#">
							</cfquery>
	
							<!--- pone la fecha hasta del corte hasta infinito --->
							<cfquery datasource="#session.DSN#">
								update ACLineaTiempoAsociado
								set ACLTAfhasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime('01/01/6100')#">
								where ACLTAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_vigente.id#" >
							</cfquery>
							<!--- modifica las fechas de ingreso/egreso del asociado para mantener actualizado con el corte vigente --->
							<cfquery datasource="#session.DSN#">
								update ACAsociados
								set ACAfechaEgreso = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime('01/01/6100')#">
								where ACAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ACAid#">
							</cfquery>
							<!--- VERIFICAR CUALES DEDUCCIONES Y CARGAS ESTAN RELACIONADAS CON EL SOCIA PARA INACTIVARLAS --->
							<cfquery name="rsDeducciones" datasource="#session.DSN#">
								select Did
								from ACAportesAsociado
								where ACAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsExisteEmpelado.ACAid#">
								  and Did is not null
								  and DClinea is null
							</cfquery>
							<cfquery name="rsCargas" datasource="#session.DSN#">
								select DClinea
								from ACAportesAsociado
								where ACAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsExisteEmpelado.ACAid#">
								  and Did is null
								  and DClinea is not null
							</cfquery>
							<cfquery name="rsAportes" datasource="#session.DSN#">
								update ACAportesAsociado
								set ACAAfechaInicio = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.ACAfechaIngreso)#">,
									BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
									BMfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
								where ACAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsExisteEmpelado.ACAid#">
							</cfquery>
							<cfloop query="rsDeducciones">
								<cfquery name="updateDeduccion" datasource="#session.DSN#">
									update DeduccionesEmpleado
									set Dfechafin = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime('01/01/6100')#">,
										Dactivo = 1
									where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsExisteEmpelado.DEid#">
									  and Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDeducciones.Did#">
								</cfquery>
							</cfloop>
							<cfloop query="rsCargas">
								<cfquery name="updateCargas" datasource="#session.DSN#">
									update CargasEmpleado
									set CEhasta = null
									where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsExisteEmpelado.DEid#">
									  and DClinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCargas.DClinea#">
								</cfquery>
							</cfloop>
						</cfif>
					</cfif>
				<cfelse> <!--- no hay linea del tiempo vigente --->
					<!--- REACTIVA ASOCIADO --->
						<!--- activa 2 <cf_dump var="#form#"> --->
					<cfif isdefined('rsEmpleadoActivo') and rsEmpleadoActivo.RecordCount>
						<cfif isdefined("Form.Alta")> <!--- usuario activado --->
							<!--- borra cortes cuya fecha desde es menos a la fecha digitada. Esto hay que analizarlo, podria borrar la historia(ingresos,egresos) del asociado  --->
							<cfquery datasource="#session.DSN#">
								delete ACLineaTiempoAsociado
								where ACLTAfdesde > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.ACAfechaIngreso)#">
								  and ACAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsExisteEmpelado.ACAid#" >
							</cfquery>
	
							<!--- inserta la linea de tiempo del asociado a la fecha digitada--->
							<cfquery datasource="#session.DSN#">
								insert into ACLineaTiempoAsociado( ACAid, ACLTAfdesde, ACLTAfhasta, BMUsucodigo, BMfecha )
								values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ACAid#">,
										<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.ACAfechaIngreso)#">,
										<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime('01/01/6100')#">,
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
										<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> )
							</cfquery>
							<!--- modifica las fechas de ingreso/egreso del asociado para mantener actualizado con el corte vigente --->
							<cfquery datasource="#session.DSN#">
								update ACAsociados
								set ACAfechaIngreso = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.ACAfechaIngreso)#">,
									ACAfechaEgreso = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime('01/01/6100')#">
								where ACAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ACAid#">
							</cfquery>
						</cfif>
					</cfif>
				</cfif>
			</cftransaction>
			<cfset params = params&"&DEid="&Form.DEid>				

		<cfelse>
			<cfif isdefined('rsEmpleadoActivo') and rsEmpleadoActivo.RecordCount>
			<!--- NUEVO ASOCIADO --->
			<!--- Observaciones --->
			<cfset vObservaciones = Replace(form.ACAobservaciones,'<p>&nbsp;</p>','','all')>
			<cfset vObservaciones = Replace(vObservaciones,'<p><font face="Times New Roman" size="3">&nbsp;</font></p>','<font face="Times New Roman" size="3">&nbsp;</font>','all')>
				
			<cftransaction>
				<!--- Inserta en la tabla ACAsociados (Datos Asocaido al Empleado) --->
				<cfquery name="rsACAsociados" datasource="#Session.DSN#">
					insert into ACAsociados (
						DEid, 				ACAestado, 		ACAfechaIngreso, 
						BMUsucodigo, 		BMfecha,		ACAobservaciones
					)
					values (
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">,
						1,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.ACAfechaIngreso)#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#vObservaciones#">
					)
					<cf_dbidentity1 datasource="#Session.DSN#">
				</cfquery>
				<cf_dbidentity2 datasource="#Session.DSN#" name="rsACAsociados">
				
				<!--- Inserta en la tabla ACLineaTiempoAsociado (Línea del Tiempo) --->
				<cfquery name="rsACLineaTiempoAsociado" datasource="#Session.DSN#">
					insert into ACLineaTiempoAsociado (
						ACAid, ACLTAfdesde, ACLTAfhasta, BMUsucodigo, BMfecha
					)
					values (
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsACAsociados.identity#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.ACAfechaIngreso)#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime('01/01/6100')#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					)
				</cfquery>
			</cftransaction>
			<cfset params = params&"&DEid="&Form.DEid>	
			</cfif>
		</cfif><!--- fin del rsExisteEmpelado --->
					
	</cfif>
				
</cfif>

<cflocation url="expediente-cons.cfm?o=10&sel=1&#params#">

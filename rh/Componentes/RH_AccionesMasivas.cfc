<!---


	Criterios para Reconocimiento de Empleados
	- Empleados que no tengan el salario negociado en caso de que la acción masiva modifique componentes (Eso se averigua de la linea del tiempo de la plaza)


drop table RHcalMasivo_PagosEmpleado
go

create table RHcalMasivo_PagosEmpleado (
	Registro numeric identity not null,
	RCNid numeric null,
	DEid numeric not null,
	FechaDesde datetime null,
	FechaHasta mdatetime null,
	Cantidad int null,
	RHAlinea numeric not null,
	primary key (Registro)
)
go

create index RHcalMasivo_PagosEmpleado01 on RHcalMasivo_PagosEmpleado (RHAlinea, DEid)
go

--->
<cfcomponent>

	<cffunction name="generarEmpleados" access="public" output="true" returntype="numeric"  hint="Generación de Empleados de Acción Masiva">
		<cfargument name="RHAid" 	type="numeric" required="yes" hint="Código de Acción Masiva">
		<cfargument name="Ecodigo" 	type="numeric" required="no" default="#Session.Ecodigo#" hint="Empresa">
		<cfargument name="conexion" type="string" required="no" default="#Session.DSN#" hint="cache">
        <cfargument name="validaTcodigo"  type="boolean" required="no" hint=" Codigo de la Nomina" default="false">
		
		<!----=================== TRADUCCION =======================---->
		<cfinvoke key="MSG_No_se_han_definido_los_parametros_para_trabajar_con_periodos_Proceda_a_definirlos_en_el_paso_3_antes_de_continuar" default="No se han definido los parámetros para trabajar con períodos. Proceda a definirlos en el paso 3 antes de continuar."	 returnvariable="MSG_ParametrosPeriodos" component="sif.Componentes.Translate" method="Translate"/>
		<cfinvoke key="MSG_NoReconocidoPorqueLaFechaDeVencimientoDeLaAccionMasivaExcedeElVencimientoDelPeriodoDeNombramientoDelEmpleado" default="NO RECONOCIDO porque la fecha de vencimiento de la acción masiva excede el vencimiento del período de nombramiento del empleado"	 returnvariable="MSG_NoReconocido" component="sif.Componentes.Translate" method="Translate"/>
		<cfinvoke key="MSG_NO_RECONOCIDo_porque_en_la_accion_masiva_se_esta_modificando_un_componente_salarial_que_usa_tabla_o_es_de_tipo_porcentaje" default="NO RECONOCIDO porque en la acción masiva se está modificando un componente salarial que usa tabla o es de tipo porcentaje"	 returnvariable="MSG_NoReconocidoComponenteSal" component="sif.Componentes.Translate" method="Translate"/>
		<cfinvoke key="MSG_NO_RECONOCIDO_porque_el_tipo_de_accion_masiva_afecta_incorrectamente_la_linea_del_tiempo_del_empleado" default="NO RECONOCIDO porque el tipo de acción masiva afecta incorrectamente la línea del tiempo del empleado"	 returnvariable="MSG_NoReconocidoLineaTiempo" component="sif.Componentes.Translate" method="Translate"/>
		<cfinvoke key="MSG_NO_RECONOCIDO_porque_la_evaluacion_del_empleado_no_cumple_con_la_nota_minima_exigida" default="NO RECONOCIDO porque la evaluación del empleado no cumple con la nota mínima exigida"	returnvariable="MSG_NoReconocidoNotaMinima" component="sif.Componentes.Translate" method="Translate"/>
		<!--- Eliminar Empleados que ya existiesen en la acción masiva --->
		<cfquery name="rsDelEmp" datasource="#Arguments.conexion#">
			delete from RHEmpleadosAccionMasiva
			where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAid#">
		</cfquery>

		<!--- Datos de la Accion Masiva --->
		<cfquery name="rsAccionMasiva" datasource="#Arguments.conexion#">
			select a.RHAid, a.RHTAid, rtrim(a.RHAcodigo) as RHAcodigo, rtrim(a.RHAdescripcion) as RHAdescripcion, a.RHCPlinea, a.RHAfdesde, a.RHAfhasta, a.Ecodigo,
				   rtrim(a.Tcodigo) as Tcodigo, a.RVid, a.Ocodigo, a.Dcodigo, rtrim(a.RHPcodigo) as RHPcodigo, a.RHAporcsal, a.RHAporc, a.RHJid, 
				   a.RHAidliquida, a.RHAAnoreconocidos, a.RHAAperiodom, a.RHAAnumerop, a.BMUsucodigo, a.ts_rversion,
				   b.RHTid, b.RHTAcodigo, b.PCid, b.RHTAdescripcion, b.RHTAcomportamiento, b.RHTAaplicaauto, b.RHTAcempresa, 
				   b.RHTActiponomina, b.RHTAcregimenv, b.RHTAcoficina, b.RHTAcdepto, b.RHTAcplaza, b.RHTAcpuesto, 
				   b.RHTAccomp, b.RHTAcsalariofijo, b.RHTAccatpaso, b.RHTAcjornada, b.RHTAidliquida, b.RHTAevaluacion, 
				   b.RHTAnotaminima, b.RHTAperiodos, b.RHTAfutilizap, b.RHTArespetarLT
			from RHAccionesMasiva a
				inner join RHTAccionMasiva b
					on b.RHTAid = a.RHTAid
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			and a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAid#">
		</cfquery>

		<!--- Verificar que hayan insertado datos para trabajar con Periodos --->
		<cfif rsAccionMasiva.RHTAperiodos EQ 1>
			<cfquery name="rsPeriodosAMasiva" datasource="#Arguments.conexion#">
				select RHPAMid, RHAid, RHPAcodigo, RHPAdescripcion, RHPAManio, RHPAMfdesde, RHPAMfhasta, Ecodigo, BMUsucodigo
				from RHPeriodosAccionesM
				where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAid#">
			</cfquery>
			<cfif rsPeriodosAMasiva.recordCount EQ 0>
				<cf_throw message="#MSG_ParametrosPeriodos#" errorCode="12075">
			</cfif>
		</cfif>
		
		<cfquery name="Anua" datasource="#session.dsn#">
			select RHTAanualidad 
			from RHAccionesMasiva a
				inner join RHTAccionMasiva b
				on b.RHTAid=a.RHTAid
			where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAid#">
		</cfquery>
		
		<!---                                                                                                                             
		ESTA ES LA INSERCION DE LOS EMPLEADOS CON BASE A LOS FILTROS DEFINIDOS, EN ESTE CASO COMO SE CAMBIO LA FUNCIONALIDAD DE LAS       
		ACCIONES MASIVAS ESTOS FILTROS NO SE VAN A TOMAR EN CUENTA CUANDO LA DEFINICIÓN DE LA ACCION SE MARCO QUE ES DE ANTIGUEDAD        
		                                                                                                                              --->
		
		<cfif len(trim(Anua.RHTAanualidad)) eq 0 or Anua.RHTAanualidad eq 0>		
		<!--- Cargar Empleados de Acciones Masivas Anteriores en el caso de Acciones de Anualidad --->
		<cfif rsAccionMasiva.RHTAperiodos EQ 1>
			<!---===== Trae los empleados de acciones anteriores (Diferentes a la actual) =======--->
			<cfquery name="rsDepen1" datasource="#Arguments.conexion#">
				insert into RHEmpleadosAccionMasiva 
								(DEid,
								RHAid, 
								Ecodigo, 
								RHCPlinea, 
								RHAfdesde, 
								RHAfhasta, 
								Dcodigo, 
								Ocodigo, 
								RHPcodigo, 
								RHAporcsal, 
								RHAporc, 
								Tcodigo, 
								RVid, 
								RHEAMreconocido, 
								RHEAMjustificacion, 
								RHEAMusuarior, 
								RHEAMfecha,
								RHEAMrevaluado, 
								RHEAMevaluacion, 
								RHEAMfuevaluacion, 
								BMUsucodigo)
				select c.DEid, a.RHAid, a.Ecodigo, a.RHCPlinea, a.RHAfdesde, a.RHAfhasta, a.Dcodigo, a.Ocodigo, a.RHPcodigo, a.RHAporcsal, a.RHAporc, a.Tcodigo, a.RVid, 
					   1 as RHEAMreconocido, 
					   null as RHEAMjustificacion, 
					   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#"> as RHEAMusuarior, 
					   <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#"> as RHEAMfecha, 
					   0 as RHEAMrevaluado, null as RHEAMevaluacion, null as RHEAMfuevaluacion, 
					   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#"> as BMUsucodigo
				from RHAccionesMasiva a
					inner join RHAccionesMasiva b
						on b.RHTAid = a.RHTAid
						and b.RHAid <> a.RHAid
					inner join RHPeriodosAccionesM p
						on p.RHAid = b.RHAid
						and p.RHPAManio between (a.RHAAperiodom - a.RHAAnumerop) and a.RHAAperiodom
					inner join RHEmpleadosAccionMasiva c
						on c.RHAid = b.RHAid
						and c.RHEAMreconocido = 0
				where a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAid#">
				and not exists (
					select 1
					from RHEmpleadosAccionMasiva eam
					where eam.RHAid = a.RHAid
					and eam.DEid = c.DEid
				)
			</cfquery>
		</cfif>

		<!--- Insertar Empleados seleccionados directamente si la acción NO TRABAJA CON PERIODOS --->
		<cfif rsAccionMasiva.RHTAperiodos EQ 0>
			<cfquery name="rsDepen1" datasource="#Arguments.conexion#">
				insert into RHEmpleadosAccionMasiva (DEid, 
													RHAid, 
													Ecodigo, 
													RHCPlinea, 
													RHAfdesde, 
													RHAfhasta, 
													Dcodigo, 
													Ocodigo, 
													RHPcodigo, 
													RHAporcsal, 
													RHAporc, 
													Tcodigo, 
													RVid, 
													RHEAMreconocido, 
													RHEAMjustificacion, 
													RHEAMusuarior, 
													RHEAMfecha, 
													RHEAMrevaluado, 
													RHEAMevaluacion, 
													RHEAMfuevaluacion, 
													BMUsucodigo)
				select 	b.DEid, 
						a.RHAid, 
						a.Ecodigo, 
						a.RHCPlinea, 
						<!---- ==== Para la fecha desde toma la mayor entre la fecha desde de la accion masiva y la fecha desde de la linea del tiempo ==== ----->
						case when c.LTdesde <  a.RHAfdesde then  a.RHAfdesde else c.LTdesde end as RHAfdesde,
						<!---- ==== Para la fecha hasta toma la menor entre la fecha hasta de la accion masiva y la fecha hasta de la linea del tiempo ==== ----->
						case when c.LThasta >  a.RHAfhasta then  a.RHAfhasta else c.LThasta end as RHAfhasta,
						b.Dcodigo, 
						b.Ocodigo, 
						a.RHPcodigo,
						a.RHAporcsal, 
						a.RHAporc, 
						a.Tcodigo, 
						a.RVid, 
					   	1 as RHEAMreconocido, 
					   	null as RHEAMjustificacion, 
					   	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#"> as RHEAMusuarior, 
					   	<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#"> as RHEAMfecha, 
					   	0 as RHEAMrevaluado, 
						null as RHEAMevaluacion, 
						null as RHEAMfuevaluacion, 
					   	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#"> as BMUsucodigo
				from RHAccionesMasiva a
					inner join RHDepenAccionM b
						on b.RHAid = a.RHAid
						and b.DEid is not null
						and not exists (
							select 1
							from RHEmpleadosAccionMasiva x
							where x.RHAid = a.RHAid
							and x.DEid = b.DEid
						)
					<!----- ==== Se pega con la línea del tiempo para utilizar la fecha del corte ==== ----->
					inner join LineaTiempo c
						on b.Ecodigo = c.Ecodigo
						and b.DEid = c.DEid
						and a.RHAfdesde between c.LTdesde and c.LThasta	
                        <cfif Arguments.validaTcodigo>
                          and c.Tcodigo = b.Tcodigo
                        </cfif>
												
				where a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAid#">
				
				and not exists (
					select 1
					from RHEmpleadosAccionMasiva eam
					where eam.RHAid = a.RHAid
					and eam.DEid = b.DEid
				)
				<!--- Chequear que el empleado no se haya cambiado de empresa en ese rango de fechas --->
				and (select count(distinct Ecodigo) 
						from LineaTiempo lt 
								where lt.DEid = b.DEid 
								and (lt.LTdesde between a.RHAfdesde 
												and coalesce(a.RHAfhasta, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(6100, 01, 01)#">) 
												or lt.LThasta between a.RHAfdesde 
												and coalesce(a.RHAfhasta, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(6100, 01, 01)#">))) <= 1
				
			</cfquery>
		</cfif>	
        <cf_dbfunction name="now" returnvariable="lvarHoy">
        <cfif Arguments.validaTcodigo>
        	<!--- Insertar Empleados que pertenecen a una nomina --->
            <cfquery name="rsDepen2" datasource="#Arguments.conexion#">
                insert into RHEmpleadosAccionMasiva (DEid, 
                                                    RHAid, 
                                                    Ecodigo, 
                                                    RHCPlinea, 
                                                    RHAfdesde, 
                                                    RHAfhasta, 
                                                    Dcodigo, 
                                                    Ocodigo, 
                                                    RHPcodigo, 
                                                    RHAporcsal, 
                                                    RHAporc, 
                                                    Tcodigo, 
                                                    RVid, 
                                                    RHEAMreconocido, 
                                                    RHEAMjustificacion, 
                                                    RHEAMusuarior, 
                                                    RHEAMfecha, 
                                                    RHEAMrevaluado, 
                                                    RHEAMevaluacion, 
                                                    RHEAMfuevaluacion,
                                                    BMUsucodigo)
                select 	c.DEid, 
                        a.RHAid, 
                        a.Ecodigo, 
                        a.RHCPlinea, 
                        <!---- ==== Para la fecha desde toma la mayor entre la fecha desde de la accion masiva y la fecha desde de la linea del tiempo ==== ---->
                        case when c.LTdesde <  a.RHAfdesde then  a.RHAfdesde else c.LTdesde end as RHAfdesde,
                        <!---- ==== Para la fecha hasta toma la menor entre la fecha hasta de la accion masiva y la fecha hasta de la linea del tiempo ==== ---->
                        case when c.LThasta >  a.RHAfhasta then  a.RHAfhasta else c.LThasta end as RHAfhasta,					
                        b.Dcodigo, 
                        b.Ocodigo, 
                        a.RHPcodigo,
                        a.RHAporcsal, 
                        a.RHAporc, 
                        a.Tcodigo, 
                        a.RVid, 
                        1 as RHEAMreconocido, 
                        null as RHEAMjustificacion, 
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#"> as RHEAMusuarior, 
                        <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#"> as RHEAMfecha, 
                        0 as RHEAMrevaluado, 
                        null as RHEAMevaluacion, 
                        null as RHEAMfuevaluacion, 
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#"> as BMUsucodigo
                from RHAccionesMasiva a 
                    inner join RHDepenAccionM b
                        on b.RHAid = a.RHAid and b.Tcodigo is not null and b.DEid is null and b.RHPcodigo is null and b.Dcodigo is null and b.Ocodigo is null 
                          and b.CFid is null and b.RHTPid is null and b.Fcorte is null
                    inner join LineaTiempo c
                        on c.Ecodigo = a.Ecodigo
                        and a.RHAfdesde between c.LTdesde and c.LThasta
                        and not exists (select 1
                                        from RHEmpleadosAccionMasiva x
                                        where x.RHAid = a.RHAid
                                            and x.DEid = c.DEid
                                        )
                        <!--- Si se trabajan con periodos hay que extraer únicamente los empleados que cumplan con una fecha de periodo --->
                        <cfif rsAccionMasiva.RHTAperiodos EQ 1>
                            <!--- Segun el tipo de periodo de referencia se hace los chequeos --->
                            <!--- Fecha de Anualidad --->
                            <cfif rsAccionMasiva.RHTAfutilizap EQ 1>
                                and exists (
                                    select 1
                                    from RHPeriodosAccionesM pam, DatosEmpleado de
                                    where pam.RHAid = a.RHAid
                                    and de.DEid = c.DEid
                                    
                                    and convert(int, substring(convert(varchar, de.DEfanuales, 112), 5, 4)) < pam.RHPAManio
                                    and de.DEfanuales between pam.RHPAMfdesde and pam.RHPAMfhasta
                                )
                            <!--- Fecha de Vacaciones --->
                            <cfelseif rsAccionMasiva.RHTAfutilizap EQ 2>
                                and exists (
                                    select 1
                                    from RHPeriodosAccionesM pam, DatosEmpleado de
                                    where pam.RHAid = a.RHAid
                                    and de.DEid = c.DEid
                                    and convert(int, substring(convert(varchar, de.DEfvacaciones, 112), 5, 4)) < pam.RHPAManio
                                    and de.DEfvacaciones between pam.RHPAMfdesde and pam.RHPAMfhasta
                                )
                            <!--- Fecha de Ingreso --->
                            <cfelse>
                                and exists (
                                    select 1
                                    from RHPeriodosAccionesM pam, EVacacionesEmpleado de
                                    where pam.RHAid = a.RHAid
                                    and de.DEid = c.DEid
                                    and convert(int, substring(convert(varchar, de.EVfantig, 112), 5, 4)) < pam.RHPAManio
                                    and de.EVfantig between pam.RHPAMfdesde and pam.RHPAMfhasta
                                )
                            </cfif>						
                        </cfif>
                        <!----========= VALIDAR QUE LA PLAZA DE LOS EMPLEADOS EN EL RANGO DE FECHAS DE LA ACCION NO SEAN NEGOCIADAS ===========----->
                        and not exists (select 1 
                                        from  RHLineaTiempoPlaza d
                                        where c.RHPid = d.RHPid
                                            and d.RHMPnegociado = 'N'
                                            and a.RHAfdesde <= d.RHLTPfhasta
                                            and a.RHAfhasta >= d.RHLTPfdesde
                                        )
                        <!----=======================================================================================================---->																				
                where a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAid#">
                and not exists (select 1
                                from RHEmpleadosAccionMasiva eam
                                where eam.RHAid = a.RHAid
                                and eam.DEid = c.DEid)	
                and (select count(1) from RHDepenAccionM dam where dam.RHAid = a.RHAid) = 1		
                <!--- Chequear que el empleado no se haya cambiado de empresa en ese rango de fechas --->
                and (select count(distinct Ecodigo) from LineaTiempo lt where lt.DEid = c.DEid and (lt.LTdesde between a.RHAfdesde and coalesce(a.RHAfhasta, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(6100, 01, 01)#">) or lt.LThasta between a.RHAfdesde and coalesce(a.RHAfhasta, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(6100, 01, 01)#">))) <= 1
            	<!----========= Validar que el empleado perteneza a la misma nomina del filtro a la fecha de hoy ===========----->
              	and exists (select 1 
                		 	from LineaTiempo lts 
                             where lts.DEid = c.DEid 
                             and (lts.LTdesde between #lvarHoy# and '61000101'
                             or lts.LThasta between #lvarHoy# and '61000101')
                             and lts.Tcodigo = b.Tcodigo
                           )
            </cfquery>
        </cfif>

		<!--- Insertar Empleados que tienen un puesto --->
		<cfquery name="rsDepen2" datasource="#Arguments.conexion#">
			insert into RHEmpleadosAccionMasiva (DEid, 
												RHAid, 
												Ecodigo, 
												RHCPlinea, 
												RHAfdesde, 
												RHAfhasta, 
												Dcodigo, 
												Ocodigo, 
												RHPcodigo, 
												RHAporcsal, 
												RHAporc, 
												Tcodigo, 
												RVid, 
												RHEAMreconocido, 
												RHEAMjustificacion, 
												RHEAMusuarior, 
												RHEAMfecha, 
												RHEAMrevaluado, 
												RHEAMevaluacion, 
												RHEAMfuevaluacion,
												BMUsucodigo)
			select 	c.DEid, 
					a.RHAid, 
					a.Ecodigo, 
					a.RHCPlinea, 
					<!---- ==== Para la fecha desde toma la mayor entre la fecha desde de la accion masiva y la fecha desde de la linea del tiempo ==== ---->
					case when c.LTdesde <  a.RHAfdesde then  a.RHAfdesde else c.LTdesde end as RHAfdesde,
					<!---- ==== Para la fecha hasta toma la menor entre la fecha hasta de la accion masiva y la fecha hasta de la linea del tiempo ==== ---->
					case when c.LThasta >  a.RHAfhasta then  a.RHAfhasta else c.LThasta end as RHAfhasta,					
					b.Dcodigo, 
					b.Ocodigo, 
					a.RHPcodigo,
					a.RHAporcsal, 
					a.RHAporc, 
					a.Tcodigo, 
					a.RVid, 
				   	1 as RHEAMreconocido, 
				   	null as RHEAMjustificacion, 
				   	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#"> as RHEAMusuarior, 
				   	<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#"> as RHEAMfecha, 
				   	0 as RHEAMrevaluado, 
					null as RHEAMevaluacion, 
					null as RHEAMfuevaluacion, 
				   	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#"> as BMUsucodigo
			from RHAccionesMasiva a 
				inner join RHDepenAccionM b
					on b.RHAid = a.RHAid
					and b.RHPcodigo is not null
				inner join LineaTiempo c
					on c.Ecodigo = a.Ecodigo
					<!--- and c.RHPcodigo = b.RHPcodigo --->
					and a.RHAfdesde between c.LTdesde and c.LThasta
					and not exists (select 1
									from RHEmpleadosAccionMasiva x
									where x.RHAid = a.RHAid
										and x.DEid = c.DEid
									)
					<!--- Si se trabajan con periodos hay que extraer únicamente los empleados que cumplan con una fecha de periodo --->
					<cfif rsAccionMasiva.RHTAperiodos EQ 1>
						<!--- Segun el tipo de periodo de referencia se hace los chequeos --->
						<!--- Fecha de Anualidad --->
						<cfif rsAccionMasiva.RHTAfutilizap EQ 1>
							and exists (
								select 1
								from RHPeriodosAccionesM pam, DatosEmpleado de
								where pam.RHAid = a.RHAid
								and de.DEid = c.DEid
								
								and convert(int, substring(convert(varchar, de.DEfanuales, 112), 5, 4)) < pam.RHPAManio
								and de.DEfanuales between pam.RHPAMfdesde and pam.RHPAMfhasta
							)
						<!--- Fecha de Vacaciones --->
						<cfelseif rsAccionMasiva.RHTAfutilizap EQ 2>
							and exists (
								select 1
								from RHPeriodosAccionesM pam, DatosEmpleado de
								where pam.RHAid = a.RHAid
								and de.DEid = c.DEid
								and convert(int, substring(convert(varchar, de.DEfvacaciones, 112), 5, 4)) < pam.RHPAManio
								and de.DEfvacaciones between pam.RHPAMfdesde and pam.RHPAMfhasta
							)
						<!--- Fecha de Ingreso --->
						<cfelse>
							and exists (
								select 1
								from RHPeriodosAccionesM pam, EVacacionesEmpleado de
								where pam.RHAid = a.RHAid
								and de.DEid = c.DEid
								and convert(int, substring(convert(varchar, de.EVfantig, 112), 5, 4)) < pam.RHPAManio
								and de.EVfantig between pam.RHPAMfdesde and pam.RHPAMfhasta
							)
						</cfif>						
					</cfif>
					<!----========= VALIDAR QUE LA PLAZA DE LOS EMPLEADOS EN EL RANGO DE FECHAS DE LA ACCION NO SEAN NEGOCIADAS ===========----->
					and not exists (select 1 
									from  RHLineaTiempoPlaza d
									where c.RHPid = d.RHPid
										and d.RHMPnegociado = 'N'
										and a.RHAfdesde <= d.RHLTPfhasta
										and a.RHAfhasta >= d.RHLTPfdesde
									)
					<!----=======================================================================================================---->							
			inner join RHPlazas pl
				on pl.RHPid 	= c.RHPid
				and    pl.RHPpuesto = b.RHPcodigo
				and    pl.Ecodigo	= c.Ecodigo															
			where a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAid#">
			and not exists (select 1
							from RHEmpleadosAccionMasiva eam
							where eam.RHAid = a.RHAid
							and eam.DEid = c.DEid)			
			<!--- Chequear que el empleado no se haya cambiado de empresa en ese rango de fechas --->
			and (select count(distinct Ecodigo) from LineaTiempo lt where lt.DEid = c.DEid and (lt.LTdesde between a.RHAfdesde and coalesce(a.RHAfhasta, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(6100, 01, 01)#">) or lt.LThasta between a.RHAfdesde and coalesce(a.RHAfhasta, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(6100, 01, 01)#">))) <= 1
			<!----========= Validar que el empleado perteneza a la misma nomina del filtro a la fecha de hoy ===========----->
			<cfif Arguments.validaTcodigo>
                  and exists (select 1 
                    from LineaTiempo lts 
                     where lts.DEid = c.DEid 
                     and (lts.LTdesde between #lvarHoy# and '61000101'
                     or lts.LThasta between #lvarHoy# and '61000101')
                     and lts.Tcodigo = b.Tcodigo
                   )
            </cfif>
        </cfquery>
		
		<!--- Insertar Empleados que tienen un tipo de Puesto --->
		<cfquery name="rs5" datasource="#session.dsn#">
			insert into RHEmpleadosAccionMasiva (DEid, 
												RHAid, 
												Ecodigo, 
												RHCPlinea, 
												RHAfdesde, 
												RHAfhasta, 
												Dcodigo, 
												Ocodigo, 
												RHPcodigo, 
												RHAporcsal, 
												RHAporc, 
												Tcodigo, 
												RVid, 
												RHEAMreconocido, 
												RHEAMjustificacion, 
												RHEAMusuarior, 
												RHEAMfecha, 
												RHEAMrevaluado, 
												RHEAMevaluacion, 
												RHEAMfuevaluacion,
												BMUsucodigo)
			select 	c.DEid, 
					a.RHAid, 
					a.Ecodigo, 
					a.RHCPlinea, 
					<!---- ==== Para la fecha desde toma la mayor entre la fecha desde de la accion masiva y la fecha desde de la linea del tiempo ==== ---->
					case when c.LTdesde <  a.RHAfdesde then  a.RHAfdesde else c.LTdesde end as RHAfdesde,
					<!---- ==== Para la fecha hasta toma la menor entre la fecha hasta de la accion masiva y la fecha hasta de la linea del tiempo ==== ---->
					case when c.LThasta >  a.RHAfhasta then  a.RHAfhasta else c.LThasta end as RHAfhasta,					
					b.Dcodigo, 
					b.Ocodigo, 
					a.RHPcodigo,
					a.RHAporcsal, 
					a.RHAporc, 
					a.Tcodigo, 
					a.RVid, 
				   	1 as RHEAMreconocido, 
				   	null as RHEAMjustificacion, 
				   	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#"> as RHEAMusuarior, 
				   	<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#"> as RHEAMfecha, 
				   	0 as RHEAMrevaluado, 
					null as RHEAMevaluacion, 
					null as RHEAMfuevaluacion, 
				   	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#"> as BMUsucodigo
			from RHAccionesMasiva a 
				inner join RHDepenAccionM b
					on b.RHAid = a.RHAid
					and b.RHTPid is not null
				inner join LineaTiempo c
					on c.Ecodigo = a.Ecodigo
					<!--- and c.RHPcodigo = b.RHPcodigo --->
					and a.RHAfdesde between c.LTdesde and c.LThasta
					and not exists (select 1
									from RHEmpleadosAccionMasiva x
									where x.RHAid = a.RHAid
										and x.DEid = c.DEid
									)
					<!--- Si se trabajan con periodos hay que extraer únicamente los empleados que cumplan con una fecha de periodo --->
					<cfif rsAccionMasiva.RHTAperiodos EQ 1>
						<!--- Segun el tipo de periodo de referencia se hace los chequeos --->
						<!--- Fecha de Anualidad --->
						<cfif rsAccionMasiva.RHTAfutilizap EQ 1>
							and exists (
								select 1
								from RHPeriodosAccionesM pam, DatosEmpleado de
								where pam.RHAid = a.RHAid
								and de.DEid = c.DEid
								
								and convert(int, substring(convert(varchar, de.DEfanuales, 112), 5, 4)) < pam.RHPAManio
								and de.DEfanuales between pam.RHPAMfdesde and pam.RHPAMfhasta
							)
						<!--- Fecha de Vacaciones --->
						<cfelseif rsAccionMasiva.RHTAfutilizap EQ 2>
							and exists (
								select 1
								from RHPeriodosAccionesM pam, DatosEmpleado de
								where pam.RHAid = a.RHAid
								and de.DEid = c.DEid
								and convert(int, substring(convert(varchar, de.DEfvacaciones, 112), 5, 4)) < pam.RHPAManio
								and de.DEfvacaciones between pam.RHPAMfdesde and pam.RHPAMfhasta
							)
						<!--- Fecha de Ingreso --->
						<cfelse>
							and exists (
								select 1
								from RHPeriodosAccionesM pam, EVacacionesEmpleado de
								where pam.RHAid = a.RHAid
								and de.DEid = c.DEid
								and convert(int, substring(convert(varchar, de.EVfantig, 112), 5, 4)) < pam.RHPAManio
								and de.EVfantig between pam.RHPAMfdesde and pam.RHPAMfhasta
							)
						</cfif>						
					</cfif>
					<!----========= VALIDAR QUE LA PLAZA DE LOS EMPLEADOS EN EL RANGO DE FECHAS DE LA ACCION NO SEAN NEGOCIADAS ===========----->
					and not exists (select 1 
									from  RHLineaTiempoPlaza d
									where c.RHPid = d.RHPid
										and d.RHMPnegociado = 'N'
										and a.RHAfdesde <= d.RHLTPfhasta
										and a.RHAfhasta >= d.RHLTPfdesde
									)
					<!----=======================================================================================================---->							
					inner join RHPlazas pl
						on pl.Ecodigo = c.Ecodigo
						 and pl.RHPid = c.RHPid
					inner join RHPuestos p
						on p.Ecodigo = pl.Ecodigo
						and p.RHPcodigo = pl.RHPpuesto
					inner join RHTPuestos t
						on t.RHTPid = p.RHTPid
						and t.RHTPid = b.RHTPid															
			where a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAid#">
			and not exists (select 1
							from RHEmpleadosAccionMasiva eam
							where eam.RHAid = a.RHAid
							and eam.DEid = c.DEid)			
			<!--- Chequear que el empleado no se haya cambiado de empresa en ese rango de fechas --->
			and (select count(distinct Ecodigo) from LineaTiempo lt where lt.DEid = c.DEid and (lt.LTdesde between a.RHAfdesde and coalesce(a.RHAfhasta, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(6100, 01, 01)#">) or lt.LThasta between a.RHAfdesde and coalesce(a.RHAfhasta, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(6100, 01, 01)#">))) <= 1
			<!----========= Validar que el empleado perteneza a la misma nomina del filtro a la fecha de hoy ===========----->
			<cfif Arguments.validaTcodigo>
                  and exists (select 1 
                    from LineaTiempo lts 
                     where lts.DEid = c.DEid 
                     and (lts.LTdesde between #lvarHoy# and '61000101'
                     or lts.LThasta between #lvarHoy# and '61000101')
                     and lts.Tcodigo = b.Tcodigo
                   )
            </cfif>
        </cfquery>
		
		<!--- Insertar Empleados que pertenecen a un Depto y Oficina --->
		<cfquery name="rsDepen3" datasource="#Arguments.conexion#">
			insert into RHEmpleadosAccionMasiva (DEid, 
												RHAid, 
												Ecodigo, 
												RHCPlinea, 
												RHAfdesde, 
												RHAfhasta, 
												Dcodigo, 
												Ocodigo, 
												RHPcodigo, 
												RHAporcsal, 
												RHAporc, 
												Tcodigo, 
												RVid, 
												RHEAMreconocido, 
												RHEAMjustificacion, 
												RHEAMusuarior, 
												RHEAMfecha, 
												RHEAMrevaluado, 
												RHEAMevaluacion, 
												RHEAMfuevaluacion, 
												BMUsucodigo)
			select 	c.DEid, 
					a.RHAid, 
					a.Ecodigo, 
					a.RHCPlinea, 
					<!---- ==== Para la fecha desde toma la mayor entre la fecha desde de la accion masiva y la fecha desde de la linea del tiempo ==== ---->
					case when c.LTdesde <  a.RHAfdesde then  a.RHAfdesde else c.LTdesde end as RHAfdesde,
					<!---- ==== Para la fecha hasta toma la menor entre la fecha hasta de la accion masiva y la fecha hasta de la linea del tiempo ==== ---->
					case when c.LThasta >  a.RHAfhasta then  a.RHAfhasta else c.LThasta end as RHAfhasta, 
					b.Dcodigo, 
					b.Ocodigo, 
					a.RHPcodigo,
					a.RHAporcsal, 
					a.RHAporc, 
					a.Tcodigo, 
					a.RVid, 
				   	1 as RHEAMreconocido, 
				   	null as RHEAMjustificacion, 
				   	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#"> as RHEAMusuarior, 
				   	<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#"> as RHEAMfecha, 
				   	0 as RHEAMrevaluado, 
					null as RHEAMevaluacion, 
					null as RHEAMfuevaluacion, 
				   	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#"> as BMUsucodigo
			from RHAccionesMasiva a
				inner join RHDepenAccionM b
					on b.RHAid = a.RHAid
					and b.Dcodigo is not null
					and b.Ocodigo is not null
				inner join LineaTiempo c
					on c.Ecodigo = a.Ecodigo
					and c.Dcodigo = b.Dcodigo
					and c.Ocodigo = b.Ocodigo
					and a.RHAfdesde between c.LTdesde and c.LThasta
					and not exists (
						select 1
						from RHEmpleadosAccionMasiva x
						where x.RHAid = a.RHAid
						and x.DEid = c.DEid
					)
					<!--- Si se trabajan con periodos hay que extraer únicamente los empleados que cumplan con una fecha de periodo --->
					<cfif rsAccionMasiva.RHTAperiodos EQ 1>
						<!--- Segun el tipo de periodo de referencia se hace los chequeos --->
						<!--- Fecha de Anualidad --->
						<cfif rsAccionMasiva.RHTAfutilizap EQ 1>
							and exists (
								select 1
								from RHPeriodosAccionesM pam, DatosEmpleado de
								where pam.RHAid = a.RHAid
								and de.DEid = c.DEid
								and convert(int, substring(convert(varchar, de.DEfanuales, 112), 5, 4)) < pam.RHPAManio
								and de.DEfanuales between pam.RHPAMfdesde and pam.RHPAMfhasta
							)
						<!--- Fecha de Vacaciones --->
						<cfelseif rsAccionMasiva.RHTAfutilizap EQ 2>
							and exists (
								select 1
								from RHPeriodosAccionesM pam, DatosEmpleado de
								where pam.RHAid = a.RHAid
								and de.DEid = c.DEid
								and convert(int, substring(convert(varchar, de.DEfvacaciones, 112), 5, 4)) < pam.RHPAManio
								and de.DEfvacaciones between pam.RHPAMfdesde and pam.RHPAMfhasta
							)
						<!--- Fecha de Ingreso --->
						<cfelse>
							and exists (
								select 1
								from RHPeriodosAccionesM pam, EVacacionesEmpleado de
								where pam.RHAid = a.RHAid
								and de.DEid = c.DEid
								and convert(int, substring(convert(varchar, de.EVfantig, 112), 5, 4)) < pam.RHPAManio
								and de.EVfantig between pam.RHPAMfdesde and pam.RHPAMfhasta
							)
						</cfif>
					</cfif>
					<!----========= VALIDAR QUE LA PLAZA DE LOS EMPLEADOS EN EL RANGO DE FECHAS DE LA ACCION NO SEAN NEGOCIADAS ===========----->
					and not exists (select 1 
									from  RHLineaTiempoPlaza d
									where c.RHPid = d.RHPid
										and d.RHMPnegociado = 'N'
										and a.RHAfdesde <= d.RHLTPfhasta
										and a.RHAfhasta >= d.RHLTPfdesde
									)
					<!----=======================================================================================================---->
			where a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAid#">
			and not exists (
				select 1
				from RHEmpleadosAccionMasiva eam
				where eam.RHAid = a.RHAid
				and eam.DEid = c.DEid
			)
			<!--- Chequear que el empleado no se haya cambiado de empresa en ese rango de fechas --->
			and (select count(distinct Ecodigo) from LineaTiempo lt where lt.DEid = c.DEid and (lt.LTdesde between a.RHAfdesde and coalesce(a.RHAfhasta, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(6100, 01, 01)#">) or lt.LThasta between a.RHAfdesde and coalesce(a.RHAfhasta, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(6100, 01, 01)#">))) <= 1
			<!----========= Validar que el empleado perteneza a la misma nomina del filtro a la fecha de hoy ===========----->
			<cfif Arguments.validaTcodigo>
                  and exists (select 1 
                    from LineaTiempo lts 
                     where lts.DEid = c.DEid 
                     and (lts.LTdesde between #lvarHoy# and '61000101'
                     or lts.LThasta between #lvarHoy# and '61000101')
                     and lts.Tcodigo = b.Tcodigo
                   )
            </cfif>
        </cfquery>

		<!--- Insertar Empleados que pertenecen a un Centro Funcional --->
		<cfquery name="rsDepen4" datasource="#Arguments.conexion#">
			insert into RHEmpleadosAccionMasiva (DEid, 
												RHAid, 
												Ecodigo, 
												RHCPlinea, 
												RHAfdesde, 
												RHAfhasta, 
												Dcodigo, 
												Ocodigo, 
												RHPcodigo, 
												RHAporcsal, 
												RHAporc, 
												Tcodigo, 
												RVid, 
												RHEAMreconocido, 
												RHEAMjustificacion, 
												RHEAMusuarior, 
												RHEAMfecha, 
												RHEAMrevaluado, 
												RHEAMevaluacion, 
												RHEAMfuevaluacion, 
												BMUsucodigo)
			select 	c.DEid, 
					a.RHAid, 
					a.Ecodigo, 
					a.RHCPlinea, 
					<!---- ==== Para la fecha desde toma la mayor entre la fecha desde de la accion masiva y la fecha desde de la linea del tiempo ==== ---->
					case when c.LTdesde <  a.RHAfdesde then  a.RHAfdesde else c.LTdesde end as RHAfdesde,
					<!---- ==== Para la fecha hasta toma la menor entre la fecha hasta de la accion masiva y la fecha hasta de la linea del tiempo ==== ---->
					case when c.LThasta >  a.RHAfhasta then  a.RHAfhasta else c.LThasta end as RHAfhasta,
					b.Dcodigo, 
					b.Ocodigo, 
					a.RHPcodigo,
					a.RHAporcsal, 
					a.RHAporc, 
					a.Tcodigo, 
					a.RVid, 
				   	1 as RHEAMreconocido, 
				   	null as RHEAMjustificacion, 
				   	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#"> as RHEAMusuarior, 
				   	<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#"> as RHEAMfecha, 
				   	0 as RHEAMrevaluado, 
					null as RHEAMevaluacion, 
					null as RHEAMfuevaluacion, 
				   	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#"> as BMUsucodigo
			from RHAccionesMasiva a
				inner join RHDepenAccionM b
					on b.RHAid = a.RHAid
					and b.CFid is not null
				inner join LineaTiempo c
					on c.Ecodigo = a.Ecodigo
					and a.RHAfdesde between c.LTdesde and c.LThasta
					and not exists (
						select 1
						from RHEmpleadosAccionMasiva x
						where x.RHAid = a.RHAid
						and x.DEid = c.DEid
					)
					<!--- Si se trabajan con periodos hay que extraer únicamente los empleados que cumplan con una fecha de periodo --->
					<cfif rsAccionMasiva.RHTAperiodos EQ 1>
						<!--- Segun el tipo de periodo de referencia se hace los chequeos --->
						<!--- Fecha de Anualidad --->
						<cfif rsAccionMasiva.RHTAfutilizap EQ 1>
							and exists (
								select 1
								from RHPeriodosAccionesM pam, DatosEmpleado de
								where pam.RHAid = a.RHAid
								and de.DEid = c.DEid
								<!---- ======= ANTERIOR =======
								and convert(int, substring(convert(varchar, de.DEfanuales, 112), 5, 4)) < pam.RHPAManio
								and de.DEfanuales between pam.RHPAMfdesde and pam.RHPAMfhasta
								----->
								and <cf_dbfunction name="date_part" args="mm,de.DEfanuales"> between <cf_dbfunction name="date_part" args="mm, pam.RHPAMfdesde"> and <cf_dbfunction name="date_part" args="mm,pam.RHPAMfhasta">
								and <cf_dbfunction name="date_part" args="yy,de.DEfanuales"> <  <cf_dbfunction name="date_part" args="yy,pam.RHPAMfdesde">
								and substring(convert(varchar,de.DEfanuales,112),5,4) <= substring(convert(varchar,pam.RHPAMfhasta,112),5,4)
								<!-----
								and datepart(mm,de.DEfanuales) between datepart(mm, pam.RHPAMfdesde) and datepart(mm,pam.RHPAMfhasta)
								and datepart(yy,de.DEfanuales) < datepart(yy,pam.RHPAMfdesde)
								and substring(convert(varchar,de.DEfanuales,112),5,4) <= substring(convert(varchar,pam.RHPAMfhasta,112),5,4)
								------>
							)
						<!--- Fecha de Vacaciones --->
						<cfelseif rsAccionMasiva.RHTAfutilizap EQ 2>
							and exists (
								select 1
								from RHPeriodosAccionesM pam, DatosEmpleado de
								where pam.RHAid = a.RHAid
								and de.DEid = c.DEid
								<!----========== ANTERIOR ========
								and convert(int, substring(convert(varchar, de.DEfvacaciones, 112), 5, 4)) < pam.RHPAManio
								and de.DEfvacaciones between pam.RHPAMfdesde and pam.RHPAMfhasta
								------>
								and <cf_dbfunction name="date_part" args="mm,de.DEfvacaciones"> between <cf_dbfunction name="date_part" args="mm,pam.RHPAMfdesde"> and  <cf_dbfunction name="date_part" args="mm,pam.RHPAMfhasta">
								and <cf_dbfunction name="date_part" args="yy,de.DEfvacaciones"> <  <cf_dbfunction name="date_part" args="yy,pam.RHPAMfdesde">
								and substring(convert(varchar,de.DEfvacaciones,112),5,4) <= substring(convert(varchar,pam.RHPAMfhasta,112),5,4)
								<!----
								and datepart(mm,de.DEfvacaciones) between datepart(mm,pam.RHPAMfdesde) and datepart(mm,pam.RHPAMfhasta)
								and datepart(yy,de.DEfvacaciones) < datepart(yy,pam.RHPAMfdesde)
								and substring(convert(varchar,de.DEfvacaciones,112),5,4) <= substring(convert(varchar,pam.RHPAMfhasta,112),5,4)
								----->
							)
						<!--- Fecha de Ingreso --->
						<cfelse>
							and exists (
								select 1
								from RHPeriodosAccionesM pam, EVacacionesEmpleado de
								where pam.RHAid = a.RHAid
								and de.DEid = c.DEid
								<!----========= ANTERIOR ==========
								and convert(int, substring(convert(varchar, de.EVfantig, 112), 5, 4)) < pam.RHPAManio
								and de.EVfantig between pam.RHPAMfdesde and pam.RHPAMfhasta
								----->
								and <cf_dbfunction name="date_part" args="mm,de.EVfantig"> between <cf_dbfunction name="date_part" args="mm,pam.RHPAMfdesde"> and  <cf_dbfunction name="date_part" args="mm,pam.RHPAMfhasta">
								and <cf_dbfunction name="date_part" args="yy,de.EVfantig"> <  <cf_dbfunction name="date_part" args="yy,pam.RHPAMfdesde">
								and substring(convert(varchar,de.EVfantig,112),5,4) <= substring(convert(varchar,pam.RHPAMfhasta,112),5,4)
								<!-----
								and datepart(mm,de.EVfantig) between datepart(mm,pam.RHPAMfdesde) and datepart(mm,pam.RHPAMfhasta)
								and datepart(yy,de.EVfantig) < datepart(yy,pam.RHPAMfdesde)
								and substring(convert(varchar,de.EVfantig,112),5,4) <= substring(convert(varchar,pam.RHPAMfhasta,112),5,4)
								------>
							)
						</cfif>
					</cfif>
				inner join RHPlazas d
					on d.Ecodigo = c.Ecodigo
					and d.RHPid = c.RHPid
					and d.CFid = b.CFid
					<!----========= VALIDAR QUE LA PLAZA DE LOS EMPLEADOS EN LA FECHA DE LA ACCION NO SEAN NEGOCIADAS ===========----->
					and not exists( select 1 from  RHLineaTiempoPlaza e
									where d.RHPid = e.RHPid	
										and e.RHMPnegociado = 'N'
										and a.RHAfdesde <= e.RHLTPfhasta
										and a.RHAfhasta >= e.RHLTPfdesde
									)
					<!----=======================================================================================================---->				

			where a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAid#">
			and not exists (
				select 1
				from RHEmpleadosAccionMasiva eam
				where eam.RHAid = a.RHAid
				and eam.DEid = c.DEid
			)
			<!--- Chequear que el empleado no se haya cambiado de empresa en ese rango de fechas --->
			and (select count(distinct Ecodigo) from LineaTiempo lt where lt.DEid = c.DEid and (lt.LTdesde between a.RHAfdesde and coalesce(a.RHAfhasta, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(6100, 01, 01)#">) or lt.LThasta between a.RHAfdesde and coalesce(a.RHAfhasta, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(6100, 01, 01)#">))) <= 1
			<!----========= Validar que el empleado perteneza a la misma nomina del filtro a la fecha de hoy ===========----->
			<cfif Arguments.validaTcodigo>
                  and exists (select 1 
                    from LineaTiempo lts 
                     where lts.DEid = c.DEid 
                     and (lts.LTdesde between #lvarHoy# and '61000101'
                     or lts.LThasta between #lvarHoy# and '61000101')
                     and lts.Tcodigo = b.Tcodigo
                   )
            </cfif>
        </cfquery>	
	</cfif>
		<!----------------------------------------------Insertar Empleados que sean por antiguedad--> Funcionalidad nueva del ITCR------------------------------------------------>
		<cfif len(trim(Anua.RHTAanualidad)) gt 0 or Anua.RHTAanualidad eq 1>
			<cfquery name="rsDepen1" datasource="#Arguments.conexion#">
				insert into RHEmpleadosAccionMasiva (DEid, 
													RHAid, 
													Ecodigo, 
													RHCPlinea, 
													RHAfdesde, 
													RHAfhasta, 
													Dcodigo, 
													Ocodigo, 
													RHPcodigo, 
													RHAporcsal, 
													RHAporc, 
													Tcodigo, 
													RVid, 
													RHEAMreconocido, 
													RHEAMjustificacion, 
													RHEAMusuarior, 
													RHEAMfecha, 
													RHEAMrevaluado, 
													RHEAMevaluacion, 
													RHEAMfuevaluacion, 
													BMUsucodigo)
				select 	b.DEid, 
						a.RHAid, 
						a.Ecodigo, 
						a.RHCPlinea, 
						<!---- ==== Para la fecha desde toma la mayor entre la fecha desde de la accion masiva y la fecha desde de la linea del tiempo ==== ----->
						case when c.LTdesde <  a.RHAfdesde then  a.RHAfdesde else c.LTdesde end as RHAfdesde,
						<!---- ==== Para la fecha hasta toma la menor entre la fecha hasta de la accion masiva y la fecha hasta de la linea del tiempo ==== ----->
						case when c.LThasta >  a.RHAfhasta then  a.RHAfhasta else c.LThasta end as RHAfhasta,
						b.Dcodigo, 
						b.Ocodigo, 
						a.RHPcodigo,
						a.RHAporcsal, 
						a.RHAporc, 
						a.Tcodigo, 
						a.RVid, 
						1 as RHEAMreconocido, 
						null as RHEAMjustificacion, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#"> as RHEAMusuarior, 
						<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#"> as RHEAMfecha, 
						0 as RHEAMrevaluado, 
						null as RHEAMevaluacion, 
						null as RHEAMfuevaluacion, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#"> as BMUsucodigo
				from RHAccionesMasiva a
					inner join RHDepenAccionM b
						on b.RHAid = a.RHAid
						and b.DEid is not null
						and not exists (select 1
										from RHEmpleadosAccionMasiva x
										where x.RHAid = a.RHAid
										and x.DEid = b.DEid)
					<!----- ==== Se pega con la línea del tiempo para utilizar la fecha del corte ==== ----->
					inner join LineaTiempo c
						on b.Ecodigo = c.Ecodigo
						and b.DEid = c.DEid
						and a.RHAfdesde between c.LTdesde and c.LThasta	
						<cfif Arguments.validaTcodigo>
                          and c.Tcodigo = b.Tcodigo
                        </cfif>						
				where a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAid#">
				
				and not exists (
					select 1
					from RHEmpleadosAccionMasiva eam
					where eam.RHAid = a.RHAid
					and eam.DEid = b.DEid
				)
				<!--- Chequear que el empleado no se haya cambiado de empresa en ese rango de fechas --->
				and (select count(distinct Ecodigo) 
						from LineaTiempo lt 
								where lt.DEid = b.DEid 
								and (lt.LTdesde between a.RHAfdesde 
												and coalesce(a.RHAfhasta, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(6100, 01, 01)#">) 
												or lt.LThasta between a.RHAfdesde 
												and coalesce(a.RHAfhasta, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(6100, 01, 01)#">))) <= 1		
				<!----========= Validar que el empleado perteneza a la misma nomina del filtro a la fecha de hoy ===========----->
				<cfif Arguments.validaTcodigo>
                      and exists (select 1 
                        from LineaTiempo lts 
                         where lts.DEid = c.DEid 
                         and (lts.LTdesde between #lvarHoy# and '61000101'
                         or lts.LThasta between #lvarHoy# and '61000101')
                         and lts.Tcodigo = b.Tcodigo
                       )
                </cfif>
                </cfquery>
			
			</cfif>
		
		<!--- Chequear que no se repita el empleado en la tabla de empleados de la acción masiva --->
		<!--- Cargar las notas de evaluacion de los empleados --->
		<cfif rsAccionMasiva.RHTAevaluacion EQ 1>
			<cfquery name="updNotas" datasource="#Arguments.conexion#">
				update RHEmpleadosAccionMasiva set
					RHEAMevaluacion = coalesce(b.RHLEnotajefe, 0.00)
				from RHEmpleadosAccionMasiva emp
	
					inner join RHEEvaluacionDes a
						on a.RHEEid = (
							select coalesce(max(x.RHEEid), 0)
							from RHEEvaluacionDes x
							where x.PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAccionMasiva.PCid#">
							and x.RHEEestado = 3
							and x.RHEEfhasta = (
								select coalesce(max(y.RHEEfhasta), <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(6100, 01, 01)#">)
								from RHEEvaluacionDes y
								where y.PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAccionMasiva.PCid#">
								and y.RHEEestado = 3
								and y.RHEEfhasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#rsAccionMasiva.RHAfdesde#">
							)
						)
	
					inner join RHListaEvalDes b
						on b.RHEEid = a.RHEEid
						and b.DEid = emp.DEid
	
				where emp.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAid#">
			</cfquery>
		</cfif>

		<!--------------------------------------------- NO RECONOCIDOS --------------------------------------------->
		<!--- 
			Fecha de vencimiento de la acción masiva excede el vencimiento del período de nombramiento del empleado
		--->
		<cfquery name="updDepend1" datasource="#Arguments.conexion#">
			update RHEmpleadosAccionMasiva set
				RHEAMreconocido = 0,
				RHEAMjustificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#MSG_NoReconocido#">
			where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAid#">
			and RHEAMreconocido = 1
			and not exists (
				select 1
				from LineaTiempo x
				where x.DEid = RHEmpleadosAccionMasiva.DEid
				and RHEmpleadosAccionMasiva.RHAfhasta between x.LTdesde and x.LThasta
			)
		</cfquery>
		
		<!---
			ESTE CHEQUEO YA NO ES NECESARIO
		<!--- En la acción masiva se está modificando/eliminando un componente salarial que el empleado no tiene --->
		<cfquery name="updDepend2" datasource="#Arguments.conexion#">
			update RHEmpleadosAccionMasiva set
				RHEAMreconocido = 0,
				RHEAMjustificacion = 'NO RECONOCIDO porque en la acción masiva se está modificando/eliminando un componente salarial que el empleado no tiene'
			where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAid#">
			and RHEAMreconocido = 1
			and exists (
				select 1
				from RHComponentesAccionM r
				where r.RHAid = RHEmpleadosAccionMasiva.RHAid
				and (r.RHCAMtmodificar = 1 or r.RHCAMmodificars = 1 or r.RHCAMteliminar = 1)
				and not exists (
					select 1
					from LineaTiempo x
						inner join DLineaTiempo y
							on y.LTid = x.LTid
							and y.CSid = r.CSid
					where x.DEid = RHEmpleadosAccionMasiva.DEid
					and RHEmpleadosAccionMasiva.RHAfhasta between x.LTdesde and x.LThasta
				)
			)
		</cfquery>
		--->
		
		<!--- En la acción masiva se está modificando un componente salarial que usa tabla o es de tipo porcentaje --->
		<cfquery name="updDepend2" datasource="#Arguments.conexion#">
			update RHEmpleadosAccionMasiva set
				RHEAMreconocido = 0,
				RHEAMjustificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#MSG_NoReconocidoComponenteSal#">
			where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAid#">
			and RHEAMreconocido = 1
			and (
				<!--- Averigua si existen componentes que usan tabla y no son de tipo multiplicador --->
				exists (
					select 1
					from RHComponentesAccionM r
						inner join RHEmpleadosAccionMasiva
                            on r.RHAid = RHEmpleadosAccionMasiva.RHAid 
						inner join ComponentesSalariales s
							on s.CSid = r.CSid
							and s.CSusatabla = 1
						inner join RHMetodosCalculo t
							on t.CSid = s.CSid
							and RHEmpleadosAccionMasiva.RHAfdesde between t.RHMCfecharige and t.RHMCfechahasta
							and t.RHMCestadometodo = 1
							and t.RHMCcomportamiento <> 3
					where (r.RHCAMtmodificar = 1 or r.RHCAMmodificars = 1)
				)
				or
				<!--- Averigua si existen componentes que son métodos y no son de tipo multiplicador --->
				exists (
					select 1
					from RHComponentesAccionM r
						inner join RHEmpleadosAccionMasiva
							on r.RHAid = RHEmpleadosAccionMasiva.RHAid
						inner join ComponentesSalariales s
							on s.CSid = r.CSid
							and s.CSusatabla = 2
						inner join RHMetodosCalculo t
							on t.CSid = s.CSid
							and RHEmpleadosAccionMasiva.RHAfdesde between t.RHMCfecharige and t.RHMCfechahasta
							and t.RHMCestadometodo = 1
							and t.RHMCcomportamiento <> 3
					where (r.RHCAMtmodificar = 1 or r.RHCAMmodificars = 1)
				)
			)
		</cfquery>
		
		<!--- El tipo de acción masiva afecta incorrectamente la línea del tiempo del empleado
			  ya sea porque tiene aplicado un tipo de acción o se tiene una acción de personal en proceso 
			  que no permite aplicar el tipo de acción especificado en la acción masiva
			  
			Comportamiento de Acciones
			1 Nombramiento
			2 Cese
			3 Vacaciones
			4 Permiso
			5 Incapacidad
			6 Cambio
			7 Anulación
			8 Aumento
			9 Cambio de Empresa
		--->
		<cfquery name="updDepend3" datasource="#Arguments.conexion#">
			update RHEmpleadosAccionMasiva set
				RHEAMreconocido = 0,
				RHEAMjustificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#MSG_NoReconocidoLineaTiempo#">
			where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAid#">
			and RHEAMreconocido = 1
			and exists (
				select 1
				from RHAccionesMasiva r
					inner join RHEmpleadosAccionMasiva a
						on r.RHAid = a.RHAid
					inner join RHTAccionMasiva s
						on s.RHTAid = r.RHTAid
					inner join RHTipoAccion t
						on t.RHTid = s.RHTid
						and t.RHTcomportam = 3
					inner join DLaboralesEmpleado u
						on u.DEid = a.DEid
						and (a.RHAfdesde between u.DLfvigencia 
							 and coalesce(u.DLffin, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(6100, 01, 01)#">) 
							  or a.RHAfhasta between u.DLfvigencia 
							  	and coalesce(u.DLffin, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(6100, 01, 01)#">))
					inner join RHTipoAccion v
						on v.RHTid = u.RHTid
						and v.RHTcomportam = 5 
					where a.RHAid = RHEmpleadosAccionMasiva.RHAid
					  and a.DEid = RHEmpleadosAccionMasiva.DEid
					  and a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAid#">
					  and a.RHEAMreconocido = 1
			)
		</cfquery>

		<cfquery name="updDepend4" datasource="#Arguments.conexion#">
			update RHEmpleadosAccionMasiva set
				RHEAMreconocido = 0,
				RHEAMjustificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#MSG_NoReconocidoLineaTiempo#">
			where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAid#">
			and RHEAMreconocido = 1
			and exists (
				select 1
				from RHAccionesMasiva r
					inner join RHEmpleadosAccionMasiva a
						on r.RHAid = a.RHAid
					inner join RHTAccionMasiva s
						on s.RHTAid = r.RHTAid
					inner join RHTipoAccion t
						on t.RHTid = s.RHTid
						and t.RHTcomportam = 3
					inner join RHAcciones u
						on u.DEid = a.DEid
						and (a.RHAfdesde between u.DLfvigencia and coalesce(u.DLffin, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(6100, 01, 01)#">) or a.RHAfhasta between u.DLfvigencia and coalesce(u.DLffin, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(6100, 01, 01)#">))
					inner join RHTipoAccion v
						on v.RHTid = u.RHTid
						and v.RHTcomportam = 5
					where a.RHAid = RHEmpleadosAccionMasiva.RHAid
					  and a.DEid = RHEmpleadosAccionMasiva.DEid
					  and a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAid#">
					  and RHEAMreconocido = 1
			)
		</cfquery>
		
		<!--- Si se trabajan con Periodos se debe chequear también que hayan cumplido con la evaluación --->
		<cfif rsAccionMasiva.RHTAevaluacion EQ 1>
			<cfquery name="updDepen5" datasource="#Arguments.conexion#">
				update RHEmpleadosAccionMasiva set
					RHEAMreconocido = 0,
					RHEAMjustificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#MSG_NoReconocidoNotaMinima#">
				where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAid#">
				and RHEAMreconocido = 1
				and not exists (
					select 1
					from RHAccionesMasiva r
						inner join RHTAccionMasiva s
							on s.RHTAid = r.RHTAid
							and RHEmpleadosAccionMasiva.RHEAMevaluacion is not null
							and RHEmpleadosAccionMasiva.RHEAMevaluacion >= s.RHTAnotaminima
					where r.RHAid = RHEmpleadosAccionMasiva.RHAid
				)
			</cfquery>
		</cfif>
		
		<!---Me elimina aquellos empleados que fueron nombrados despues de la fecha de corte-MCZ--->
		<cfquery name="rsRev" datasource="#session.dsn#">
			delete from RHEmpleadosAccionMasiva 
					where DEid in (	select distinct l.DEid  from LineaTiempo l
										inner join RHDepenAccionM r
										on l.DEid=r.DEid
									where l.DEid in (select DEid from RHEmpleadosAccionMasiva where RHAid=#Arguments.RHAid#)
									and LTdesde = (select min(LTdesde) from LineaTiempo where DEid=l.DEid)
									and LTdesde>=r.Fcorte )
					and  RHAid=#Arguments.RHAid#
		</cfquery>
	
		<cfset error = 0>
		<cfreturn error>
	</cffunction>


	<cffunction name="generarAccionesMasivas" access="public" output="true" returntype="numeric"  hint="Generación de Acciones Masivas">
		<cfargument name="RHAid" type="numeric" required="yes" hint="Código de Acción Masiva">
		<cfargument name="RHTipoAplicacion" type="numeric" required="no" default="0" hint="cache">
		<cfargument name="Ecodigo" type="numeric" required="no" default="#Session.Ecodigo#" hint="Empresa">
		<cfargument name="conexion" type="string" required="no" default="#Session.DSN#" hint="cache">
		<!---
		<cflog time="yes" file="logyu" text="------- Inicio Proceso generarAccionesMasivas ------------">
		--->
		<!----================== TRADUCCION ================----->
		<cfinvoke key="LB_Accion_generada_por_Registro_de_Acciones_de_Personal_Masiva" default="Acción generada por Registro de Acciones de Personal Masiva"	 returnvariable="LB_AccionRegistroAccionMasiva" component="sif.Componentes.Translate" method="Translate"/>
		<cfinvoke key="MSG_La_accion_no_se_puede_generar_Por_favor_verifique_los_parametros_de_configuracion_para_Estructura Salarial" default="La accion no se puede generar. Por favor verifique los parámetros de configuración para Estructura Salarial."	 returnvariable="MSG_AccionNoGenerada" component="sif.Componentes.Translate" method="Translate"/>
		
		<!--- Funciones de Calculadora --->
		<cfset RH_Calculadora = createobject("component","rh.Componentes.RH_Calculadora")>	
		
		<!--- Eliminar Acciones anteriores que fueron generadas con la acción masiva --->
		<cfquery name="rsDel" datasource="#Arguments.conexion#">
			delete from RHDAcciones
			where exists ( 	select 1 
							from RHDAcciones a, RHAcciones b
							where b.RHAlinea = a.RHAlinea
								and b.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAid#">
						  )
		</cfquery>

		<cfquery name="rsDel" datasource="#Arguments.conexion#">
			delete from RHConceptosAccion
			where exists ( 	select 1 
							from RHConceptosAccion a, RHAcciones b
							where b.RHAlinea = a.RHAlinea
								and b.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAid#">
						  )
		</cfquery>
	
		<cfquery name="rsDel" datasource="#Arguments.conexion#">
			delete from RHAcciones
			where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAid#">
		</cfquery>

		<!--- Averiguar si la Empresa usa Estructura Salarial --->
		<cfset usaEstructuraSalarial = 0>
		<cfquery name="rsSalBase" datasource="#Arguments.conexion#">
			select CSusatabla
			from ComponentesSalariales
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			and CSsalariobase = 1
		</cfquery>
		<cfif rsSalBase.recordCount>
			<cfset usaEstructuraSalarial = rsSalBase.CSusatabla>
		</cfif>
		
		<!--- Datos de la Accion Masiva --->
		<cfquery name="rsAccionMasiva" datasource="#Arguments.conexion#">
			select a.RHAid, a.RHTAid, rtrim(a.RHAcodigo) as RHAcodigo, rtrim(a.RHAdescripcion) as RHAdescripcion, a.RHCPlinea, a.RHAfdesde, a.RHAfhasta, a.Ecodigo,
				   rtrim(a.Tcodigo) as Tcodigo, a.RVid, a.Ocodigo, a.Dcodigo, rtrim(a.RHPcodigo) as RHPcodigo, a.RHAporcsal, a.RHAporc, a.RHJid, 
				   a.RHAidliquida, a.RHAAnoreconocidos, a.RHAAperiodom, a.RHAAnumerop, a.BMUsucodigo, a.ts_rversion,
				   b.RHTid, b.RHTAcodigo, b.PCid, b.RHTAdescripcion, b.RHTAcomportamiento, b.RHTAaplicaauto, b.RHTAcempresa, 
				   b.RHTActiponomina, b.RHTAcregimenv, b.RHTAcoficina, b.RHTAcdepto, b.RHTAcplaza, b.RHTAcpuesto, 
				   b.RHTAccomp, b.RHTAcsalariofijo, b.RHTAccatpaso, b.RHTAcjornada, b.RHTAidliquida, b.RHTAevaluacion, 
				   b.RHTAnotaminima, b.RHTAperiodos, b.RHTAfutilizap, b.RHTArespetarLT,
				   c.RHTcomportam
			from RHAccionesMasiva a
				inner join RHTAccionMasiva b
					on b.RHTAid = a.RHTAid
				inner join RHTipoAccion c
					on c.RHTid = b.RHTid
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			and a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAid#">
		</cfquery>
		
		<!--- Si se respeta la linea del tiempo hay que mantener los cortes de la linea del tiempo --->
		<cfif rsAccionMasiva.RHTArespetarLT EQ 1>
        	<!---SML. Inicio Modificacion para Acciones Masivas--->
			<!--- Insertar el primer movimiento en la linea del tiempo a partir de la fecha de inicio de la acción masiva en caso de que sea necesario --->
			<cfquery name="insAcciones" datasource="#Arguments.conexion#">
				insert into RHAcciones (DEid, 
										RHAid, 
										RHTid, 
										Ecodigo, 
										DLfvigencia, 
										DLffin, 
										DLobs, 
										Usucodigo, 
										Ulocalizacion, 
										Tcodigo, 
										RVid, 
										RHJid, 
										Dcodigo, 
										Ocodigo, 
										RHCPlinea, 
										RHPid, 
										RHPcodigo, 
										DLsalario, 
										RHAporc, 
										RHAporcsal, 
										Mcodigo,
										Indicador_de_Negociado, 
										BMUsucodigo,
										RHTipoAplicacion,
										RHPcodigoAlt,RHCPlineaP)
                   select b.DEid, 
						b.RHAid, 
						case when f.RHTcomportam = 3 then
                        d.RHTid
                        else
						c.RHTid
                        end,
						a.Ecodigo, 
					   	a.RHAfdesde, 
                        case when a.RHAfhasta <= d.LThasta then a.RHAfhasta else d.LThasta end,
                        <!---case when d.LThasta > a.RHAfdesde then a.RHAfdesde else d.LThasta end ---><!---case when d.LTdesde <= a.RHAfdesde then a.RHAfdesde else a.RHAfhasta end-,--->
                        <!---,d.LTdesde,d.LThasta,--->
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#LB_AccionRegistroAccionMasiva#">, 
					   	87, '00', 
					   	coalesce(b.Tcodigo, d.Tcodigo),
					   	coalesce(b.RVid, d.RVid),
					   	d.RHJid,
					   	coalesce(b.Dcodigo, d.Dcodigo),
					   	coalesce(b.Ocodigo, d.Ocodigo),
					   	coalesce(b.RHCPlinea, d.RHCPlinea),
					   	d.RHPid,
						coalesce(b.RHPcodigo, d.RHPcodigo),
						d.LTsalario,
						coalesce(b.RHAporc, d.LTporcplaza),
						coalesce(b.RHAporcsal, d.LTporcsal),
						null as Mcodigo, 
						0,<!---(case when e.RHMPnegociado is not null and e.RHMPnegociado = 'N' then 1 else 0 end) as Indicador_de_Negociado, --->
						87,
						1,
						d.RHPcodigoAlt,d.RHCPlineaP
				from RHAccionesMasiva a
					inner join RHEmpleadosAccionMasiva b
						on b.RHAid = a.RHAid
						and b.RHEAMreconocido = 1
					inner join RHTAccionMasiva c
						on c.RHTAid = a.RHTAid
					inner join LineaTiempo d
						on d.DEid = b.DEid
						<!-----and d.LTdesde < a.RHAfdesde
						--and d.LTdesde = (
						--	select x.LTdesde
						--	from LineaTiempo x
						--	where x.DEid = b.DEid--->
							and a.RHAfdesde between d.LTdesde and d.LThasta
						<!---)
					--right outer join RHLineaTiempoPlaza e
					--	on e.RHPid = d.RHPid
					--and a.RHAfdesde between e.RHLTPfdesde and e.RHLTPfhasta--->
                    inner join RHTipoAccion f
                    	on f.RHTid = d.RHTid
				where a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAid#">
			</cfquery>
			
			<!--- Insertar todos los movimientos que ocurren dentro del rango de fechas de la acción masiva --->
			<!---<cfquery name="insAcciones" datasource="#Arguments.conexion#">
				insert into RHAcciones (DEid, 
										RHAid, 
										RHTid, 
										Ecodigo, 
										DLfvigencia, 
										DLffin, 
										DLobs, 
										Usucodigo, 
										Ulocalizacion, 
										Tcodigo, 
										RVid, 
										RHJid, 
										Dcodigo, 
										Ocodigo, 
										RHCPlinea, 
										RHPid, 
										RHPcodigo, 
										DLsalario, 
										RHAporc, 
										RHAporcsal, 
										Mcodigo, 
										Indicador_de_Negociado, 
										BMUsucodigo,
										RHTipoAplicacion,
										RHPcodigoAlt,
										RHCPlineaP)
                                        
                     select 	b.DEid, 
						b.RHAid, 
						<!-----case when f.RHTcomportam = 3 then--->
                        d.RHTid,
                       <!--- --else
						--c.RHTid
                        --end,--->
						a.Ecodigo, 
					   	case when d.LTdesde < a.RHAfdesde then d.LTdesde else a.RHAfdesde end,
                        case when d.LThasta > a.RHAfdesde then a.RHAfdesde else d.LThasta end,
                        <!---d.LTdesde,d.LThasta,--->
						'Acción generada por Registro de Acciones de Personal Masiva', 
					   	87, '00', 
					   	coalesce(b.Tcodigo, d.Tcodigo),
					   	coalesce(b.RVid, d.RVid),
					   	d.RHJid,
					   	coalesce(b.Dcodigo, d.Dcodigo),
					   	coalesce(b.Ocodigo, d.Ocodigo),
					   	coalesce(b.RHCPlinea, d.RHCPlinea),
					   	d.RHPid,
						coalesce(b.RHPcodigo, d.RHPcodigo),
						d.LTsalario,
						coalesce(b.RHAporc, d.LTporcplaza),
						coalesce(b.RHAporcsal, d.LTporcsal),
						null as Mcodigo, 
						0,<!-----(case when e.RHMPnegociado is not null and e.RHMPnegociado = 'N' then 1 else 0 end) as Indicador_de_Negociado, --->
						87,
						1,
						d.RHPcodigoAlt,d.RHCPlineaP
				from RHAccionesMasiva a
					inner join RHEmpleadosAccionMasiva b
						on b.RHAid = a.RHAid
						and b.RHEAMreconocido = 1
					inner join RHTAccionMasiva c
						on c.RHTAid = a.RHTAid
					inner join LineaTiempo d
						on d.DEid = b.DEid
						<!-----and d.LTdesde < a.RHAfdesde
						--and d.LTdesde = (
						--	select x.LTdesde
						--	from LineaTiempo x
						--	where x.DEid = b.DEid--->
							and a.RHAfdesde between d.LTdesde and d.LThasta
						<!---)
					--right outer join RHLineaTiempoPlaza e
					--	on e.RHPid = d.RHPid
					--and a.RHAfdesde between e.RHLTPfdesde and e.RHLTPfhasta--->
                    inner join RHTipoAccion f
                    	on f.RHTid = d.RHTid
                    	
				where a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAid#">          
				
			</cfquery>--->
			<!---SML. Inicio Modificacion para Acciones Masivas--->
		<!--- Cuando no es necesario respetar la línea del tiempo --->
		<cfelse>
			
			<cfquery name="insAcciones" datasource="#Arguments.conexion#">
				insert into RHAcciones (DEid, 
										RHAid, 
										RHTid, 
										Ecodigo, 
										DLfvigencia, 
										DLffin, 
										DLobs, 
										Usucodigo, 
										Ulocalizacion, 
										Tcodigo, 
										RVid, 
										RHJid, 
										Dcodigo, 
										Ocodigo, 
										RHCPlinea, 
										RHPid, 
										RHPcodigo, 
										DLsalario, 
										RHAporc, 
										RHAporcsal, 
										Mcodigo, 
										Indicador_de_Negociado, 
										BMUsucodigo,
										RHTipoAplicacion,
										RHPcodigoAlt,RHCPlineaP)
				select 	b.DEid, 
						b.RHAid, 
						c.RHTid, 
						a.Ecodigo, 
						<!---- ==== Para la fecha desde toma la mayor entre la fecha desde de la accion masiva y la fecha desde de la linea del tiempo ==== ---->
						case when d.LTdesde <  a.RHAfdesde then  a.RHAfdesde else d.LTdesde end as RHAfdesde,
						<!---- ==== Para la fecha hasta toma la menor entre la fecha hasta de la accion masiva y la fecha hasta de la linea del tiempo ==== ---->
						case when d.LThasta >  a.RHAfhasta then  a.RHAfhasta else d.LThasta end as RHAfhasta,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#LB_AccionRegistroAccionMasiva#">,
					  <!---- 'Acción generada por Registro de Acciones de Personal Masiva', ---->
					   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
					   '00', 
					   coalesce(b.Tcodigo, d.Tcodigo),
					   coalesce(b.RVid, d.RVid),
					   d.RHJid,
					   coalesce(b.Dcodigo, d.Dcodigo),
					   coalesce(b.Ocodigo, d.Ocodigo),
					   coalesce(b.RHCPlinea, d.RHCPlinea),
					   d.RHPid,
					   coalesce(b.RHPcodigo, d.RHPcodigo),
					   d.LTsalario,
					   coalesce(b.RHAporc, d.LTporcplaza),
					   coalesce(b.RHAporcsal, d.LTporcsal),
					   null as Mcodigo, 
					   (case when e.RHMPnegociado is not null and e.RHMPnegociado = 'N' then 1 else 0 end) as Indicador_de_Negociado, 
					   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHTipoAplicacion#">
						,d.RHPcodigoAlt,d.RHCPlineaP
				from RHAccionesMasiva a
					inner join RHEmpleadosAccionMasiva b
						on b.RHAid = a.RHAid
						and b.RHEAMreconocido = 1
					inner join RHTAccionMasiva c
						on c.RHTAid = a.RHTAid
					inner join LineaTiempo d
						on d.DEid = b.DEid
						and a.RHAfdesde between d.LTdesde and d.LThasta
					left outer join RHLineaTiempoPlaza e
						on e.RHPid = d.RHPid
						and a.RHAfdesde between e.RHLTPfdesde and e.RHLTPfhasta
				where a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAid#">
			<cf_dbidentity1 datasource="#Arguments.Conexion#" verificar_transaccion="false">
			</cfquery>
			<cf_dbidentity2 datasource="#Arguments.Conexion#" name="insAcciones" verificar_transaccion="false">	
		</cfif>
		
		<!--- 
			Actualizar el campo de vacaciones en caso de que la acción masiva sea de tipo vacaciones 
			Se calcula obteniendo sumando las siguientes cantidades
				  días habiles por semana multiplicado por la cantidad de semanas dentro del rango de fechas
				+ dias restantes que no completaron una semana
				- cantidad de feriados que caen en día laboral
		--->
		<!---<cf_dump var="#rsAccionMasiva.RHTcomportam#">--->
		<cfif rsAccionMasiva.RHTcomportam EQ 3>
			<cfquery name="rsObtienefechasAccion" datasource="#Arguments.conexion#">
				select DLfvigencia as FechaIni, DLffin as FechaFin, a.Ecodigo, a.Ocodigo
				from RHAcciones a
				where a.RHAid = #Arguments.RHAid#
			</cfquery>
	
			<cfset LvarFechaFin = rsObtienefechasAccion.FechaFin>
			<cfset LvarFechaIni = rsObtienefechasAccion.FechaIni>
			<cfset LvarFechaCnt = rsObtienefechasAccion.FechaIni>
			<cfset LvarEcodigo = rsObtienefechasAccion.Ecodigo>
			<cfset LvarOcodigo = rsObtienefechasAccion.Ocodigo>
			<cfquery name="rsObtieneDiasJornada" datasource="#Arguments.conexion#">
				select 
					b.RHJsun,
					b.RHJmon,
					b.RHJtue,
					b.RHJwed,
					b.RHJthu,
					b.RHJfri,
					b.RHJsat
				from RHAcciones a
					inner join RHJornadas b
					on b.RHJid = a.RHJid
				where a.RHAid = #Arguments.RHAid#
			</cfquery>

			<cfset LvarDiasJornada = ArrayNew(1)>
			<cfset ArrayAppend(LvarDiasJornada, rsObtieneDiasJornada.RHJsun)>
			<cfset ArrayAppend(LvarDiasJornada, rsObtieneDiasJornada.RHJmon)>
			<cfset ArrayAppend(LvarDiasJornada, rsObtieneDiasJornada.RHJtue)>
			<cfset ArrayAppend(LvarDiasJornada, rsObtieneDiasJornada.RHJwed)>
			<cfset ArrayAppend(LvarDiasJornada, rsObtieneDiasJornada.RHJthu)>
			<cfset ArrayAppend(LvarDiasJornada, rsObtieneDiasJornada.RHJfri)>
			<cfset ArrayAppend(LvarDiasJornada, rsObtieneDiasJornada.RHJsat)>

			<cfset LvarDiasVacaciones = 0>

			<cfloop condition="DateDiff('d',LvarFechaCnt,LvarFechaFin) GTE 0">
				<cfset LvarDiaSemana = datepart("w", LvarFechaCnt)>
				<cfif LvarDiasJornada[LvarDiaSemana] EQ 1>
					<!--- Dia Laboral --->
					<cfquery name="rsFeriados1" datasource="#Arguments.conexion#">
						select 1 as Cantidad
						from RHFeriados f1
						where f1.Ecodigo = #LvarEcodigo#
						  and f1.RHFfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFechaCnt#">
						  and f1.RHFregional = 0
					</cfquery>
					<cfquery name="rsFeriados2" datasource="#Arguments.conexion#">
						select 1 as Cantidad
						from RHFeriados f1
							inner join RHDFeriados f2
							on f2.RHFid = f1.RHFid
							and f2.Ecodigo = #LvarEcodigo# 
							and f2.Ocodigo = #LvarOcodigo#
						where f1.Ecodigo = #LvarEcodigo#
						  and f1.RHFfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFechaCnt#">
						  and f1.RHFregional = 1
					</cfquery>
					<cfif rsFeriados1.recordcount EQ 0 and rsFeriados2.recordcount EQ 0>
						<cfset LvarDiasVacaciones = LvarDiasVacaciones + 1>
					</cfif>
				</cfif>
				<cfset LvarFechaCnt = dateadd("d", 1, LvarFechaCnt)>
			</cfloop>

			<cfquery name="updVacaciones" datasource="#Arguments.conexion#">
				update RHAcciones set RHAvdisf = #LvarDiasVacaciones#
				where RHAid = #Arguments.RHAid#
			</cfquery>
		</cfif>
		
		<!--- Insertar los componentes de los empleados siempre y cuando no fueron marcados para borrar dentro de la acción masiva --->
	
		<cfquery name="insComponentes" datasource="#Arguments.conexion#">
			insert into RHDAcciones (RHAlinea, CSid, RHDAtabla, RHDAunidad, RHDAmontobase, RHDAmontores, Usucodigo, Ulocalizacion, BMUsucodigo)
			select a.RHAlinea, c.CSid, c.DLTtabla, 
				   coalesce(c.DLTunidades, 1.00), 
				   case 
						when d.RHMCcomportamiento is not null and d.RHMCcomportamiento = 2 
						then round(coalesce(c.DLTmonto, 0.00) / coalesce(c.DLTunidades, 1.00), 2) * 100
                        when c.DLTunidades = 0
                        then 0
						else round(coalesce(c.DLTmonto, 0.00) / coalesce(c.DLTunidades, 1.00), 2)
				   end as DLTmontobase,
				   coalesce(c.DLTmonto, 0.00), 
				   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
				   '00',
				   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
			from RHAcciones a
				inner join LineaTiempo b
					on b.DEid = a.DEid
					and a.DLfvigencia between b.LTdesde and b.LThasta
				inner join DLineaTiempo c
					on c.LTid = b.LTid
				left outer join RHMetodosCalculo d
					on d.CSid = c.CSid
					and a.DLfvigencia between d.RHMCfecharige and d.RHMCfechahasta
					and d.RHMCestadometodo = 1
			where a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAid#">
			and not exists (
				select 1
				from RHDAcciones x
				where x.RHAlinea = a.RHAlinea
				and x.CSid = c.CSid
			)
			<cfif rsAccionMasiva.RHTAccomp EQ 1>
				and not exists (
					select 1
					from RHComponentesAccionM x
					where x.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAid#">
					and x.RHCAMteliminar = 1
					and x.CSid = c.CSid
				)
			</cfif>
		</cfquery>

		<!--- Actualizar los componentes según lo indicado en la acción masiva en caso de que esta permita modificar componentes --->
		<!--- La modificación de componentes se comporta como una acción de tipo aumento, sin embargo permite no solo se tramitan aumentos --->
		<cfif rsAccionMasiva.RHTAccomp EQ 1>
			<!--- Modificar los componentes definidos en la acción masiva --->
			<cfquery name="updComponentes2" datasource="#Arguments.conexion#">
				update RHDAcciones set
					RHDAunidad = (	select 	case 
												when c.CSusatabla = 0 then 1.00
												when d.RHMCcomportamiento is not null and d.RHMCcomportamiento = 3 
												and (c.CSusatabla = 1 or c.CSusatabla = 2) then coalesce(k.RHDAunidad, 1.00) + coalesce(b.RHCAMvmodificar, 0.00)
												else k.RHDAunidad
											end
									from RHDAcciones k
										inner join RHAcciones a
											on a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAid#">
											and a.RHAlinea = k.RHAlinea
										inner join RHComponentesAccionM b
											on b.RHCAMtmodificar = 1
											and b.RHCAMmodificars = 0
											and b.RHAid = a.RHAid
											and b.CSid = k.CSid
										inner join ComponentesSalariales c
											on c.CSid = b.CSid
										left outer join RHMetodosCalculo d
											on d.CSid = c.CSid
											and a.DLfvigencia between d.RHMCfecharige and d.RHMCfechahasta
											and d.RHMCestadometodo = 1 ),
					
					RHDAmontobase = ( 	select 	case 
													when c.CSusatabla = 0 then coalesce(k.RHDAmontores, 0.00) + coalesce(b.RHCAMvmodificar, 0.00)
													else k.RHDAmontobase
												end
										from RHDAcciones k
											inner join RHAcciones a
												on a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAid#">
												and a.RHAlinea = k.RHAlinea
											inner join RHComponentesAccionM b
												on b.RHCAMtmodificar = 1
												and b.RHCAMmodificars = 0
												and b.RHAid = a.RHAid
												and b.CSid = k.CSid
											inner join ComponentesSalariales c
												on c.CSid = b.CSid
											left outer join RHMetodosCalculo d
												on d.CSid = c.CSid
												and a.DLfvigencia between d.RHMCfecharige and d.RHMCfechahasta
												and d.RHMCestadometodo = 1 ),
												
					RHDAmontores = (	select 	case 
													when c.CSusatabla = 0 then coalesce(k.RHDAmontores, 0.00) + coalesce(b.RHCAMvmodificar, 0.00)
													else k.RHDAmontores
												end
										from RHDAcciones k
											inner join RHAcciones a
												on a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAid#">
												and a.RHAlinea = k.RHAlinea
											inner join RHComponentesAccionM b
												on b.RHCAMtmodificar = 1
												and b.RHCAMmodificars = 0
												and b.RHAid = a.RHAid
												and b.CSid = k.CSid
											inner join ComponentesSalariales c
												on c.CSid = b.CSid
											left outer join RHMetodosCalculo d
												on d.CSid = c.CSid
												and a.DLfvigencia between d.RHMCfecharige and d.RHMCfechahasta
												and d.RHMCestadometodo = 1 ),
											
					Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
				
				where exists ( 	select 1 
								from RHDAcciones k
									inner join RHAcciones a
										on a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAid#">
										and a.RHAlinea = k.RHAlinea
									inner join RHComponentesAccionM b
										on b.RHCAMtmodificar = 1
										and b.RHCAMmodificars = 0
										and b.RHAid = a.RHAid
										and b.CSid = k.CSid
									inner join ComponentesSalariales c
										on c.CSid = b.CSid
									left outer join RHMetodosCalculo d
										on d.CSid = c.CSid
										and a.DLfvigencia between d.RHMCfecharige and d.RHMCfechahasta
										and d.RHMCestadometodo = 1 )
			</cfquery>

			<!--- Sustituir los componentes definidos en la acción masiva --->
			<cfquery name="updComponentes3" datasource="#Arguments.conexion#">
				update RHDAcciones set
					RHDAunidad = (	select	case 
												when c.CSusatabla = 0 then 1.00
												when d.RHMCcomportamiento is not null and d.RHMCcomportamiento = 3 and (c.CSusatabla = 1 or c.CSusatabla = 2) then coalesce(b.RHCAMvmodificar, 0.00)
												else k.RHDAunidad
											end
									from RHDAcciones k
										inner join RHAcciones a
											on a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAid#">
											and a.RHAlinea = k.RHAlinea
										inner join RHComponentesAccionM b
											on b.RHCAMtmodificar = 1
											and b.RHCAMmodificars = 1
											and b.RHAid = a.RHAid
											and b.CSid = k.CSid
										inner join ComponentesSalariales c
											on c.CSid = b.CSid
										left outer join RHMetodosCalculo d
											on d.CSid = c.CSid
											and a.DLfvigencia between d.RHMCfecharige and d.RHMCfechahasta
											and d.RHMCestadometodo = 1 ),
											
					RHDAmontobase =	(	select	case 
													when c.CSusatabla = 0 then coalesce(b.RHCAMvmodificar, 0.00)
													else k.RHDAmontobase
												end
										from RHDAcciones k
											inner join RHAcciones a
												on a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAid#">
												and a.RHAlinea = k.RHAlinea
											inner join RHComponentesAccionM b
												on b.RHCAMtmodificar = 1
												and b.RHCAMmodificars = 1
												and b.RHAid = a.RHAid
												and b.CSid = k.CSid
											inner join ComponentesSalariales c
												on c.CSid = b.CSid
											left outer join RHMetodosCalculo d
												on d.CSid = c.CSid
												and a.DLfvigencia between d.RHMCfecharige and d.RHMCfechahasta
												and d.RHMCestadometodo = 1),
												
					RHDAmontores = (	select	case 
													when c.CSusatabla = 0 then coalesce(b.RHCAMvmodificar, 0.00)								
													else k.RHDAmontores
												end
										from RHDAcciones k
											inner join RHAcciones a
												on a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAid#">
												and a.RHAlinea = k.RHAlinea
											inner join RHComponentesAccionM b
												on b.RHCAMtmodificar = 1
												and b.RHCAMmodificars = 1
												and b.RHAid = a.RHAid
												and b.CSid = k.CSid
											inner join ComponentesSalariales c
												on c.CSid = b.CSid
											left outer join RHMetodosCalculo d
												on d.CSid = c.CSid
												and a.DLfvigencia between d.RHMCfecharige and d.RHMCfechahasta
												and d.RHMCestadometodo = 1),
												
					Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
				where exists (	select 1 
								from RHDAcciones k
									inner join RHAcciones a
										on a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAid#">
										and a.RHAlinea = k.RHAlinea
									inner join RHComponentesAccionM b
										on b.RHCAMtmodificar = 1
										and b.RHCAMmodificars = 1
										and b.RHAid = a.RHAid
										and b.CSid = k.CSid
									inner join ComponentesSalariales c
										on c.CSid = b.CSid
									left outer join RHMetodosCalculo d
										on d.CSid = c.CSid
										and a.DLfvigencia between d.RHMCfecharige and d.RHMCfechahasta
										and d.RHMCestadometodo = 1 )
			</cfquery>

			<!--- Agregar los componentes definidos en la acción masiva --->
			<cfquery name="updComponentes1" datasource="#Arguments.conexion#">
				insert into RHDAcciones (RHAlinea, CSid, RHDAunidad, RHDAmontobase, RHDAmontores, Usucodigo, Ulocalizacion, BMUsucodigo)
				select a.RHAlinea, c.CSid, 
					   case 
					   		when c.CSusatabla = 0 then 1.00
					   		when d.RHMCcomportamiento is not null and d.RHMCcomportamiento = 3 and (c.CSusatabla = 1 or c.CSusatabla = 2) then coalesce(b.RHCAMvagregar, 1.00)
							else 1.00
					   end as unidades,
					   case 
					   		when c.CSusatabla = 0 then coalesce(b.RHCAMvagregar, 0.00)
					
							else coalesce(b.RHCAMvagregar, 0.00)
					   end as montobase,
					   case 
					   		when c.CSusatabla = 0 then coalesce(b.RHCAMvagregar, 0.00)
		
							else coalesce(b.RHCAMvagregar, 0.00)
					   end as monto,
					   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					   '00',
					   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
				from RHAcciones a
					inner join RHComponentesAccionM b
						on b.RHCAMtagregar = 1
						and b.RHAid = a.RHAid
					inner join ComponentesSalariales c
						on c.CSid = b.CSid
					left outer join RHMetodosCalculo d
						on d.CSid = c.CSid
						and a.DLfvigencia between d.RHMCfecharige and d.RHMCfechahasta
						and d.RHMCestadometodo = 1
				where a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAid#">
				and not exists (
					select 1
					from RHDAcciones x
					where x.RHAlinea = a.RHAlinea
					and x.CSid = c.CSid
				)
			</cfquery>
			
		</cfif>

		<!--- Actualizar los montos de los componentes salariales únicamente si se usa estructura salarial y los componentes no son de monto fijo --->
		<cfif usaEstructuraSalarial>		
			<cfquery name="rsComponentes2" datasource="#Arguments.conexion#">
				select a.RHAlinea,
					   a.DLfvigencia,
					   b.RHDAlinea,
					   coalesce(a.DLffin,'61000101') as DLffin,
					   b.CSid,
					   a.DEid,
					   coalesce(a.RHCPlinea, 0) as RHCPlinea, 
					   coalesce(b.RHDAunidad, 1.00) as RHDAunidad, 
					   coalesce(b.RHDAmontobase, 0.00) as RHDAmontobase, 
					   coalesce(b.RHDAmontores, 0.00) as RHDAmontores,
					   a.Indicador_de_Negociado as negociado,RHDAmetodoC,
					   a.RHAporcsal,DLfvigencia as Fdesde,
					   c.CSdescripcion
				from RHAcciones a
					inner join RHDAcciones b
						on b.RHAlinea = a.RHAlinea
					inner join ComponentesSalariales c
						on c.CSid = b.CSid
				where a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAid#">
				  and c.CSusatabla <> 0
				order by a.RHAlinea, c.CSorden, c.CScodigo
			</cfquery>
	<cfloop query="rsComponentes2">			
	<!--- LINEAS DE TIEMPO QUE SE TIENEN QUE RECALCULAR --->
        <cfquery name="rsLTid" datasource="#conexion#">
       		select a.LTid
            from LineaTiempo a
            where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsComponentes2.DEid#">
              and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
              and ((a.LThasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsComponentes2.Fdesde#"> 
                  and a.LTdesde <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsComponentes2.DLffin#">) 
                  or (a.LTdesde <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsComponentes2.DLffin#"> 
                  and a.LThasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsComponentes2.Fdesde#">))
        </cfquery>
   	    <cfloop query="rsLTid">
			<!--- Recalcular todos los componentes --->
            <cfquery name="rsComp" datasource="#Session.DSN#">
                select c.DEid,a.LTid, a.CSid, a.DLTunidades, a.DLTmonto,
                       c.LTdesde,coalesce(c.LThasta,'61000101') as LThasta, c.RHCPlinea, LTporcsal,c.RHPcodigoAlt,coalesce(RHCPlineaP,0) as RHCPlineaP,a.DLTmetodoC
                from DLineaTiempo a
                    inner join ComponentesSalariales b
                        on b.CSid = a.CSid
                    inner join LineaTiempo c
                        on c.LTid = a.LTid
                        and c.Ecodigo = b.Ecodigo
                where a.LTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLTid.LTid#">
                  and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                order by b.CSorden, b.CScodigo, b.CSdescripcion
            </cfquery>
            <cfset Lvar_CatAlt = rsComp.RHCPlinea>
	
            <!--- VERIFICA SI LA ACCIÓN DEBE DE APLICAR UN PUESTO ALTERNO --->
            <cfquery name="rsAccion" datasource="#session.DSN#">
            	select RHPcodigoAlt
                from RHAcciones
                where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsComponentes2.RHAlinea#">
            </cfquery>
            <cfif rsAccion.RecordCount and LEN(TRIM(rsAccion.RHPcodigoAlt)) GT 0>
            	<cfset rsComp.RHPcodigoAlt = rsAccion.RHPcodigoAlt>
            </cfif>
		
           <!--- VERIFICAR SI TIENE UN PUESTO ALTERNO QUE CAMBIA LA CATEGORIA --->
            <cfset Lvar_RHTTid = 0>
            <cfset Lvar_RHMPPid = 0>
            <cfset Lvar_RHCid = 0>
            <cfif rsComp.RecordCount GT 0 and rsComp.RHPcodigoAlt GT 0>
                <cfquery name="rsCatPuestoAlt" datasource="#session.DSN#">
                    select RHCPlinea
                    from RHPuestos a
                    inner join RHMaestroPuestoP b
                        on b.RHMPPid = a.RHMPPid
                        and b.Ecodigo = a.Ecodigo
                    inner join RHCategoriasPuesto c
                        on c.RHMPPid = b.RHMPPid
                        and c.Ecodigo = b.Ecodigo
                    where RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsComp.RHPcodigoAlt#">
                      and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                </cfquery>
                <cfset Lvar_CatAlt = rsCatPuestoAlt.RHCPlinea>							

          	 <cfif isdefined('rsCatPuestoAlt') and rsCatPuestoAlt.RecordCount>
                    <cfset Lvar_CatAlt = rsCatPuestoAlt.RHCPlinea>
               <cfelseif isdefined ('rsComponentes2.RHCPlinea')>
                    <cfset Lvar_CatAlt = rsComponentes2.RHCPlinea>
				<cfelse>
					 <cfset Lvar_CatAlt =0>
                </cfif>
            </cfif>					
				<cfinvoke 
					 component="rh.Componentes.RH_EstructuraSalarial"
					 method="calculaComponente"
					 returnvariable="calculaComponenteRet">
					<cfinvokeargument name="CSid" value="#rsComponentes2.CSid#"/>
					<cfinvokeargument name="fecha" value="#rsComponentes2.DLfvigencia#"/>
					<cfinvokeargument name="fechah" value="#rsComponentes2.DLffin#"/>
					<cfinvokeargument name="DEid" value="#rsComponentes2.DEid#"/>
					<!---<cfinvokeargument name="RHCPlinea" value="#Lvar_CatAlt#"/>--->	
					 <cfinvokeargument name="PorcSalario" value="#rsComponentes2.RHAporcsal#"/>
					<cfinvokeargument name="BaseMontoCalculo" value="0.00"/>
					<cfinvokeargument name="negociado" value="#rsComponentes2.negociado#"/>
					<cfinvokeargument name="Unidades" value="#rsComponentes2.RHDAunidad#"/>
					<cfinvokeargument name="MontoBase" value="#rsComponentes2.RHDAmontobase#"/>
					<cfinvokeargument name="Monto" value="#rsComponentes2.RHDAmontores#"/>
					<cfinvokeargument name="Metodo" value="#rsComponentes2.RHDAmetodoC#"/>
					<cfinvokeargument name="TablaComponentes" value="RHDAcciones"/>
					<cfinvokeargument name="CampoLlaveTC" value="RHAlinea"/>
					<cfinvokeargument name="ValorLlaveTC" value="#rsComponentes2.RHAlinea#"/>
					<cfinvokeargument name="CampoMontoTC" value="RHDAmontores"/>
                    <cfinvokeargument name="RHAlinea" value="#rsComponentes2.RHAlinea#"/>
				</cfinvoke>
			
				
				Componente Salarial : <cfdump var="#rsComponentes2.CSdescripcion#"><br>
				Unidades<cfset unidades = calculaComponenteRet.Unidades><cfdump var="#LSNumberFormat(unidades,'0.00')#"><br>
				MontoBases<cfset montobase = calculaComponenteRet.MontoBase><cfdump var="#LSNumberFormat(montobase,',0.00')#"><br>
				Monto<cfset monto = calculaComponenteRet.Monto><cfdump var="#LSNumberFormat(monto,',0.00')#"><br>
				
				<br>
				<br>
				<br>

				<cfif Len(Trim(unidades)) EQ 0 or Len(Trim(montobase)) EQ 0 or Len(Trim(monto)) EQ 0>
					<cf_throw message="#MSG_AccionNoGenerada#"  errorCode="12080">
				</cfif>
				
				<cfquery name="ABC_RHAcciones" datasource="#Session.DSN#">
					update RHDAcciones
					   set RHDAunidad 	= <cfqueryparam cfsqltype="cf_sql_float" value="#calculaComponenteRet.Unidades#">,
						   RHDAmontobase= <cfqueryparam cfsqltype="cf_sql_money" value="#calculaComponenteRet.MontoBase#">,
						   RHDAmontores = <cfqueryparam cfsqltype="cf_sql_money" value="#calculaComponenteRet.Monto#">,
						   RHDAmetodoC 	= <cfqueryparam cfsqltype="cf_sql_char" value="#calculaComponenteRet.Metodo#">,
						   BMUsucodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
						   BMfechamodif = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					 where RHDAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsComponentes2.RHDAlinea#">
				</cfquery>
	
			</cfloop>
		</cfloop>
        <cfelse> <!---SML. Modificacion para que se pueda visualizar la informacion cuando no tiene una Estructura Salarial--->
        	<cfquery name="rsComponentes2" datasource="#Arguments.conexion#">
				select a.RHAlinea,
					   a.DLfvigencia,
					   b.RHDAlinea,
					   coalesce(a.DLffin,'61000101') as DLffin,
					   b.CSid,
					   a.DEid,
					   coalesce(a.RHCPlinea, 0) as RHCPlinea, 
					   coalesce(b.RHDAunidad, 1.00) as RHDAunidad, 
					   coalesce(b.RHDAmontobase, 0.00) as RHDAmontobase, 
					   coalesce(b.RHDAmontores, 0.00) as RHDAmontores,
					   a.Indicador_de_Negociado as negociado,RHDAmetodoC,
					   a.RHAporcsal,DLfvigencia as Fdesde,
					   c.CSdescripcion
				from RHAcciones a
					inner join RHDAcciones b
						on b.RHAlinea = a.RHAlinea
					inner join ComponentesSalariales c
						on c.CSid = b.CSid
				where a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAid#">
				  and c.CSusatabla <> 0
				order by a.RHAlinea, c.CSorden, c.CScodigo
			</cfquery>
	<cfloop query="rsComponentes2">			
	<!--- LINEAS DE TIEMPO QUE SE TIENEN QUE RECALCULAR --->
        <cfquery name="rsLTid" datasource="#conexion#">
       		select a.LTid
            from LineaTiempo a
            where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsComponentes2.DEid#">
              and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
              and ((a.LThasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsComponentes2.Fdesde#"> 
                  and a.LTdesde <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsComponentes2.DLffin#">) 
                  or (a.LTdesde <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsComponentes2.DLffin#"> 
                  and a.LThasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsComponentes2.Fdesde#">))
        </cfquery>
   	    <cfloop query="rsLTid">
			<!--- Recalcular todos los componentes --->
            <cfquery name="rsComp" datasource="#Session.DSN#">
                select c.DEid,a.LTid, a.CSid, a.DLTunidades, a.DLTmonto,
                       c.LTdesde,coalesce(c.LThasta,'61000101') as LThasta, c.RHCPlinea, LTporcsal,c.RHPcodigoAlt,coalesce(RHCPlineaP,0) as RHCPlineaP,a.DLTmetodoC
                from DLineaTiempo a
                    inner join ComponentesSalariales b
                        on b.CSid = a.CSid
                    inner join LineaTiempo c
                        on c.LTid = a.LTid
                        and c.Ecodigo = b.Ecodigo
                where a.LTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLTid.LTid#">
                  and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                order by b.CSorden, b.CScodigo, b.CSdescripcion
            </cfquery>
            <cfset Lvar_CatAlt = rsComp.RHCPlinea>
	
            <!--- VERIFICA SI LA ACCIÓN DEBE DE APLICAR UN PUESTO ALTERNO --->
            <cfquery name="rsAccion" datasource="#session.DSN#">
            	select RHPcodigoAlt
                from RHAcciones
                where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsComponentes2.RHAlinea#">
            </cfquery>
            <cfif rsAccion.RecordCount and LEN(TRIM(rsAccion.RHPcodigoAlt)) GT 0>
            	<cfset rsComp.RHPcodigoAlt = rsAccion.RHPcodigoAlt>
            </cfif>
		
           <!--- VERIFICAR SI TIENE UN PUESTO ALTERNO QUE CAMBIA LA CATEGORIA --->
            <cfset Lvar_RHTTid = 0>
            <cfset Lvar_RHMPPid = 0>
            <cfset Lvar_RHCid = 0>
            <cfif rsComp.RecordCount GT 0 and rsComp.RHPcodigoAlt GT 0>
                <cfquery name="rsCatPuestoAlt" datasource="#session.DSN#">
                    select RHCPlinea
                    from RHPuestos a
                    inner join RHMaestroPuestoP b
                        on b.RHMPPid = a.RHMPPid
                        and b.Ecodigo = a.Ecodigo
                    inner join RHCategoriasPuesto c
                        on c.RHMPPid = b.RHMPPid
                        and c.Ecodigo = b.Ecodigo
                    where RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsComp.RHPcodigoAlt#">
                      and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                </cfquery>
                <cfset Lvar_CatAlt = rsCatPuestoAlt.RHCPlinea>							

          	 <cfif isdefined('rsCatPuestoAlt') and rsCatPuestoAlt.RecordCount>
                    <cfset Lvar_CatAlt = rsCatPuestoAlt.RHCPlinea>
               <cfelseif isdefined ('rsComponentes2.RHCPlinea')>
                    <cfset Lvar_CatAlt = rsComponentes2.RHCPlinea>
				<cfelse>
					 <cfset Lvar_CatAlt =0>
                </cfif>
            </cfif>					
				<cfinvoke 
					 component="rh.Componentes.RH_SinEstructuraSalarial"
					 method="calculaComponente"
					 returnvariable="calculaComponenteRet">
					<cfinvokeargument name="CSid" value="#rsComponentes2.CSid#"/>
					<cfinvokeargument name="fecha" value="#rsComponentes2.DLfvigencia#"/>
					<cfinvokeargument name="fechah" value="#rsComponentes2.DLffin#"/>
					<cfinvokeargument name="DEid" value="#rsComponentes2.DEid#"/>
					<!---<cfinvokeargument name="RHCPlinea" value="#Lvar_CatAlt#"/>--->	
					 <cfinvokeargument name="PorcSalario" value="#rsComponentes2.RHAporcsal#"/>
					<cfinvokeargument name="BaseMontoCalculo" value="0.00"/>
					<cfinvokeargument name="negociado" value="#rsComponentes2.negociado#"/>
					<cfinvokeargument name="Unidades" value="#rsComponentes2.RHDAunidad#"/>
					<cfinvokeargument name="MontoBase" value="#rsComponentes2.RHDAmontobase#"/>
					<cfinvokeargument name="Monto" value="#rsComponentes2.RHDAmontores#"/>
					<cfinvokeargument name="Metodo" value="#rsComponentes2.RHDAmetodoC#"/>
					<cfinvokeargument name="TablaComponentes" value="RHDAcciones"/>
					<cfinvokeargument name="CampoLlaveTC" value="RHAlinea"/>
					<cfinvokeargument name="ValorLlaveTC" value="#rsComponentes2.RHAlinea#"/>
					<cfinvokeargument name="CampoMontoTC" value="RHDAmontores"/>
                    <cfinvokeargument name="RHAlinea" value="#rsComponentes2.RHAlinea#"/>
				</cfinvoke>
			
				
				Componente Salarial : <cfdump var="#rsComponentes2.CSdescripcion#"><br>
				Unidades<cfset unidades = calculaComponenteRet.Unidades><cfdump var="#LSNumberFormat(unidades,'0.00')#"><br>
				MontoBases<cfset montobase = calculaComponenteRet.MontoBase><cfdump var="#LSNumberFormat(montobase,',0.00')#"><br>
				Monto<cfset monto = calculaComponenteRet.Monto><cfdump var="#LSNumberFormat(monto,',0.00')#"><br>
				
				<br>
				<br>
				<br>

				<cfif Len(Trim(unidades)) EQ 0 or Len(Trim(montobase)) EQ 0 or Len(Trim(monto)) EQ 0>
					<cf_throw message="#MSG_AccionNoGenerada#"  errorCode="12080">
				</cfif>
				
				<cfquery name="ABC_RHAcciones" datasource="#Session.DSN#">
					update RHDAcciones
					   set RHDAunidad 	= <cfqueryparam cfsqltype="cf_sql_float" value="#calculaComponenteRet.Unidades#">,
						   RHDAmontobase= <cfqueryparam cfsqltype="cf_sql_money" value="#calculaComponenteRet.MontoBase#">,
						   RHDAmontores = <cfqueryparam cfsqltype="cf_sql_money" value="#calculaComponenteRet.Monto#">,
						   RHDAmetodoC 	= <cfqueryparam cfsqltype="cf_sql_char" value="#calculaComponenteRet.Metodo#">,
						   BMUsucodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
						   BMfechamodif = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					 where RHDAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsComponentes2.RHDAlinea#">
				</cfquery>
	
			</cfloop>
		</cfloop>
		</cfif>
		
		<!------------------------------------- CALCULO DE CONCEPTOS DE PAGO -------------------------------------->
		<!--- Procesamiento de los Conceptos de Pago --->
		<cfquery name="rsConceptos2" datasource="#Arguments.conexion#">
			select a.DLfvigencia, 
				   a.DLffin, 
				   a.DEid, 
				   a.Ecodigo, 
				   a.RHTid, 
				   a.RHAlinea, 
				   coalesce(a.RHJid, 0) as RHJid, 
				   c.CIid, 
				   c.CIcantidad, c.CIrango, c.CItipo, c.CIcalculo, c.CIdia, c.CImes, 
				   CIsprango, coalesce(CIspcantidad,0) as CIspcantidad, coalesce(CImescompleto,0) as CImescompleto
			from RHAcciones a, ConceptosTipoAccion b, CIncidentesD c
			where a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAid#">
			and a.RHTid = b.RHTid
			and b.CIid = c.CIid
		</cfquery>
		
		<!---
		<cflog time="yes" file="logyu" text="-------- Cantidad concepto de pago: #rsConceptos2.recordCount# -------">
		--->

		<cfloop query="rsConceptos2">
			<!---
			<cflog time="yes" file="logyu" text="-------- Procesando concepto de pago #rsConceptos2.RHAlinea#:#rsConceptos2.DEid#:#rsConceptos2.CIid#-------">
			--->
		
			<cfset FVigencia = LSDateFormat(rsConceptos2.DLfvigencia, 'DD/MM/YYYY')>
			<cfif Len(Trim(rsConceptos2.DLffin))>
				<cfset FFin = LSDateFormat(rsConceptos2.DLffin, 'DD/MM/YYYY')>
			<cfelse>
				<cfset FFin = '01/01/6100'>
			</cfif>
			<!---
			<cflog time="yes" file="logyu" text="Inicio get_presets">
			--->
			<cfset current_formulas = rsConceptos2.CIcalculo>
            <cfset presets_text = RH_Calculadora.get_presets(CreateDate(ListGetAt(FVigencia,3,'/'), ListGetAt(FVigencia,2,'/'), ListGetAt(FVigencia,1,'/')),
                                       CreateDate(ListGetAt(FFin,3,'/'), ListGetAt(FFin,2,'/'), ListGetAt(FFin,1,'/')),
                                       rsConceptos2.CIcantidad,
                                       rsConceptos2.CIrango,
                                       rsConceptos2.CItipo,
                                       rsConceptos2.DEid,
                                       rsConceptos2.RHJid,
                                       rsConceptos2.Ecodigo,
                                       rsConceptos2.RHTid,
                                       rsConceptos2.RHAlinea,
                                       rsConceptos2.CIdia,
                                       rsConceptos2.CImes,
                                       "", <!--- Tcodigo solo se requiere si no va RHAlinea--->
                                       FindNoCase('SalarioPromedio', current_formulas),<!---  optimizacion - SalarioPromedio es el calculo mas pesado--->
                                       true,
                                       "RHcalMasivo_PagosEmpleado",
                                        FindNoCase('DiasRealesCalculoNomina', current_formulas) <!--- optimizacion - DiasRealesCalculoNomina es el segundo calculo mas pesado--->
                                        , 0
                                        , '' 
                                        ,rsConceptos2.CIsprango
                                        ,rsConceptos2.CIspcantidad
                                        ,rsConceptos2.CImescompleto
                                       )>
            <cfset values = RH_Calculadora.calculate ( presets_text & ";" & current_formulas )>
            <cfset calc_error = RH_Calculadora.getCalc_error()>
			<!---
			<cflog time="yes" file="logyu" text="Fin get_presets">
			--->

			<cfif Not IsDefined("values")>
				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_NoEsPosibleRealizarElCalculo"
				Default="No es posible realizar el c&aacute;lculo"
				returnvariable="LB_NoEsPosibleRealizarElCalculo"/> 

				<cfif isdefined("presets_text")>
					<cf_throw message="#LB_NoEsPosibleRealizarElCalculo#&nbsp;#presets_text#&nbsp;#current_formulas#&nbsp#calc_error#" errorCode="1000">
				<cfelse>
					<cf_throw message="#LB_NoEsPosibleRealizarElCalculo#&nbsp;#calc_error#" errorCode="1000">
				</cfif>
			</cfif>
			 
			<cfquery name="updConceptos" datasource="#Arguments.conexion#">
				insert into RHConceptosAccion(RHAlinea, CIid, RHCAimporte, RHCAres, RHCAcant, CIcalculo)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConceptos2.RHAlinea#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConceptos2.CIid#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#values.get('importe').toString()#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#values.get('resultado').toString()#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#values.get('cantidad').toString()#">,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#presets_text & ';' & current_formulas#">
				)
			</cfquery> 

			<!--- Limpiar Tabla Temporal --->
			<cfquery datasource="#Arguments.conexion#">
				delete from RHcalMasivo_PagosEmpleado
				where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConceptos2.RHAlinea#">
				  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConceptos2.DEid#">
			</cfquery>
			<!---
			<cflog time="yes" file="logyu" text="-------- Tabla Temporal limpia -------">
			--->

		</cfloop>

		<!---
		<cflog time="yes" file="logyu" text="------- Fin Proceso generarAccionesMasivas ------------">
		--->

		<cfset error = 0>
		<cfreturn error>
	</cffunction>
	
	
	<cffunction name="aplicarAccionMasiva" access="public" output="true" returntype="numeric"  hint="Aplicación de Acción Masiva">
		<cfargument name="RHAid" type="numeric" required="yes" hint="Código de Acción Masiva">
		<cfargument name="Ecodigo" type="numeric" required="no" default="#Session.Ecodigo#" hint="Empresa">
		<cfargument name="conexion" type="string" required="no" default="#Session.DSN#" hint="cache">
		
		<cfsetting requesttimeout="84600">
		
		<cfquery name="rsAcciones" datasource="#Arguments.conexion#">
			select RHAlinea, c.RHTArespetarLT
			from RHAcciones a
				inner join RHAccionesMasiva b					
					on a.RHAid = b.RHAid			
				inner join RHTAccionMasiva c
					on b.RHTAid = c.RHTAid	
			where a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAid#">
			order by DEid, DLfvigencia
		</cfquery>
		
				
		<cftransaction>
			<cfloop query="rsAcciones">
				<cfinvoke component="rh.Componentes.RH_AplicaAccion" method="AplicaAccion" returnvariable="LvarResult">
					<cfinvokeargument name="Ecodigo" value="#Session.Ecodigo#"/> 
					<cfinvokeargument name="RHAlinea" value="#rsAcciones.RHAlinea#"/> 
					<cfinvokeargument name="Usucodigo" value="#Session.Usucodigo#"/> 
					<cfinvokeargument name="conexion" value="#Arguments.conexion#"/> 
					<!---<cfinvokeargument name="respetarLT" value="#rsAccionMasiva.RHTArespetarLT EQ 1#"/>--->
					<cfinvokeargument name="respetarLT" value="#rsAcciones.RHTArespetarLT EQ 1#"/>
					<cfinvokeargument name="validar" value="true"/>
					<cfinvokeargument name="debug" value="false"/> 
				</cfinvoke>
				
				<cfinvoke component="rh.Componentes.RH_AplicaAccion" method="AplicaAccion" returnvariable="LvarResult">
					<cfinvokeargument name="Ecodigo" value="#Session.Ecodigo#"/> 
					<cfinvokeargument name="RHAlinea" value="#rsAcciones.RHAlinea#"/> 
					<cfinvokeargument name="Usucodigo" value=" #Session.Usucodigo#"/> 
					<cfinvokeargument name="conexion" value="#Arguments.conexion#"/> 
					<!---<cfinvokeargument name="respetarLT" value="#rsAccionMasiva.RHTArespetarLT EQ 1#"/>--->
					<cfinvokeargument name="respetarLT" value="#rsAcciones.RHTArespetarLT EQ 1#"/>
					<cfinvokeargument name="validar" value="false"/> 
					<cfinvokeargument name="debug" value="false"/> 
				</cfinvoke>
			</cfloop>
		</cftransaction>		

		<!--- Actualizar el estado de la acción masiva --->
		<cfquery name="updAccion" datasource="#Arguments.conexion#">
			update RHAccionesMasiva set
				RHAaplicado = 1
			where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAid#">
		</cfquery>		
		
		<cfreturn 1>
		
	</cffunction>    
    
    <cffunction name="fnAltaAccionMasiva" access="public" returntype="numeric">
        <cfargument name="RHAcodigo" 		type="string" 	required="yes">
        <cfargument name="RHAdescripcion" 	type="string" 	required="yes">
        <cfargument name="RHAfdesde" 		type="string" 	required="yes">
        <cfargument name="RHTAid" 			type="numeric" 	required="no">
        <cfargument name="RHAfhasta" 		type="string" 	required="no">
        <cfargument name="RHCPlinea" 		type="numeric" 	required="no">
        <cfargument name="Tcodigo" 			type="string" 	required="no" default="">
        <cfargument name="RVid" 			type="numeric" 	required="no">
        <cfargument name="Ocodigo" 			type="numeric" 	required="no">
        <cfargument name="Dcodigo" 			type="numeric" 	required="no">
        <cfargument name="RHPcodigo" 		type="string" 	required="no" default="">
        <cfargument name="RHAporcsal" 		type="numeric" 	required="no">
        <cfargument name="RHJid" 			type="numeric" 	required="no">
        <cfargument name="RHAidliquida" 	type="numeric" 	required="no" default="0">
        <cfargument name="Ecodigo" 			type="numeric" 	required="no">
        <cfargument name="Usucodigo" 		type="numeric" 	required="no">
        <cfargument name="Conexion" 		type="string" 	required="no">
        
        <cfif not isdefined('Arguments.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
		<cfif not isdefined('Arguments.Usucodigo')>
        	<cfset Arguments.Usucodigo = session.Usucodigo>
        </cfif>
        <cfif not isdefined('Arguments.Conexion')>
        	<cfset Arguments.Conexion = session.dsn>
        </cfif>
        
        <cfif not isdefined('Arguments.RHAfhasta')>
        	<cfset Arguments.RHAfhasta = "01/01/6100">
        </cfif>
        <cfif not isdefined('Arguments.RHTAid')>
        	<cfset Arguments.RHTAid = "">
        </cfif>
        <cfif not isdefined('Arguments.RHCPlinea')>
        	<cfset Arguments.RHCPlinea = "">
        </cfif>
        <cfif not isdefined('Arguments.RVid')>
        	<cfset Arguments.RVid = "">
        </cfif>
        <cfif not isdefined('Arguments.Ocodigo')>
        	<cfset Arguments.Ocodigo = "">
        </cfif>
        <cfif not isdefined('Arguments.Dcodigo')>
        	<cfset Arguments.Dcodigo = "">
        </cfif>
        <cfif not isdefined('Arguments.RHAporcsal')>
        	<cfset Arguments.RHAporcsal = "">
        </cfif>
        <cfif not isdefined('Arguments.RHAporc')>
        	<cfset Arguments.RHAporc = "">
        </cfif>
        <cfif not isdefined('Arguments.RHJid')>
        	<cfset Arguments.RHJid = "">
        </cfif>
        
   		<cfquery name="rsInsert" datasource="#Arguments.Conexion#">
				insert into RHAccionesMasiva(RHTAid, RHAcodigo, RHAdescripcion, Ecodigo, RHAfdesde, RHAfhasta, RHCPlinea, Tcodigo, RVid, Ocodigo, Dcodigo, RHPcodigo, RHAporcsal, RHAporc, RHJid, RHAidliquida, RHAAnoreconocidos, RHAAnumerop, BMUsucodigo)
				values (
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.RHTAid#" voidnull>, 
					<cfqueryparam    cfsqltype="cf_sql_char"		value="#Arguments.RHAcodigo#">, 
					<cfqueryparam 	 cfsqltype="cf_sql_char" 		value="#Arguments.RHAdescripcion#">, 
					<cfqueryparam 	 cfsqltype="cf_sql_integer" 	value="#Arguments.Ecodigo#">, 
					<cfqueryparam 	 cfsqltype="cf_sql_timestamp" 	value="#LSParseDateTime(Arguments.RHAfdesde)#">, 
					<cfqueryparam 	 cfsqltype="cf_sql_timestamp" 	value="#LSParseDateTime(Arguments.RHAfhasta)#">, 
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.RHCPlinea#" 	voidnull>, 
                    <cf_jdbcquery_param cfsqltype="cf_sql_char" 	value="#Arguments.Tcodigo#" 	voidnull>, 
                    <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.RVid#" 		voidnull>, 
                    <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.Ocodigo#" 	voidnull>,
                    <cf_jdbcquery_param cfsqltype="cf_sql_integer" 	value="#Arguments.Dcodigo#" 	voidnull>, 
 					<cf_jdbcquery_param cfsqltype="cf_sql_char" 	value="#Arguments.RHPcodigo#" 	voidnull>, 
                   	<cf_jdbcquery_param cfsqltype="cf_sql_float" 	value="#Arguments.RHAporcsal#" 	voidnull>,
					<cf_jdbcquery_param cfsqltype="cf_sql_float" 	value="#Arguments.RHAporc#" 	voidnull>,
                    <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.RHJid#" 		voidnull>,
					<cfqueryparam 	 cfsqltype="cf_sql_bit" 		value="#Arguments.RHAidliquida#">,
					0, 0,
                    <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.Usucodigo#">
				)
				<cf_dbidentity1 datasource="#Arguments.Conexion#">
			</cfquery>
			<cf_dbidentity2 name="rsInsert" datasource="#Arguments.Conexion#">
		<cfreturn rsInsert.identity>
    </cffunction>
    
    <cffunction name="fnBajaAccionMasiva" access="public">
        <cfargument name="RHAid" 		type="numeric" 	required="yes">
        <cfargument name="Conexion" 	type="string" 	required="no">
        
        <cfif not isdefined('Arguments.Conexion')>
        	<cfset Arguments.Conexion = session.dsn>
        </cfif>
        <cfquery name="Anua" datasource="#Arguments.Conexion#">
			select RHTAanualidad 
			from RHAccionesMasiva a
				inner join RHTAccionMasiva b
				on b.RHTAid=a.RHTAid
			where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAid#">
		</cfquery>
		
		<cfif Anua.RHTAanualidad eq 1>
            <cfquery  name="reversaAnua" datasource="#Arguments.Conexion#">
                select DEid from EAnualidad
                where EAacum < 345
                and DEid in (select DEid from RHEmpleadosAccionMasiva where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAid#">)
                and DAtipoConcepto= 2
            </cfquery>
            <cfloop query="reversaAnua">
                <cfquery datasource="#Arguments.Conexion#">
                    update EAnualidad 
                                   set EAacum= (EAacum+360)
                            where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#reversaAnua.DEid#">
                            and DAtipoConcepto=2
                </cfquery>	
            </cfloop>
            <cfquery datasource="#Arguments.Conexion#">
                delete from DAnualidad where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAid#">
            </cfquery>
		</cfif>
		<cfquery datasource="#Arguments.Conexion#">
			delete from RHDAcciones
			where  exists (select 1
					from RHAcciones b
					where b.RHAlinea = RHDAcciones.RHAlinea
					and b.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAid#">
					)
		</cfquery>

		<cfquery datasource="#Arguments.Conexion#">
			delete from RHConceptosAccion
			where exists(select 1
						from RHAcciones b
						where b.RHAlinea = RHConceptosAccion.RHAlinea
						and b.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAid#">
						)
		</cfquery>
	
		<cfquery datasource="#Arguments.Conexion#">
			delete from RHAcciones
			where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAid#">
		</cfquery>
	
		<cfquery datasource="#Arguments.Conexion#">
			delete from RHEmpleadosAccionMasiva
			where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAid#">
		</cfquery>
	
		<cfquery datasource="#Arguments.Conexion#">
			delete from RHDepenAccionM
			where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAid#">
		</cfquery>

		<cfquery datasource="#Arguments.Conexion#">
			delete from RHPeriodosAccionesM
			where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAid#">
		</cfquery>

		<cfquery datasource="#Arguments.Conexion#">
			delete from RHComponentesAccionM
			where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAid#">
		</cfquery>

		<cfquery datasource="#Arguments.Conexion#">
			delete from RHAccionesMasiva
			where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAid#">
		</cfquery>
        
   		<cfquery datasource="#Arguments.Conexion#">
            delete from RHAccionesMasiva where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAid#">
		</cfquery>
    </cffunction>
    
    <cffunction name="fnGetAccionMasiva" access="public" returntype="query">
        <cfargument name="RHAid" 		type="numeric" 	required="no">
        <cfargument name="Tcodigo" 		type="string" 	required="no">
        <cfargument name="Ecodigo" 		type="numeric" 	required="no">
        <cfargument name="Conexion" 	type="string" 	required="no">
        
        <cfif not isdefined('Arguments.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
        <cfif not isdefined('Arguments.Conexion')>
        	<cfset Arguments.Conexion = session.dsn>
        </cfif>
        
   		<cfquery name="rsAM" datasource="#Arguments.Conexion#">
				select tam.RHTid, am.RHAid, am.RHTAid, RHAcodigo, RHAdescripcion, am.Ecodigo, RHAfdesde, RHAfhasta, RHCPlinea, Tcodigo, RVid, Ocodigo, Dcodigo, RHPcodigo, RHAporcsal, RHAporc, RHJid, RHAidliquida, RHAAnoreconocidos, RHAAnumerop, am.BMUsucodigo
                from RHAccionesMasiva am
           			inner join RHTAccionMasiva tam
                    	on tam.RHTAid = am.RHTAid
                where am.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Arguments.Ecodigo#">
                  and RHAaplicado = 0
                <cfif isdefined('Arguments.RHAid')>
                  and am.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.RHAid#">
                </cfif>
                <cfif isdefined('Arguments.Tcodigo')>
                  and (select count(1) from RHDepenAccionM dam where dam.RHAid = am.RHAid and dam.Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Tcodigo#">) > 0
				</cfif>
            </cfquery>
		<cfreturn rsAM>
    </cffunction>
    
    <cffunction name="fnAltaDependencia" access="public" returntype="numeric">
		<cfargument name="RHAid" 			type="numeric" 	required="yes">
        <cfargument name="DEid" 			type="numeric" 	required="no">
        <cfargument name="RHPcodigo" 		type="string" 	required="no" default="">
        <cfargument name="Dcodigo" 			type="numeric" 	required="no">
        <cfargument name="Ocodigo" 			type="numeric" 	required="no">
        <cfargument name="CFid" 			type="numeric" 	required="no">
        <cfargument name="RHTPid" 			type="numeric" 	required="no">
        <cfargument name="Fcorte" 			type="string" 	required="no" default="">
        <cfargument name="Tcodigo" 			type="string" 	required="no" default="">
        <cfargument name="Ecodigo" 			type="numeric" 	required="no">
        <cfargument name="Usucodigo" 		type="numeric" 	required="no">
        <cfargument name="Conexion" 		type="string" 	required="no">

        <cfif not isdefined('Arguments.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
		<cfif not isdefined('Arguments.Usucodigo')>
        	<cfset Arguments.Usucodigo = session.Usucodigo>
        </cfif>
        <cfif not isdefined('Arguments.Conexion')>
        	<cfset Arguments.Conexion = session.dsn>
        </cfif>
        
        <cfif not isdefined('Arguments.DEid')>
        	<cfset Arguments.DEid = "">
        </cfif>
        <cfif not isdefined('Arguments.Dcodigo')>
        	<cfset Arguments.Dcodigo = "">
        </cfif>
        <cfif not isdefined('Arguments.Ocodigo')>
        	<cfset Arguments.Ocodigo = "">
        </cfif>
        <cfif not isdefined('Arguments.CFid')>
        	<cfset Arguments.CFid = "">
        </cfif>
        <cfif not isdefined('Arguments.RHTPid')>
        	<cfset Arguments.RHTPid = "">
        </cfif>
        <cfif len(trim(Arguments.Fcorte)) gt 0>
        	<cfset Arguments.Fcorte = LSParseDateTime(Arguments.Fcorte)>
        </cfif>
        
   		<cfquery name="rsInsert" datasource="#Arguments.Conexion#">
			insert into RHDepenAccionM(RHAid, DEid, RHPcodigo, Dcodigo, Ocodigo, CFid, Ecodigo, BMUsucodigo, RHTPid, Fcorte, Tcodigo)
			values (
				<cfqueryparam 		cfsqltype="cf_sql_numeric" 		value="#Arguments.RHAid#">, 
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.DEid#" voidnull>, 
				<cf_jdbcquery_param cfsqltype="cf_sql_char" 	 	value="#Arguments.RHPcodigo#" voidnull>, 
				<cf_jdbcquery_param cfsqltype="cf_sql_integer" 		value="#Arguments.Dcodigo#" voidnull>, 
				<cf_jdbcquery_param cfsqltype="cf_sql_integer" 		value="#Arguments.Ocodigo#" voidnull>, 
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.CFid#" voidnull>, 
				<cfqueryparam 		cfsqltype="cf_sql_integer" 		value="#Arguments.Ecodigo#">,
				<cfqueryparam 		cfsqltype="cf_sql_numeric" 		value="#Arguments.Usucodigo#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.RHTPid#" voidnull>, 
				<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" 	value="#Arguments.Fcorte#" voidnull>,
                <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#Arguments.Tcodigo#" voidnull>
			)
        	<cf_dbidentity1 datasource="#Arguments.Conexion#">
        </cfquery>
        <cf_dbidentity2 name="rsInsert" datasource="#Arguments.Conexion#">
        
		<cfreturn rsInsert.identity>
    </cffunction>
    
    <cffunction name="fnBajaDependencia" access="public">
		<cfargument name="RHDAMid" 			type="numeric" 	required="no">
        <cfargument name="RHAid" 			type="numeric" 	required="no">
        <cfargument name="Ecodigo" 			type="numeric" 	required="no">
        <cfargument name="Conexion" 		type="string" 	required="no">

		<cfif not isdefined('Arguments.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
        <cfif not isdefined('Arguments.Conexion')>
        	<cfset Arguments.Conexion = session.dsn>
        </cfif>
        <cfif not isdefined('Arguments.RHDAMid') and not isdefined('Arguments.RHAid')>
        	<cfthrow message="Debe de pasar uno de estos 2 argumentos, RHDAMid y/o RHAid.">
        </cfif>
   		<cfquery datasource="#Arguments.Conexion#">
			delete from RHDepenAccionM
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
            <cfif isdefined('Arguments.RHDAMid')>
              and RHDAMid = <cfqueryparam 	cfsqltype="cf_sql_numeric" 		value="#Arguments.RHDAMid#">
           	</cfif>
          	<cfif isdefined('Arguments.RHAid')>
              and RHAid = <cfqueryparam 	cfsqltype="cf_sql_numeric" 		value="#Arguments.RHAid#">
           	</cfif>
        </cfquery>
    </cffunction>
    
    <cffunction name="fnGetDependencia" access="public" returntype="query">
		<cfargument name="RHAid" 			type="numeric" 	required="yes">
        <cfargument name="DEid" 			type="numeric" 	required="no">
        <cfargument name="RHPcodigo" 		type="string" 	required="no">
        <cfargument name="Dcodigo" 			type="numeric" 	required="no">
        <cfargument name="Ocodigo" 			type="numeric" 	required="no">
        <cfargument name="CFid" 			type="numeric" 	required="no">
        <cfargument name="RHTPid" 			type="numeric" 	required="no">
        <cfargument name="Fcorte" 			type="string" 	required="no">
        <cfargument name="Tcodigo" 			type="string" 	required="no">
        <cfargument name="Conexion" 		type="string" 	required="no">

        <cfif not isdefined('Arguments.Conexion')>
        	<cfset Arguments.Conexion = session.dsn>
        </cfif>
        
   		<cfquery name="rsDependencias" datasource="#Arguments.Conexion#">
			select RHAid, DEid, RHPcodigo, Dcodigo, Ocodigo, CFid, Ecodigo, BMUsucodigo, RHTPid, Fcorte, Tcodigo
			from RHDepenAccionM
            where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAid#">
           	<cfif isdefined('Arguments.DEid')>
            	and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
            </cfif>
            <cfif isdefined('Arguments.RHPcodigo')>
            	and RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.RHPcodigo#">
            </cfif>
            <cfif isdefined('Arguments.Dcodigo')>
            	and Dcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Dcodigo#">
            </cfif>
            <cfif isdefined('Arguments.Ocodigo')>
            	and Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ocodigo#">
            </cfif>
            <cfif isdefined('Arguments.CFid')>
            	and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CFid#">
            </cfif>
            <cfif isdefined('Arguments.RHTPid')>
            	and RHTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHTPid#">
            </cfif>
            <cfif isdefined('Arguments.Fcorte')>
            	and Fcorte = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Arguments.Fcorte)#">
            </cfif>
            <cfif isdefined('Arguments.Tcodigo')>
            	and Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Tcodigo#">
            </cfif>
        </cfquery>
        
		<cfreturn rsDependencias>
    </cffunction>
	
  	<cffunction name="fnAltaAccionMasivaComponente" access="public" returntype="numeric">
		<cfargument name="RHAid" 			type="numeric" 	required="yes">
        <cfargument name="CSid" 			type="numeric" 	required="yes">
        <cfargument name="RHCAMtagregar" 	type="binary" 	required="yes" default="0">
        <cfargument name="RHCAMtmodificar" 	type="binary" 	required="yes" default="0">
        <cfargument name="RHCAMmodificars" 	type="binary" 	required="yes" default="0">
        <cfargument name="RHCAMteliminar" 	type="binary" 	required="yes" default="0">
        <cfargument name="RHCAMvagregar" 	type="numeric" 	required="no"  default="0">
        <cfargument name="RHCAMvmodificar" 	type="numeric" 	required="no"  default="0">
        <cfargument name="Ecodigo" 			type="numeric" 	required="no">
        <cfargument name="Usucodigo" 		type="numeric" 	required="no">
        <cfargument name="Conexion" 		type="string" 	required="no">
        
        <cfif not isdefined('Arguments.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
		<cfif not isdefined('Arguments.Usucodigo')>
        	<cfset Arguments.Usucodigo = session.Usucodigo>
        </cfif>
        <cfif not isdefined('Arguments.Conexion')>
        	<cfset Arguments.Conexion = session.dsn>
        </cfif>
        
   		<cfquery name="rsInsert" datasource="#Arguments.Conexion#">
			insert into RHComponentesAccionM(RHAid, CSid, RHCAMtagregar, RHCAMtmodificar, RHCAMmodificars, RHCAMteliminar, RHCAMvagregar, RHCAMvmodificar, Ecodigo, BMUsucodigo)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAid#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CSid#">, 
				<cfqueryparam cfsqltype="cf_sql_bit" 	 value="#Arguments.RHCAMtagregar#">, 
				<cfqueryparam cfsqltype="cf_sql_bit" 	 value="#Arguments.RHCAMtmodificar#">, 
				<cfqueryparam cfsqltype="cf_sql_bit" 	 value="#Arguments.RHCAMmodificars#">, 
				<cfqueryparam cfsqltype="cf_sql_bit" 	 value="#Arguments.RHCAMteliminar#">, 
				<cfqueryparam cfsqltype="cf_sql_float" 	 value="#Arguments.RHCAMvagregar#">,
				<cfqueryparam cfsqltype="cf_sql_float" 	 value="#Arguments.RHCAMvmodificar#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
			)
        	<cf_dbidentity1 datasource="#Arguments.Conexion#">
        </cfquery>
        <cf_dbidentity2 name="rsInsert" datasource="#Arguments.Conexion#">
        
		<cfreturn rsInsert.identity>
    </cffunction>
    
    <cffunction name="fnGetTAccionMasiva" access="public" returntype="query">
		<cfargument name="RHTAid" 			type="numeric" 	required="no">
        <cfargument name="RHTcomportam" 	type="numeric" 	required="no">
        <cfargument name="Ecodigo" 			type="numeric" 	required="no">
        <cfargument name="Conexion" 		type="string" 	required="no">
        
        <cfif not isdefined('Arguments.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
        <cfif not isdefined('Arguments.Conexion')>
        	<cfset Arguments.Conexion = session.dsn>
        </cfif>
        
   		<cfquery name="rsTAccionesMasivas" datasource="#Arguments.Conexion#">
			select tam.RHTAid, tam.RHTid, tam.RHTAcodigo, tam.RHTAdescripcion
            from RHTAccionMasiva tam
            	<cfif isdefined('Arguments.RHTcomportam')>
            	inner join RHTipoAccion ta
                	on ta.RHTid = tam.RHTid
              	</cfif>
            where tam.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
            <cfif isdefined('Arguments.RHTcomportam')>
              and ta.RHTcomportam = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHTcomportam#">
           	</cfif>
            <cfif isdefined('Arguments.RHTAid')>
              and tam.RHTAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHTAid#">
           	</cfif>
        </cfquery>
		<cfreturn rsTAccionesMasivas>
    </cffunction>
    
    <cffunction name="fnBajaEmpleado" access="public">
		<cfargument name="RHEAMid" 			type="numeric" 	required="no">
        <cfargument name="RHAid" 			type="numeric" 	required="yes">
        <cfargument name="Conexion" 		type="string" 	required="no">

		<cfif not isdefined('Arguments.Conexion')>
        	<cfset Arguments.Conexion = session.dsn>
        </cfif>
		<cfquery datasource="#Arguments.Conexion#">
        	delete from RHConceptosAccion
            from RHEmpleadosAccionMasiva eam
            inner join RHAcciones a
                on a.DEid = eam.DEid
                and a.RHAid = eam.RHAid
            inner join RHConceptosAccion ca
                on ca.RHAlinea = a.RHAlinea
            where eam.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAid#">
            <cfif isdefined('Arguments.RHEAMid')>
                and eam.RHEAMid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHEAMid#">
            </cfif>  
        </cfquery> 	
         <cfquery datasource="#Arguments.Conexion#">
        	delete from RHDAcciones
            from RHEmpleadosAccionMasiva eam
            inner join RHAcciones a
            	on a.DEid = eam.DEid
                and a.RHAid = eam.RHAid
            inner join RHDAcciones da
            	on da.RHAlinea = a.RHAlinea
            where eam.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAid#">
			<cfif isdefined('Arguments.RHEAMid')>
                and eam.RHEAMid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHEAMid#">
            </cfif>
        </cfquery> 
		<cfquery datasource="#Arguments.Conexion#">
        	delete from RHAcciones 
            from RHEmpleadosAccionMasiva eam
            inner join RHAcciones a
            	on a.DEid = eam.DEid
                and a.RHAid = eam.RHAid
            where eam.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAid#">
			<cfif isdefined('Arguments.RHEAMid')>
                and eam.RHEAMid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHEAMid#">
            </cfif>
        </cfquery>
		<cfquery datasource="#Arguments.Conexion#">
            delete from RHEmpleadosAccionMasiva
            where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAid#">
			<cfif isdefined('Arguments.RHEAMid')>
                and RHEAMid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHEAMid#">
            </cfif>
		</cfquery>
    </cffunction>
    
    <cffunction name="fnGetEmpleados" access="public" returntype="query">
    	<cfargument name="RHAid" 			type="numeric" 	required="yes">
        <cfargument name="Conexion" 		type="string" 	required="no">
    	
    	<cfif not isdefined('Arguments.Conexion')>
        	<cfset Arguments.Conexion = session.dsn>
        </cfif>
        
        <cfquery name="rsEmpleados" datasource="#Arguments.Conexion#">
            select de.DEid, de.DEidentificacion, de.DEnombre, de.DEapellido1, de.DEapellido2
            from RHEmpleadosAccionMasiva eam
            	inner join DatosEmpleado de
                	on de.DEid = eam.DEid
            where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAid#">
              and RHEAMreconocido = 1
		</cfquery>
        
        <cfreturn rsEmpleados>
        
    </cffunction>
    
</cfcomponent>
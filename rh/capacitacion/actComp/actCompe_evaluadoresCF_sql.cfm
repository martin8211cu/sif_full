<!--- FUNCIONES UTILIZADAS --->
<cffunction name="getCentrosFuncionalesDependientes" returntype="query">
	<cfargument name="cfid" required="yes" type="numeric">
	<cfset nivel = 1>
	<cfquery name="rs1" datasource="#session.dsn#">
		select CFid, #nivel# as nivel, null as CFidresp
		from CFuncional
		where CFid = #arguments.cfid#
	</cfquery>
	<cfquery name="rs2" datasource="#session.dsn#">
		select CFid, CFidresp
		from CFuncional
		where Ecodigo = #session.Ecodigo#
	</cfquery>
	<cfloop condition="1 eq 1">
		<cfquery name="rs3" dbtype="query">
			select rs2.CFid, #nivel# + 1 as nivel, rs2.CFidresp
			from rs1, rs2
			where rs1.nivel = #nivel#
			   and rs2.CFidresp = rs1.cfid
		</cfquery>
		<cfif rs3.RecordCount gt 0>
			<cfset nivel = nivel + 1>
			<cfquery name="rs0" dbtype="query">
				select CFid, nivel, CFidresp from rs1
				union
				select CFid, nivel, CFidresp from rs3
			</cfquery>
			<cfquery name="rs1" dbtype="query">
				select * from rs0
			</cfquery>
		<cfelse>
			<cfbreak>
		</cfif>
	</cfloop>
	<cfreturn rs1>
</cffunction>
<cffunction name="processcf" returntype="string">
	<cfargument name="list" type="string">
	<cfset arr = ListToArray(list)>
	<cfset arrstr = ArrayNew(1)>
	<cfloop from="1" to="#ArrayLen(arr)#" index="i">
		<cfset cf = ListToArray(arr[i],'|')>
		<cfif cf[2] eq 1>
			<cfinvoke component="rh.Componentes.RH_Funciones" method="CFDependencias"
				CFid = "#cf[1]#"
				Nivel = 5
				returnvariable="Dependencias"/>
			<cfloop query="Dependencias">
				<cfset ArrayAppend(arrstr,cfid)>
			</cfloop>
		<cfelse>
			<cfset ArrayAppend(arrstr,cf[1])>
		</cfif>
	</cfloop>
	<cfreturn ArrayToList(arrstr)>
</cffunction>
<cfset vHabilitar = false>
<cfset vListaEmpleados = -1>
<!--- OBTENGO LOS DATOS DE LA RELACION --->
<cfquery name="rsDatosRelCal" datasource="#session.DSN#">
	select RHRCitems,RHRCestado
	from RHRelacionCalificacion
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
 	  and RHRCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#">
</cfquery>

<cfif isdefined('form.Generar')>
	<cftransaction >
	<!--- GENERA LA LISTA DE LOS CENTROS FUNCIONALES QUE SE VAN A TOMAR EN CUENTA
		NO TOMA EN CUENTA LOS CENTROS FUNCIONALES QUE YA SE ENCUENTREN EN UNA RELACION
		QUE ESTA EN PROCESO 0 O  HABILITADA 10--->
	<cfif isdefined('form.cfidlist') and form.cfidlist NEQ ''>
		<cfquery name="rsCFs" datasource="#session.dsn#">
			Select CFid
			from CFuncional
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and CFid in (#processcf(form.cfidlist)#)
		</cfquery>
	</cfif>
	<!--- SI HAY CENTROS FUNCIONALES PARA ASIGNAR --->
	<cfif isdefined('rsCFs') and rsCFs.recordCount GT 0>
		<cfset vHabilitar = true>
		<cfloop query="rsCFs"> 
			<!--- BUSCA LOS EMPLEADOS DE ESOS CENTROS FUNCONALES EN LA LISTA DE EMPLEADOS A EVALUAR --->
			<cfquery name="data" datasource="#session.DSN#">
				select a.DEid
				from LineaTiempo a
				inner join RHPlazas b
					on b.RHPid 	  = a.RHPid
				  	and b.Ecodigo = a.Ecodigo
				inner join CFuncional c	
					on c.CFid = b.CFid
					and c.Ecodigo = b.Ecodigo
				where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and <cf_dbfunction name="today"> between LTdesde and LThasta						
					and a.DEid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">	
					and c.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCFs.CFid#">
					and not exists (select DEid 
									from RHEmpleadosCF d1 
									inner join RHRelacionCalificacion rc
										on rc.RHRCid = d1.RHRCid
										and rc.RHRCestado in (0,10)
									where d1.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
									  and d1.DEid 	 = a.DEid)
					and a.DEid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
				inner join CFuncional c
					on  c.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCFs.CFid#">
					and c.CFid = b.CFid
					and c.Ecodigo = b.Ecodigo
			
				where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and getdate() between LTdesde and LThasta			
			</cfquery>
			<cfif data.RecordCount>
				<cfset vListaEmpleados = ListAppend(vListaEmpleados,ValueList(data.DEid))>
			</cfif>
		</cfloop>
	</cfif>
	<cfif isdefined('form.EmpleadoIDList') and form.EmpleadoIDList NEQ ''>
		<!--- VERIFICA QUE EL EMPLEADO NO SE ENCUENTRE EN LA RELACION 
		ME DA LOS EMPLEADOS QUE PUEDO AGREGAR A LA RELACION--->
		<cfset vHabilitar = true>
		<cfquery name="rsDEid" datasource="#session.DSN#">
			select DEid 
			from DatosEmpleado
			where DEid in (#form.EmpleadoIDList#) 
			  and DEid not in (select DEid
			  					from RHEmpleadosCF d1
			  					inner join RHRelacionCalificacion rc
										on rc.RHRCid = d1.RHRCid
										and rc.RHRCestado in (0,10)
									where d1.Ecodigo = #session.Ecodigo# )
			  and DEid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		</cfquery>
		<cfif rsDEid.RecordCount>
			<cfset vListaEmpleados = ListAppend(vListaEmpleados,ValueList(rsDEid.DEid))>
		</cfif>
	</cfif>
	<!--- CON LA LISTA DE EMPLEADOS SE CREAN LOS REGISTROS --->
	<cfif isdefined('vListaEmpleados') and vListaEmpleados NEQ ''>
		<cfquery name="data" datasource="#session.DSN#">
			insert into RHEmpleadosCF (RHRCid, CFid, DEid, DEidJefe,RHPcodigo, Ecodigo, BMUsucodigo)
		
			select  	
				#form.RHRCid#
				, c.CFid
				, a.DEid
				, #form.DEid#
				, a.RHPcodigo
				, <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">						
			from LineaTiempo a
			inner join RHPlazas b
				on b.RHPid = a.RHPid
			  	and b.Ecodigo = a.Ecodigo
			inner join CFuncional c
				on  c.CFid = b.CFid
				and c.Ecodigo = b.Ecodigo
		
			where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and a.DEid in (#vListaEmpleados#)
			  and <cf_dbfunction name="today"> between LTdesde and LThasta			
		</cfquery>
	</cfif>
	<!--- SI LA EVALUACION ESTA HABILITADA Y SE AGREGA UN EMPLEADO A UNA RELACION
		QUE YA HA SIDO TERMINADA DE CALIFICAR, SE TIENE QUE VOLVER A ABRIR PARA CALIFICACION --->
	<cfif rsDatosRelCal.RHRCestado EQ 10 and vHabilitar>
		<cfquery name="UpdateRelacion" datasource="#session.DSN#">
			update RHEvaluadoresCalificacion
			set RHECestado = 0
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and DEid 	  =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			  and RHRCid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#">
		</cfquery>
		<!--- RHHabilidadesPuesto --->
		<cfif rsDatosRelCal.RHRCitems EQ 'H' OR rsDatosRelCal.RHRCitems EQ 'A'>
			<cfquery name="data" datasource="#session.DSN#">
				insert into RHEvaluacionComp (RHRCid, CFid, DEid, RHHid, RHCid, nuevanota, Ecodigo, BMUsucodigo, notaant)
				select 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#">
					, a.CFid
					, a.DEid
					, b.RHHid
					, null
					, 0
					, <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					, 0
				from RHEmpleadosCF a,
					RHHabilidadesPuesto b
				where a.RHRCid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#">
					and a.DEid in (#vListaEmpleados#)
					and a.Ecodigo 	= b.Ecodigo
					and a.RHPcodigo = b.RHPcodigo
			</cfquery>
		</cfif>
	
		<!--- RHConocimientosPuesto --->
		<cfif rsDatosRelCal.RHRCitems EQ 'C' OR rsDatosRelCal.RHRCitems EQ 'A'>
			<cfquery name="data" datasource="#session.DSN#">
				insert into RHEvaluacionComp (RHRCid, CFid, DEid, RHHid, RHCid, nuevanota, Ecodigo, BMUsucodigo, notaant)
				select 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#">
					, a.CFid
					, a.DEid
					, null
					, b.RHCid
					, 0
					, <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					, 0
				from RHEmpleadosCF a,
					RHConocimientosPuesto b
				where a.RHRCid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#">
				and a.DEid in (#vListaEmpleados#)
				and a.Ecodigo 	= b.Ecodigo
				and a.RHPcodigo = b.RHPcodigo
			</cfquery>		
		</cfif>
	
		<!--- Actualizacion del campo de nota anterior de la tabla RHEvaluacionComp --->
		<cfquery name="rsEvalComp" datasource="#session.DSN#">
			Select RHEClinea,RHHid,RHCid,DEid
			from RHEvaluacionComp
			where Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and RHRCid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#">
				and DEid in (#vListaEmpleados#)
			order by DEid,CFid
		</cfquery>
		
		<cfif isdefined('rsEvalComp') and rsEvalComp.recordCount GT 0>
			<cfloop query="rsEvalComp">
				<!--- Habilidades --->
				<cfif rsEvalComp.RHHid NEQ ''>
					<cfquery name="rsCompetEmpl" datasource="#session.DSN#">
						Select RHCEdominio
						from RHCompetenciasEmpleado
						where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and tipo = 'H'
							and idcompetencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEvalComp.RHHid#">
							and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEvalComp.DEid#">
							and <cf_dbfunction name="today"> between RHCEfdesde and RHCEfhasta
					</cfquery>
					<cfif isdefined('rsCompetEmpl') and rsCompetEmpl.recordCount GT 0 and rsCompetEmpl.RHCEdominio GT 0>
						<!--- Modificacion de la nota anterior para la habilidad --->
						<cfquery datasource="#session.DSN#">
							update RHEvaluacionComp set
								notaant = <cfqueryparam cfsqltype="cf_sql_money" value="#rsCompetEmpl.RHCEdominio#">
							where RHEClinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEvalComp.RHEClinea#">
							  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEvalComp.DEid#">
						</cfquery>
					</cfif>
				<!--- Conocimientos --->
				<cfelseif rsEvalComp.RHCid NEQ ''>
					<cfquery name="rsCompetEmpl" datasource="#session.DSN#">
						Select RHCEdominio
						from RHCompetenciasEmpleado
						where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and tipo = 'C'
							and idcompetencia=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEvalComp.RHCid#">
							and DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEvalComp.DEid#">
							and <cf_dbfunction name="today"> between RHCEfdesde and RHCEfhasta
					</cfquery>
					<cfif isdefined('rsCompetEmpl') and rsCompetEmpl.recordCount GT 0 and rsCompetEmpl.RHCEdominio GT 0>
						<!--- Modificacion de la nota anterior para la habilidad --->
						<cfquery datasource="#session.DSN#">
							update RHEvaluacionComp set
								notaant = <cfqueryparam cfsqltype="cf_sql_money" value="#rsCompetEmpl.RHCEdominio#">
							where RHEClinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEvalComp.RHEClinea#">
							  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEvalComp.DEid#">
						</cfquery>
					</cfif>				
				</cfif>
			</cfloop>
		</cfif>
	
		<!--- LLENADO LA TABLA RHEvalPlanSucesion --->
		<cfquery name="rsEmpleadosCF" datasource="#session.DSN#">
			Select ecf.DEid,ecf.CFid,RHRCid
			from RHEmpleadosCF ecf
				inner join RHEmpleadosPlan ep
				   on ep.Ecodigo 	= ecf.Ecodigo
				  and ep.DEid	 	= ecf.DEid
				  and ep.RHPcodigo 	= ecf.RHPcodigo
			where ecf.Ecodigo = <cfqueryparam  cfsqltype="cf_sql_integer"value="#session.Ecodigo#">
				and RHRCid	  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#">
				and ecf.DEid in (#vListaEmpleados#)
			order by DEid,CFid
		</cfquery>		
		
		<cfif isdefined('rsEmpleadosCF') and rsEmpleadosCF.recordCount GT 0>
			<cfloop query="rsEmpleadosCF">
				<cfif rsDatosRelCal.RHRCitems EQ 'H' OR rsDatosRelCal.RHRCitems EQ 'A'>
					<!--- Habilidades de los puestos en el plan de susecion para el empleado --->
					<cfquery name="rsHabPuesto" datasource="#session.DSN#">
						Select RHHid,RHPcodigo
						from RHHabilidadesPuesto
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and RHPcodigo in (
								Select RHPcodigo
								from RHEmpleadosPlan
								where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
									and DEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpleadosCF.DEid#">
								)		
					</cfquery>			
					<cfif isdefined('rsHabPuesto') and rsHabPuesto.recordCount GT 0>
						<cfloop query="rsHabPuesto">
							<!--- LLENADO LA TABLA RHEvalPlanSucesion --->
							<cfquery datasource="#session.DSN#">
								insert into RHEvalPlanSucesion 
									(RHRCid, CFid, DEid, RHPcodigo, Ecodigo, RHHid, RHCid, fechaalta, BMUsucodigo, nuevanota, notaant)
								values (
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#">
									, <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpleadosCF.CFid#">
									, <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpleadosCF.DEid#">
									, <cfqueryparam cfsqltype="cf_sql_char" value="#rsHabPuesto.RHPcodigo#">
									, <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
									, <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsHabPuesto.RHHid#">
									, null
									, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
									, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
									, 0
									, 0)			
							</cfquery>				
						</cfloop>
					</cfif>
				</cfif>
				<cfif rsDatosRelCal.RHRCitems EQ 'C' OR rsDatosRelCal.RHRCitems EQ 'A'>
					<!--- Conocimientos de los puestos en el plan de susecion para el empleado --->
					<cfquery name="rsConPuesto" datasource="#session.DSN#">
						Select RHCid,RHPcodigo
						from RHConocimientosPuesto
						where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and RHPcodigo in (
								Select RHPcodigo
								from RHEmpleadosPlan
								where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
									and DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpleadosCF.DEid#">
								)
					</cfquery>			
					<cfif isdefined('rsConPuesto') and rsConPuesto.recordCount GT 0>
						<cfloop query="rsConPuesto">
							<!--- LLENADO LA TABLA RHEvalPlanSucesion --->
							<cfquery datasource="#session.DSN#">
								insert into RHEvalPlanSucesion 
									(RHRCid, CFid, DEid, RHPcodigo, Ecodigo, RHHid, RHCid, fechaalta, BMUsucodigo, nuevanota, notaant)
								values (
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#">
									, <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpleadosCF.CFid#">
									, <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpleadosCF.DEid#">
									, <cfqueryparam cfsqltype="cf_sql_char" value="#rsConPuesto.RHPcodigo#">
									, <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
									, null
									, <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConPuesto.RHCid#">
									, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
									, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
									, 0
									, 0)			
							</cfquery>				
						</cfloop>
					</cfif>
				</cfif>
			</cfloop>					
		</cfif>
		
		<!--- Modificacion de las notas anteriores para la tabla de RHEvalPlanSucesion --->
		<cfquery name="rsEvalPlanSus" datasource="#session.DSN#">
			Select DEid,CFid,RHHid,RHCid,RHEPSlinea
			from RHEvalPlanSucesion 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and RHRCid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#">
				and DEid in (#vListaEmpleados#)
			order by DEid,CFid
		</cfquery>
		
		<cfif isdefined('rsEvalPlanSus') and rsEvalPlanSus.recordCount GT 0>
			<cfloop query="rsEvalPlanSus">
				<!--- Habilidades --->
				<cfif rsEvalPlanSus.RHHid NEQ ''>
					<cfquery name="rsCompetEmpl" datasource="#session.DSN#">
						Select RHCEdominio
						from RHCompetenciasEmpleado
						where Ecodigo		  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and tipo 		  = 'H'
							and idcompetencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEvalPlanSus.RHHid#">
							and DEid		  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEvalPlanSus.DEid#">
							and <cf_dbfunction name="today"> between RHCEfdesde and RHCEfhasta
					</cfquery>
					<cfif isdefined('rsCompetEmpl') and rsCompetEmpl.recordCount GT 0 and rsCompetEmpl.RHCEdominio GT 0>
						<!--- Modificacion de la nota anterior para la habilidad --->
						<cfquery datasource="#session.DSN#">
							update RHEvalPlanSucesion set
								notaant=<cfqueryparam cfsqltype="cf_sql_money" value="#rsCompetEmpl.RHCEdominio#">
							where RHEPSlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEvalPlanSus.RHEPSlinea#">
							  and DEid 		 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEvalPlanSus.DEid#">
						</cfquery>
					</cfif>
				<!--- Conocimientos --->
				<cfelseif rsEvalPlanSus.RHCid NEQ ''>
					<cfquery name="rsCompetEmpl" datasource="#session.DSN#">
						Select RHCEdominio
						from RHCompetenciasEmpleado
						where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and tipo = 'C'
							and idcompetencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEvalPlanSus.RHCid#">
							and DEid		  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEvalPlanSus.DEid#">
							and <cf_dbfunction name="today"> between RHCEfdesde and RHCEfhasta
					</cfquery>
					<cfif isdefined('rsCompetEmpl') and rsCompetEmpl.recordCount GT 0 and rsCompetEmpl.RHCEdominio GT 0>
						<!--- Modificacion de la nota anterior para la habilidad --->
						<cfquery datasource="#session.DSN#">
							update RHEvalPlanSucesion set
								notaant=<cfqueryparam cfsqltype="cf_sql_money" value="#rsCompetEmpl.RHCEdominio#">
							where RHEPSlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEvalPlanSus.RHEPSlinea#">
							  and DEid 		 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEvalPlanSus.DEid#">
						</cfquery>
					</cfif>				
				</cfif>
			</cfloop>
		</cfif>	
	</cfif>
	</cftransaction>
</cfif>


<cfset params = "">
<cfset params = params  &  iif(len(trim(params)) gt 0,DE('&'),DE('?'))  &  "modo=CAMBIO">
<cfset params = params  &  iif(len(trim(params)) gt 0,DE('&'),DE('?'))  &  "Sel=4">	
<cfset params = params  &  iif(len(trim(params)) gt 0,DE('&'),DE('?'))  &  "DEid="  &  form.DEid>
<cfset params = params  &  iif(len(trim(params)) gt 0,DE('&'),DE('?'))  &  "RHRCid="  &  form.RHRCid>

	
<cflocation url="actCompetencias.cfm#params#">
<cfset cont = 0>

<cfloop index = "LoopCount" from = "1" to = "2">	
	<cfset cont = cont + 1>
	<!--- 1. Cuestionarios --->
	<cfif cont EQ 1>
		<!--- Cuestionario Bezinger sin contestar --->
		<cfquery name="data" datasource="#session.DSNnuevo#">
			Select 	*
			from PortalCuestionario
			where PCid = 6
		</cfquery>
	</cfif>


	
	<cfif (cont EQ 1 and isdefined('data') and data.recordcount GT 0) or cont EQ 2>
		<cfquery datasource="#session.DSNnuevo#">
			insert RHEEvaluacionDes 
				(RHEEdescripcion, Usucodigo, RHEEfecha, RHEEfdesde, RHEEfhasta, RHEEestado, RHEEtipoeval, PCid, Ecodigo)
			values (
				<cfif cont EQ 1>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="Test BTSA">, 
				<cfelseif cont EQ 2>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="Test de Aptitudes">,  
				</cfif>
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.UsucodigoNuevo#">, 
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('m', 3, Now())#">, 
				2, 
				'1', 
				<cfif cont EQ 1>
					6, 				
				<cfelseif cont EQ 2>
					null, 
				</cfif>
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">)
		</cfquery>
	<cfelseif cont EQ 1>
		<cf_errorCode	code = "50367" msg = "No se encontro el Cuestionario base para llenar los datos de ejemplo">
	</cfif>
</cfloop>

<!--- Seleccion de las Relaciones de Evaluacion recientemente insertadas --->
<cfquery name="rsNewEval" datasource="#session.DSNnuevo#">
	Select RHEEid, PCid
	from RHEEvaluacionDes
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
</cfquery>

<cfif isdefined('rsNewEval') and rsNewEval.recordCount GT 0>
	<!--- Seleccion de los empleados --->
	<cfquery name="rsEmpl" datasource="#session.DSNnuevo#">
		select 
			Jefe = (select min(l.DEid) from LineaTiempo l where l.RHPid = c.RHPid and getdate() between l.LTdesde and l.LThasta <!----and l.DEid in (#session.LvarEmpleados.lista#)---->), 
			Jefe2= (select min(l.DEid) from LineaTiempo l where l.RHPid = c2.RHPid and getdate()  between l.LTdesde and l.LThasta <!----and l.DEid in (#session.LvarEmpleados.lista#)---->),
			c.CFid,a.DEid IDEmpleado, 
			c.CFidresp, a.RHPid, c.RHPid, a.RHPcodigo
		from LineaTiempo a
			inner join RHPlazas b
				on b.Ecodigo=a.Ecodigo
					and b.RHPid=a.RHPid
	
			inner join CFuncional c
				on c.Ecodigo=b.Ecodigo
					and c.CFid=b.CFid
	
			left outer join CFuncional c2
				on c2.CFidresp=c.CFid
	
		where a.Ecodigo = #vn_Ecodigo#
			<!---and a.RHPcodigo in ('0015','0002','0003','0011','0010','GC4841','4567','0008')--->
			<!----and a.DEid in (#session.LvarEmpleados.lista#) ---->
	</cfquery>

	<cfif rsEmpl.recordCount>
		<cfquery name="rsPuestosEmp" datasource="#session.DSNnuevo#">
			Select 1
			from RHPuestos
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
				<!---and RHPcodigo in ('0015','0002','0003','0011','0010','GC4841','4567','0008')--->
		</cfquery>	
		
		<cfif isdefined('rsPuestosEmp') and rsPuestosEmp.recordcount eq 0>
			<!--- Inserción de Puestos para la empresa de session --->
			<cfquery datasource="#session.DSNnuevo#">
				insert RHPuestos 
					(Ecodigo, RHPcodigo, RHOcodigo, RHTPid, RHPEid, RHGMid, RHPdescpuesto, 
					BMusuario, BMfecha, BMusumod, BMfechamod, HYLAcodigo, HYMgrado, HYIcodigo, 
					HYHEcodigo, HYHGcodigo, HYIHgrado, HYCPgrado, HYMRcodigo, ptsHabilidad, porcSP
					, ptsSP, ptsResp, ptsTotal, HYperfilnivel, HYperfilvalor, CFid, BMUsucodigo, 
					DEidaprueba, RHPfechaaprob, RHPactivo, RHPfactiva, FLval, FRval, BLval, BRval,
					 FLtol, FRtol, BLtol, BRtol, extravertido, introvertido, balanceado, 
					 ubicacionMuneco)
				
				Select <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">,
					RHPcodigo, RHOcodigo, RHTPid, RHPEid, RHGMid, RHPdescpuesto, BMusuario, 
					BMfecha, BMusumod, BMfechamod, HYLAcodigo, HYMgrado, HYIcodigo, HYHEcodigo,
					 HYHGcodigo, HYIHgrado, HYCPgrado, HYMRcodigo, ptsHabilidad, porcSP, ptsSP,
					  ptsResp, ptsTotal, HYperfilnivel, HYperfilvalor, CFid, BMUsucodigo, 
					  DEidaprueba, RHPfechaaprob, RHPactivo, RHPfactiva, FLval, FRval, BLval, 
					  BRval, FLtol, FRtol, BLtol, BRtol, extravertido, introvertido, balanceado, 
					  ubicacionMuneco
				From RHPuestos 
				Where Ecodigo=#vn_Ecodigo#
					<!---and RHPcodigo in ('0015','0002','0003','0011','0010','GC4841','4567','0008')--->
			</cfquery>
		</cfif>
		
		<cfset codRelEvaluac = 	"">
		<cfloop query="rsNewEval">		<!--- Ciclo de las Relaciones de Evaluacion recientemente insertadas --->		
			<!--- Query para saber si se usa Cuestionario específico (Si es especifico no se llena la  tabla RHNotasEvalDes
			o Cuestionario por habilidades si se llena la tabla RHNotasEvalDes ---->
			<cfset codRelEvaluac = 	rsNewEval.RHEEid>
			<cfquery name="rsPCid" datasource="#session.DSNnuevo#">
				select PCid 
				from RHEEvaluacionDes
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
					and RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#codRelEvaluac#">
					
			</cfquery>		
			
			<cfloop query="rsEmpl">		<!--- Ciclo con la lista de Empleados --->
				<!--- JUSTIFICACION DEL "IF NOT EXISTS"
						Si el empleado ya fue agregado en esta lista, ya fueron agregados los demás datos también, en un momento determinado,
						con ciertos criterios determinados, y estos podrían haber cambiado hasta este momento, pero si genero varias veces, 
						se espera que la razón sea agregar mas empleados a la evaluación y regenerar los datos porque cambiaron los criterios.
						Si se determina que es común regenerar los criterios durante el proceso de agregar empleados a la evaluación se debe 
						desarrollar un comportamiento que permita esta acción.
						Resumen: Actualmente en este proceso se pregunta si existe la persona en la tabla RHListaEvalDes, si existe no se inserta
						ningún registro ni en esta tabla ni en las demás tablas involucradas (RHEvaluadoresDes, RHNotasEvalDes), esto implica que
						si se cambiaron los items de evaluacion estos no se van a actualizar para los empleados agregados previamente. Solo los 
						empleados que se están agregando nuevos reflejarán los nuevos items.
				--->

				<cfquery name="rsLisEvalDes" datasource="#session.DSNnuevo#">
					select 1 
					from RHListaEvalDes 
					where RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#codRelEvaluac#"> 
						and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.LvarEmpleados[rsEmpl.IDEmpleado]#">
				</cfquery>
				
				<cfif isdefined('rsLisEvalDes') and rsLisEvalDes.recordCount EQ 0>
 					<cfquery datasource="#session.DSNnuevo#">
						insert RHListaEvalDes 
							(RHEEid, DEid, RHPcodigo, Ecodigo, promglobal, RHLEnotajefe, RHLEnotaauto, RHLEpromotros)
						values (
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#codRelEvaluac#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.LvarEmpleados[rsEmpl.IDEmpleado]#">, 
							<cfqueryparam cfsqltype="cf_sql_char" value="#rsEmpl.RHPcodigo#">, 
							<cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">, 
							null, null, null, null)				
					</cfquery>  
				</cfif>

				<cfquery name="rsEvalDes" datasource="#session.DSNnuevo#">
					select 1 
					from RHEvaluadoresDes 
					where RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#codRelEvaluac#"> 
						and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.LvarEmpleados[rsEmpl.IDEmpleado]#"> 
						and DEideval = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.LvarEmpleados[rsEmpl.IDEmpleado]#">				
				</cfquery>				
				
				<cfif isdefined('rsEvalDes') and rsEvalDes.recordCount EQ 0>
 					<cfquery datasource="#session.DSNnuevo#">
						insert RHEvaluadoresDes 
							(RHEEid, DEid, DEideval, RHEDtipo)
						values (
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#codRelEvaluac#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.LvarEmpleados[rsEmpl.IDEmpleado]#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.LvarEmpleados[rsEmpl.IDEmpleado]#">, 
							'A')
					</cfquery> 
				</cfif>				

				<cfif LEN(TRIM(rsEmpl.Jefe)) gt 0 AND rsEmpl.Jefe NEQ rsEmpl.IDEmpleado>
					<cfquery name="rsEvaluadoresD" datasource="#session.DSNnuevo#">
						select 1 
						from RHEvaluadoresDes 
						where RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#codRelEvaluac#"> 
							and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.LvarEmpleados[rsEmpl.IDEmpleado]#"> 
							and DEideval = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.LvarEmpleados[rsEmpl.Jefe]#">				
					</cfquery>						

					<cfif isdefined('rsEvaluadoresD') and rsEvaluadoresD.recordCount EQ 0>
						<cfquery datasource="#session.DSNnuevo#">
							insert RHEvaluadoresDes 
								(RHEEid, DEid, DEideval, RHEDtipo)
							values (
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#codRelEvaluac#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.LvarEmpleados[rsEmpl.IDEmpleado]#">, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.LvarEmpleados[rsEmpl.Jefe]#">, 
								'J')
						</cfquery>
					</cfif>								
				<cfelseif LEN(TRIM(rsEmpl.Jefe2)) gt 0 AND rsEmpl.Jefe2 NEQ rsEmpl.IDEmpleado>
					<cfquery name="rsRHEvaluadoresDes" datasource="#session.DSNnuevo#">
						select 1 
						from RHEvaluadoresDes 
						where RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#codRelEvaluac#"> 
							and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.LvarEmpleados[rsEmpl.IDEmpleado]#"> 
							and DEideval = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.LvarEmpleados[rsEmpl.Jefe2]#">				
					</cfquery>			

					<cfif isdefined('rsRHEvaluadoresDes') and rsRHEvaluadoresDes.recordCount EQ 0>
 						<cfquery datasource="#session.DSNnuevo#">
							insert RHEvaluadoresDes 
								(RHEEid, DEid, DEideval, RHEDtipo)
							values (
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#codRelEvaluac#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.LvarEmpleados[rsEmpl.IDEmpleado]#">, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.LvarEmpleados[rsEmpl.Jefe2]#">, 
								'J')
						</cfquery>
					</cfif>							
				</cfif>				

				<!--- Usa o no Cuestionario específico --->
				<cfif isdefined("rsPCid") and len(trim(rsPCid.PCid)) EQ 0>
					<cfquery name="rsNotasEval" datasource="#session.DSNnuevo#">
						select 1 
						from RHNotasEvalDes 
						where RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#codRelEvaluac#">
							and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.LvarEmpleados[rsEmpl.IDEmpleado]#">
					</cfquery>					

					<cfif isdefined('rsNotasEval') and rsNotasEval.recordCount EQ 0>
 						<cfquery datasource="#session.DSNnuevo#">
							insert RHNotasEvalDes 
								(RHEEid, DEid, RHCid, RHNEDnotajefe, RHNEDnotaauto, RHNEDpromotros, RHNEDpromedio, RHNEDpeso)
								
							select 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#codRelEvaluac#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.LvarEmpleados[rsEmpl.IDEmpleado]#">,
								a.RHCid, null, null, null, null, null
							from RHConocimientos a 
								inner join RHConocimientosPuesto b
									on b.Ecodigo=a.Ecodigo
										and b.RHCid = a.RHCid
										and b.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsEmpl.RHPcodigo#">
							where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
						</cfquery>
						
 						<cfquery datasource="#session.DSNnuevo#">
							insert RHNotasEvalDes 
								(RHEEid, DEid, RHHid, RHNEDnotajefe, RHNEDnotaauto, RHNEDpromotros, RHNEDpromedio, RHNEDpeso)
								
							select distinct 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#codRelEvaluac#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.LvarEmpleados[rsEmpl.IDEmpleado]#">,							
								a.RHHid, null, null, null, null, null
							from RHHabilidades a
								inner join RHHabilidadesPuesto b
									on b.RHHid = a.RHHid
										and b.Ecodigo = a.Ecodigo
										and b.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsEmpl.RHPcodigo#">
							where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
						</cfquery>		
					</cfif>						
				</cfif>
			</cfloop>

			<!--- Si la relacion de evaluacion recientemente insertada no es del tipo de Bezinger,
				sino que es para clima organizacional --->
			<cfif rsNewEval.PCid EQ ''>
				<!--- Habilitacion y cierre de la Relaciones de Evaluacion Evaluada --->			
				<cfquery name="ABC_Evaluacion_Masivo" datasource="#session.DSNnuevo#">
					update RHEEvaluacionDes
						set RHEEestado = 3
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
						and RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#codRelEvaluac#">
				</cfquery>			
				<cfset yaveRelEval = codRelEvaluac>
			</cfif>
		</cfloop>
	</cfif>	
</cfif>

<!--- 
	Insercion de informacion para el calculo de las notas por habilidad para todos los empleados
	de la segunda relacion de evaluacion recientemente insertada
 --->
<cfif isdefined('yaveRelEval') and len(trim(yaveRelEval))>
	<cfquery name="selInfEval" datasource="#session.DSNnuevo#">
		Select led.RHEEid, led.DEid, ned.RHHid,RHHpeso, DEideval
		
		from RHListaEvalDes led
			inner join RHNotasEvalDes ned
				on ned.RHEEid=led.RHEEid
					and ned.DEid=led.DEid
					
			inner join RHHabilidadesPuesto hp
				on hp.Ecodigo=led.Ecodigo
					and hp.RHPcodigo=led.RHPcodigo
					and hp.RHHid=ned.RHHid
		
			inner join RHEvaluadoresDes ed
				on ed.RHEEid=ned.RHEEid
					and ed.DEid=ned.DEid
		
		where led.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
			and led.RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#yaveRelEval#">
	</cfquery> 
	
	<cfif isdefined('selInfEval') and selInfEval.recordCount GT 0>
		<cfloop query="selInfEval">
			<cfset notaAleat  = RandRange(40, 100)>
			<cfset porcen  = (selInfEval.RHHpeso * notaAleat) / 100>

			<cfquery datasource="#session.DSNnuevo#">
				insert RHDEvaluacionDes 
				(RHEEid, DEid, DEideval, RHHid, RHDEnota, RHDEporcentaje, RHDEfecha, BMUsucodigo)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#selInfEval.RHEEid#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#selInfEval.DEid#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#selInfEval.DEideval#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#selInfEval.RHHid#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#notaAleat#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#porcen#">, 
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.UsucodigoNuevo#">)
			</cfquery>
		</cfloop>
	</cfif>

	<!--- Actualizacion de la tabla RHNotasEvalDes --->
	<cfquery name="rsEDes" datasource="#session.DSNnuevo#">
		Select ed.RHEEid, ed.DEid, DEideval, ed.RHHid,RHDEnota,RHHpeso
		from RHDEvaluacionDes ed
			inner join RHEEvaluacionDes ee
				on ed.RHEEid=ee.RHEEid

			inner join RHListaEvalDes led
				on led.DEid = ed.DEid
					and  led.RHEEid=ed.RHEEid
  
			inner join RHHabilidadesPuesto hp
				on hp.Ecodigo=ee.Ecodigo
					and hp.RHPcodigo=led.RHPcodigo
					and hp.RHHid=ed.RHHid				
		
		where ed.RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#yaveRelEval#">
		order by ed.DEid, ed.RHHid
	</cfquery>
	
	<cfif isdefined('rsEDes') and rsEDes.recordCount GT 0>
		<cfset empl = "">
		<cfset habil = "">		
		<cfset notaAuto = 0>		
		<cfset notaJefe = 0>
		<cfset prom = 0>
		<cfset peso = 0>
		<cfset actualiza = false>		
				
		<cfloop query="rsEDes">
			<cfif rsEDes.DEid NEQ rsEDes.DEideval><!--- AutoEvaluacion --->
				<cfset notaAuto = rsEDes.RHDEnota>
			<cfelse><!--- Evaluacion del Jefe --->
				<cfset notaJefe = rsEDes.RHDEnota>
			</cfif>
			<cfset prom = (notaAuto + notaJefe) / 2>
			<cfset peso = (rsEDes.RHHpeso * prom) / 100>
			
			<cfif empl NEQ rsEDes.DEid><!--- Cambio el empleado --->
				<cfif empl NEQ "">
					<cfset actualiza = true>
				</cfif>
				<cfset empl = rsEDes.DEid>
			</cfif>
			<cfif habil NEQ rsEDes.RHHid><!--- Cambio la habilidad --->
				<cfif habil NEQ "">
					<cfset actualiza = true>
				</cfif>
				<cfset habil = rsEDes.RHHid>
			</cfif>			
			
			<cfif actualiza>
				<cfquery datasource="#session.DSNnuevo#">
					update RHNotasEvalDes set
						RHNEDnotaauto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#notaAuto#">, 
						RHNEDnotajefe = <cfqueryparam cfsqltype="cf_sql_numeric" value="#notaJefe#">, 
						RHNEDpromedio = <cfqueryparam cfsqltype="cf_sql_numeric" value="#prom#">,  
						RHNEDpeso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#peso#">,  
						BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.UsucodigoNuevo#">
					where RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEDes.RHEEid#">
						and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEDes.DEid#">
						and RHHid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEDes.RHHid#">
				</cfquery>
				<cfset actualiza = false>
			</cfif>			
		</cfloop>

		<!--- Actualizacion de la tabla RHListaEvalDes --->
		<cfquery name="rsNEDes" datasource="#session.DSNnuevo#">
			Select sum(coalesce(RHNEDnotajefe,0)) as RHNEDnotajefe, 
				sum(coalesce(RHNEDnotaauto,0)) as RHNEDnotaauto,
				((sum(coalesce(RHNEDnotaauto,0)) + sum(coalesce(RHNEDnotajefe,0))) / 2) as promGlob
			from RHNotasEvalDes
			where RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#yaveRelEval#">
				and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEDes.DEid#">		
		</cfquery>
		
		<cfif isdefined('rsNEDes') and rsNEDes.recordCount GT 0>
			<cfset promGlob = (rsNEDes.RHNEDnotaauto + rsNEDes.RHNEDnotajefe) / 2>		
			<cfset totNotaAuto = rsNEDes.RHNEDnotaauto>			
			<cfset totNotaJefe = rsNEDes.RHNEDnotajefe>	
				
			<cfquery datasource="#session.DSNnuevo#">
				update RHListaEvalDes set
					RHLEnotajefe = <cfqueryparam cfsqltype="cf_sql_numeric" value="#notaAuto#">, 
					RHLEnotaauto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#notaJefe#">, 
					promglobal = <cfqueryparam cfsqltype="cf_sql_numeric" value="#prom#">
				where RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEDes.RHEEid#">
					and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEDes.DEid#">
					and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoNuevo#">
			</cfquery>
		</cfif>	
	</cfif>
</cfif>


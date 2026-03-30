<cfcomponent extends="home.Componentes.IndicadorBase">
<!--- 
	Cantidad de puestos en riesgo
	Indica la cantidad de puestos que tienen plan de sucesión, pero
	no tienen un candidato idóneo, es decir, cuya calificación no
	llegue a RHPlanSucesion.PSporcreq, segun la consulta indicada
	por /rh/sucesion/operacion/PlanSucesion-paso4.cfm
--->

<cffunction name="calcular">
	<cfargument name="datasource"  type="string"  required="yes" >
	<cfargument name="indicador"   type="string"  required="yes" >
	<cfargument name="Ecodigo"     type="numeric" required="yes" >
	<cfargument name="EcodigoSDC"  type="numeric" required="yes" >
	<cfargument name="CEcodigo"    type="numeric" required="yes" >
	<cfargument name="fecha_desde" type="date"    required="yes" >
	<cfargument name="fecha_hasta" type="date"    required="yes" >

	<!--- No puede ir en transaccion porque usa asp para calcular UsuarioReferencias --->
	<cfset limpiar(datasource,indicador,Ecodigo,CEcodigo,fecha_desde,fecha_hasta)>

	<cfif IsDefined('session.Usucodigo') And Len(session.Usucodigo)>
		<cfset BMUsucodigo = session.Usucodigo>
	<cfelse>
		<cfset BMUsucodigo = 0>
	</cfif>
	<cfset Arguments.fecha = Arguments.fecha_desde>
	
	<cfquery datasource="#Arguments.datasource#" name="puestos">
		select ps.RHPcodigo, ps.PSporcreq, pu.RHPdescpuesto
		from RHPlanSucesion ps
			join RHPuestos pu
				 on pu.Ecodigo = ps.Ecodigo
				and pu.RHPcodigo = ps.RHPcodigo
		where ps.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
	</cfquery>

<cfloop query="puestos">
	<cfset puestos_RHPcodigo = puestos.RHPcodigo>
	<cfset puestos_PSporcreq = puestos.PSporcreq>
	<cfset puestos_RHPdescpuesto = puestos.RHPdescpuesto>
	<cfset puestos_CurrentRow = puestos.CurrentRow>
	<!--- PARA CADA PUESTO --->
	<cfquery name="empleados" datasource="#Arguments.datasource#">							
		select a.DEid
		from RHEmpleadosPlan a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
		  and a.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#puestos_RHPcodigo#">
	</cfquery>
	
	<!--- ////////  CALCULAR LAS CALIFICACIONES PARA CADA CANDIDATO, BUSCANDO LA ULTIMA EVALUACION PARA CADA HABILIDAD /////// --->
	
	<cfset en_riesgo = 1>
	<cfloop query="empleados">
		<cfset empleados_DEid = empleados.DEid>
		<cfinvoke component="home.Componentes.Seguridad" method="getUsuarioByRef" returnvariable="usu"
			referencia="#empleados_deid#" Ecodigo="#Arguments.EcodigoSDC#" tabla="DatosEmpleado"></cfinvoke>
		<cfif not usu.RecordCount><cfthrow message="Usuario no existe: #DeId#"></cfif>
		<cfinvoke component="home.Componentes.Seguridad" method="getUsuarioByCod" returnvariable="alu"
			Usucodigo="#usu.Usucodigo#" Ecodigo="#Arguments.EcodigoSDC#" tabla="PersonaEducativo"></cfinvoke>
		<cfif not alu.RecordCount><cfthrow message="Alumno no existe: #DeId#-#usu.Usucodigo#"></cfif>
			
		<cfquery name="hab" datasource="#Arguments.datasource#">							
			select rhh.RHHdescripcion as descripcion, notas.RHNEDpromedio, hp.RHHpeso as peso, (hp.RHHpeso * notas.RHNEDpromedio) as resultado,
				m.Mnombre,
				(
					select count(1)
					from CursoAlumno ca join Curso cu on ca.Ccodigo = cu.Ccodigo
					where cu.Mcodigo = m.Mcodigo
					  and ca.Apersona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#alu.llave#">
				) as llevado
			from RHHabilidadesPuesto hp
				left join RHNotasEvalDes notas
				   on notas.RHHid = hp.RHHid
				   and notas.DEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#empleados_DEid#">
				left join RHEEvaluacionDes notasE
					 on notasE.RHEEid = notas.RHEEid
					and notasE.Ecodigo    =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
				join RHHabilidades rhh
					on rhh.RHHid = hp.RHHid
				left join RHHabilidadesMaterias cm
					on cm.RHHid = rhh.RHHid
					and cm.Ecodigo = rhh.Ecodigo
				left join Materia m
					on cm.Mcodigo = m.Mcodigo
			where hp.RHPcodigo  = <cfqueryparam cfsqltype="cf_sql_char" value="#puestos_RHPcodigo#">
			  and hp.Ecodigo    = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
			order by descripcion, Mnombre, notasE.RHEEfecha desc
		</cfquery>
		
		<cfquery name="con" datasource="#Arguments.datasource#">							
				select rhh.RHCdescripcion as descripcion, notas.RHNEDpromedio, hp.RHCpeso as peso, (hp.RHCpeso * notas.RHNEDpromedio) as resultado,
					m.Mnombre,
					(
						select count(1)
						from CursoAlumno ca join Curso cu on ca.Ccodigo = cu.Ccodigo
						where cu.Mcodigo = m.Mcodigo
						  and ca.Apersona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#alu.llave#">
					) as llevado
				from RHConocimientosPuesto hp
					left join RHNotasEvalDes notas
					   on notas.RHCid = hp.RHCid
					  and notas.DEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#empleados_DEid#">
					left join RHEEvaluacionDes notasE
						 on notasE.RHEEid = notas.RHEEid
						and notasE.Ecodigo    =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
					join RHConocimientos rhh
						on rhh.RHCid = hp.RHCid
					left join RHConocimientosMaterias cm
						on cm.RHCid = rhh.RHCid
						and cm.Ecodigo = rhh.Ecodigo
					left join Materia m
						on cm.Mcodigo = m.Mcodigo
			where hp.RHPcodigo  = <cfqueryparam cfsqltype="cf_sql_char" value="#puestos_RHPcodigo#">
			  and hp.Ecodigo    =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
			order by descripcion, Mnombre, notasE.RHEEfecha desc
		</cfquery>
		
		<cfset NotaTotal_resultado = 0>
		<cfset NotaTotal_peso = 0>
		<cfoutput query="hab" group="descripcion"><!--- porque la primera que sale es la mas reciente --->
			<cfif Len(resultado)><cfset NotaTotal_resultado = NotaTotal_resultado + resultado></cfif>
			<cfif Len(peso)><cfset NotaTotal_peso = NotaTotal_peso + peso></cfif>
		</cfoutput>
		<cfoutput query="con" group="descripcion"><!--- porque la primera que sale es la mas reciente --->
			<cfif Len(resultado)><cfset NotaTotal_resultado = NotaTotal_resultado + resultado></cfif>
			<cfif Len(peso)><cfset NotaTotal_peso = NotaTotal_peso + peso></cfif>
		</cfoutput>
		<cfif NotaTotal_peso>
			<cfset calificacion = NumberFormat(NotaTotal_resultado / NotaTotal_peso,',0.00')>
			<cfif calificacion GE puestos_PSporcreq>
				<cfset en_riesgo = 0>
				<cfbreak>
			</cfif>
		<cfelse>
			<cfset rsLista.calificacion = '0.00'>
		</cfif>
	</cfloop><!--- EMPLEADOS --->
	
	<cfquery datasource="#Arguments.datasource#" >
		insert into IndicadorValor (
			indicador, Ecodigo, CEcodigo, Dcodigo, Ocodigo, fecha,
			CFid, CFcodigo, CFpath, dia_semana, periodo, mes, trimestre,
			texto, valor, total,
			BMUsucodigo, BMfecha)
		select <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.indicador#">, #Arguments.Ecodigo#, #Arguments.CEcodigo#, 
			0, 0, ife.fecha,
			#puestos_CurrentRow#, ' ', null,
			<cf_dbfunction name="date_part" args="DD,ife.fecha" datasource="#Arguments.datasource#" > as dia_semana,
			<cf_dbfunction name="date_part" args="YY,ife.fecha" datasource="#Arguments.datasource#" > as periodo,
			<cf_dbfunction name="date_part" args="MM,ife.fecha" datasource="#Arguments.datasource#" > as mes,
			<cf_dbfunction name="date_part" args="Q,ife.fecha"  datasource="#Arguments.datasource#" > as trimestre,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#RHPdescpuesto#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#en_riesgo#"> as valor, 1 as total,
			#BMUsucodigo#, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
		from IndicadorFecha ife
		where ife.fecha between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.fecha_desde#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.fecha_hasta#"> 
	</cfquery>	
	<!--- ////////// YA ESTA CALCULADO PARA EL PUESTO ////////// --->
</cfloop><!--- PUESTOS --->

</cffunction>

</cfcomponent>


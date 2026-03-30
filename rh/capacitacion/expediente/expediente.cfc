<!---
puestoEmpleado(empleado, empresa)
		  devuelve el puesto de un empleado 
		  
cfEmpleado(empleado, empresa)
		  devuelve el centro funcional de un empleado 

notasObtenidas(empresa, empleado, puesto)
		  devuelve las notasObtenidas por un empleado para todas las competencias de un puesto. 

competenciasRequeridas(puesto, empresa, tipo)
		  devuelve las competencias requeridas por un puesto. 

competenciasPosee(empleado, puesto, tipo, competencia, empresa)
		  devuelve el porcentaje de conocimiento que tiene un colaborador para una habilidad en un puesto. 

competencias(empleado, tipo, filtro, empresa)
		  devuelve las competencias asociadas a un empleado, a excepcion de las competencias indicadas en el parametro filtro. 

cursosLlevados(empleado, empresa)
		  devuelve los cursos que un colaborador ha llevado. 
		  Los toma de RHEmpleadoCurso, no interesan las fechas y 
		  consulta los que estan en estado de aprobado (10) en adelante.
		  Excluye los que estan en proceso.


programas(empresa, cfuncional, puesto, empleado)
		  devuelve los programas/materias/cursos asociados al 
		  centro funcional y puesto del empleado. 

correosEvaluacion(empleado, empresa, IDEvaluacion)
	Envio de correo al programar una evaluacion
	
correos(empleado, empresa, IDcurso, IDmateria, ID)
		  Envio de  correo al matricular cursos/materias

evaluaciones360(empleado, empresa)
		  devuelve las evaluaciones aplicadas al colaborador. 

misevaluaciones(empleado, empresa)
		  devuelve las evaluaciones aplicadas por el colaborador. 

otrasevaluaciones(empleado, empresa, tipo)
		  devuelve las otrao tipo de evaluaciones aplicadas al colaborador. 

evalprogramadas(empleado, empresa)
		  devuelve las evaluaciones programadas al colaborador para el futuro. 
		  La fecha actual debe ser menor al la fecah de inicio de la evaluacion
		  o debe estar entre las fechas desde y hasta de la evaluacion

--->

<cfcomponent>
	<!--- init: Inicializa el componente --->
	<cffunction name="init">
		<cfreturn This>
	</cffunction>
	
	<!--- puestoEmpleado:
		  devuelve el puesto de un empleado 
	--->
	<cffunction name="puestoEmpleado" returntype="query">
		<cfargument name="empleado" required="yes" type="string">
		<cfargument name="empresa" required="yes" type="string">
        <cf_translatedata name="get" tabla="RHPuestos" col="p.RHPdescpuesto" returnvariable="LvarRHPdescpuesto">
		<cfquery name="data" datasource="#session.DSN#">
			select coalesce(ltrim(rtrim(p.RHPcodigoext)),ltrim(rtrim(p.RHPcodigo))) as RHPcodigoext, ltrim(rtrim(p.RHPcodigo)) as RHPcodigo, #LvarRHPdescpuesto# as RHPdescpuesto
			from LineaTiempo lt
			
			inner join RHPuestos p
			on lt.Ecodigo=p.Ecodigo
			and lt.RHPcodigo=p.RHPcodigo
			
			where lt.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.empleado#">
			and lt.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.empresa#">
			and <cf_dbfunction name="today"> between lt.LTdesde and lt.LThasta
		</cfquery>
        
		<cfif isdefined('data') and data.RecordCount eq 0>
        
            <cfquery name="data" datasource="#session.DSN#">
               select coalesce(ltrim(rtrim(p.RHPcodigoext)),ltrim(rtrim(p.RHPcodigo))) as RHPcodigoext, ltrim(rtrim(p.RHPcodigo)) as RHPcodigo, #LvarRHPdescpuesto# as RHPdescpuesto
                from LineaTiempo lt
                
                inner join RHPuestos p
                on lt.Ecodigo=p.Ecodigo
                and lt.RHPcodigo=p.RHPcodigo
                
                where lt.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.empleado#">
                and lt.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.empresa#">
                and  (select max(LThasta) from LineaTiempo where DEid  = lt.DEid) between lt.LTdesde and lt.LThasta
            </cfquery>
        </cfif>
        
		<cfreturn data > 
	</cffunction>

	<!--- cfEmpleado:
		  devuelve el centro funcional de un empleado 
	--->
	<cffunction name="cfEmpleado" returntype="numeric">
		<cfargument name="empleado" required="yes" type="string">
		<cfargument name="empresa" required="yes" type="string">
		
		<cfquery name="data" datasource="#session.DSN#">
			select CFid 
			from LineaTiempo lt
			
			inner join RHPlazas p
			on lt.Ecodigo = p.Ecodigo
			and lt.RHPid = p.RHPid
			
			where lt.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.empresa#">
			and <cf_dbfunction name="today"> between LTdesde and LThasta
			and DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.empleado#">
		</cfquery>
        <cfif isdefined('data') and data.RecordCount eq 0>
            <cfquery name="data" datasource="#session.DSN#">
                select CFid 
                from LineaTiempo lt
                
                inner join RHPlazas p
                on lt.Ecodigo = p.Ecodigo
                and lt.RHPid = p.RHPid
                
                where lt.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.empresa#">
                and (select max(LThasta) from LineaTiempo where DEid  = lt.DEid) between LTdesde and LThasta
                and DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.empleado#">
            </cfquery>
        </cfif>        
        <cfif !len(trim(data.CFid))>
        	<cfreturn 0>
        </cfif>
		<cfreturn data.CFid > 
	</cffunction>

	<!--- notasObtenidas: 
		  devuelve las notasObtenidas por un empleado para todas las competencias de un puesto. 
	--->
	<cffunction name="notasObtenidas" returntype="query">
		<cfargument name="empresa" required="yes" type="string">
		<cfargument name="empleado" required="yes" type="string">
		<cfargument name="puesto" required="yes" type="string">
		
		<cfquery name="data" datasource="#session.DSN#">
			select 1 as tipo,
				   a.RHHid as id, 
				   b.RHHcodigo as codigo, 
				   b.RHHdescripcion as descripcion, 
				   a.RHNnotamin * 100 as notaRequerida, 
				   a.RHHpeso as peso,
				   c.RHCEdominio as notaObtenida,
				   c.RHCEdominio * a.RHHpeso / 100.0 as pesoObtenido
			
			from RHHabilidadesPuesto a

				inner join RHHabilidades b
					on b.Ecodigo = a.Ecodigo
					and b.RHHid = a.RHHid
			
				left outer join RHCompetenciasEmpleado c
					on c.idcompetencia = a.RHHid
					and c.Ecodigo = a.Ecodigo
					and c.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.empleado#">
					and c.tipo = 'H'
					
			
			where a.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.puesto#">
				and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.empresa#">
				and c.RHCEfdesde >= (	select max(x.RHCEfdesde) 
										from RHCompetenciasEmpleado x
										where x.DEid = c.DEid
											and x.Ecodigo = c.Ecodigo 
											and x.tipo = c.tipo
											and x.idcompetencia = c.idcompetencia )
			
			union
			
			select 2 as tipo,
				   a.RHCid as id, 
				   b.RHCcodigo as codigo, 
				   b.RHCdescripcion as descripcion, 
				   a.RHCnotamin * 100 as notaRequerida, 
				   a.RHCpeso as peso,
				   c.RHCEdominio as notaObtenida,
				   c.RHCEdominio * a.RHCpeso / 100.0 as pesoObtenido
			
			from RHConocimientosPuesto a
			
				inner join RHConocimientos b
					on b.Ecodigo = a.Ecodigo
					and b.RHCid = a.RHCid
			
				left outer join RHCompetenciasEmpleado c
					on c.idcompetencia = a.RHCid
					and c.Ecodigo = a.Ecodigo
					and c.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.empleado#">
					and c.tipo = 'C'
				
			
			where a.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.puesto#">
				and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.empresa#">
				and c.RHCEfdesde >= (	select max(x.RHCEfdesde) 
										from RHCompetenciasEmpleado x
										where x.DEid = c.DEid
											and x.Ecodigo = c.Ecodigo 
											and x.tipo = c.tipo
											and x.idcompetencia = c.idcompetencia )
				
			order by 1, 3
		</cfquery>
		
		<cfreturn data > 
	</cffunction>

	<!--- competenciasRequeridas: 
		  devuelve las competencias requeridas por un puesto. 
	--->
	<cffunction name="competenciasRequeridas" returntype="query">
		<cfargument name="puesto" required="yes" type="string">
		<cfargument name="empresa" required="yes" type="string">
		<cfargument name="tipo" required="yes" type="string">
		
		<cfif ucase(trim(tipo)) eq 'H' >
			<cfquery name="data" datasource="#session.DSN#">
				select a.RHHid, b.RHHcodigo, b.RHHdescripcion, coalesce(a.RHNnotamin,0)*100 as nota, a.RHHpeso as peso, n.RHNcodigo as nivel
				from RHHabilidadesPuesto a
				
				inner join RHHabilidades b
				on a.Ecodigo=b.Ecodigo
				and a.RHHid=b.RHHid

				inner join RHNiveles n
				on n.Ecodigo = a.Ecodigo
				and n.RHNid = a.RHNid
								
				where a.RHPcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.puesto#">
				  and a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.empresa#">
				order by b.RHHcodigo
			</cfquery>
		<cfelse>
			<cfquery name="data" datasource="#session.DSN#">
				select a.RHCid, b.RHCcodigo, b.RHCdescripcion, coalesce(a.RHCnotamin,0)*100 as nota, a.RHCpeso as peso, n.RHNcodigo as nivel
				from RHConocimientosPuesto a
				
				inner join RHConocimientos b
				on a.Ecodigo=b.Ecodigo
				and a.RHCid=b.RHCid
				
				inner join RHNiveles n
				on n.Ecodigo = a.Ecodigo
				and n.RHNid = a.RHNid

				where a.RHPcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.puesto#">
				  and a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.empresa#">
				order by b.RHCcodigo
			</cfquery>
		</cfif>
		
		<cfreturn data > 
	</cffunction>

	<!--- competenciasPosee: 
		  devuelve el porcentaje de conocimiento que tiene un colaborador para una habilidad en un puesto. 
	--->
	<cffunction name="competenciasPosee" returntype="string">
		<cfargument name="empleado" required="yes" type="string">
		<cfargument name="puesto" required="yes" type="string">
		<cfargument name="tipo" required="yes" type="string">
		<cfargument name="competencia" required="yes" type="string">
		<cfargument name="empresa" required="yes" type="string">
		
		<cfif ucase(trim(tipo)) eq 'H'>
			<cfquery name="data" datasource="#session.DSN#">
				select a.RHCEdominio as nota
				from RHCompetenciasEmpleado a
				
				inner join RHHabilidadesPuesto b
				on a.Ecodigo=b.Ecodigo
				and a.idcompetencia=b.RHHid
				and b.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.puesto#">
				
				where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.empleado#">
				and tipo= 'H'
				and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between RHCEfdesde and RHCEfhasta
				and RHHid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#competencia#">
			</cfquery>
		<cfelse>
			<cfquery name="data" datasource="#session.DSN#">
				select a.RHCEdominio as nota
				from RHCompetenciasEmpleado a
				
				inner join RHConocimientosPuesto b
				on a.Ecodigo=b.Ecodigo
				and a.idcompetencia=b.RHCid
				and b.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.puesto#">
				
				where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.empleado#">
				and tipo= 'C'
				and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between RHCEfdesde and RHCEfhasta
				and RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#competencia#">
			</cfquery>
		</cfif>
		
		<cfreturn data.nota > 
	</cffunction>

	<!--- competencias: 
		  devuelve las competencias asociadas a un empleado, a excepcion de las competencias indicadas en el parametro filtro. 
	--->
	<cffunction name="competencias" returntype="query">
		<cfargument name="empleado" required="yes" type="string">
		<cfargument name="tipo" required="yes" type="string">
		<cfargument name="filtro" required="yes" type="string">
		<cfargument name="empresa" required="yes" type="string">
		
		<cfif ucase(trim(tipo)) eq 'H'>
			<cfquery name="data" datasource="#session.DSN#">
				select ce.idcompetencia, RHHcodigo as codigo, RHHdescripcion as descripcion, RHCEdominio as nota
				from RHCompetenciasEmpleado ce
				
				inner join RHHabilidades h
				on ce.Ecodigo=h.Ecodigo
				and ce.idcompetencia=h.RHHid
				
				where ce.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
				and ce.tipo='H'
				and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between ce.RHCEfdesde and ce.RHCEfhasta
				and ce.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.empresa#">
				<cfif len(trim(arguments.filtro))>
					and ce.idcompetencia not in (#arguments.filtro#)
				</cfif>
			</cfquery>
		<cfelse>
			<cfquery name="data" datasource="#session.DSN#">
				select ce.idcompetencia, RHCcodigo as codigo, RHCdescripcion as descripcion, RHCEdominio as nota
				from RHCompetenciasEmpleado ce
				
				inner join RHConocimientos c
				on ce.Ecodigo=c.Ecodigo
				and ce.idcompetencia=c.RHCid
				
				where ce.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
				and ce.tipo='C'
				and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between ce.RHCEfdesde and ce.RHCEfhasta
				and ce.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.empresa#">
				<cfif len(trim(arguments.filtro))>
					and ce.idcompetencia not in (#arguments.filtro#)
				</cfif>
			</cfquery>
		</cfif>
		<cfreturn data > 
	</cffunction>
	
	<!--- cursosLlevados: 
		  devuelve los cursos que un colaborador ha llevado. 
		  Los toma de RHEmpleadoCurso, no interesan las fechas y 
		  consulta los que estan en estado de aprobado (10) en adelante.
		  Excluye los que estan en proceso.
	--->
	<cffunction name="cursosLlevados" returntype="query">
		<cfargument name="empleado" required="yes" type="string">
		<cfargument name="empresa" required="yes" type="string">
		
		<cfquery name="data" datasource="#session.DSN#">
			select 	coalesce(b.RHCcodigo, e.Msiglas) as RHCcodigo, 
					coalesce(d.RHIAnombre, 'N/A') as institucion, 
					coalesce(b.RHCfdesde, a.RHECfdesde) as inicio,
					coalesce(b.RHCfhasta, a.RHECfhasta) as fin,
					coalesce(a.RHEMnota,0) as nota,
					e.Mnombre, <!---coalesce(b.duracion,0) as tiempo,--->
					coalesce(
						(select sum(rha.RHAChoras) 
						from RHAsistenciaCurso rha 
						where rha.DEid=a.DEid 
							and rha.RHCid=a.RHCid
						), 
						coalesce(
							(select RHEMhoras 
							from RHEmpleadoCurso rhec
							where rhec.RHECid=a.RHECid
							), 
							case when b.RHCtipo = 'A' then 
                        		b.duracion
                          		else 0
                          	end 
                        )
                    ) as tiempo,
					case RHEMestado 
						when 0 then 'Progreso' 
						when 10 then 'Aprobado' 
						when 15 then 'Convalidado' 
						when 20 then 'Perdido' 
						when 30 then 'Abandonado' 
						when 40 then 'Retirado' 
					end as estado,
                    RHCtipo
				 
				from RHEmpleadoCurso a
				 
				 inner join RHMateria e
					on a.Mcodigo = e.Mcodigo
					and a.RHEStatusCurso = 1
					and e.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
					
				 left join RHCursos b
					on a.RHCid = b.RHCid
				 
				 left join RHOfertaAcademica c
					on b.RHIAid = c.RHIAid
					and b.Mcodigo = c.Mcodigo
				 
				 left join RHInstitucionesA d
					on c.RHIAid = d.RHIAid
					and e.CEcodigo = d.CEcodigo
				 
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.empresa#">
					and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
					and a.RHEMestado in (10, 15, 20)
				order by estado, inicio	
		</cfquery>
		<cfreturn data > 
	</cffunction>

	<!--- programas: 
		  devuelve los programas/materias/cursos asociados al 
		  centro funcional y puesto del empleado. 
	--->
	<cffunction name="programas" returntype="query">
		<cfargument name="empresa" required="yes" type="numeric">
		<cfargument name="cfuncional" required="yes" type="numeric">
		<cfargument name="puesto" required="yes" type="string">
		<cfargument name="empleado" required="yes" type="string">
		<cfquery name="data" datasource="#session.DSN#">
			select b.RHGMcodigo, b.Descripcion, c.RHMGperiodo, d.Msiglas, d.Mnombre, f.RHCcodigo, f.RHCnombre, f.RHCfdesde as inicio, f.RHCfhasta as fin, d.Mcodigo as Mcodigo 
			from RHGrupoMateriaCF a
			
			inner join RHGrupoMaterias b
			on a.RHGMid=b.RHGMid
			and a.Ecodigo=b.Ecodigo
			
			inner join RHMateriasGrupo c
			on b.Ecodigo=c.Ecodigo
			and b.RHGMid=c.RHGMid
			
			inner join RHMateria d
			on c.Mcodigo=d.Mcodigo
			and d.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
			
			inner join CFuncional e
			on a.CFid=e.CFid
			and a.Ecodigo=e.Ecodigo
			
			left outer join RHCursos f
			on d.Mcodigo=f.Mcodigo
			
			where a.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.cfuncional#">
			and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.empresa#">
			
			union 

			select b.RHGMcodigo, b.Descripcion, c.RHMGperiodo, d.Msiglas, d.Mnombre, f.RHCcodigo, f.RHCnombre, f.RHCfdesde as inicio, f.RHCfhasta as fin, d.Mcodigo as Mcodigo
			from RHPuestos a
			
			inner join RHGrupoMaterias b
			on a.RHGMid=b.RHGMid
			and a.Ecodigo=b.Ecodigo
			
			inner join RHMateriasGrupo c
			on b.Ecodigo=c.Ecodigo
			and b.RHGMid=c.RHGMid
			
			inner join RHMateria d
			on c.Mcodigo=d.Mcodigo
			and d.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
			
			left outer join RHCursos f
			on d.Mcodigo=f.Mcodigo
			
			where a.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.puesto#">
			and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.empresa#">
			
			order by 1, 4, 6	
			<!----
			union 
			
			
			select  'Z*' as RHGMcodigo, '' as Descripcion, null as RHMGperiodo,  '' as Msiglas, '' as Mnombre, b.Msiglas as RHCcodigo, b.Mnombre as RHCnombre , RHPCfdesde as inicio, RHPCfhasta as fin, b.Mcodigo as Mcodigo
			from RHProgramacionCursos a
			
				inner join RHMateria b
					on a.Ecodigo = b.Ecodigo
					and a.Mcodigo = b.Mcodigo
					
					left outer join RHOfertaAcademica c
						on b.Ecodigo = c.Ecodigo
						and b.Mcodigo = c.Mcodigo
				
						left outer join RHInstitucionesA d
							on c.Ecodigo = d.Ecodigo
							and  c.RHIAid = d.RHIAid
			
			where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.empleado#">
				and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.empresa#">
			----->
			
		</cfquery>
		<cfreturn data >
	</cffunction>
	
	<!---Correos
	Envio de correo al programar una evaluacion----->
	
	<cffunction name="correosEvaluacion">
		<cfargument name="empleado" required="yes" type="string">
		<cfargument name="empresa" required="yes" type="string">
		<cfargument name="IDEvaluacion" required="yes" type="string">
		
		<!--- Obtengo el mail del empleado----->
		<cfquery name="rsMail" datasource="#session.DSN#">
			select DEemail, <cf_dbfunction name="concat" args="DEnombre,' ',DEapellido1,' ',DEapellido2"> as Empleado
			from DatosEmpleado
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.empleado#">
		</cfquery>
		<!----Datos de la evaluacion---->
		<cfquery name="rsEvaluacion" datasource="#session.DSN#">
			select RHEEdescripcion,RHEEfdesde,RHEEfhasta
			from RHEEvaluacionDes
			where RHEEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.IDEvaluacion#">
		</cfquery>
		
		<cfset hostname = session.sitio.host>
		<cfset CEcodigo = session.CEcodigo>
		<!--- Se arma el cuerpo del mail ---->
		<cfsavecontent variable="email_body">
			<html>
				<head>
					<style type="text/css">
						.tituloIndicacion {
							font-size: 10pt;
							font-variant: small-caps;
							background-color: #CCCCCC;
						}
						.tituloListas {
							font-weight: bolder;
							vertical-align: middle;
							padding: 2px;
							background-color: #F5F5F5;
						}
						.listaNon { background-color:#FFFFFF; vertical-align:middle; padding-left:5px;}
						.listaPar { background-color:#FAFAFA; vertical-align:middle; padding-left:5px;}
						body,td {
							font-size: 12px;
							background-color: #f8f8f8;
							font-family: Verdana, Arial, Helvetica, sans-serif;
						}
					</style>
				</head>
				<body>
					<table width="99%" align="center"  border="0" cellspacing="0" cellpadding="2">
						<tr>
							<td colspan="7">
								<table width="99%" align="center"  border="0" cellspacing="0" cellpadding="2">
									<tr>
										<td nowrap width="6%"><strong>De:</strong></td>										
										<td width="94%"><cfoutput>#session.Enombre#</cfoutput></td>
									</tr>
									<tr>
										<td><strong>Para:</strong></td>
										<td><cfoutput>#rsMail.Empleado#</cfoutput></td>
									</tr>
									<tr>
										<td nowrap><strong>Asunto:</strong></td>
										<td>Programaci&oacute;n de evaluaci&oacute;n</td>	
									</tr>																			
								</table>
							</td>
						</tr>	
						<tr><td>&nbsp;</td></tr>
						<tr>
							<td width="2%">&nbsp;</td>
							<td colspan="6" width="98%">
								Sr(a)/ Srta: &nbsp;<cfoutput>#rsMail.Empleado#</cfoutput>.<br><br>
								Se le ha programado la evaluación:&nbsp;<cfoutput>#rsEvaluacion.RHEEdescripcion#</cfoutput>.
								La cual tiene vigencia a partir del día &nbsp;<cf_locale name="date" value="#rsEvaluacion.RHEEfdesde#"/> hasta el día &nbsp;<cf_locale name="date" value="#rsEvaluacion.RHEEfhasta#"/> 
							</td>
						</tr>	
						<tr><td colspan="7">&nbsp;</td></tr>
						<tr><td colspan="7">&nbsp;</td></tr>
						<!----
						<tr>														
							<td colspan="7">
								<strong>Nota:</strong> En <cfoutput>#hostname#</cfoutput> respetamos su privacidad.
								Si usted considera que este correo le lleg&oacute; por equivocaci&oacute;n, o si no desea recibir m&aacute;s informaci&oacute;n de nosotros, haga click 
								<a href="http://#hostname#/cfmx/home/public/optout.cfm?b=#CEcodigo#&amp;c=#hostname#&amp;#Hash('please let me out of ' & hostname)#">aqu&iacute;</a>. 
							</td>
						</tr>
						---->					
					</table>
				</body>
			</html>
		</cfsavecontent>		
		
		<cfset email_subject = "Programación de evaluación">
		<cfset email_to = rsMail.DEemail>
		<!---<cfset Email_remitente = "gestion@soin.co.cr">--->
		
		<cfset FromEmail = "capacitacion@soin.co.cr">
		<cfquery name="CuentaPortal"   datasource="#session.dsn#">
			Select valor
			from  <cf_dbdatabase table="PGlobal" datasource="asp">
			Where parametro='correo.cuenta'
		</cfquery>
		<cfif isdefined('CuentaPortal') and CuentaPortal.Recordcount GT 0>
			<cfset FromEmail = CuentaPortal.valor>
		</cfif>
		
		<cfif email_to NEQ ''>				
			<cfquery datasource="#session.dsn#">						
				insert into SMTPQueue (SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml)
				values (
					<cfqueryparam cfsqltype="cf_sql_varchar" value='#FromEmail#'>,
					<cfqueryparam cfsqltype="cf_sql_varchar" value='#email_to#'>,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#email_subject#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#email_body#">, 1)
			</cfquery>
		</cfif>		
	</cffunction>
	
	
	<!--- correos: 
		  Envio de  correo al matricular cursos/materias
	--->
	<cffunction name="correos">
		<cfargument name="empleado" required="yes" type="string">
		<cfargument name="empresa" required="yes" type="string">
		<cfargument name="IDcurso" required="yes" type="string">
		<cfargument name="IDmateria" required="yes" type="string">
		<cfargument name="ID" required="yes" type="string">
		
		<!--- Obtengo el mail del empleado----->
		<cfquery name="rsMail" datasource="#session.DSN#">
			select DEemail, DEnombre, DEapellido1, DEapellido2
			from DatosEmpleado
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.empleado#">
		</cfquery>
		

		<cfset Dato_empleado = trim(rsMail.DEnombre & ' ' & rsMail.DEapellido1 & ' '& rsMail.DEapellido2)>							
		
		<cfset hostname = session.sitio.host>
		<cfset CEcodigo = session.CEcodigo>
		<!---Obtener los datos del curso---->
		<cfif isdefined("arguments.IDcurso") and len(trim(arguments.IDcurso))>
			<cfquery name="rsDatosCurso" datasource="#session.DSN#">
				select a.RHCcodigo as codigo, a.RHCnombre as nombre, a.RHCfdesde as inicio, a.RHCfhasta as fin, c.RHIAnombre as institucion
				from RHCursos a
					left outer join RHOfertaAcademica b
						on a.RHIAid = b.RHIAid 
						and a.Mcodigo = b.Mcodigo
						and a.Ecodigo = b.Ecodigo
					inner join RHMateria d
						on a.Mcodigo = d.Mcodigo
						and d.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
						
					inner join RHInstitucionesA c
						on b.Ecodigo = c.Ecodigo
						and b.RHIAid = c.RHIAid 	
				where a.RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.IDcurso#">
			</cfquery>
		<cfelseif isdefined("arguments.IDmateria") and len(trim(arguments.IDmateria))>
			<cfquery name="rsDatosCurso" datasource="#session.DSN#">
				select b.Msiglas as codigo, b.Mnombre as nombre, a.RHPCfdesde as inicio, a.RHPCfhasta as fin, d.RHIAnombre as institucion
				from RHProgramacionCursos a
					inner join RHMateria b
						on a.Mcodigo = b.Mcodigo
						and b.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
					
						left outer join RHOfertaAcademica c
							on b.Ecodigo = c.Ecodigo
							and b.Mcodigo = c.Mcodigo
							
							inner join RHInstitucionesA d
								on c.Ecodigo = d.Ecodigo
								and c.RHIAid = d.RHIAid
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.empresa#">
					and a.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.IDmateria#">	
					and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.empleado#">
					and a.RHPCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ID#">				
			</cfquery>
		</cfif>

		<!--- Se arma el cuerpo del mail ---->
		<cfsavecontent variable="email_body">
			<html>
				<head>
					<style type="text/css">
						.tituloIndicacion {
							font-size: 10pt;
							font-variant: small-caps;
							background-color: #CCCCCC;
						}
						.tituloListas {
							font-weight: bolder;
							vertical-align: middle;
							padding: 2px;
							background-color: #F5F5F5;
						}
						.listaNon { background-color:#FFFFFF; vertical-align:middle; padding-left:5px;}
						.listaPar { background-color:#FAFAFA; vertical-align:middle; padding-left:5px;}
						body,td {
								font-size: 12px;
							background-color: #f8f8f8;
							font-family: Verdana, Arial, Helvetica, sans-serif;
						}
					</style>
				</head>
				<body>
					<table width="99%" align="center"  border="0" cellspacing="0" cellpadding="2">
						<tr>
							<td colspan="7">
								<table width="99%" align="center"  border="0" cellspacing="0" cellpadding="2">
									<tr>
										<td nowrap width="6%"><strong>De:</strong></td>										
										<td width="94%"><cfoutput>#session.Enombre#</cfoutput></td>
									</tr>
									<tr>
										<td><strong>Para:</strong></td>
										<td><cfoutput>#Dato_empleado#</cfoutput></td>
									</tr>
									<tr>
										<td nowrap><strong>Asunto:</strong></td>
										<td>Programac&oacute;n de curso</td>	
									</tr>																			
								</table>
							</td>
						</tr>	
						<tr><td>&nbsp;</td></tr>
						<tr>
							<td width="2%">&nbsp;</td>
							<td colspan="6" width="98%">
								Sr(a)/ Srta: <cfoutput>#Dato_empleado#</cfoutput>, se le ha programado el curso: <cfoutput>#rsDatosCurso.codigo#-#rsDatosCurso.nombre#</cfoutput>
											El cual se estará llevando a cabo a partir del día <cf_locale name="date" value="#rsDatosCurso.inicio#"/> hasta el día  <cf_locale name="date" value="#rsDatosCurso.fin#"/> y se
											impartirá en <cfoutput>#rsDatosCurso.institucion#</cfoutput>
							</td>
						</tr>	
						<tr><td colspan="7">&nbsp;</td></tr>
						<tr><td colspan="7">&nbsp;</td></tr>
						<!----
						<tr>														
							<td colspan="7">
								<strong>Nota:</strong> En <cfoutput>#hostname#</cfoutput> respetamos su privacidad.
								Si usted considera que este correo le lleg&oacute; por equivocaci&oacute;n, o si no desea recibir m&aacute;s informaci&oacute;n de nosotros, haga click 
								<a href="http://#hostname#/cfmx/home/public/optout.cfm?b=#CEcodigo#&amp;c=#hostname#&amp;#Hash('please let me out of ' & hostname)#">aqu&iacute;</a>. 
							</td>
						</tr>
						---->					
					</table>
				</body>
			</html>
		</cfsavecontent>
			
		<cfset email_subject = "Programación de curso">
		<cfset email_to = rsMail.DEemail>
		<!--- <cfset Email_remitente = "gestion@soin.co.cr">--->
	
		<cfset FromEmail = "capacitacion@soin.co.cr">
		<cfquery name="CuentaPortal"   datasource="asp">
			Select valor
			from  PGlobal
			Where parametro='correo.cuenta'
		</cfquery>
		<cfif isdefined('CuentaPortal') and CuentaPortal.Recordcount GT 0>
			<cfset FromEmail = CuentaPortal.valor>
		</cfif>
	
		<cfif email_to NEQ ''>				
			<cfquery datasource="#session.dsn#">						
				insert into SMTPQueue (SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml)
				values (
					<cfqueryparam cfsqltype="cf_sql_varchar" value='#FromEmail#'>,
					<cfqueryparam cfsqltype="cf_sql_varchar" value='#email_to#'>,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#email_subject#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#email_body#">, 1)
			</cfquery>
		</cfif>		
	</cffunction>			

	<!--- evaluaciones360: 
		  devuelve las evaluaciones aplicadas al colaborador. 
	--->
	<cffunction name="evaluaciones360" returntype="query">
		<cfargument name="empleado" required="yes" type="string">
		<cfargument name="empresa" required="yes" type="string">
		
		<cf_dbtemp name="temp_EvalDisplay1" returnvariable="EvalDisplay" datasource="#session.dsn#">
			<cf_dbtempcol name="RHEEid"					type="numeric"  		mandatory="no">
			<cf_dbtempcol name="RHPcodigo"				type="varchar(255)"  	mandatory="no">
			<cf_dbtempcol name="RHPdescpuesto"			type="varchar(255)"  	mandatory="no">
			<cf_dbtempcol name="RHLEnotajefe"			type="numeric(7,4)"			mandatory="no">
			<cf_dbtempcol name="RHLEnotaauto"			type="numeric(7,4)"			mandatory="no">
			<cf_dbtempcol name="RHLEpromotros"		    type="numeric(7,4)"			mandatory="no">
			<cf_dbtempcol name="RHEEdescripcion"		type="varchar(255)"		mandatory="no">
			<cf_dbtempcol name="RHEEfdesde"				type="date"	    		mandatory="no">
			<cf_dbtempcol name="promglobal"				type="numeric(7,4)"	   		mandatory="no">
	</cf_dbtemp>	

		<cfquery name="data" datasource="#session.DSN#">
			insert into #EvalDisplay# ( RHEEid, RHPcodigo,RHPdescpuesto, RHLEnotajefe,RHLEnotaauto,RHLEpromotros, RHEEdescripcion, RHEEfdesde, promglobal)
			select a.RHEEid, coalesce(ltrim(rtrim(c.RHPcodigoext)),ltrim(rtrim(c.RHPcodigo))) as RHPcodigo, c.RHPdescpuesto, 
			coalesce(a.RHLEnotajefe,0), coalesce(a.RHLEnotaauto,0), coalesce(a.RHLEpromotros,0), 
			b.RHEEdescripcion, b.RHEEfdesde,coalesce( a.promglobal,0)
			from RHListaEvalDes a
			
			inner join RHEEvaluacionDes b
			on a.Ecodigo=b.Ecodigo
			and a.RHEEid=b.RHEEid
			and ( b.RHEEestado=3 or ( b.RHEEestado=5 and b.RHEEfhasta < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> ))
			and b.PCid <= 0<!--- 0 = POR CONOCIMIENTOS o -1 = POR HABILIDADES o -2 POR HABILIDADES Y CONOCIMIENTOS--->
			
			inner join RHPuestos c
			on a.RHPcodigo=c.RHPcodigo
			and a.Ecodigo=c.Ecodigo
			
			where a.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#empleado#">
			and a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#empresa#">
			order by RHEEfdesde desc
		</cfquery>
		
		<cfquery name="data" datasource="#session.DSN#">
			insert into #EvalDisplay# ( RHEEid, RHPcodigo,RHPdescpuesto, RHLEnotajefe,RHLEnotaauto,RHLEpromotros, RHEEdescripcion, RHEEfdesde, promglobal)
			select a.RHEEid, coalesce(ltrim(rtrim(c.RHPcodigoext)),ltrim(rtrim(c.RHPcodigo))) as RHPcodigo, c.RHPdescpuesto, 
			coalesce(a.RHLEnotajefe,0), coalesce(a.RHLEnotaauto,0), coalesce(a.RHLEpromotros,0),
			b.RHEEdescripcion, b.RHEEfdesde,coalesce( a.promglobal,0)
			from RHListaEvalDes a
			
			inner join RHEEvaluacionDes b
				<!--- Se van a tomar en cuenta las evaluaciones que se realizaron por cuestionario tipo Cuestionario
				 (0=Cuestionario, 10=Encuesta, 20=Bezinger, 30=test, 40=Otros)--->
				inner join PortalCuestionario pc
				on pc.PCid=b.PCid
				and pc.PCtipo=0
			on a.Ecodigo=b.Ecodigo
			and a.RHEEid=b.RHEEid
			and ( b.RHEEestado=3 or ( b.RHEEestado=5 and b.RHEEfhasta < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> ))
			and b.PCid > 0
		
			inner join RHPuestos c
			on a.RHPcodigo=c.RHPcodigo
			and a.Ecodigo=c.Ecodigo
			
			where a.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#empleado#">
			and a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#empresa#">
			order by RHEEfdesde desc
		</cfquery>
<!---		<cf_dump var="#data#">--->
		<cfquery name="data" datasource="#session.DSN#">
			select * from #EvalDisplay#
		</cfquery>
		<cfreturn data >
	</cffunction>	

	<!--- misevaluaciones: 
		  devuelve las evaluaciones aplicadas por el colaborador. 
	--->
	<cffunction name="misevaluaciones" returntype="query">
		<cfargument name="empleado" required="yes" type="string">
		<cfargument name="empresa" required="yes" type="string">

		<cfquery name="data" datasource="#session.DSN#">
			select a.RHEEid, a.DEid, 
			<cf_dbfunction name="concat" args="e.DEnombre,' ',e.DEapellido1,'  ',e.DEapellido2"> as empleado,
			coalesce(ltrim(rtrim(c.RHPcodigoext)),ltrim(rtrim(c.RHPcodigo))) as RHPcodigo, c.RHPdescpuesto, b.RHEEdescripcion, b.RHEEfdesde, case when d.RHEDtipo = 'J' then RHLEnotajefe else RHLEpromotros end as nota
			from RHListaEvalDes a
			
			inner join RHEEvaluacionDes b
			on a.Ecodigo=b.Ecodigo
			and a.RHEEid=b.RHEEid
			and ( b.RHEEestado=3 or ( b.RHEEestado=5 and b.RHEEfhasta < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> ))
			
			inner join RHPuestos c
			on a.RHPcodigo=c.RHPcodigo
			and a.Ecodigo=c.Ecodigo
		
			inner join RHEvaluadoresDes d
			on a.RHEEid=d.RHEEid
			and a.DEid=d.DEid
			and d.DEideval=<cfqueryparam cfsqltype="cf_sql_numeric" value="#empleado#">
			and d.RHEDtipo <> 'A'
		
			inner join DatosEmpleado e
			on a.Ecodigo=e.Ecodigo
			and a.DEid=e.DEid
			
			where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#empresa#">
			order by RHEEfdesde desc, a.RHEEid, empleado
		</cfquery>
		<cfreturn data >
	</cffunction>

	<!--- otrasevaluaciones: 
		  devuelve las otrao tipo de evaluaciones aplicadas al colaborador. 
	--->
	<cffunction name="otrasevaluaciones" returntype="query">
		<cfargument name="empleado" required="yes" type="string">
		<cfargument name="empresa" required="yes" type="string">
		<cfargument name="tipo" required="no" type="string">
		
		<cf_dbtemp name="temp_EvalDisplayOtros" returnvariable="EvalDisplayOtros" datasource="#session.dsn#">
			<cf_dbtempcol name="RHEEid"					type="numeric"  		mandatory="no">
			<cf_dbtempcol name="RHPcodigo"				type="varchar(255)"  	mandatory="no">
			<cf_dbtempcol name="RHPdescpuesto"			type="varchar(255)"  	mandatory="no">
			<cf_dbtempcol name="RHLEnotajefe"			type="numeric(7,4)"			mandatory="no">
			<cf_dbtempcol name="RHLEnotaauto"			type="numeric(7,4)"			mandatory="no">
			<cf_dbtempcol name="RHLEpromotros"		    type="numeric(7,4)"			mandatory="no">
			<cf_dbtempcol name="RHEEdescripcion"		type="varchar(255)"		mandatory="no">
			<cf_dbtempcol name="RHEEfdesde"				type="date"	    		mandatory="no">
			<cf_dbtempcol name="promglobal"				type="numeric(7,4)"	   		mandatory="no">
	</cf_dbtemp>	
<!---
		<cfquery name="data" datasource="#session.DSN#">
			insert into #EvalDisplayOtros# ( RHEEid, RHPcodigo,RHPdescpuesto, RHLEnotajefe,RHLEnotaauto,RHLEpromotros, RHEEdescripcion, b.RHEEfdesde, promglobal)
			select a.RHEEid, coalesce(ltrim(rtrim(c.RHPcodigoext)),ltrim(rtrim(c.RHPcodigo))) as RHPcodigo,
			 c.RHPdescpuesto, a.RHLEnotajefe, a.RHLEnotaauto, a.RHLEpromotros, b.RHEEdescripcion, b.RHEEfdesde, a.promglobal
			from RHListaEvalDes a
			
			inner join RHEEvaluacionDes b
			on a.Ecodigo=b.Ecodigo
			and a.RHEEid=b.RHEEid
			and ( b.RHEEestado=3 or ( b.RHEEestado=5 and b.RHEEfhasta < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> ))
			and b.PCid <= 0 <!--- 0 = POR CONOCIMIENTOS o -1 = POR HABILIDADES o -2 POR HABILIDADES Y CONOCIMIENTOS--->

			inner join RHPuestos c
			on a.RHPcodigo=c.RHPcodigo
			and a.Ecodigo=c.Ecodigo
			
			where a.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#empleado#">
			and a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#empresa#">
			order by RHEEfdesde desc
		</cfquery>
		--->
		<cfquery name="data" datasource="#session.DSN#">
			insert into #EvalDisplayOtros# ( RHEEid, RHPcodigo,RHPdescpuesto, RHLEnotajefe,RHLEnotaauto,RHLEpromotros, RHEEdescripcion, RHEEfdesde, promglobal)
			select a.RHEEid, coalesce(ltrim(rtrim(c.RHPcodigoext)),ltrim(rtrim(c.RHPcodigo))) as RHPcodigo,
			 c.RHPdescpuesto, a.RHLEnotajefe, a.RHLEnotaauto, a.RHLEpromotros, b.RHEEdescripcion, b.RHEEfdesde, a.promglobal
			from RHListaEvalDes a
			
			inner join RHEEvaluacionDes b
			on a.Ecodigo=b.Ecodigo
			and a.RHEEid=b.RHEEid
			and ( b.RHEEestado=3 or ( b.RHEEestado=5 and b.RHEEfhasta < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> ))
			and b.PCid > 0 

			inner join PortalCuestionario pc
			on b.PCid=pc.PCid
			<cfif isdefined("arguments.tipo") and len(trim(arguments.tipo)) >
				and pc.PCtipo in (#arguments.tipo#)
			</cfif>
			
			inner join RHPuestos c
			on a.RHPcodigo=c.RHPcodigo
			and a.Ecodigo=c.Ecodigo
			
			where a.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#empleado#">
			and a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#empresa#">
			order by RHEEfdesde desc
		</cfquery>
		
		<cfquery name="data" datasource="#session.DSN#">
			select * from #EvalDisplayOtros#
		</cfquery>
		<cfreturn data >
	</cffunction>
	
	<!--- evalprogramadas: 
		  devuelve las evaluaciones programadas al colaborador para el futuro. 
		  La fecha actual debe ser menor al la fecah de inicio de la evaluacion
		  o debe estar entre las fechas desde y hasta de la evaluacion
	--->
	<cffunction name="evalprogramadas" returntype="query">
		<cfargument name="empleado" required="yes" type="string">
		<cfargument name="empresa" required="yes" type="string">

		<cfquery name="data" datasource="#session.DSN#">
			select b.RHEEdescripcion as relacion, b.RHEEfdesde as inicio, b.RHEEfhasta as fin
			from RHListaEvalDes a
			
			inner join RHEEvaluacionDes b
			on b.Ecodigo=a.Ecodigo
			and b.RHEEid=a.RHEEid
			and b.RHEEestado!=3
			and ( <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> < b.RHEEfdesde or <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between b.RHEEfdesde and b.RHEEfhasta )

			where a.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#empleado#">
			and a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#empresa#">
			order by b.RHEEfdesde
		</cfquery>
		<cfreturn data >
	</cffunction>	
	
	
	
</cfcomponent>
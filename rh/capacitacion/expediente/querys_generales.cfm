<!--Cursos que esta llevando actualmente el empleado--->
<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.DSN#" ecodigo="#session.Ecodigo#" pvalor="2109" default="" returnvariable="valP"/>
<cfquery name="cursosporllevar" datasource="#session.DSN#">
	select  {fn concat( b.RHCcodigo,{fn concat(' - ',b.RHCnombre )})}  as descripcion,
			coalesce(c.RHIAcodigo,'<cf_translate key="MSG_No_especificada">No especificada</cf_translate>') as institucion,
			b.RHCfdesde as inicio,
			b.RHCfhasta as fin
			,(
				case when b.RHCautomat = 1
					and not exists (select 1 from RHRelacionCap rc, RHDRelacionCap rd
									where rc.RHCid = b.RHCid
									  and rc.RHRCestado = 40
									  and rc.RHRCid = rd.RHRCid
									  and rd.DEid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#"> )
					and a.RHEMestado = 0
				then {fn concat('<img src="/cfmx/rh/imagenes/Borrar01_S.gif" width="20" height="18" onClick="Eliminar(',{fn concat(<cf_dbfunction name="to_char" args="b.RHCid">, ')">')})} 
								<!---'<img src="/cfmx/rh/imagenes/Borrar01_S.gif" width="20" height="18" onClick="Eliminar(' || <cf_dbfunction name="to_char" args="b.RHCid"> || ')">' --->
				else '' end
			) as removible,RHECestado
			
	from RHEmpleadoCurso a
		inner join RHCursos b
			on a.RHCid = b.RHCid
		inner join RHMateria d
			on b.Mcodigo = d.Mcodigo
			and d.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#"> 
		inner join RHInstitucionesA c
			on b.RHIAid = c.RHIAid
			and b.Ecodigo = c.Ecodigo
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
		and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		and a.RHCid is not null
		and a.RHEMestado=0

	
	union 
	
	select  {fn concat( b.Msiglas,{fn concat(' - ',b.Mnombre )})}   as descripcion, 
			coalesce(d.RHIAcodigo,'<cf_translate key="MSG_No_especificada">No especificada</cf_translate>') as institucion,
			a.RHECfdesde as inicio,
			a.RHECfhasta as fin	
			,(
				case when x.RHCautomat = 1
					and not exists (select 1 from RHRelacionCap rc, RHDRelacionCap rd
									where rc.RHCid = x.RHCid
									  and rc.RHRCestado = 40
									  and rc.RHRCid = rd.RHRCid
									  and rd.DEid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#"> )
					and a.RHEMestado = 0
				then {fn concat('<img src="/cfmx/rh/imagenes/Borrar01_S.gif" width="20" height="18" onClick="Eliminar(',{fn concat(<cf_dbfunction name="to_char" args="x.RHCid">,')">' )})}
				<!---'<img src="/cfmx/rh/imagenes/Borrar01_S.gif" width="20" height="18" onClick="Eliminar(' ||   <cf_dbfunction name="to_char" args="x.RHCid">  || ')">' --->
				else '' end
			) as removible		,RHECestado
	from RHEmpleadoCurso a
		
		inner join RHCursos x
			on a.RHCid = x.RHCid
			
		inner join RHMateria b
			on a.Mcodigo = b.Mcodigo
			and b.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
			
		left outer join RHOfertaAcademica c
			on b.Mcodigo = c.Mcodigo
			and b.Ecodigo = c.Ecodigo			
			left outer join  RHInstitucionesA d
				on c.RHIAid = d.RHIAid
				and c.Ecodigo = d.Ecodigo
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		and a.RHCid is null
		and a.RHEMestado=0

</cfquery>

<!----TAB DE EXPEDIENTE (RESUMEN DE PLAN DE CAPACITACION)--->
<!---Cursos programados--->
<cfquery name="rsCProgramados" datasource="#session.DSN#">
	select  case when b.RHCnombre is null then '<cf_translate key="MSG_No_especificada">No especificada</cf_translate>' else  d.Mnombre end as Mnombre,
			case when e.RHACdescripcion is null then 'N/A' else e.RHACdescripcion end as RHACdescripcion,
			case f.RHIAcodigo when null then '<cf_translate key="MSG_No_especificada">No especificada</cf_translate>' else f.RHIAcodigo end as RHIAnombre ,
			a.RHPCfdesde as fdesde,
			a.RHPCfhasta as fhasta,
			b.RHCcodigo
			,a.RHCid
			,'' as removible
	from RHProgramacionCursos a
		  
		inner join RHCursos b
			on a.RHCid = b.RHCid
		
			inner join RHOfertaAcademica c
				on b.RHIAid = c.RHIAid
				and b.Mcodigo = c.Mcodigo
				
				inner join RHMateria d
					on c.Mcodigo = d.Mcodigo
					and d.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
					
					left outer join RHAreasCapacitacion e
						on d.RHACid = e.RHACid 
						--and d.Ecodigo = e.Ecodigo
				
				inner join RHInstitucionesA  f
					on c.RHIAid = f.RHIAid 
					--and c.Ecodigo = f.Ecodigo
		
		
	
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">						
		and a.DEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#"> 
		and a.RHCid not in(select RHCid
							from RHEmpleadoCurso
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#"> 
						)
		and a.RHCid is not null
		and a.RHACid is null
	
		/*Materias (cursos)*/
	union 
	
	select 	case when c.Mnombre is null then '<cf_translate key="MSG_No_especificada">No especificada</cf_translate>' else  c.Mnombre end as Mnombre,
			case when d.RHACdescripcion is null then '<cf_translate key="MSG_No_especificada">No especificada</cf_translate>' else d.RHACdescripcion end as RHACdescripcion,		
			case when e.RHIAcodigo is null then '<cf_translate key="MSG_No_especificada">No especificada</cf_translate>' else e.RHIAcodigo end as RHIAnombre ,
			a.RHPCfdesde as fdesde,
			a.RHPCfhasta as fhasta,
			null as RHCcodigo
			,a.RHCid
			,'' as removible
			
	from RHProgramacionCursos a
		
		left outer join RHOfertaAcademica b
			on a.RHIAid = b.RHIAid
			and a.Mcodigo = b.Mcodigo
			
			inner join RHMateria c
				on b.Mcodigo = c.Mcodigo
				and c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
			
				left outer join RHAreasCapacitacion d
					on c.RHACid = d.RHACid 
					--and c.Ecodigo = d.Ecodigo
	
			inner join RHInstitucionesA e
				on b.RHIAid = e.RHIAid
				--and b.Ecodigo = e.Ecodigo
	
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
		and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		and a.RHIAid is not null
		and a.Mcodigo is not null
		and a.RHACid is null
		and a.RHCid is null
			
		/* Areas de capacitacion */
	union
	
	select 	'N/A' as Mnombre,
			b.RHACdescripcion,
			'N/A' as RHIAnombre,
			a.RHPCfdesde as fdesde,
			a.RHPCfhasta as fhasta,
			null as RHCcodigo
			,a.RHCid
			,'' as removible
			
	from  RHProgramacionCursos a
		left outer join RHAreasCapacitacion b
			on a.RHACid = b.RHACid
			--and a.Ecodigo = b.Ecodigo
		
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#"> 
		and a.RHACid is not null

	order by fdesde desc, 5
</cfquery>	

<cfloop query="rsCProgramados">
	
	<cfif isdefined('rsCProgramados.RHCid') and len(trim(rsCProgramados.RHCid))>
		
		<cfset remov = ''>
		<cfquery name="x" datasource="#session.dsn#">
			select 1 from RHRelacionCap rc, RHDRelacionCap rd 
			where rc.RHCid = #rsCProgramados.RHCid#
			and rc.RHRCestado = 40 
			and rc.RHRCid = rd.RHRCid 
			and rd.DEid = #form.DEid#
		</cfquery>
		<cfif x.recordcount gt 0>
			<cfquery name="rsCProgramados2" dbtype="query">	
<!---			
			
			select a.RHCid,
				(case when not exists (select 1 from RHRelacionCap rc, RHDRelacionCap rd
				where rc.RHCid = a.RHCid
				and rc.RHRCestado = 40
				and rc.RHRCid = rd.RHRCid
				and rd.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#"> )
				
				and a.RHCautomat = 1 and w.RHEMestado = 0
				then {fn concat('<img src="/cfmx/rh/imagenes/Borrar01_S.gif" width="20" height="18" onClick="Eliminar(',{fn concat(<cf_dbfunction name="to_char" args="a.RHCid">,')">')})}
				<!---'<img src="/cfmx/rh/imagenes/Borrar01_S.gif" width="20" height="18" onClick="Eliminar(' || <cf_dbfunction name="to_char" args="a.RHCid"> || ')">' --->
				
				else '' end
				) as removible
				from RHCursos a
				
				inner join RHEmpleadoCurso w
				on w.RHCid = a.RHCid
				and w.DEid = = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
				where a.RHCid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCProgramados.RHCid#">--->
				select a.RHCid, 
					(case when a.RHCautomat = 1
							and not exists (select 1 from RHRelacionCap rc, RHDRelacionCap rd
											where rc.RHCid = a.RHCid
											  and rc.RHRCestado = 40
											  and rc.RHRCid = rd.RHRCid
											  and rd.DEid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#"> )
							and w.RHEMestado = 0
						then {fn concat('<img src="/cfmx/rh/imagenes/Borrar01_S.gif" width="20" height="18" onClick="Eliminar(',{fn concat(<cf_dbfunction name="to_char" args="a.RHCid">,')">')})} 
						<!---'<img src="/cfmx/rh/imagenes/Borrar01_S.gif" width="20" height="18" onClick="Eliminar(' ||  <cf_dbfunction name="to_char" args="a.RHCid"> || ')">' --->
	
						else '' end
					) as removible 
				from 	RHCursos a
					
					inner join RHEmpleadoCurso w
						on w.RHCid = a.RHCid
						and w.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
				where a.RHCid =  <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCProgramados.RHCid#">
			</cfquery>
	
		
		<cfset remov = rsCProgramados2.removible>
			</cfif>
		<cfset rsCProgramados.removible = remov>
	
	</cfif>
</cfloop>

<cfquery name="cursosporllevar" datasource="#session.DSN#">
	select distinct b.RHCcodigo,
	  case f.RHIAnombre when null then '<cf_translate key="MSG_Inst_No_especificada">Inst. No especificada</cf_translate>' else f.RHIAnombre end as institucion,
	  b.RHCnombre as Mnombre,
	  a.RHPCfdesde as inicio,
	  a.RHPCfhasta as fin  
	  
	 from RHProgramacionCursos a
	 
	  left outer join RHCursos b
	   on a.RHCid = b.RHCid
	   and a.Ecodigo = b.Ecodigo
		and ( b.RHCid in ( 	select distinct c.RHCid
							from RHHabilidadesMaterias hm
							
							inner join RHHabilidadesPuesto hp
							on hm.Ecodigo=hp.Ecodigo
							and hm.RHHid=hp.RHHid
							and RHPcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#ps#">
							
							inner join RHCursos c
							on hm.Ecodigo=c.Ecodigo
							and hm.Mcodigo=c.Mcodigo
							
							where hm.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> )
							
							
		or b.RHCid in ( 	select distinct c.RHCid
							from RHConocimientosMaterias hm
							
							inner join RHConocimientosPuesto hp
							on hm.Ecodigo=hp.Ecodigo
							and hm.RHCid=hp.RHCid
							and RHPcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#ps#">
							
							inner join RHCursos c
							on hm.Ecodigo=c.Ecodigo
							and hm.Mcodigo=c.Mcodigo
							
							where hm.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> ) )																					
	  
	   inner join RHOfertaAcademica c
		on b.RHIAid = c.RHIAid
		and b.Mcodigo = c.Mcodigo
		and b.Ecodigo = c.Ecodigo
		
		inner join RHMateria d
		 on c.Mcodigo = d.Mcodigo
		 and c.Ecodigo = d.Ecodigo
		 
		 left outer join RHAreasCapacitacion e
		  on d.RHACid = e.RHACid 
		  and d.Ecodigo = e.Ecodigo
		
		inner join RHInstitucionesA  f
		 on c.RHIAid = f.RHIAid 
		 and c.Ecodigo = f.Ecodigo
	 
	 where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and a.DEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
	  and a.RHCid is not null
	  and a.RHACid is null
	  and RHPCfdesde > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
	  and a.RHCid not in(select RHCid
							from RHEmpleadoCurso
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#"> 
						)
</cfquery>

<!--- ******* FALTA FILTRAR POR LA COMPETRENCIAS ASOCIADAS AL PUESTO DEL PLAN. VER EL SUBQUERY DE CURSOS ACTUALES--->
<cfquery name="areascapacitar" datasource="#session.DSN#">
select  distinct  b.RHACdescripcion
       
from  RHProgramacionCursos a
     
 left outer join RHAreasCapacitacion b
  on a.RHACid = b.RHACid
  and a.Ecodigo = b.Ecodigo
      
where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
 and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
 and a.RHACid is not null
 and RHPCfdesde > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
</cfquery>

<!---
<cfquery name="cursosporllevar" datasource="#session.DSN#">
	select b.RHCcodigo, d.RHIAnombre as institucion, 
	  b.RHCfdesde as inicio,
	  b.RHCfhasta as fin,
	  e.Mnombre
	 
	from RHProgramacionCursos a
	 
	 inner join RHCursos b
	  on a.RHCid = b.RHCid
	  and a.Ecodigo = b.Ecodigo
	  and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> < RHCfdesde  
	 
	 inner  join RHOfertaAcademica c
	  on b.RHIAid = c.RHIAid
	  and b.Mcodigo = c.Mcodigo
	  and b.Ecodigo = c.Ecodigo
	 
	 inner join RHInstitucionesA d
	  on c.RHIAid = d.RHIAid
	  and c.Ecodigo = d.Ecodigo
	 
	 inner join RHMateria e
	  on c.Mcodigo = e.Mcodigo
	  and c.Ecodigo = e.Ecodigo
	 
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	 and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
	 and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> < a.RHPCfdesde
	order by inicio, RHCcodigo
</cfquery>
--->

<table width="100%" cellpadding="0" cellspacing="0">
	<tr>
		<td align="center" bgcolor="#CCCCCC" style="padding:3;"><strong>Cursos Planeados</strong></td>
	</tr>

	<tr><td>
		<!--- Cursos que llevara el colaborador en el futuro --->
		<table width="100%" cellpadding="2" cellspacing="0" >
			<cfif cursosporllevar.recordcount + areascapacitar.recordcount gt 0>
				<cfif cursosporllevar.recordcount gt 0>
					<tr>
						<td class="tituloListas"><cf_translate key="LB_Curso">Curso</cf_translate></td>
						<td class="tituloListas"><cf_translate key="LB_Fecha_Inicio">Fecha Inicio</cf_translate></td>
						<td class="listaCorte"><cf_translate key="LB_Fecha_Final">Fecha Final</cf_translate></td>
						<td class="tituloListas"><cf_translate key="LB_Institucion">Institución</cf_translate></td>
					</tr>

					<cfoutput query="cursosporllevar">
						<tr class="<cfif cursosporllevar.currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
							<td>#trim(cursosporllevar.RHCcodigo)# - #cursosporllevar.Mnombre#</td>
							<td align="left"><cf_locale name="date" value="#cursosporllevar.inicio#"/></td>
							<td align="left"><cf_locale name="date" value="#cursosporllevar.fin#"/></td>
							<td align="left">#cursosporllevar.institucion#</td>
						</tr>
					</cfoutput>
				</cfif>
				<cfif areascapacitar.recordcount gt 0>
					<tr><td colspan="4" class="tituloListas">Areas de Capacitaci&oacute;n</td></tr>					
					<cfoutput query="areascapacitar">
						<tr class="<cfif areascapacitar.currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
							<td colspan="4">#trim(areascapacitar.RHACdescripcion)#</td>
						</tr>
					</cfoutput>
				</cfif>

			<cfelse>
				<tr><td colspan="2" align="center">-El colaborador no tiene cursos programados-</td></tr>
			</cfif>
		</table>
	</td></tr>
</table>
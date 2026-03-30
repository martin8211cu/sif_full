<!----
<cfquery name="cursosporllevar" datasource="#session.DSN#">
	select b.RHCcodigo,
	  case f.RHIAnombre when null then 'Inst.no especificada' else f.RHIAnombre end as institucion,
	  b.RHCnombre as Mnombre,
	  a.RHPCfdesde as inicio,
	  a.RHPCfhasta as fin  
	  
	 from RHProgramacionCursos a
	 
	  left outer join RHCursos b
	   on a.RHCid = b.RHCid
	   and a.Ecodigo = b.Ecodigo
	  
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
</cfquery>
---->
<cfset cursosporllevar = rsCProgramados>

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


<table width="100%" cellpadding="0" cellspacing="0">
	<tr>
		<td align="center" bgcolor="#CCCCCC" style="padding:3; " ><strong><cf_translate key="LB_Cursos_Planeados">Cursos Planeados</cf_translate></strong></td>
	</tr>

	<tr><td>
		<!--- Cursos que llevara el colaborador en el futuro --->
		<table width="100%" cellpadding="2" cellspacing="0" >
			<cfif cursosporllevar.recordcount +  areascapacitar.recordcount gt 0>
				<cfif cursosporllevar.recordcount GT 0>
					<tr>
						<td class="tituloListas"><cf_translate key="LB_Curso">Curso</cf_translate></td>
						<td class="tituloListas"><cf_translate key="LB_Fecha_Inicio">Fecha Inicio</cf_translate></td>
						<td class="tituloListas"><cf_translate key="LB_Fecha_Final">Fecha Final</cf_translate></td>
						<td class="tituloListas"><cf_translate key="LB_Institucion">Instituci&oacute;n</cf_translate></td>
					</tr>

					<cfoutput query="cursosporllevar">
						<tr class="<cfif cursosporllevar.currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
							<td>#trim(cursosporllevar.RHCcodigo)# - #cursosporllevar.Mnombre#</td>
							<td align="left"><cf_locale name="date" value="#cursosporllevar.fdesde#"/></td>
							<td align="left"><cf_locale name="date" value="#cursosporllevar.fhasta#"/></td>
							<td align="left">#cursosporllevar.RHIAnombre#</td>
						</tr>
					</cfoutput>
				</cfif>				
				
				<cfif areascapacitar.recordcount gt 0>
					<tr><td colspan="4" class="tituloListas"><cf_translate key="LB_Areas_de_Capacitacion">Areas de Capacitación</cf_translate></td></tr>					
					<cfoutput query="areascapacitar">
						<tr class="<cfif areascapacitar.currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
							<td colspan="4">#trim(areascapacitar.RHACdescripcion)#</td>
						</tr>
					</cfoutput>
				</cfif>
				
			<cfelse>
				<tr><td colspan="2" align="center">-<cf_translate key="LB_El_colaborador_no_tiene_cursos_programados">El colaborador no tiene cursos programados</cf_translate>-</td></tr>
			</cfif>
		</table>
	</td></tr>
</table>
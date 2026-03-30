<cfquery name="rsDatos" datasource="#session.DSN#">
	select  
		'#session.Enombre#' as  Edescripcion,
		b.DEidentificacion,coalesce(sum(ec.RHAChoras),0) as horas,
		{fn concat(b.DEapellido1,{fn concat(' ',{fn concat(b.DEapellido2,{fn concat(' ',b.DEnombre)})})})} as nombre,
		RHPdescpuesto,
		case	
			when (a.RHEMestado=0 and a.RHEStatusCurso = 1) then '<cf_translate  key="LB_Enprogreso">En progreso</cf_translate>' 
			when (a.RHEMestado=10 and a.RHEStatusCurso = 1) then '<cf_translate  key="LB_Aprobado">Aprobado</cf_translate>' 
			when (a.RHEMestado=15 and a.RHEStatusCurso = 1) then '<cf_translate  key="LB_Convalidado">Convalidado</cf_translate>' 
			when (a.RHEMestado=20 and a.RHEStatusCurso = 1) then '<cf_translate  key="LB_Perdido">Perdido</cf_translate>' 
			when (a.RHEMestado=30 and a.RHEStatusCurso = 1) then '<cf_translate  key="LB_Abandonado">Abandonado</cf_translate>' 
			when (a.RHEMestado=40 and a.RHEStatusCurso = 1) then '<cf_translate  key="LB_Retirado">Retirado</cf_translate>' 
			when (a.RHEMestado=0 and a.RHEStatusCurso = 0) then '<cf_translate  key="LB_ExcluidodeCurso">Excluido de Curso</cf_translate>' 
		end RHEMestado,
		RHEMnota,e.RHCtipo,
		e.RHCfdesde,e.RHCfhasta,e.RHCprofesor,e.RHCcupo,e.RHCnombre,e.duracion,e.lugar,f.RHIAnombre as institucion						
	from RHEmpleadoCurso a
	inner join RHCursos e
		on a.RHCid = e.RHCid
	left outer  join RHAsistenciaCurso ec
		on a.RHCid=ec.RHCid
		and a.DEid=ec.DEid
	inner join DatosEmpleado b
		on a.DEid = b.DEid
		and a.Ecodigo = b.Ecodigo
	inner join LineaTiempo c
		on c.Ecodigo = a.Ecodigo
		and c.DEid = a.DEid	
		and RHCfdesde between c.LTdesde and c.LThasta		
	inner join RHPuestos d
		on d.Ecodigo = c.Ecodigo
		and d.RHPcodigo=c.RHPcodigo
	inner join RHCursos e1
		on a.RHCid = e1.RHCid
	left outer join RHDiasCurso dc 
			on dc.RHCid=e1.RHCid 
			and dc.RHDCactivo=1 
			and dc.RHDCid=ec.RHDCid
	inner join RHInstitucionesA f
		on e1.RHIAid = f.RHIAid
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">																			
	and a.RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.rhcid#">
	group by DEidentificacion,b.DEnombre,b.DEapellido1,b.DEapellido2,RHPdescpuesto,
    RHEMestado,RHEMnota, e.RHCfdesde,e.RHCfhasta,e.RHCprofesor,e.RHCcupo,
    e.RHCnombre,e.duracion,e.lugar,f.RHIAnombre,RHEStatusCurso,e.RHCtipo
	order by b.DEapellido1,b.DEapellido2,b.DEnombre
</cfquery>
<!--- --RHAChoras, --->
<cfif rsDatos.recordcount gt 0 >
	<cfif rsDatos.RHCtipo neq 'P'>
		<cfreport format="#url.formato#" template="Rep_InformacionCursos-rep.cfr" query="rsDatos">
		</cfreport>	
	<cfelse>
		<cfreport format="#url.formato#" template="Rep_InformacionCursos-repP.cfr" query="rsDatos">
		</cfreport>
	</cfif>
<cfelse>
	<table width="98%" cellpadding="0" cellspacing="0">
		<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_ReporteInformacionDetalladaDeCursos"
				Default="Reporte información detallada de cursos"
				returnvariable="LB_ReporteInformacionDetalladaDeCursos"/> 
		
		<cfoutput>
			<tr><td>&nbsp;</td></tr>
			<tr><td align="center"><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">#session.Enombre#</strong></td></tr>
			<tr>
			  <td align="center" style="font-size:13px"><strong>#LB_ReporteInformacionDetalladaDeCursos#</strong></td>
			</tr>	
			<tr><td>&nbsp;</td></tr>
			<tr><td align="center"><strong>-------- <cf_translate  XmlFile="/rh/generales.xml" key="LB_NoSeEncontraronRegistros">No se encontraron registros</cf_translate> --------</strong></td></tr>
		</cfoutput>
	</table>
</cfif>





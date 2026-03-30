<cfset Form.DEid = 23901>
<cfquery name="rs" datasource="nacion">
	select 
	from DatosEmpleado a, LineaTiempo b, RHPuestos c
	where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
</cfquery>		
		
<cfquery name="rs" datasource="nacion">
		
		select cf.CFdescripcion,
			 a.DEidentificacion
			,isnull(a.DEnombre || ' ' || a.DEapellido1 || ' ' || a.DEapellido2,'No
				Asignado') as NombreEmpleado
			,NombreJefe = isnull((select
				DEnombre || ' ' || DEapellido1 || ' ' || DEapellido2 from DatosEmpleado
				where DEid = isnull (
				(select min(l.DEid) from LineaTiempo l where l.RHPid = cf.RHPid and
				getdate() between l.LTdesde and l.LThasta),
				(select min(l.DEid) from LineaTiempo l where l.RHPid = c2.RHPid and
				getdate() between l.LTdesde and l.LThasta))),'No Asignado')
			, rhp.RHPdescripcion
			, cf.CFdescripcion
			, hap.RHPcodigo
			, hab.RHHdescripcion  as Competencia --8
			, cia.Enombre
			, rhpu.RHPdescpuesto   
			, 'No definido' as tipo
			, 1 as clase
			, hab.RHHcodigo as CodCompetencia
			, rhee.RHEECdescripcion as descripcion
			, m.Mnombre as NombreMateria
			, m.Mcodigo
			from ##t t 	
			,DatosEmpleado a
			,CFuncional cf
			,CFuncional c2
			,RHPlazas rhp
			,RHHabilidades hab
			, RHHabilidadesPuesto hap
			,RHPuestos rhpu
			,Empresa cia
			,RHDEvaluacionCap rhde
			,RHListaEvalCap rhlev
			,RHEEvaluacionCap rhee
			,RHHabilidadesMaterias rhhm
			,Materia m
		where   t.DEid      = a.DEid
		  and t.CFid = cf.CFid
		  and t.RHPid = cf.RHPid
		  and t.Ecodigo = cf.Ecodigo
		  and t.EcodigoSDC = cia.Ecodigo	
		  and t.RHPid = cf.RHPid
		  and cf.CFidresp *= c2.CFid
		  and t.RHPid = rhp.RHPid
		
		  and t.RHPcodigo = rhpu.RHPcodigo
		  and t.Ecodigo = rhpu.Ecodigo
		  and hap.RHPcodigo = rhpu.RHPcodigo
		  and hap.Ecodigo = rhpu.Ecodigo
		  and hab.RHHid = hap.RHHid 
		  and hab.RHHid = rhde.RHHid 
		  and rhde.RHDECdesarrollar = 'S'
		  and rhde.DEid = rhlev.DEid
		  and rhde.RHEECid = rhlev.RHEECid
		  and rhee.RHEECid = rhlev.RHEECid
		  and rhde.RHECidevaluador != t.DEid
		  and getdate() between rhee.RHEECfdesde and rhee.RHEECfhasta
		  and rhee.RHEECfdesde = (select max(RHEECfdesde)  
				from 
					RHEEvaluacionCap a1,  RHListaEvalCap b1 , RHDEvaluacionCap c1
				where  
			<cfif isdefined("form.DEid") and len(trim(form.DEid)) NEQ 0>
					b1.DEid = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#form.DEid#"> and
			</cfif>
				a1.RHEECid = b1.RHEECid
				and b1.RHEECid = c1.RHEECid
				and b1.DEid = c1.DEid)
		  and hab.RHHid *= rhhm.RHHid	
		  and rhhm.Mcodigo *= m.Mcodigo	
		union
		
		select cf.CFdescripcion,
			 a.DEidentificacion
			,isnull(a.DEnombre || ' ' || a.DEapellido1 || ' ' || a.DEapellido2,'No
				Asignado') as NombreEmpleado
			,NombreJefe = isnull((select
				DEnombre || ' ' || DEapellido1 || ' ' || DEapellido2 from DatosEmpleado
				where DEid = isnull (
					(select min(l.DEid) from LineaTiempo l where l.RHPid = cf.RHPid and
					getdate() between l.LTdesde and l.LThasta),
					(select min(l.DEid) from LineaTiempo l where l.RHPid = c2.RHPid and
					  getdate() between l.LTdesde and l.LThasta))),'No Asignado')
			, rhp.RHPdescripcion
			, cf.CFdescripcion
			, cop.RHPcodigo
			, con.RHCdescripcion  as Competencia -- 8
			, cia.Enombre
			, rhpu.RHPdescpuesto   
			, case when cop.RHCtipo = 0 then 'Primordial' when cop.RHCtipo = 1 then 'Basico' when cop.RHCtipo = 2  then  'Complementario' when cop.RHCtipo = 3 then 'Deseable' end  as tipo
			, 2 as clase
			, con.RHCcodigo as CodCompetencia
			, rhee.RHEECdescripcion as descripcion
			, m.Mnombre as NombreMateria 
			, m.Mcodigo
			from ##t t 	
			,DatosEmpleado a
			,CFuncional cf
			,CFuncional c2
			,RHPlazas rhp
			,RHConocimientos con
			,RHConocimientosPuesto cop
			,RHPuestos rhpu
			,Empresa cia
			,RHDEvaluacionCap rhde
			,RHListaEvalCap rhlev
			,RHEEvaluacionCap rhee
			,RHConocimientosMaterias rhcm
			,Materia m
		where   t.DEid      = a.DEid
		  and t.CFid = cf.CFid
		  and t.RHPid = cf.RHPid
		  and t.Ecodigo = cf.Ecodigo 
		  and t.EcodigoSDC = cia.Ecodigo	
		  and t.RHPid = cf.RHPid
		  and cf.CFidresp *= c2.CFid
		  and t.RHPid = rhp.RHPid
		
		  and t.RHPcodigo = rhpu.RHPcodigo
		  and t.Ecodigo = rhpu.Ecodigo
		  and cop.RHPcodigo = rhpu.RHPcodigo
		  and cop.Ecodigo = rhpu.Ecodigo
		  and con.RHCid = cop.RHCid 
		  and con.RHCid = rhde.RHCid 
		  and rhde.RHDECdesarrollar = 'S'
		  and rhde.DEid = rhlev.DEid
		  and rhde.RHEECid = rhlev.RHEECid
		  and rhee.RHEECid = rhlev.RHEECid
		  and rhde.RHECidevaluador != t.DEid
		  and getdate() between rhee.RHEECfdesde and rhee.RHEECfhasta
		  and rhee.RHEECfdesde = (select max(RHEECfdesde)  from 
			RHEEvaluacionCap a1,  RHListaEvalCap b1 , RHDEvaluacionCap c1
			where  
				<cfif isdefined("form.DEid") and len(trim(form.DEid)) NEQ 0>
					b1.DEid = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#form.DEid#"> and
				</cfif>
				 a1.RHEECid = b1.RHEECid
				 and b1.RHEECid = c1.RHEECid
				 and b1.DEid = c1.DEid)
		 and con.RHCid *= rhcm.RHCid	
		 and rhcm.Mcodigo *= m.Mcodigo
		  
		order by 1,2,12, 8
		
		drop table ##t
		
		set nocount off

</cfquery>
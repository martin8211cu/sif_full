<!--- =========================================================== ---> 
<!--- querys usados por puesto actual y plan de sucesion 		  --->
<!--- =========================================================== ---> 
<!--- puesto del empleado --->
<cfquery name="puesto" datasource="#session.DSN#">
	select coalesce(ltrim(rtrim(p.RHPcodigoext)),ltrim(rtrim(p.RHPcodigo))) as RHPcodigo, p.RHPdescpuesto
	from LineaTiempo lt
	
	inner join RHPuestos p
	on lt.Ecodigo=p.Ecodigo
	and lt.RHPcodigo=p.RHPcodigo
	
	where lt.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
	and lt.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between lt.LTdesde and lt.LThasta
</cfquery>

<!--- Competencias requeridas del puesto --->
<cfquery name="ps_habilidades_requeridas" datasource="#session.DSN#">
	select a.RHHid, b.RHHcodigo, b.RHHdescripcion, coalesce(a.RHNnotamin,0)*100 as nota, a.RHHpeso as peso
	from RHHabilidadesPuesto a
	
	inner join RHHabilidades b
	on a.Ecodigo=b.Ecodigo
	and a.RHHid=b.RHHid
	
	where a.RHPcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#ps#">
	  and a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	order by b.RHHcodigo
</cfquery>
<cfset ps_habilidades_puesto = valuelist(ps_habilidades_requeridas.RHHid) >

<cfquery name="ps_conocimientos_requeridos" datasource="#session.DSN#">
	select a.RHCid, b.RHCcodigo, b.RHCdescripcion, coalesce(a.RHCnotamin,0)*100 as nota, a.RHCpeso as peso
	from RHConocimientosPuesto a
	
	inner join RHConocimientos b
	on a.Ecodigo=b.Ecodigo
	and a.RHCid=b.RHCid
	
	where a.RHPcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#ps#">
	  and a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	order by b.RHCcodigo
</cfquery>
<cfset ps_conocimientos_puesto = valuelist(ps_conocimientos_requeridos.RHCid) >


<!--- Competencias del puesto que posee el colaborador --->
<cfquery name="ps_habilidades_poseidas" datasource="#session.DSN#">
	select a.idcompetencia, b.RHHcodigo, b.RHHdescripcion, a.RHCEdominio as nota
	from RHCompetenciasEmpleado a
	
	inner join RHHabilidades b
	on a.Ecodigo=b.Ecodigo
	and a.idcompetencia=b.RHHid
	
	where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
	and tipo='H'
	and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between RHCEfdesde and RHCEfhasta
</cfquery>
<cfset ps_habilidades_posee = valuelist(ps_habilidades_poseidas.idcompetencia) >

<cfquery name="ps_conocimientos_poseidos" datasource="#session.DSN#">
	select a.idcompetencia, b.RHCcodigo, b.RHCdescripcion, a.RHCEdominio as nota
	from RHCompetenciasEmpleado a
	
	inner join RHConocimientos b
	on a.Ecodigo=b.Ecodigo
	and a.idcompetencia=b.RHCid
	
	where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
	and tipo='C'
	and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between RHCEfdesde and RHCEfhasta
</cfquery>
<cfset ps_conocimientos_posee = valuelist(ps_conocimientos_poseidos.idcompetencia) >

<!--- =========================================================== ---> 
<!--- querys usados por puesto actual 					 		  --->
<!--- =========================================================== ---> 
<!--- Competencias que faltan--->
<!--- competencias que tiene el puesto y el colaborador no las tiene --->
<cfquery name="ps_habilidades_faltantes" datasource="#session.DSN#">
	select a.RHHid as id, b.RHHcodigo as codigo,b.RHHdescripcion as descripcion, a.RHNnotamin*100 as nota
	from RHHabilidadesPuesto a
	
	inner join RHHabilidades b
	on a.Ecodigo=b.Ecodigo
	and a.RHHid=b.RHHid
	
	where a.RHPcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#ps#">
	  and a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		<cfif isdefined("ps_habilidades_posee") and len(trim(ps_habilidades_posee))>
	  		and a.RHHid not in (#ps_habilidades_posee#)
	  	</cfif>

	union

	select a.RHHid as id, b.RHHcodigo as codigo, b.RHHdescripcion as descripcion, (a.RHNnotamin*100)-c.RHCEdominio as nota 
	from RHHabilidadesPuesto a
	
	inner join RHHabilidades b
	on a.Ecodigo=b.Ecodigo
	and a.RHHid=b.RHHid
	
	inner join RHCompetenciasEmpleado c
	on a.Ecodigo=c.Ecodigo
	and a.RHHid=c.idcompetencia
	and (a.RHNnotamin*100) > c.RHCEdominio
	and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between RHCEfdesde and RHCEfhasta
	and tipo='H'
	and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
	
	where a.RHPcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#ps#">
	  and a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		<cfif isdefined("ps_habilidades_posee") and len(trim(ps_habilidades_posee))>
	  		and a.RHHid in (#ps_habilidades_posee#)
	  	</cfif>

	order by 2

</cfquery>

<cfquery name="ps_conocimientos_faltantes" datasource="#session.DSN#">
	select a.RHCid as id, b.RHCcodigo as codigo, b.RHCdescripcion as descripcion, a.RHCnotamin*100 as nota
	from RHConocimientosPuesto a
	
	inner join RHConocimientos b
	on a.Ecodigo=b.Ecodigo
	and a.RHCid=b.RHCid
	
	where a.RHPcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#ps#">
   	  and a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		<cfif isdefined("ps_conocimientos_posee") and len(trim(ps_conocimientos_posee))>
	  		and a.RHCid not in (#ps_conocimientos_posee#)
	  	</cfif>

	union

	select a.RHCid as id, b.RHCcodigo as codigo, b.RHCdescripcion as descripcion, (a.RHCnotamin*100)-c.RHCEdominio as nota 
	from RHConocimientosPuesto a
	
	inner join RHConocimientos b
	on a.Ecodigo=b.Ecodigo
	and a.RHCid=b.RHCid
	
	inner join RHCompetenciasEmpleado c
	on a.Ecodigo=c.Ecodigo
	and a.RHCid=c.idcompetencia
	and (a.RHCnotamin*100) > c.RHCEdominio
	and tipo = 'C'
	and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
	and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between RHCEfdesde and RHCEfhasta
	
	where a.RHPcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#ps#">
	  and a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		<cfif isdefined("ps_conocimientos_posee") and len(trim(ps_conocimientos_posee))>
	  		and a.RHCid in (#ps_conocimientos_posee#)
	  	</cfif>

	order by 2
</cfquery>



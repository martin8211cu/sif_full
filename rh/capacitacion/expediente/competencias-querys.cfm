<!--- =========================================================== ---> 
<!--- querys usados por puesto actual y plan de sucesion 		  --->
<!--- =========================================================== ---> 
<!--- Competencias requeridas del puesto --->
<cf_translatedata name="get" tabla="RHHabilidades" col="b.RHHdescripcion" returnvariable="LvarRHHdescripcion">
<cf_translatedata name="get" tabla="RHConocimientos" col="b.RHCdescripcion" returnvariable="LvarRHCdescripcion">

<cfquery name="habilidades_requeridas" datasource="#session.DSN#">
	select a.RHHid, b.RHHcodigo, #LvarRHHdescripcion# as RHHdescripcion, coalesce(a.RHNnotamin,0)*100 as nota, a.RHHpeso as peso, n.RHNcodigo as nivel
	from RHHabilidadesPuesto a
	
	inner join RHHabilidades b
	on a.Ecodigo=b.Ecodigo
	and a.RHHid=b.RHHid

	inner join RHNiveles n
	on n.Ecodigo = a.Ecodigo
	and n.RHNid = a.RHNid
	
	where a.RHPcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#puesto.RHPcodigo#">
	  and a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	order by b.RHHcodigo
</cfquery>
<cfset habilidades_puesto = valuelist(habilidades_requeridas.RHHid) >
<cfif isdefined("form.debug")>
	<cfdump var="#habilidades_requeridas#">
</cfif>


<cfquery name="total_conocimientos" datasource="#session.DSN#">
	select sum (RHCpeso) as peso
	from RHConocimientosPuesto a
	where a.RHPcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#puesto.RHPcodigo#">
   	  and a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
</cfquery>

<cfif isdefined("form.debug")>
	<cfdump var="#total_conocimientos#">
</cfif>


<cfif total_conocimientos.recordcount gt 0 and total_conocimientos.peso gt 0>
	<cfset totalpesos =  total_conocimientos.peso>
<cfelse>
	<cfset totalpesos =  1>
</cfif>

<cfquery name="conocimientos_requeridos" datasource="#session.DSN#">
	select a.RHCid, b.RHCcodigo, #LvarRHCdescripcion# as RHCdescripcion, coalesce(a.RHCnotamin,0)*100 as nota, a.RHCpeso as peso,(a.RHCpeso /#totalpesos#)*100  as pesoSP, n.RHNcodigo as nivel
	from RHConocimientosPuesto a
	
	inner join RHConocimientos b
	on a.Ecodigo=b.Ecodigo
	and a.RHCid=b.RHCid
	
	inner join RHNiveles n
	on n.Ecodigo = a.Ecodigo
	and n.RHNid = a.RHNid

	where a.RHPcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#puesto.RHPcodigo#">
   	  and a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	order by b.RHCcodigo
</cfquery>

<cfif isdefined("form.debug")>
	<cfdump var="#conocimientos_requeridos#">
    
    <cfquery name="habilidades_obtenidas_pct" datasource="#Session.DSN#">
        select a.RHHid,b.RHCEdominio,a.RHHpeso,coalesce((b.RHCEdominio * a.RHHpeso / 100.0), 0.0) as nota
        from RHHabilidadesPuesto a
            inner join RHCompetenciasEmpleado b
                on b.idcompetencia = a.RHHid
                and b.Ecodigo = a.Ecodigo
                and b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
                and b.tipo = 'H'
                and b.RHCEfdesde >= (
                                     select max(c.RHCEfdesde) from RHCompetenciasEmpleado c
                                     where c.DEid = b.DEid
                                       and c.Ecodigo = b.Ecodigo 
                                       and c.tipo = b.tipo
                                       and c.idcompetencia = b.idcompetencia
                                     )
    
        where a.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#puesto.RHPcodigo#">
          and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
    </cfquery>
    <cfdump var="#habilidades_obtenidas_pct#">
    <cfquery name="conocimientos_obtenidos_pct" datasource="#Session.DSN#">
        select b.RHCEdominio,a.RHCpeso,#totalpesos# as total,coalesce((b.RHCEdominio /#totalpesos#)*100, 0.0) as nota
        from RHConocimientosPuesto a
            inner join RHCompetenciasEmpleado b
                on b.idcompetencia = a.RHCid
                and b.Ecodigo = a.Ecodigo
                and b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
                and b.tipo = 'C'
                and b.RHCEfdesde >= (
                                     select max(c.RHCEfdesde) from RHCompetenciasEmpleado c
                                     where c.DEid = b.DEid
                                       and c.Ecodigo = b.Ecodigo 
                                       and c.tipo = b.tipo
                                       and c.idcompetencia = b.idcompetencia
                                     )
    
        where a.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#puesto.RHPcodigo#">
          and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
    </cfquery>
    <cfdump var="#conocimientos_obtenidos_pct#">     
</cfif>

<cfset conocimientos_puesto = valuelist(conocimientos_requeridos.RHCid) >

<!--- Competencias del puesto que posee el colaborador --->
<cfif len(trim(habilidades_puesto))>
	<cfquery name="habilidades_poseidas" datasource="#session.DSN#">
		select a.idcompetencia, b.RHHcodigo, #LvarRHHdescripcion# as RHHdescripcion, a.RHCEdominio as nota
		from RHCompetenciasEmpleado a
		
		inner join RHHabilidades b
		on a.Ecodigo=b.Ecodigo
		and a.idcompetencia=b.RHHid
		
		where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		and tipo='H'
		and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between RHCEfdesde and RHCEfhasta
		and idcompetencia in (#habilidades_puesto#)
	</cfquery>
	<cfset habilidades_posee = valuelist(habilidades_poseidas.idcompetencia) >
</cfif> 
<cfquery name="otras_habilidades" datasource="#session.DSN#">
	select a.idcompetencia, b.RHHcodigo, #LvarRHHdescripcion# as RHHdescripcion, a.RHCEdominio as nota
	from RHCompetenciasEmpleado a
	
	inner join RHHabilidades b
	on a.Ecodigo=b.Ecodigo
	and a.idcompetencia=b.RHHid
	
	where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
	and tipo='H'
	and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between RHCEfdesde and RHCEfhasta
</cfquery>

<cfif len(trim(conocimientos_puesto))>
	<cfquery name="conocimientos_poseidos" datasource="#session.DSN#">
		select a.idcompetencia, b.RHCcodigo, #LvarRHCdescripcion# as RHCdescripcion, a.RHCEdominio as nota
		from RHCompetenciasEmpleado a
		
		inner join RHConocimientos b
		on a.Ecodigo=b.Ecodigo
		and a.idcompetencia=b.RHCid
		
		where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		and tipo='C'
		and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between RHCEfdesde and RHCEfhasta
		and idcompetencia in (#conocimientos_puesto#)
	</cfquery>
	<cfset conocimientos_posee = valuelist(conocimientos_poseidos.idcompetencia) >
</cfif>

<cfquery name="otros_conocimientos" datasource="#session.DSN#">
	select a.idcompetencia, b.RHCcodigo, #LvarRHCdescripcion# as RHCdescripcion, a.RHCEdominio as nota
	from RHCompetenciasEmpleado a
	
	inner join RHConocimientos b
	on a.Ecodigo=b.Ecodigo
	and a.idcompetencia=b.RHCid
	
	where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
	and tipo='C'
	and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between RHCEfdesde and RHCEfhasta
</cfquery>

<!--- =========================================================== ---> 
<!--- querys usados por puesto actual 					 		  --->
<!--- =========================================================== ---> 
<!--- Competencias que faltan--->
<!--- competencias que tiene el puesto y el colaborador no las tiene --->
<cfquery name="habilidades_faltantes" datasource="#session.DSN#">
	select a.RHHid, b.RHHcodigo, #LvarRHHdescripcion# as RHHdescripcion, a.RHNnotamin*100 as nota
	from RHHabilidadesPuesto a
	
	inner join RHHabilidades b
	on a.Ecodigo=b.Ecodigo
	and a.RHHid=b.RHHid
	
	where a.RHPcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#puesto.RHPcodigo#">
	  and a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		<cfif isdefined("habilidades_posee") and len(trim(habilidades_posee))>
	  		and a.RHHid not in (#habilidades_posee#)
	  	</cfif>
	order by b.RHHcodigo
</cfquery>

<cfquery name="habilidades_faltantes_pct" datasource="#session.DSN#">
	select a.RHHid, b.RHHcodigo, #LvarRHHdescripcion# as RHHdescripcion, (a.RHNnotamin*100)-c.RHCEdominio as nota 
	from RHHabilidadesPuesto a
	
	inner join RHHabilidades b
	on a.Ecodigo=b.Ecodigo
	and a.RHHid=b.RHHid
	
	inner join RHCompetenciasEmpleado c
	on a.Ecodigo=c.Ecodigo
	and a.RHHid=c.idcompetencia
	and (a.RHNnotamin*100) > c.RHCEdominio
	and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
	and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between RHCEfdesde and RHCEfhasta
	
	where a.RHPcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#puesto.RHPcodigo#">
	  and a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		<cfif isdefined("habilidades_posee") and len(trim(habilidades_posee))>
	  		and a.RHHid in (#habilidades_posee#)
	  	</cfif>

	order by b.RHHcodigo
</cfquery>

<cfquery name="conocimientos_faltantes" datasource="#session.DSN#">
	select a.RHCid, b.RHCcodigo, #LvarRHCdescripcion# as RHCdescripcion, a.RHCnotamin*100 as nota
	from RHConocimientosPuesto a
	
	inner join RHConocimientos b
	on a.Ecodigo=b.Ecodigo
	and a.RHCid=b.RHCid
	
	where a.RHPcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#puesto.RHPcodigo#">
   	  and a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		<cfif isdefined("conocimientos_posee") and len(trim(conocimientos_posee))>
	  		and a.RHCid not in (#conocimientos_posee#)
	  	</cfif>
	order by b.RHCcodigo
</cfquery>

<cfquery name="conocimientos_faltantes_pct" datasource="#session.DSN#">
	select a.RHCid, b.RHCcodigo, #LvarRHCdescripcion# as RHCdescripcion, (a.RHCnotamin*100)-c.RHCEdominio as nota 
	from RHConocimientosPuesto a
	
	inner join RHConocimientos b
	on a.Ecodigo=b.Ecodigo
	and a.RHCid=b.RHCid
	
	inner join RHCompetenciasEmpleado c
	on a.Ecodigo=c.Ecodigo
	and a.RHCid=c.idcompetencia
	and (a.RHCnotamin*100) > c.RHCEdominio
	and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
	and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between RHCEfdesde and RHCEfhasta
	
	where a.RHPcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#puesto.RHPcodigo#">
	  and a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		<cfif isdefined("conocimientos_posee") and len(trim(conocimientos_posee))>
	  		and a.RHCid in (#conocimientos_posee#)
	  	</cfif>

	order by b.RHCcodigo
</cfquery>


<!--- =========================================================== ---> 
<!--- querys usados por plan de sucesion				 		  --->
<!--- =========================================================== ---> 


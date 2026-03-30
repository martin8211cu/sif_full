<cfif isdefined("url.RHCconcurso") and NOT isdefined("form.RHCconcurso")>
	<cfset form.RHCconcurso = url.RHCconcurso>
</cfif>	
<cfif isdefined("url.Formato") and NOT isdefined("form.Formato")>
	<cfset form.Formato = url.Formato>
</cfif>
	
    <cf_translatedata name="get" tabla="RHConcursos" col="RHCdescripcion" returnvariable="LvarRHCdescripcion">
    <cf_dbfunction name="spart" args="#LvarRHCdescripcion#°1°55" delimiters="°" returnvariable="LvaRHCdescripcion">
    <cf_translatedata name="get" tabla="CFuncional" col="CFdescripcion" returnvariable="LvarCFdescripcion">
    <cf_translatedata name="get" tabla="RHPuestos" col="RHPdescpuesto" returnvariable="LvarRHPdescpuesto">
    <cf_translatedata name="get" tabla="RHPruebas" col="RHPdescripcionpr" returnvariable="LvarRHPdescripcionpr">
    <cf_translatedata name="get" tabla="RHEAreasEvaluacion" col="RHEAdescripcion" returnvariable="LvarRHEAdescripcion">
    <cf_translatedata name="get" tabla="RHPlazas" col="RHPdescripcion" returnvariable="LvarRHPdescripcion">
	<cfquery name="rsReporte" datasource="#session.DSN#">
		select
		 a.RHCconcurso,
		  a.RHCcodigo,
		  a.RHCfapertura  ,
		  a.RHCfcierre  ,
		  a.RHCcantplazas ,
		  a.RHPcodigo,
		  case a.RHCestado
		  when 0 then '<cf_translate key="LB_EnProceso" xmlFile="/rh/generales.xml">En Proceso</cf_translate>'
		  when 10 then '<cf_translate key="LB_Solicitado" xmlFile="/rh/generales.xml">Solicitado</cf_translate>'
		  when 20 then '<cf_translate key="LB_Desierto" xmlFile="/rh/generales.xml">Desierto</cf_translate>'
		  when 30 then '<cf_translate key="LB_Cerrado" xmlFile="/rh/generales.xml">Cerrado</cf_translate>'
		  when 15 then '<cf_translate key="LB_Verificado" xmlFile="/rh/generales.xml">Verificado</cf_translate>'
		  when 40 then '<cf_translate key="LB_EnRevision" xmlFile="/rh/generales.xml">En Revisión</cf_translate>'
		  when 50 then '<cf_translate key="LB_Aplicado" xmlFile="/rh/generales.xml">Aplicado</cf_translate>'
		  when 60 then '<cf_translate key="LB_Evaluando" xmlFile="/rh/generales.xml">Evaluando</cf_translate>'
		  when 70 then '<cf_translate key="LB_Terminado" xmlFile="/rh/generales.xml">Terminado</cf_translate>'
		else '' end Estado,
		  #LvaRHCdescripcion# as  RHCdescripcion,
		  a.CFid,
		  c.CFcodigo,
		  <cf_dbfunction name="concat" args="dp.Pnombre,' ', dp.Papellido1,'  ',dp.Papellido2"> as solicitante,
		  c.CFdescripcion ,
		  #LvarRHPdescpuesto# as RHPdescpuesto,
		  a.RHCfecha,
		  case  a.RHCmotivo
		  when 1 then '<cf_translate key="LB_Despido" xmlFile="/rh/generales.xml">Despido</cf_translate>'
		  when 2 then '<cf_translate key="LB_Renuncia" xmlFile="/rh/generales.xml">Renuncia</cf_translate>'
		  when 3 then '<cf_translate key="LB_Traslado" xmlFile="/rh/generales.xml">Traslado</cf_translate>'
		  when 4 then '<cf_translate key="LB_Temporal" xmlFile="/rh/generales.xml">Temporal</cf_translate>'
		  when 5 then '<cf_translate key="LB_Otro" xmlFile="/rh/generales.xml">Otro</cf_translate>' else '' end as RHCmotivo,
		  a.RHCotrosdatos,
		  a.RHCestado,
		  a.Usucodigo,
		  d.RHPcodigopr,
		  d.Cantidad ,
		  #LvarRHPdescripcionpr# as RHPdescripcionpr,
		  d.Peso,
		  d.ts_rversion ,
		  h.RHEAcodigo,
		  #LvarRHEAdescripcion# as RHEAdescripcion,
		  g.RHAECpeso peso,
		  f.RHCPid,
		  i.DEidentificacion  ,
		 coalesce(<cf_dbfunction name="concat" args="i.DEapellido1,' ', i.DEapellido2,'  ',i.DEnombre">, 
		 <cf_dbfunction name="concat" args="j.RHOapellido1,' ', j.RHOapellido2,'  ',j.RHOnombre">) as Nombre,
		  f.DEid,
		  f.RHOid,
		  f.RHCdescalifica,
		  f.RHCrazondeacalifica,
		  f.RHCPtipo,
		  f.RHCPpromedio,
		  f.RHCevaluado,
		  j.RHOidentificacion ,
		  n.RHPid, n.RHPCid,  #LvarRHPdescripcion# as RHPdescripcion,
		 {fn concat(#LvarRHPdescripcionpr#,{fn concat( '(',{fn concat(<cf_dbfunction name="to_char" args="d.Cantidad">,')')})}} as RHPdescpr
<!---		   e.RHPdescripcionpr  || '('  || convert(varchar,d.Cantidad) ||  ')' RHPdescpr--->
		  from RHConcursos a
		  inner join RHPuestos b
			on b.RHPcodigo = a.RHPcodigo
			and b.Ecodigo = a.Ecodigo
		  inner join CFuncional c
			on c.CFid = a.CFid
			and c.Ecodigo = a.Ecodigo
		  left outer join Usuario u
			on u.Usucodigo = a.Usucodigo
		  left outer join DatosPersonales dp
			on dp.datos_personales = u.datos_personales
		  left outer join RHPruebasConcurso d
			on d.RHCconcurso = a.RHCconcurso
		  inner join RHPruebas e
			on e. Ecodigo = d. Ecodigo
			and e.RHPcodigopr  = d.RHPcodigopr
		  left outer join RHConcursantes f
			on f.RHCconcurso  = a.RHCconcurso
		  inner join DatosEmpleado i
			on i.DEid = f.DEid
			and i.Ecodigo = f.Ecodigo
		  left outer  join  DatosOferentes j
			on j.RHOid = f.RHOid
			and j.Ecodigo = f.Ecodigo
		  left outer join RHAreasEvalConcurso g
			on g.RHCconcurso = a.RHCconcurso
		  inner join RHEAreasEvaluacion h
			on g.Ecodigo   = h.Ecodigo
			and g.RHEAid = h.RHEAid
		   inner join RHPlazasConcurso n
			 on n.RHCconcurso  = a.RHCconcurso
				and  n.Ecodigo = a. Ecodigo
		  inner join RHPlazas p
			on    n.Ecodigo = p. Ecodigo
			and n.RHPid   = p.RHPid
		where a.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and a.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">
		  and a.RHCestado in (10, 15, 50, 60)
		order by a.RHCfcierre  desc, a.RHCfapertura, RHCconcurso,n.RHPid,Nombre, RHPdescpr			
	</cfquery>
	
	<cfif isdefined("form.Formato") and len(trim(form.Formato)) and form.Formato EQ 1>
		<cfset formatos = "flashpaper">
	<cfelseif isdefined("form.Formato") and len(trim(form.Formato)) and form.Formato EQ 2>
		<cfset formatos = "pdf">
	</cfif>
	
	<cfreport format="#formatos#" template= "consol.cfr" query="rsReporte">	
		<cfreportparam name="Enombre" value="#session.enombre#">
		<cfreportparam name="Concurso" value="#form.RHCconcurso#">
		<cfreportparam name="Ecodigo" value="#session.Ecodigo#">
	</cfreport>
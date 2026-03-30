<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<cf_dbfunction name='to_char' args='{fn year(d.CPPfechaDesde)}' returnvariable="CPPfechaDesde">
<cf_dbfunction name='to_char' args='{fn year(d.CPPfechaHasta)}' returnvariable="CPPfechaHasta">
<cfquery name="rsPeriodos" datasource="#session.DSN#">
	select distinct a.CPPid as value,  case d.CPPtipoPeriodo when 1 then 'Mensual' when 2 then 'Bimestral' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' else '' end
		#_Cat# ' de ' #_Cat# 
	 case {fn month(CPPfechaDesde)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
		#_Cat# ' ' #_Cat# #preservesinglequotes(CPPfechaDesde)#
		#_Cat# ' a ' #_Cat# 
	 case {fn month(CPPfechaHasta)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
		#_Cat# ' ' #_Cat# #preservesinglequotes(CPPfechaHasta)#
	 as description, 1 as ord 
	from FPEEstimacion a inner join CPresupuestoPeriodo d on a.Ecodigo = d.Ecodigo and a.CPPid  = d.CPPid
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	and FPEEestado in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Status#" list="yes">)
	union 
	select <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null"> as value, '-- todos --' as description, 0 as ord  from dual
	order by ord,description
</cfquery>
<cfquery name="rsEstados" datasource="#session.DSN#">
	select distinct FPEEestado as value, case FPEEestado 
						  when 0 then 'En Preparación' 
						  when 1 then 'En Aprobación' 
						  when 2 then 'En Equilibrio Financiero' 
						  when 3 then 'En Aprobación Interna' 
						  when 4 then 'En Aprobación Externa' 
						  when 5 then 'Aprobada' 
						  when 6 then 'Publicada'
						  when 7 then 'Descartada' 
						  else 'otro' end as description
	from FPEEstimacion
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	and FPEEestado in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Status#" list="yes">)
	union 
	select -1 as value, '-- todos --' as description from dual
	order by 1
</cfquery>
<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#session.Ecodigo#" returnVariable="Ecodigo">
<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Status#" list="yes" returnVariable="Estados">
<cfinvoke component="sif.Componentes.pListas"
		method			="pLista"
		returnvariable	="Lvar_Lista"
		tabla			="FPEEstimacion a inner join CPresupuestoPeriodo d on a.CPPid = d.CPPid left outer join TipoVariacionPres f on f.FPTVid = a.FPTVid"
		columnas		="Distinct a.CPPid, case 
							when f.FPTVTipo = -1 then 'Prespuesto Ordinario ' 
							when f.FPTVTipo =  0 then 'Modificación Presupuestaria ' 
							else 'Variación ' end #_Cat#
						case d.CPPtipoPeriodo when 1 then 'Mensual' when 2 then 'Bimestral' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' else '' end
						#_Cat# ' de ' #_Cat# 
						case {fn month(d.CPPfechaDesde)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
						#_Cat# ' ' #_Cat# #preservesinglequotes(CPPfechaDesde)#
						#_Cat# ' a ' #_Cat# 
						case {fn month(d.CPPfechaHasta)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
						#_Cat# ' ' #_Cat# #preservesinglequotes(CPPfechaHasta)#
						as Pdescripcion,
						(select count(1) from FPEEstimacion  b where a.CPPid = b.CPPid and FPEEestado in(0,1,2,3,4)) total,
						(select count(1) from FPEEstimacion  b where a.CPPid = b.CPPid and FPEEestado = 0 ) EnPreparacion,
						(select count(1) from FPEEstimacion  b where a.CPPid = b.CPPid and FPEEestado = 1 ) EnAprobacion,
						(select count(1) from FPEEstimacion  b where a.CPPid = b.CPPid and FPEEestado = 2 ) Listo, 
						case FPEEestado 
							when 2 then 'En equilibrio Financiero' 
							when 3 then 'En Aprobación Interna' 
							when 4 then 'En Aprobación Externa'  
							when 5 then 'Aprobada' 
						    when 6 then 'Publicada'
						    when 7 then 'Descartada' else 'Otro' end as Estado, 
						FPEEestado"
		desplegar		="Estado, Pdescripcion,total, EnPreparacion,EnAprobacion"
		etiquetas		="Estado, Periodo Presupuestal,Total de CF, CF Pendientes, CF en Aprobación"
		formatos		="S,S,U,U,U"
		filtro			="a.Ecodigo = #session.Ecodigo# and a.FPEEestado in (#Estados#)"
		align			="left,left,left,left,left"
		keys			="CPPid"
		maxrows			="25"
		formname		="ListaActivos"
		ira				=""
		showEmptyListMsg="true"
		cortes			="Pdescripcion"
		filtrar_automatico ="true"
		mostrar_filtro 	="true"
		filtrar_por		="a.FPEEestado,a.CPPid,total, EnPreparacion,EnAprobacion"
		rsPdescripcion	="#rsPeriodos#"
		rsEstado		="#rsEstados#"/>
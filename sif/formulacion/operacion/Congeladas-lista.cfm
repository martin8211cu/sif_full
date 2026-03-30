<cfset filtro = ''>
<cfset botones = ''>
<cfif not request.RolAdmin>
	<cfinvoke component="sif.Componentes.FP_SeguridadUsuario" method="fnGetCFs" returnvariable="CFuncionales" Usucodigo="#session.Usucodigo#"></cfinvoke>
	<cfif CFuncionales.recordcount eq 0>
		<cfset filtro = 'and a.CFid in(-1)'>
	<cfelse>
		<cfset filtro = 'and a.CFid in(#valuelist(CFuncionales.CFid)#)'>
	</cfif>
<cfelse>
	<cfset botones = 'Nuevo'>
</cfif>
<cfquery name="rsTipoVariaciones" datasource="#session.DSN#">
	select distinct tv.FPTVid as value, case FPTVTipo 
						  when 0 then 'Presupuesto Extraordinario' 
						  when 1 then 'No Modifica Monto' 
						  when 2 then 'Modifica Monto hacia abajo' 
						  when 3 then 'Modifica Monto hacia Arriba'
						  when 4 then 'No Modifica Monto Grupal' 
						  else 'otro' end as description, 1 as ord
	from FPEstimacionesCongeladas ec
		inner join FPEEstimacion ee
			on ee.FPECid = ec.FPECid
		inner join TipoVariacionPres tv
			on tv.FPTVid = ee.FPTVid
	where ec.Ecodigo = #session.Ecodigo#
	union 
	select -1 as value, '-- todos --' as description, 0 as ord from dual
	order by ord
</cfquery>
<cfinvoke component="sif.Componentes.pListas"
		method			="pLista"
		returnvariable	="Lvar_Lista"
		tabla			="FPEstimacionesCongeladas ec inner join FPEEstimacion ee on ee.FPECid = ec.FPECid inner join CPresupuestoPeriodo pp on pp.CPPid = ee.CPPid inner join TipoVariacionPres tv on tv.FPTVid = ee.FPTVid"
		columnas		="FPECdescripcion, count(1) as Cantidad, ee.CPPid,
						 case CPPtipoPeriodo when 1 then 'Mensual' when 2 then 'Bimestral' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' else '' end
							#_Cat# ' de ' #_Cat# 
						 case {fn month(CPPfechaDesde)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
							#_Cat# ' ' #_Cat# #preservesinglequotes(CPPfechaDesde)#
							#_Cat# ' a ' #_Cat# 
						 case {fn month(CPPfechaHasta)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
							#_Cat# ' ' #_Cat# #preservesinglequotes(CPPfechaHasta)#
						 as Periodo,
						 case FPTVTipo 
						  when 0 then 'Presupuesto Extraordinario' 
						  when 1 then 'No Modifica Monto' 
						  when 2 then 'Modifica Monto hacia abajo' 
						  when 3 then 'Modifica Monto hacia Arriba'
						  when 4 then 'No Modifica Monto Grupal' 
						  else 'otro' end as Tipo, ee.FPTVid, ec.FPECid"
		desplegar		="Periodo,FPECdescripcion,Cantidad, Tipo"
		etiquetas		="Periódo, Agrupador, Cantidad Estimaciones/Variaciones, Tipo"
		formatos		="S,U,U,S"
		filtro			="ec.Ecodigo = #session.Ecodigo# group by FPECdescripcion, ee.CPPid, CPPtipoPeriodo, CPPfechaHasta, CPPfechaDesde, FPTVTipo, ee.FPTVid, ec.FPECid order by ee.CPPid, FPECdescripcion"
		incluyeform		="true"
		align			="left,center,center,left"
		keys			="FPECid"
		maxrows			="25"
		showlink		="true"
		formname		="formCongelados"
		ira				="#CurrentPage#"
		showEmptyListMsg="true"
		cortes			="Periodo"
		filtrar_automatico ="true"
		mostrar_filtro 	="true"
		<!---botones			="Descongelar"
		checkboxes		="S"--->
		rsPeriodo		="#rsPeriodos#"
		rsTipo 			="#rsTipoVariaciones#"/>

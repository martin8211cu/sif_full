<cfset NavegacionE ="">
<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<cfquery name="ListaArticulo" datasource="#session.dsn#">
	select Distinct case CPPtipoPeriodo when 1 then 'Mensual' when 2 then 'Bimestral' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' else '' end
					|| ' de ' #_Cat# 
					case {fn month(CPPfechaDesde)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
					#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(CPPfechaDesde)}">
					#_Cat# ' a ' #_Cat# 
					case {fn month(CPPfechaHasta)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
					#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(CPPfechaHasta)}">
				as Pdescripcion, b.CPPid
   from FPPreciosArticulo a 
	inner join CPresupuestoPeriodo b 
		on a.Ecodigo = b.Ecodigo 
		and a.CPPid = b.CPPid 
	where a.Ecodigo = #session.Ecodigo#
	<cfif isdefined('form.filtro_Pdescripcion')	and len(trim(form.filtro_Pdescripcion)) and form.filtro_Pdescripcion neq -1>
		and a.CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.filtro_Pdescripcion#">
	</cfif>
	 order by Pdescripcion
</cfquery>
<cfquery name="rsPeriodos" datasource="#session.DSN#">
	select  Distinct a.CPPid as value, case CPPtipoPeriodo when 1 then 'Mensual' when 2 then 'Bimestral' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' else '' end
					|| ' de ' #_Cat# 
					case {fn month(CPPfechaDesde)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
					#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(CPPfechaDesde)}">
					#_Cat# ' a ' #_Cat# 
					case {fn month(CPPfechaHasta)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
					#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(CPPfechaHasta)}">
				as description, 1 as ord 
	from FPPreciosArticulo a inner join CPresupuestoPeriodo b on a.Ecodigo = b.Ecodigo and a.CPPid  = b.CPPid
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	union 
	select -1 as value, '-- todos --' as description, 0 as ord  from dual
	order by ord,description
</cfquery>

<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
	query="#ListaArticulo#"
	desplegar="Pdescripcion"
	etiquetas="Periodo Presupuestal"
	formatos="S"
	align="left"
	ira="EstimacionPrecio.cfm"
	showlink="true" 
	incluyeform="true"
	form_method="post"
	showEmptyListMsg="yes"
	keys="CPPid"	
	MaxRows="10"
	navegacion="#NavegacionE#"
	botones="Nuevo"	
	usaAJAX = "true"
	conexion = "#session.DSN#"	
	PageIndex = "2"
	rsPdescripcion="#rsPeriodos#"
	mostrar_filtro 	="true"		
/>		


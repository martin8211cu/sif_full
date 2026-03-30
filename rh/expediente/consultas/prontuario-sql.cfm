<!--- Actualiza los demás datos a los empleados que estaban en las nóminas --->
<cf_dbfunction name="OP_Concat" returnvariable="concat">

<cfset filtroTcodigo=''>
<cfif isdefined("url.TcodigoList")>
	<cfset miLista="">
	<cfset coldfusion_list =url.TcodigoList>
	<cfloop list="#coldfusion_list#" delimiters="," index="i">
		<cfset miLista = listAppend(miLista, "'"&i&"'",",")> 
	</cfloop>
	<cfset filtroTcodigo="and ltrim(rtrim(b.Tcodigo)) in (" & trim(miLista) & ")">
</cfif>


<cfset ordenamiento=''> 
<cfif isdefined("url.TcodigoList")>
	<cfset ordenamiento="Nomina asc"> 
</cfif>

<cfif isdefined("url.orderby") and url.orderby eq 1>
	<cfset ordenamiento = listAppend(ordenamiento, "DEidentificacion",",")> 
<cfelseif isdefined("url.orderby") and url.orderby eq 2>
	<cfset ordenamiento = listAppend(ordenamiento, "a.DEapellido1 #concat#' '#concat# a.DEapellido2 #concat#' '#concat# a.DEnombre",",")> 
<cfelseif isdefined("url.orderby") and url.orderby eq 3>
	<cfset ordenamiento = listAppend(ordenamiento, "cf.CFcodigo",",")>
<cfelseif isdefined("url.orderby") and url.orderby eq 4>
	<cfset ordenamiento = listAppend(ordenamiento, "d.RHPdescpuesto",",")>
<cfelse>	
</cfif>

<cfif len(trim(ordenamiento))  eq 0> 
	<cfset ordenamiento="DEidentificacion">
</cfif>

<cfquery name="EmpleadosAMostrar" datasource="#session.DSN#">
select distinct a.DEapellido1 #concat#' '#concat# a.DEapellido2 #concat#' '#concat# a.DEnombre as nombre,DEidentificacion as cedula ,DEtarjeta,b.Tcodigo as Nomina,
	a.DEid, hse.RCNid, CPdesde, CPhasta, CPcodigo, coalesce(ve.EVfantig,ve.EVfecha) as ingreso,
	cf.CFcodigo, cf.CFcodigo#concat#' '#concat#cf.CFdescripcion as CentroFuncional,
	d.RHPdescpuesto as Puesto,
	lt.LTsalario as Salario,
	cat.RHCdescripcion as Categoria
from DatosEmpleado a
	inner join EVacacionesEmpleado ve
		on a.DEid=ve.DEid
	inner join HSalarioEmpleado hse
		on a.DEid = hse.DEid
	inner join CalendarioPagos b
		on b.CPid = hse.RCNid
	inner join LineaTiempo lt
		on 	hse.DEid=lt.DEid
		and b.Ecodigo=lt.Ecodigo
    inner join RHPlazas c
    	on c.RHPid = lt.RHPid
    inner join RHPuestos d
    	on d.RHPcodigo = c.RHPpuesto
		and d.Ecodigo = c.Ecodigo
    inner join CFuncional cf
    	on cf.CFid = c.CFid 
    left outer join RHCategoriasPuesto cp
    	on cp.RHCPlinea = lt.RHCPlinea   
	left outer join RHCategoria cat 
		on cat.RHCid =	cp.RHCid

where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and CPdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Url.FechaDesde)#">
		and CPhasta <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Url.FechaHasta)#">
        and ( (b.CPdesde between lt.LTdesde and  lt.LThasta) or (b.CPhasta between lt.LTdesde and  lt.LThasta) )
		#preservesinglequotes(filtroTcodigo)#
		order by #preservesinglequotes(ordenamiento)#
</cfquery>

<cfif EmpleadosAMostrar.recordcount EQ 0>
	<br>
	<br>
	<cf_translate  key="LB_NoSeGeneroUnReporteSegunLosFiltrosDados">No se gener&oacute; un reporte seg&uacute;n los filtros dados. Intente de nuevo!</cf_translate>
	<br>
	<br>
	<cfabort>
</cfif>	

<cfquery dbtype="query" name="idEmpleado">
select distinct RCNid from EmpleadosAMostrar
</cfquery>

<cfset listaRCNid = ValueList(idEmpleado.RCNid)>

<cfquery name="rsdatosHistoricos" datasource="#session.DSN#">
<!--- Datos de salarios --->
select 	distinct 1 as orden , h.RCNid , h.DEid, 'SB' as codigo, 'Salario Bruto' as descripcion, h.SEsalariobruto as monto, 'Salario' as tipo, cf.CFcodigo, cf.CFdescripcion
from HSalarioEmpleado h
	left join RCuentasTipo rct
		on h.RCNid=rct.RCNid
		and h.DEid=rct.DEid
		and rct.tiporeg in (10,11)
	left join CFuncional cf
		on rct.CFid=cf.CFid	
where h.RCNid in ( #listaRCNid# )

<!---Datos de incidencias --->
union all
select 	distinct 2 as orden , h.RCNid , h.DEid, CIcodigo, CIdescripcion, ICmontores as monto, 'Incidencias' as tipo, cf.CFcodigo, cf.CFdescripcion
from HIncidenciasCalculo h
	inner join CIncidentes ci
		on h.CIid = ci.CIid
	left join RCuentasTipo rct
		on h.RCNid=rct.RCNid
		and h.DEid=rct.DEid
		and h.CIid=rct.referencia
		and rct.tiporeg in (20,21)
	left join CFuncional cf
		on rct.CFid=cf.CFid	
where h.RCNid in ( #listaRCNid# )

<!--- Datos de Renta --->
union all
select 	distinct 3 as orden , h.RCNid , h.DEid, 'Renta', 'Renta', SErenta as monto, 'Renta'as tipo, cf.CFcodigo, cf.CFdescripcion
from HSalarioEmpleado h
	left join RCuentasTipo rct
		on h.RCNid=rct.RCNid
		and h.DEid=rct.DEid
		and rct.tiporeg=70
	left join CFuncional cf
		on rct.CFid=cf.CFid	
where h.RCNid in ( #listaRCNid# )

<!---  Datos de Cargas --->
union all
select 	distinct 4 as orden , h.RCNid , h.DEid, dc.DCcodigo, dc.DCdescripcion, h.CCvalorpat + h.CCvaloremp as monto, 'Cargas' as tipo, cf.CFcodigo, cf.CFdescripcion
from HCargasCalculo h
	inner join DCargas dc
		on h.DClinea=dc.DClinea
	left join RCuentasTipo rct
		on h.RCNid=rct.RCNid
		and h.DEid=rct.DEid
		and dc.DClinea=rct.referencia
		and rct.tiporeg in (30,31,40,50,51,52,55,56,57)
	left join CFuncional cf
		on rct.CFid=cf.CFid	
where h.RCNid in ( #listaRCNid# )

<!---  Datos de Deducciones --->
union all
select distinct 5 as orden , deduc.RCNid , deduc.DEid, 	TDcodigo, TDdescripcion, DCvalor as monto,  'Deducciones' as tipo, cf.CFcodigo, cf.CFdescripcion
from HDeduccionesCalculo deduc
	inner join DeduccionesEmpleado d
		on deduc.Did = d.Did
	inner join TDeduccion e
		on d.TDid = e.TDid
	left join RCuentasTipo rct
		on deduc.RCNid=rct.RCNid
		and deduc.DEid=rct.DEid
		and e.TDid=rct.referencia
		and rct.tiporeg = 60
	left join CFuncional cf
		on rct.CFid=cf.CFid	
where deduc.RCNid in ( #listaRCNid# )

<!--- Datos de salarios líquidos --->
union all
select 	distinct 6 as orden , h.RCNid , h.DEid,  'SL', 'Salario Líquido', SEliquido as monto, 'Liquido' as tipo, cf.CFcodigo, cf.CFdescripcion
from HSalarioEmpleado h
	left join RCuentasTipo rct
		on h.RCNid=rct.RCNid
		and h.DEid=rct.DEid
		and rct.tiporeg in (80,85)
	left join CFuncional cf
		on rct.CFid=cf.CFid	
where h.RCNid in ( #listaRCNid# )<!------>
</cfquery>

	
<cfif isdefined("url.ckResumido")>
	<cfquery name="rsdatosHistoricos" dbtype="query">
		select DEid, orden, tipo,sum(monto) as monto
		from rsdatosHistoricos
		group by DEid, orden,  tipo
		order by orden
	</cfquery>
	<cfquery name="EmpleadosAMostrar" dbtype="query">
		select nombre, cedula,DEtarjeta, DEtarjeta,  DEid, ingreso,Categoria , CentroFuncional, Puesto,sum(Salario) as Salario
		from EmpleadosAMostrar
		group by nombre, cedula,DEtarjeta, DEtarjeta,  DEid, ingreso,Categoria , CentroFuncional, Puesto
	</cfquery>
</cfif>

<cfif rsdatosHistoricos.recordcount EQ 0>
	<br>
	<br>
	<cf_translate  key="LB_NoSeGeneroUnReporteSegunLosFiltrosDados">No se gener&oacute; un reporte seg&uacute;n los filtros dados. Intente de nuevo!</cf_translate>
	<br>
	<br>
	<cfabort>
<cfelseif rsdatosHistoricos.recordcount NEQ 0>	
		<cfinclude template="prontuario-html.cfm">
</cfif>

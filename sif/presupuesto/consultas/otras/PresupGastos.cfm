<cfif isDefined("url.Oficina") and len(trim(url.Oficina)) NEQ 0>
		<cfset LvarOficinaI = url.Oficina>
		<cfset LvarOficinaF = url.Oficina>
		<cfset LvarOfiDesc  = rsOficinas.Odescripcion>
	<cfelse>
		<cfset LvarOficinaI = 0>
		<cfset LvarOficinaF = 99999>
		<cfset LvarOfiDesc  = ''>
	</cfif>

<cfquery name="rsReporte" datasource="#session.dsn#">
	
	select cpc.CPCano as Periodo, 
	cpc.CPCmes as Mes, 
	cp.CPformato as Cuenta, 
	coalesce(cp.CPdescripcionF,cp.CPdescripcion) as Descripcion_Cuenta , 
	cpc.CPCpresupuestado + cpc.CPCmodificado + cpc.CPCvariacion + cpc.CPCtrasladado + cpc.CPCtrasladadoE as PresupuestoAutorizado , 
	cpc.CPCvariacion, 
	cpc.CPCmodificado, 
	(cpc.CPCejecutado + cpc.CPCejecutadoNC) as CPCejecutado,
	(cpc.CPCpresupuestado + cpc.CPCmodificado + cpc.CPCvariacion + cpc.CPCtrasladado + cpc.CPCtrasladadoE) - (cpc.CPCejecutado + cpc.CPCejecutadoNC) as Diferencia,
	 (select sum(cpc1.CPCpresupuestado + cpc1.CPCmodificado + cpc1.CPCvariacion + cpc1.CPCtrasladado + cpc1.CPCtrasladadoE) 
				from  CPresupuestoControl cpc1 , CPresupuestoPeriodo cpp
				where cpc1.Ecodigo = #session.Ecodigo#
				  and cpc1.Ecodigo = cpp.Ecodigo 
				  and cpc1.CPPid = cpp.CPPid
				and (cpc1.CPCano < cpc.CPCano
				   OR cpc1.CPCano = cpc.CPCano
				   and cpc1.CPCmes <= cpc.CPCmes)
				and cpc1.CPcuenta = cpc.CPcuenta
				and cpc1.Ocodigo = cpc.Ocodigo -- ver si aqui tambien filtro la oficina and cpc.Ocodigo = @Oficina or @Oficina = -1--
 				group by cpc1.CPcuenta
 ) as PresupuestoAutorizadoAcum,
 (select  sum(cpc1.CPCejecutado + cpc1.CPCejecutadoNC)
				from  CPresupuestoControl cpc1 , CPresupuestoPeriodo cpp
				where cpc1.Ecodigo = #session.Ecodigo#
				  and cpc1.Ecodigo = cpp.Ecodigo 
				  and cpc1.CPPid = cpp.CPPid
				and (cpc1.CPCano < cpc.CPCano
				   OR cpc1.CPCano = cpc.CPCano
				   and cpc1.CPCmes <= cpc.CPCmes)
				and cpc1.CPcuenta = cpc.CPcuenta
				and cpc1.Ocodigo = cpc.Ocodigo -- ver si aqui tambien filtro la oficina and cpc.Ocodigo = @Oficina  or @Oficina = -1--
 				group by cpc1.CPcuenta
 ) as PresupuestoEjecutadoAcum,
e.Edescripcion as Edescripcion,
(select  sum((cpc1.CPCpresupuestado + cpc1.CPCmodificado + cpc1.CPCvariacion + cpc1.CPCtrasladado + cpc1.CPCtrasladadoE) - (cpc1.CPCejecutado + cpc1.CPCejecutadoNC))
				from  CPresupuestoControl cpc1 , CPresupuestoPeriodo cpp
				where cpc1.Ecodigo = #session.Ecodigo#
				  and cpc1.Ecodigo = cpp.Ecodigo 
				  and cpc1.CPPid = cpp.CPPid
				and (cpc1.CPCano < cpc.CPCano
				   OR cpc1.CPCano = cpc.CPCano
				   and cpc1.CPCmes <= cpc.CPCmes)
				and cpc1.CPcuenta = cpc.CPcuenta
				and cpc1.Ocodigo = cpc.Ocodigo -- ver si aqui tambien filtro la oficina and cpc.Ocodigo = @Oficina  or @Oficina = -1--
 				group by cpc1.CPcuenta
 ) as DiferenciaAcum,
  cp1.CPformato as CuentaPadre,
  coalesce(cp1.CPdescripcionF,cp1.CPdescripcion) as DescCuentaPadre,
(select m.Mnombre from Monedas m, CPresupuestoPeriodo cpp2
	where m.Ecodigo = cpp2.Ecodigo
 	    and  m.Mcodigo = cpp2.Mcodigo
     	    and cpp2.Ecodigo = cpc.Ecodigo
	    and cpp2.CPPid = cpc.CPPid
) as NombMoneda
from CPresupuesto cp
	left outer join CPresupuesto cp1
  	  on cp.Ecodigo = cp1.Ecodigo
	  and cp.CPpadre = cp1.CPcuenta
 	inner join CPresupuestoControl cpc
	  on cpc.Ecodigo = #session.Ecodigo#
	 and cpc.CPCano = #url.CPCano#
	  and cpc.CPCmes = #url.CPCmes#
	   and cpc.Ocodigo between <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarOficinaI#">  
	   and <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarOficinaF#">
	 
	  and cpc.Ecodigo = cp.Ecodigo
	  and cpc.CPcuenta = cp.CPcuenta
	inner join Empresas e
	  on  cp.Ecodigo = e.Ecodigo
order by cp1.CPformato
</cfquery>

<cfreport format="flashpaper" query="rsReporte" template="PresupGastos.cfr">

<cfreportparam name="Ecodigo"   value="#session.Ecodigo#">
	<cfreportparam name="OficinaI"   value="#LvarOficinaI#">
	<cfreportparam name="OficinaF"   value="#LvarOficinaF#">
	<cfreportparam name="OfiDesc"   value="#LvarOfiDesc#">

	<cfif isDefined("url.CPCano") and len(trim(url.CPCano)) NEQ 0>
		<cfreportparam name="Periodo"   value="#trim(url.CPCano)#">
	</cfif>
	
	<cfif isDefined("url.CPCmes") and len(trim(url.CPCmes)) NEQ 0>
		<cfreportparam name="Mes"   value="#trim(url.CPCmes)#">
		<cfreportparam name="MesDesc"   value="#trim(meses.mes)#">
	</cfif>
</cfreport>






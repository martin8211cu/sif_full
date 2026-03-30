<!---<cf_dump var = "#url#">--->
<cfif isdefined("url.CPPid")>
	<cfset Form.CPPid="#url.CPPid#">
</cfif>
<cfquery datasource="#Session.DSN#">
	delete MensAplCompromiso where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>
<cfinclude template="../../Utiles/sifConcat.cfm">

<cfquery datasource="#Session.DSN#" name="rsget_val">
	select ltrim(rtrim(Pvalor)) as Pvalor
	from Parametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and Pcodigo = 50
</cfquery>
<cfset vs_periodo="#rsget_val.Pvalor#">
<cfquery datasource="#Session.DSN#" name="rsget_val">
	select ltrim(rtrim(Pvalor)) as Pvalor
	from Parametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and Pcodigo = 60
</cfquery>
<cfset vs_mes="#rsget_val.Pvalor#">

<cfset vs_aniomesCierre = #vs_periodo# * 100 + #vs_mes#>

<cfquery name="rsOficina" datasource="#Session.DSN#">
    select Ocodigo,Odescripcion,Oficodigo from Oficinas a
    where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cfquery name="qry_monedaEmpresa" datasource="#session.dsn#">
    select Mcodigo
      from Empresas
     where Ecodigo = #session.Ecodigo#
</cfquery>

<cfquery datasource="#Session.DSN#" name="rsget_val">
 select ltrim(rtrim(Pvalor)) as Pvalor
 from Parametros
 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
 and Pcodigo = 50
</cfquery>
<cfset vs_periodo="#rsget_val.Pvalor#">
<cfquery datasource="#Session.DSN#" name="rsget_val">
 select ltrim(rtrim(Pvalor)) as Pvalor
 from Parametros
 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
 and Pcodigo = 60
</cfquery>
<cfset vs_mes="#rsget_val.Pvalor#">

<!--- Parametro validacion por cuenta presupuestal --->
<cfquery datasource="#Session.DSN#" name="rsget_val">
 select ltrim(rtrim(Pvalor)) as Pvalor
 from Parametros
 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
 and Pcodigo = 1131
</cfquery>
<cfif rsget_val.RecordCount GT 0 >
	<cfset validaXCPVal = rsget_val.Pvalor />
<cfelse>
	<cfset validaXCPVal = 'N' />
</cfif>

<!--- Obtiene el tipo de Periodo de Presupuesto del aprobacion_sql.cfm--->
<cfquery name="rsSQL" datasource="#session.dsn#">
	select 	v.CVid, v.CVtipo, v.CVdocumentoAprobo, p.CPPid, p.CPPfechaDesde, p.CPPfechaHasta, v.RHEid
	from CVersion v
			INNER JOIN CPresupuestoPeriodo p
				ON p.CPPid = v.CPPid
	where v.Ecodigo = #session.Ecodigo#
            and p.CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPPid#">
</cfquery>
<cfset url.CVid 	= rsSQL.CVid>
<cfset LvarCPPid 	= rsSQL.CPPid>
<cfset LvarFechaIni = rsSQL.CPPfechaDesde>
<cfset LvarFechaFin = rsSQL.CPPfechaHasta>

<cfset LvarFecha	= LvarFechaIni>
<cfset LvarAno		= vs_periodo <!--- datepart("yyyy",LvarFechaIni) --->>
<cfset LvarMes		= vs_mes <!--- datepart("m",LvarFechaIni) --->>

<cfset LvarAprobacion = rsSQL.CVtipo EQ "1"> <!---Tipo de presupuesto 1Ord, 2Extraord--->

<cfquery name="rsSQLNAP" datasource="#session.dsn#">
    select count(*) as ultimo
      from CPNAP
     where Ecodigo 				= <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
       and EcodigoOri		 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
       and CPNAPmoduloOri 		= 'PRFO'
       and left(CPNAPdocumentoOri,2)	= 'CC'
</cfquery>

<cfif rsSQLNAP.ultimo EQ "">
    <cfset LvarDocumentoAprobo = 1>
<cfelse>
    <cfset LvarDocumentoAprobo = rsSQLNAP.ultimo + 1>
</cfif>
<cfset LvarDocumentoAprobo = "CC-"&#LvarDocumentoAprobo#>
<!---
<cfset tamPag = 10000>
<cfset totalRow = 0>


<cfquery name="rsTotal" datasource="sifcim">
select  count(1) as total
    from CPresupuestoComprAut a
    inner join CPresupuestoComprAutD d
    on a.CPCCid=d.CPCCid
where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and a.CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPPid#">
</cfquery>

<cfset totalRow = #rsTotal.total#>
<cfset result = #totalRow#/#tamPag#+1> --->

<cfset LobjControl = createObject( "component","sif.Componentes.PRES_Presupuesto")>
<cfset LobjControl.CreaTablaIntPresupuesto(#session.dsn#,true)>

<!---Invocar al GC para liberar memoria--->
<!---ABG--->
<cfset javaRT = createobject("java","java.lang.Runtime").getRuntime() />
<cfset javaRT.gc() />
<!--- invoca el GC --->

	<cfquery name="rsLineas" datasource="#Session.DSN#">
		select  a.Cmayor, a.CPCCmascara,a.CPcuenta, d.CPperiodo,d.CPmes,a.CPPid,
			round(coalesce(d.CPComprMod,0),2) as CPComprMod,
			round(coalesce(d.CPComp_Anterior,0),2) as CPComp_Anterior, d.CPNAPnum,
			n.CPNAPnum as NCPNAPnum, n.CPNAPDlinea, n.CPNAPnumRef, coalesce(n.NAPMonto,0) as NAPMonto,
			cpp.CPCPtipoControl, cpp.CPCPcalculoControl,
			cpc.CPcuenta as CPCCPCuenta, cpc.Ocodigo,
			cpc.CPCpresupuestado, cpc.CPCmodificado,
			cpc.CPCmodificacion_Excesos, cpc.CPCvariacion,
			cpc.CPCtrasladado, cpc.CPCtrasladadoE, cpc.CPCreservado_Anterior,
			cpc.CPCcomprometido_Anterior, cpc.CPCreservado_Presupuesto,
			cpc.CPCreservado, round(cpc.CPCcomprometido,2) as CPCcomprometido,
			cpc.CPCejecutado, cpc.CPCejecutadoNC, cpc.CPCnrpsPendientes
	    from CPresupuestoComprAut a
			inner join CPresupuestoComprAutD d
				on a.CPCCid=d.CPCCid
			left JOIN (
					select f.CPNAPnum, CPNAPDlinea, e.Ecodigo, f.CPPid, f.CPcuenta,
							f.CPCano, f.CPCmes, f.CPNAPnumRef, f.CPNAPDtipoMov, e.CPNAPmoduloOri,
							round(f.CPNAPDmonto-f.CPNAPDutilizado,2) as NAPMonto
					from dbo.CPNAPdetalle	f
						inner join dbo.CPNAP e
							on f.CPNAPnum = e.CPNAPnum
						where f.CPNAPDtipoMov = 'CC'
			  			  	and e.CPNAPmoduloOri = 'PRFO'
			  			  	and f.CPNAPnumRef is null
			)n
				on n.Ecodigo = a.Ecodigo
					and n.CPPid = a.CPPid
					and n.CPcuenta = a.CPcuenta
					and n.CPCano 	= d.CPperiodo
					and n.CPCmes 	= d.CPmes
					and n.CPNAPnum = d.CPNAPnum
			left JOIN CPCuentaPeriodo cpp
				on cpp.Ecodigo = a.Ecodigo
	            and cpp.CPPid = a.CPPid
	            and cpp.CPcuenta = a.CPcuenta
			left join CPresupuestoControl cpc
				on cpc.Ecodigo = a.Ecodigo
	            and cpc.CPPid = a.CPPid
	            and cpc.CPcuenta = a.CPcuenta
				and cpc.CPCano 	= d.CPperiodo
				and cpc.CPCmes 	= d.CPmes
				and cpc.Ocodigo  = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#rsOficina.Ocodigo#">
			where a.Ecodigo = <cfqueryparam  cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			    and a.CPPid = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#Form.CPPid#">
	            and a.CPcambioAplicado = 0
	            and d.CPComprMod <> d.CPComp_Anterior
    </cfquery>

	<cfset rowIndex = 1>
<!--- <cf_dump var="#rsLineas#"> --->
<cftransaction action="begin">
<cftry>

<cfif validaXCPVal EQ 'S'>
	<cfset LobjControlV = createObject( "component","sif.presupuesto.Componentes.PRES_GeneraTablaValidaPPTO")>
	<cfset tValPres = LobjControlV.CreaTablaValPresupuesto(#session.dsn#)>

	<cfquery name="rsConfig" datasource="#Session.DSN#">
			select	b.CPVid, REPLACE(b.Descripcion,' ','_') Descripcion, a.PCEcatid as Catalogo,
					a.Valor
			from CPValidacionConfiguracion a
			inner join CPValidacionValores b
				on a.CPVid = b.CPVid
			Where b.Ecodigo = <cfqueryparam  cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>

	<cfset mystring = "'-'">
	<cfquery name="rsValComp" datasource="#Session.DSN#">
		select	a.CPCano CPperiodo, a.CPCmes CPmes, <!--- t.CPFormato, ---> sum(cpr.CPComprMod) CPComprMod, sum(cpr.CPComp_Anterior) CPComp_Anterior,
				sum(a.PAutorizado) PAutorizado, sum(a.PUtilizado) PUtilizado, sum(a.PDisponible) PDisponible, sum(isnull(sn.NAPMonto,0)) NAPMonto,
				t.Grupo, sum(cpr.CPComprMod) - sum(a.PDisponible) + sum(isnull(sn.NAPMonto,0)) UDiff
			from  (
					select	a.CPcuenta, a.CPPid, a.Ecodigo,
							b.CPperiodo, b.CPmes, b.CPComprMod, b.CPComp_Anterior,
							b.CPNAPnum
					from	CPresupuestoComprAut a
					inner join	CPresupuestoComprAutD b
						on a.CPPid = b.CPPid
						and a.CPCCid = b.CPCCid
					where a.Ecodigo = <cfqueryparam  cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						and a.CPPid = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#Form.CPPid#">
						<!--- and a.CPcambioAplicado = 0
						and b.CPComprMod <> b.CPComp_Anterior --->
						and b.CPmes in (
							select	distinct b.CPmes
							from	CPresupuestoComprAut a
							inner join	CPresupuestoComprAutD b
								on a.CPPid = b.CPPid
								and a.CPCCid = b.CPCCid
							where a.Ecodigo = <cfqueryparam  cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
								and a.CPPid = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#Form.CPPid#">
								and a.CPcambioAplicado = 0
								and b.CPComprMod <> b.CPComp_Anterior
						)
			) cpr
			inner join (
				select	cpc.CPCmes, cpc.CPCano, cpc.CPcuenta, cpc.CPPid, cpc.Ecodigo,cp.CPCPcalculoControl,
						case cp.CPCPcalculoControl
							when 1 then
								(select	SUM(c.CPCpresupuestado + c.CPCmodificado + c.CPCmodificacion_Excesos + c.CPCvariacion + c.CPCtrasladado + c.CPCtrasladadoE) as PAutorizado
									from	CPresupuestoControl c
									where c.CPcuenta = cpc.CPcuenta
										and c.CPPid = cpc.CPPid
										and c.CPCano = cpc.CPCano
										and c.CPCmes = cpc.CPCmes
									group by c.CPCano, c.CPCmes, c.CPcuenta, c.CPPid, c.Ecodigo )
							when 2 then
								case
									when cpc.CPCmes <= (select Pvalor from Parametros where Pcodigo = 60) then
										(select	SUM(c.CPCpresupuestado + c.CPCmodificado + c.CPCmodificacion_Excesos + c.CPCvariacion + c.CPCtrasladado + c.CPCtrasladadoE) as PAutorizado
											from	CPresupuestoControl c
											where c.CPcuenta = cpc.CPcuenta
												and c.CPPid = cpc.CPPid
												and c.CPCano = cpc.CPCano
												and c.CPCmes <= cpc.CPCmes
											group by c.CPCano, c.CPcuenta, c.CPPid, c.Ecodigo)
									else
										(select	SUM(c.CPCpresupuestado + c.CPCmodificado + c.CPCmodificacion_Excesos + c.CPCvariacion + c.CPCtrasladado + c.CPCtrasladadoE) as PAutorizado
											from	CPresupuestoControl c
											where c.CPcuenta = cpc.CPcuenta
												and c.CPPid = cpc.CPPid
												and c.CPCano = cpc.CPCano
												and c.CPCmes = cpc.CPCmes
											group by c.CPCano, c.CPcuenta, c.CPPid, c.Ecodigo)
								end
							when 3 then
								(select	SUM(c.CPCpresupuestado + c.CPCmodificado + c.CPCmodificacion_Excesos + c.CPCvariacion + c.CPCtrasladado + c.CPCtrasladadoE) as PAutorizado
									from	CPresupuestoControl c
									where c.CPcuenta = cpc.CPcuenta
										and c.CPPid = cpc.CPPid
										and c.CPCano = cpc.CPCano
									group by c.CPCano, c.CPcuenta, c.CPPid, c.Ecodigo)
						else
							0
						end as PAutorizado,
						case cp.CPCPcalculoControl
							when 1 then
								(select SUM(c.CPCreservado_Anterior + c.CPCcomprometido_Anterior
											 + c.CPCreservado_Presupuesto
											 + c.CPCreservado
											 + case
													when   c.CPCcomprometido > 0 then c.CPCcomprometido
													else 0
												 end
											 + c.CPCejecutado + c.CPCejecutadoNC) as PUtilizado
									from	CPresupuestoControl c
									where c.CPcuenta = cpc.CPcuenta
										and c.CPPid = cpc.CPPid
										and c.CPCano = cpc.CPCano
										and c.CPCmes = cpc.CPCmes
									group by c.CPCano, c.CPCmes, c.CPcuenta, c.CPPid, c.Ecodigo )
							when 2 then
								case
									when cpc.CPCmes <= (select Pvalor from Parametros where Pcodigo = 60) then
										(select SUM(c.CPCreservado_Anterior + c.CPCcomprometido_Anterior
													 + c.CPCreservado_Presupuesto
													 + c.CPCreservado
													 + case
															when   c.CPCcomprometido > 0 then c.CPCcomprometido
															else 0
														 end
													 + c.CPCejecutado + c.CPCejecutadoNC) as PUtilizado
											from	CPresupuestoControl c
											where c.CPcuenta = cpc.CPcuenta
												and c.CPPid = cpc.CPPid
												and c.CPCano = cpc.CPCano
												and c.CPCmes <= cpc.CPCmes
											group by c.CPCano, c.CPcuenta, c.CPPid, c.Ecodigo)
									else
										(select SUM(c.CPCreservado_Anterior + c.CPCcomprometido_Anterior
												 + c.CPCreservado_Presupuesto
												 + c.CPCreservado
												 + case
													when   c.CPCcomprometido > 0 then c.CPCcomprometido
													else 0
												 end
												 + c.CPCejecutado + c.CPCejecutadoNC) as PUtilizado
										from	CPresupuestoControl c
										where c.CPcuenta = cpc.CPcuenta
											and c.CPPid = cpc.CPPid
											and c.CPCano = cpc.CPCano
											and c.CPCmes = cpc.CPCmes
										group by c.CPCano, c.CPcuenta, c.CPPid, c.Ecodigo)
									end
							when 3 then
								(select SUM(c.CPCreservado_Anterior + c.CPCcomprometido_Anterior
											 + c.CPCreservado_Presupuesto
											 + c.CPCreservado
											 + case
													when   c.CPCcomprometido > 0 then c.CPCcomprometido
													else 0
												end
											 + c.CPCejecutado + c.CPCejecutadoNC) as PUtilizado
									from	CPresupuestoControl c
									where c.CPcuenta = cpc.CPcuenta
										and c.CPPid = cpc.CPPid
										and c.CPCano = cpc.CPCano
									group by c.CPCano, c.CPcuenta, c.CPPid, c.Ecodigo)
						else
							0
						end as PUtilizado,
						case cp.CPCPcalculoControl
							when 1 then
								(select SUM(c.CPCpresupuestado + c.CPCmodificado + c.CPCmodificacion_Excesos + c.CPCvariacion + c.CPCtrasladado
											-(c.CPCreservado_Anterior + c.CPCcomprometido_Anterior
											 + c.CPCreservado_Presupuesto
											 + c.CPCreservado
											 + case
													when   c.CPCcomprometido > 0 then c.CPCcomprometido
													else 0
												end
											 + c.CPCejecutado + c.CPCejecutadoNC)) as PDisponible
									from	CPresupuestoControl c
									where c.CPcuenta = cpc.CPcuenta
										and c.CPPid = cpc.CPPid
										and c.CPCano = cpc.CPCano
										and c.CPCmes = cpc.CPCmes
									group by c.CPCano, c.CPCmes, c.CPcuenta, c.CPPid, c.Ecodigo )
							when 2 then
								case
									when cpc.CPCmes <= (select Pvalor from Parametros where Pcodigo = 60) then
										(select SUM(c.CPCpresupuestado + c.CPCmodificado + c.CPCmodificacion_Excesos + c.CPCvariacion + c.CPCtrasladado
											-(c.CPCreservado_Anterior + c.CPCcomprometido_Anterior
											 + c.CPCreservado_Presupuesto
											 + c.CPCreservado
											 + case
													when   c.CPCcomprometido > 0 then c.CPCcomprometido
													else 0
												end
											 + c.CPCejecutado + c.CPCejecutadoNC)) as PDisponible
											from	CPresupuestoControl c
											where c.CPcuenta = cpc.CPcuenta
												and c.CPPid = cpc.CPPid
												and c.CPCano = cpc.CPCano
												and c.CPCmes <= cpc.CPCmes
											group by c.CPCano, c.CPcuenta, c.CPPid, c.Ecodigo)
									else
										(select SUM(c.CPCpresupuestado + c.CPCmodificado + c.CPCmodificacion_Excesos + c.CPCvariacion + c.CPCtrasladado
											-(c.CPCreservado_Anterior + c.CPCcomprometido_Anterior
											 + c.CPCreservado_Presupuesto
											 + c.CPCreservado
											 + case
													when   c.CPCcomprometido > 0 then c.CPCcomprometido
													else 0
												end
											 + c.CPCejecutado + c.CPCejecutadoNC)) as PDisponible
											from	CPresupuestoControl c
											where c.CPcuenta = cpc.CPcuenta
												and c.CPPid = cpc.CPPid
												and c.CPCano = cpc.CPCano
												and c.CPCmes = cpc.CPCmes
											group by c.CPCano, c.CPcuenta, c.CPPid, c.Ecodigo)
									end
							when 3 then
								(select SUM(c.CPCpresupuestado + c.CPCmodificado + c.CPCmodificacion_Excesos + c.CPCvariacion + c.CPCtrasladado
											-(c.CPCreservado_Anterior + c.CPCcomprometido_Anterior
											 + c.CPCreservado_Presupuesto
											 + c.CPCreservado
											 + case
													when   c.CPCcomprometido > 0 then c.CPCcomprometido
													else 0
												end
											 + c.CPCejecutado + c.CPCejecutadoNC)) as PDisponible
									from	CPresupuestoControl c
									where c.CPcuenta = cpc.CPcuenta
										and c.CPPid = cpc.CPPid
										and c.CPCano = cpc.CPCano
									group by c.CPCano, c.CPcuenta, c.CPPid, c.Ecodigo)
						else
							0
						end as PDisponible
					from	CPresupuestoControl cpc
					inner join CPCuentaPeriodo cp
						on cpc.Ecodigo = cp.Ecodigo
						and cpc.CPcuenta = cp.CPcuenta
						and cpc.CPPid = cp.CPPid
			) a
					on cpr.CPPid = a.CPPid
					and cpr.Ecodigo = a.Ecodigo
					and cpr.CPcuenta = a.CPcuenta
					and cpr.CPperiodo = a.CPCano
					and cpr.CPmes = a.CPCmes
			left join (<!--- select 0 as NAPMonto,0 as CPPid, 2014 as CPCano, 0 as CPcuenta --->
					SELECT isnull(sum(nd.CPNAPDmonto - nd.CPNAPDutilizado),0) as NAPMonto,
						nd.CPCano, nd.CPCmes, nd.CPPid, nd.CPcuenta,nd.CPNAPnum
					from  CPresupuestoComprometidasNAPs cpn
					inner join CPNAPdetalle nd
						on cpn.CPNAPnum = nd.CPNAPnum
						and cpn.CPNAPDlinea = nd.CPNAPDlinea
						and cpn.CPCano = nd.CPCano
						and cpn.CPCmes = nd.CPCmes
						and cpn.CPcuenta = nd.CPcuenta
					group by nd.CPCano, nd.CPcuenta, nd.CPCmes, nd.CPPid,nd.CPNAPnum
			) sn
					 on sn.CPPid = cpr.CPPid
					and sn.CPCano = cpr.CPperiodo
					and sn.CPcuenta = cpr.CPcuenta
					and sn.CPCmes = cpr.CPmes
					and sn.CPNAPnum = cpr.CPNAPnum
			inner join #tValPres# t
					on a.CPcuenta = t.CPcuenta
			group by a.CPCano, a.CPCmes , t.Grupo
			having sum(cpr.CPComprMod) > sum(a.PDisponible) + sum(isnull(sn.NAPMonto,0))
				and sum(cpr.CPComprMod) <> sum(cpr.CPComp_Anterior)
	</cfquery>
	<!--- <cf_dump var="#rsValComp#"> --->
	<cfif rsValComp.recordCount GT 0>
		<cfset agrup = ValueList(rsConfig.Descripcion,",")>
		<cfloop query="rsValComp">
			<cfquery name="rsInsertError" datasource="#Session.DSN#">
		    	insert MensAplCompromiso (Ecodigo, Linea, Mensaje)
		        values(<cfqueryparam  cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
		        	(select count(*) from MensAplCompromiso) +1,
		        	'ERROR EN CONTROL PRESUPUESTARIO: El monto '#_Cat#'#NumberFormat(rsValComp.CPComprMod,",9.00")#'  #_Cat#' a comprometer para el mes '
		        	#_Cat#'#rsValComp.CPperiodo#'#_Cat#'-'#_Cat#'#rsValComp.CPmes#'#_Cat#' es mayor que el disponible '#_Cat#'#NumberFormat(rsValComp.PDisponible + rsValComp.NAPMonto,",9.00")# por '#_Cat#'#agrup#'
		        	#_Cat#' #rsValComp.Grupo#'
		        	)
		     </cfquery>
		</cfloop>
	</cfif>



</cfif>

<cfset AplicaCompromiso = False>
	<cfloop query="rsLineas">
    	<cfset varCeros = "0000">
        <cfset varNumeroLen = len(varCeros) - len(trim(right(rsLineas.CPNAPDlinea,4)))>
        <cfif varNumeroLen GT 0>
        	<cfset varCeros = left(varCeros,varNumeroLen)>
        <cfelse>
        	<cfset varCeros = "">
        </cfif>
<!---Se debe considerar que en algun momento se cambie el tipo de dato de Integer a Numeric para el campo Linea o modificar la logica con la que se genera este numero--->
		<cfset varLineaNAP = rsLineas.CPNAPnum & varCeros & trim(right(rsLineas.CPNAPDlinea,4))>
		<cfset vs_aniomesLinea = #rsLineas.CPperiodo# * 100 + #rsLineas.CPmes#>
	    <cfset vs_montoCompr   = #rsLineas.CPComprMod# - #rsLineas.CPComp_Anterior#>

	    <cfif vs_aniomesLinea ge vs_aniomesCierre>


	        <cfif rsLineas.NCPNAPnum EQ "" or rsLineas.CPNAPDlinea EQ "">
	            <cfset LvarLINreferencia = "NULL">
	            <cfset LvarNAPreferencia = "NULL">
	        <cfelse>
	            <cfset LvarLINreferencia = #rsLineas.CPNAPDlinea#>
	            <cfset LvarNAPreferencia = #rsLineas.NCPNAPnum#>
	        </cfif>

	        <cfif rsLineas.CPCPtipoControl EQ "" or rsLineas.CPCPcalculoControl EQ "">
	        	<cfquery name="rsInsertError" datasource="#Session.DSN#">
	            	insert MensAplCompromiso (Ecodigo, Linea, Mensaje)
	                values(<cfqueryparam  cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
	                	(select count(*) from MensAplCompromiso) +1,
	                    'ERROR EN CONTROL PRESUPUESTARIO: La Cuenta de Presupuesto '#_Cat#'#rsLineas.CPCCmascara#'#_Cat#' no Existe en Perï¿½odo '#_Cat# 		'#rsLineas.CPperiodo#')
	        	</cfquery>
	            <!--- <cf_errorCode	code = "51322"
	                            msg  = "ERROR EN CONTROL PRESUPUESTARIO: La Cuenta de Presupuesto '@errorDat_1@' no Existe en Perï¿½odo @errorDat_2@"
	                            errorDat_1="#rsLineas.CPCCmascara#"
	                            errorDat_2="#rsLineas.CPperiodo#"
	            >--->
	        <cfelse>
	        	<!---Cï¿½lculo de Saldos--->
				<cfif rsLineas.CPCCPcuenta EQ "">
	                <cfquery name="rsInsertError" datasource="#Session.DSN#">
	                    insert MensAplCompromiso (Ecodigo, Linea, Mensaje)
	                    values(<cfqueryparam  cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
	                        (select count(*) from MensAplCompromiso) +1,
	                        'No ha sido Formulado Presupuesto para cuenta '#_Cat#'#rsLineas.CPCCmascara#'#_Cat#' en la Oficina '#_Cat#'#rsOficina.Odescripcion#'#_Cat#' durante el mes '#_Cat#'#rsLineas.CPperiodo#'#_Cat#'-'#_Cat#'#rsLineas.CPmes#')
	                </cfquery>
						<!--- <cf_errorCode	code = "51323"
										msg  = "ERROR EN CONTROL PRESUPUESTARIO: No ha sido Formulado Presupuesto para cuenta '@errorDat_1@' en la Oficina '@errorDat_2@=@errorDat_3@' durante el mes '@errorDat_4@-@errorDat_5@'"
										errorDat_1="#rsLineas.CPCCmascara#"
										errorDat_2="#trim(rsOficina.Ocodigo)#"
										errorDat_3="#rsOficina.Odescripcion#"
										errorDat_4="#rsLineas.CPperiodo#"
										errorDat_5="#rsLineas.CPmes#"
						> --->
	            <cfelse>
					<cfset Autorizado = rsLineas.CPCpresupuestado + rsLineas.CPCmodificado + rsLineas.CPCmodificacion_Excesos + rsLineas.CPCvariacion + rsLineas.CPCtrasladado + rsLineas.CPCtrasladadoE>
					<cfset Utilizado		= rsLineas.CPCreservado_Anterior + rsLineas.CPCcomprometido_Anterior
														+ rsLineas.CPCreservado_Presupuesto
														+ rsLineas.CPCreservado + rsLineas.CPCcomprometido
														+ rsLineas.CPCejecutado + rsLineas.CPCejecutadoNC >
					<cfset Disponible		= #Autorizado# - #Utilizado#>
	                <cfset Comprometido     = #rsLineas.CPCcomprometido#>
	                <cfset AmplReduccion	= #rsLineas.CPComprMod#-#Comprometido#>
	            </cfif>
	            <cfset AplicaCompromisoLinea = False>
	            <cfif AmplReduccion le 0>
	            	<cfset AplicaCompromisoLinea = True>
	            <cfelse>
					<cfset LvarLINreferencia = "NULL">
	                <cfset LvarNAPreferencia = "NULL">
	            	<cfif  AmplReduccion gt Disponible>
						<cfif rsLineas.CPCPtipoControl neq "0"> <!--- No es control Abierto --->
	                        <cfquery name="rsInsertError" datasource="#Session.DSN#">
	                            insert MensAplCompromiso (Ecodigo, Linea, Mensaje)
	                            values(<cfqueryparam  cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
	                                (select count(*) from MensAplCompromiso) +1,
	                                'ERROR EN CONTROL PRESUPUESTARIO: La cuenta '#_Cat#'#rsLineas.CPCCmascara#'#_Cat#' no es de control abierto y no cuenta con suficiente monto disponible para el mes '#_Cat#'#rsLineas.CPperiodo#')
	                        </cfquery>
	                        <!--- <cf_errorCode	code = "50497"
	                                        msg  = "ERROR EN CONTROL PRESUPUESTARIO: La cuenta '@errorDat_1@' no es de control abierto y no cuenta con suficiente monto disponible para el mes '@errorDat_2@-@errorDat_3@'"
	                                        errorDat_1="#rsLineas.CPCCmascara#"
	                                        errorDat_2="#rsLineas.CPmes#"
	                                        errorDat_3="#rsLineas.CPperiodo#"
	                        > --->
	                    	<cfset AplicaCompromisoLinea = False>
	                    <cfelse>
	            			<cfset AplicaCompromisoLinea = True>
	            		</cfif>
	                <cfelse>
	                	<cfset AplicaCompromisoLinea = True>
	            	</cfif>
	            </cfif>

            	<cfif (NumberFormat(Comprometido,".00") + NumberFormat(vs_montoCompr,".00")) lt 0 and validaXCPVal EQ 'N'>

	            	<cfset AplicaCompromisoLinea = False>
	                <cfquery name="rsInsertError" datasource="#Session.DSN#">
	                    insert MensAplCompromiso (Ecodigo, Linea, Mensaje)
	                    values(<cfqueryparam  cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
	                        (select count(*) from MensAplCompromiso) +1,
	                        'ERROR EN CONTROL PRESUPUESTARIO: El monto '#_Cat#'#vs_montoCompr#'#_Cat#' a descomprometer de la cuenta  '#_Cat#'#rsLineas.CPCCmascara#'#_Cat#' es menor al monto comprometido '#_Cat#'#Comprometido#'#_Cat#' para el mes '#_Cat#'#rsLineas.CPperiodo#')
	                </cfquery>
	                <!--- <cf_errorCode	code = "500498"
	                                msg  = "ERROR EN CONTROL PRESUPUESTARIO: El monto '@errorDat_4@' a descomprometer de la cuenta '@errorDat_1@' es menor al monto comprometido '@errorDat_5@' para el mes '@errorDat_2@-@errorDat_3@'"
	                                errorDat_1="#rsLineas.CPCCmascara#"
	                                errorDat_2="#rsLineas.CPmes#"
	                                errorDat_3="#rsLineas.CPperiodo#"
	                                errorDat_4="#vs_montoCompr#"
	                                errorDat_5="#Comprometido#"
	                > --->
	            </cfif>

	            <cfif AplicaCompromisoLinea >
	            	<cfif AmplReduccion neq 0>


	                <!---Busca Si Existe NAP Anterior--->
	                    <cfif (rsLineas.NAPMonto GT 0 and validaXCPVal EQ 'N') or (rsLineas.NAPMonto NEQ 0 and validaXCPVal EQ 'S')>
		                    <cfset AplicaCompromiso = True>
					        <!---Reversa NAP Anterior--->
	                    	<cfset LINreferenciaRev = 0 - #rsLineas.CPNAPDlinea#>

	                        <cfquery name="rsInsertintPresupuesto" datasource="#session.dsn#">
	                            insert into #request.intPresupuesto#
	                                (
	                                    ModuloOrigen,
	                                    NumeroDocumento,
	                                    NumeroReferencia,
	                                    FechaDocumento,
	                                    AnoDocumento,
	                                    MesDocumento,
										NumeroLinea,
										NAPreversado,
	                                    CPPid,
	                                    CPCano, CPCmes, CPCanoMes,
	                                    CPcuenta, Ocodigo,
	                                    CuentaPresupuesto, CodigoOficina,
	                                    TipoControl, CalculoControl, SignoMovimiento,
	                                    TipoMovimiento,
	                                    Mcodigo, TipoCambio,
	                                    MontoOrigen, Monto, NAPreferencia,LINreferencia
	                                )
	                            values ('PRFO',
										'#LvarDocumentoAprobo#',
										'MODIFICACION',
	                                    <cf_dbfunction name="now">,
	                                    <cfqueryparam  cfsqltype="cf_sql_numeric" value="#rsLineas.CPperiodo#">,
	                                    <cfqueryparam  cfsqltype="cf_sql_numeric" value="#rsLineas.CPmes#">,
										-<cfqueryparam  cfsqltype="cf_sql_numeric" value="#varLineaNAP#">, <!----04/Mar/2014 ABG: Para evitar error de PK se crea un numero de Linea especial que no genere error, antes se insertaba el numero de linea del NAP a reversar pero daba error cuando coincidia el mismo numero de Linea en varios NAPS--->
										#rsLineas.CPNAPnum#,
	                                    <cfqueryparam  cfsqltype="cf_sql_numeric" value="#Form.CPPid#">,
	                                    #rsLineas.CPperiodo#, #rsLineas.CPmes#, #vs_aniomesLinea#,
	                                    <cfqueryparam  cfsqltype="cf_sql_numeric" value="#rsLineas.CPcuenta#">,
	                                    <cfqueryparam  cfsqltype="cf_sql_numeric" value="#rsOficina.Ocodigo#">,
	                                    '#rsLineas.CPCCmascara#', '#rsOficina.Oficodigo#',
	                                    #rsLineas.CPCPtipoControl#, #rsLineas.CPCPcalculoControl#, +1,
	                                    'CC',
	                                    #qry_monedaEmpresa.Mcodigo#,
	                                    1,
	                                    -1*#rsLineas.NAPMonto#, -1*#rsLineas.NAPMonto#,
										#rsLineas.CPNAPnum#,#rsLineas.CPNAPDlinea#
	                                    )
	                        </cfquery>
	                    </cfif>

					 <cfif ((NumberFormat(Comprometido,".00") + NumberFormat(vs_montoCompr,".00")) GT 0 and validaXCPVal EQ 'N') or validaXCPVal EQ 'S' >
						<cfset AplicaCompromiso = True>
						<cfquery name="rsInsertintPresupuesto" datasource="#session.dsn#">
	                        insert into #request.intPresupuesto#
	                            (
	                                ModuloOrigen,
	                                NumeroDocumento,
	                                NumeroReferencia,
	                                FechaDocumento,
	                                AnoDocumento,
	                                MesDocumento,
	                                NumeroLinea,
	                                CPPid,
	                                CPCano, CPCmes, CPCanoMes,
	                                CPcuenta, Ocodigo,
	                                CuentaPresupuesto, CodigoOficina,
	                                TipoControl, CalculoControl, SignoMovimiento,
	                                TipoMovimiento,
	                                Mcodigo,
	                                TipoCambio,
	                                MontoOrigen, Monto,
	                                NAPreferencia,LINreferencia
	                            )
	                        values ('PRFO', '#LvarDocumentoAprobo#', 'MODIFICACION',
	                                <cf_dbfunction name="now">,
	                                <cfqueryparam  cfsqltype="cf_sql_numeric" value="#rsLineas.CPperiodo#">,
	                                <cfqueryparam  cfsqltype="cf_sql_numeric" value="#rsLineas.CPmes#">,
									abs(coalesce((select max(NumeroLinea) from #request.intPresupuesto#),0)+1),
	                                <cfqueryparam  cfsqltype="cf_sql_numeric" value="#Form.CPPid#">,
	                                #rsLineas.CPperiodo#, #rsLineas.CPmes#, #vs_aniomesLinea#,
	                                <cfqueryparam  cfsqltype="cf_sql_numeric" value="#rsLineas.CPcuenta#">,
	                                <cfqueryparam  cfsqltype="cf_sql_numeric" value="#rsOficina.Ocodigo#">,
	                                '#rsLineas.CPCCmascara#',
	                                '#rsOficina.Oficodigo#',
	                                #rsLineas.CPCPtipoControl#,
	                                #rsLineas.CPCPcalculoControl#, +1,
	                                'CC',
	                                #qry_monedaEmpresa.Mcodigo#,
	                                1,
	                                #Comprometido# + #vs_montoCompr#,
	                                #Comprometido# + #vs_montoCompr#,
	                                NULL,NULL
	                                )
	                    </cfquery>
	                    <!--- <cf_dump var="#Comprometido# + #vs_montoCompr# = #Comprometido + vs_montoCompr#"> --->
	                 </cfif>

	                </cfif>
				</cfif>
	        </cfif>


		</cfif>

		<cfif rowIndex mod 500 eq 0>
			<!--- limpiando memoria --->
			<cfset javaRT = createobject("java","java.lang.Runtime").getRuntime() />
			<cfset javaRT.gc() />
			<!--- invoca el GC --->
		</cfif>
		<cfset rowIndex = rowIndex + 1>

	</cfloop>

	<cfquery name="rsErrores" datasource="#session.dsn#">
		select * from MensAplCompromiso
	</cfquery>

	<cfif rsErrores.recordCount NEQ 0>
		<cfset AplicaCompromiso="False">
	</cfif>


<cfif AplicaCompromiso >
	<cfquery name="rs_regporCompr" datasource="#session.dsn#">
		select top 1 * from #request.intPresupuesto#
	</cfquery>

	<!--- <cf_dump var="#rs_regporCompr#"> --->

    <cfif rs_regporCompr.recordCount NEQ 0>
    	<cfset LvarNAP = LobjControl.ControlPresupuestario(ModuloOrigen="PRFO", NumeroDocumento=LvarDocumentoAprobo, NumeroReferencia="MODIFICACION",
				FechaDocumento=LvarFecha, AnoDocumento=LvarAno, MesDocumento=LvarMes,validaComp="True") />
	<cfelse>
    	<cfset LvarNAP = -1 />
    </cfif>

	<cfif LvarNAP LT 0>
		<cfquery datasource="#session.dsn#">
        	update CPresupuestoComprAut
			set CPcambioAplicado = 1
            where CPPid=<cfqueryparam  cfsqltype="cf_sql_numeric" value="#Form.CPPid#">
            and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
    <cfelse>
		<!---Guardo NAP y Compromiso Anterior--->
        <cfquery name="actCPresupuestoComprometidasNAPs" datasource="#session.dsn#">
			update compnaps
            	set	CPNAPnum = cpnapd.CPNAPnum ,CPNAPDlinea = cpnapd.CPNAPDlinea
			from CPresupuestoComprometidasNAPs compnaps
	        inner join CPNAPdetalle cpnapd
				 	on compnaps.Ecodigo 	= <cfqueryparam  cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	                and compnaps.CPPid	= <cfqueryparam  cfsqltype="cf_sql_numeric" value="#Form.CPPid#">
	                and compnaps.CPcuenta	= cpnapd.CPcuenta
	                and compnaps.Ocodigo	= cpnapd.Ocodigo
	                and compnaps.CPCano 	= cpnapd.CPCano
	                and compnaps.CPCmes		= cpnapd.CPCmes
	        where cpnapd.Ecodigo			= <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	        	and cpnapd.CPNAPnum			= #LvarNAP#
	            and cpnapd.CPNAPDtipoMov	= 'CC'
	            <cfif validaXCPVal EQ 'N'>
	            	and cpnapd.CPNAPDmonto		> 0
	           <cfelse>
	            	and cpnapd.CPNAPDlinea		> 0
	            </cfif>
        </cfquery>

		<cfquery name="insCPresupuestoComprometidasNAPs" datasource="#session.dsn#">
	        insert into CPresupuestoComprometidasNAPs
	                    (
	                            Ecodigo,
	                            CPPid,
	                            CPcuenta, Ocodigo, CPCano, CPCmes,
	                            CPNAPnum, CPNAPDlinea
	                    )
	                    SELECT <cfqueryparam  cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, <cfqueryparam  cfsqltype="cf_sql_numeric" value="#Form.CPPid#">,
							cpnapd.CPcuenta, cpnapd.Ocodigo,
							cpnapd.CPCano,cpnapd.CPCmes,
							cpnapd.CPNAPnum, cpnapd.CPNAPDlinea
	                    from CPNAPdetalle cpnapd
		        left join CPresupuestoComprometidasNAPs compnaps
					 	on compnaps.Ecodigo 	= <cfqueryparam  cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		                and compnaps.CPPid	= <cfqueryparam  cfsqltype="cf_sql_numeric" value="#Form.CPPid#">
		                and compnaps.CPcuenta	= cpnapd.CPcuenta
		                and compnaps.Ocodigo	= cpnapd.Ocodigo
		                and compnaps.CPCano 	= cpnapd.CPCano
		                and compnaps.CPCmes		= cpnapd.CPCmes
		        where cpnapd.Ecodigo			= <cfqueryparam  cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		        	and cpnapd.CPNAPnum			= #LvarNAP#
		            and cpnapd.CPNAPDtipoMov	= 'CC'
		            <cfif validaXCPVal EQ 'N'>
			            and cpnapd.CPNAPDmonto		> 0
			        <cfelse>
	            		and cpnapd.CPNAPDlinea		> 0
			        </cfif>
		            and compnaps.CPcuenta	is null
		            and compnaps.Ocodigo is null
		            and compnaps.CPCano is null
		            and compnaps.CPCmes	is null
		</cfquery>

		<!---Inicia la Bitacora de aplicacion--->
		<cftry>
			<cfquery name="insertEncBitacora" datasource="#session.dsn#">
				INSERT INTO CPBitacoraCCompromiso
			           (CPPid
			           ,NumeroDocumento
			           ,FechaAplica
			           ,Ecodigo
			           ,BMUsucodigo)
			     VALUES
			           (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPPid#">,
			           <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarDocumentoAprobo#">,
			           <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
			           <cfqueryparam  cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
			           <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
				<cf_dbidentity1 datasource="#Session.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#Session.DSN#" name="rsBitacoraCCompromiso">
			<cfset CPBid = rsBitacoraCCompromiso.identity>


			<cfquery name="insertDetBitacora" datasource="#session.dsn#">
				INSERT INTO CPBitacoraCCDetalle
			           (CPBid
			           ,CPcuenta
			           ,CPperiodo
			           ,CPmes
			           ,CPNAPnum
			           ,MontoOriginal
			           ,MontoNuevo
			           ,Aplicado)
			     select distinct <cfqueryparam cfsqltype="cf_sql_numeric" value="#CPBid#">,
						a.CPcuenta, d.CPperiodo, d.CPmes,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarNAP#">,
						d.CPComp_Anterior, d.CPComprMod,
						case when i.Monto is not null then 1 else 0 end
					from CPresupuestoComprAut a
					inner join CPresupuestoComprAutD d
								on a.CPCCid=d.CPCCid
					left join #request.intPresupuesto# i
						on i.CPPid = a.CPPid
			            and i.CPCano = d.CPperiodo
			            and i.CPCmes = d.CPmes
						and i.CPcuenta = a.CPcuenta
					where a.Ecodigo = <cfqueryparam  cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					    and a.CPPid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPPid#">
						and a.CPcambioAplicado = <cfqueryparam  cfsqltype="cf_sql_integer" value="0">
						and d.CPComprMod <> d.CPComp_Anterior
						<cfif validaXCPVal EQ 'N'>
						and i.Monto > 0
						</cfif>
			</cfquery>
		<cfcatch type="any">

		</cfcatch>
		</cftry>
		<!---Fin Bitacora de aplicacion--->

		<cfquery name="rsActNAP" datasource="#session.dsn#">
                update CPresupuestoComprAutD
                set CPNAPnum = #LvarNAP#, CPComp_Anterior = CPComprMod
                where CPPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPPid#">
                    and coalesce(CPComp_Anterior,0) <> CPComprMod
        </cfquery>

    	<cfquery datasource="#session.dsn#">
        	update CPresupuestoComprAut
			set CPcambioAplicado = 1
            where CPPid=<cfqueryparam  cfsqltype="cf_sql_numeric" value="#Form.CPPid#">
            and Ecodigo=<cfqueryparam  cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>

    </cfif>
</cfif>
<cfcatch type="any">
		    	<cftransaction action="rollback"/>
	            <cfquery name="rsInsertError" datasource="#Session.DSN#">
	                insert MensAplCompromiso (Ecodigo, Linea, Mensaje)
	                values(<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
	                    (select count(*) from MensAplCompromiso) +1,'#cfcatch.Message#')
	            </cfquery>

				<cfif isdefined("cfcatch.Message")>
	            	<cfset Mensaje="#cfcatch.Message#">
	           	<cfelse>
	           		<cfset Mensaje="">
		        </cfif>
	            <cfif isdefined("cfcatch.Detail")>
	            	<cfset Detalle="#cfcatch.Detail#">
	            <cfelse>
	                <cfset Detalle="">
	            </cfif>
	            <cfif isdefined("cfcatch.sql")>
	                <cfset SQL="#cfcatch.sql#">
	            <cfelse>
	                <cfset SQL="">
	            </cfif>
	            <cfif isdefined("cfcatch.where")>
	               <cfset PARAM="#cfcatch.where#">
	            <cfelse>
	               <cfset PARAM="">
	            </cfif>
	            <cfif isdefined("cfcatch.StackTrace")>
	               <cfset PILA="#cfcatch.StackTrace#">
	            <cfelse>
	               <cfset PILA="">
	            </cfif>

	            <cfthrow message = "#Mensaje#. #Detalle# #SQL#">
	    </cfcatch>
	    </cftry>
<cftransaction action="commit"/>
</cftransaction>

<cfif NOT AplicaCompromiso and rsErrores.recordCount NEQ 0>
	<cf_errorCode	code = "51323321"
			msg = "ERROR AL APLICAR COMPROMISOS AUTOMÁTICOS: Revise el detalle de los errores"
			>
</cfif>
<!---<cfquery name="rsInsertError" datasource="#Session.DSN#">
    insert MensAplCompromiso (Ecodigo, Linea, Mensaje)
    values(<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
        (select count(*) from MensAplCompromiso) +1,
        'ERROR EN CONTROL PRESUPUESTARIO: El monto '#_Cat#'#vs_montoCompr#'#_Cat#' a descomprometer de la cuenta  '#_Cat#'#rsLineas.CPCCmascara#'#_Cat#' es menor al monto comprometido '#_Cat#'#vs_montoCompr#'#_Cat#' para el mes '#_Cat#'#rsLineas.CPperiodo#')
</cfquery>
--->
<cfoutput>
<form action="CPCompromisoAut.cfm" method="post" name="sql">
    <input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
</form>
</cfoutput>


<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
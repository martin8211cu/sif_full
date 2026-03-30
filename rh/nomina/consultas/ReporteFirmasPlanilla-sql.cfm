<cfset pre=''>
<cfif isDefined("chk_NominaAplicada")>
 <cfset pre='H'>
</cfif>

<cffunction name="getFiltroEncab" returntype="query">
	<cfquery name="rsFiltroEncab" datasource="#session.DSN#">
		select distinct tn.Tcodigo, tn.Tdescripcion, cp.CPcodigo, cp.CPdescripcion, coalesce(rcn.RCtc,1) as RCtc
		from DatosEmpleado de
		left join TiposEmpleado te
		    on de.TEid = te.TEid
		inner join #pre#SalarioEmpleado hse
			on de.DEid = hse.DEid
	    	inner join #pre#RCalculoNomina rcn
	        	on hse.RCNid = rcn.RCNid
	        	inner join CalendarioPagos cp
	        		on rcn.RCNid = cp.CPid
	        	inner join TiposNomina tn 
		        	on rcn.Ecodigo = tn.Ecodigo
		        	and rcn.Tcodigo = tn.Tcodigo
	    	left join #pre#IncidenciasCalculo ic
	        	on hse.DEid = ic.DEid
	        	and hse.RCNid = ic.RCNid
	    		left join CIncidentes ci
	         		on ic.CIid = ci.CIid 
	         		and ci.CInoanticipo = 0
		         		
		where 1=1
		<cfif isdefined("form.LISTANOMINA") and len(trim(form.LISTANOMINA)) GT 0>
			and rcn.RCNid in (<cfqueryparam cfsqltype="cf_sql_integer" value="#form.LISTANOMINA#" list="true" />)
		<cfelse>
        	and 1=2
        </cfif>	
		
	</cfquery>

	<cfreturn rsFiltroEncab>
</cffunction>

<cf_dbfunction name="op_concat" returnvariable="concat">
<cf_translatedata name="get" tabla="CFuncional" col="CF.CFdescripcion" returnvariable="LvarCFdescripcion">  

<!----- realiza el filtro a las nominas seleccionadas---->
<cfif pre EQ  'H'>
	<cfquery name="rsReporte" datasource="#session.dsn#">
		SELECT  sum(case when dr.Bid is not null and dr.CBTcodigo = 0 then dr.#pre#DRNliquido else 0 end) as sincuentamonto,
				sum(case when dr.Bid is not null and dr.CBTcodigo = 1 then dr.#pre#DRNliquido else 0 end) as concuentamonto,
				sum(case when dr.Bid is not null and dr.CBTcodigo = 0 then 1 else 0 end) as sincuenta,
				sum(case when dr.Bid is not null and dr.CBTcodigo = 1 then 1 else 0 end) as concuenta,
				sum(case when dr.Bid is null then 1 else 0 end) as totalcheque,
				sum(case when dr.Bid is null then dr.#pre#DRNliquido else 0 end) as chequemonto
		FROM #pre#ERNomina er
			inner join CalendarioPagos cp
				on er.RCNid = cp.CPid
			inner join #pre#DRNomina dr
				on er.ERNid = dr.ERNid
			inner join DatosEmpleado de
				on dr.DEid=de.DEid	
		WHERE
		<cfif isdefined("form.jtreeListaItem")and len(trim(form.jtreeListaItem))>
			er.Ecodigo in(<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.jtreeListaItem#" list="true">)
		<cfelse>
			er.Ecodigo = #session.Ecodigo#
		</cfif>	
		<cfif isDefined("form.CKUTILIZARFILTROFECHAS")>
			<cfif len(trim(form.FechaHasta))>
				and cp.CPdesde <= <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#LSParseDateTime(form.FechaHasta)#">
			</cfif>
			<cfif len(trim(form.FechaDesde))>
				and cp.CPhasta >= <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#LSParseDateTime(form.FechaDesde)#">
			</cfif>
		<cfelse>
			<cfif isdefined("form.LISTANOMINA") and len(trim(form.LISTANOMINA)) GT 0>
				and er.RCNid in (<cfqueryparam cfsqltype="cf_sql_integer" value="#form.LISTANOMINA#" list="true" />)
			<cfelse>
				and 1=2
			</cfif>
		</cfif>
	</cfquery>
<cfelse>
	<cfquery name="rsReporte" datasource="#session.dsn#">
		SELECT  
				sum(case when de.Bid is not null and de.CBTcodigo = 0 then se.SEliquido else 0 end) as sincuentamonto,
				sum(case when de.Bid is not null and de.CBTcodigo = 1 then se.SEliquido else 0 end) as concuentamonto,
				sum(case when de.Bid is not null and de.CBTcodigo = 0 then 1 else 0 end) as sincuenta,
				sum(case when de.Bid is not null and de.CBTcodigo = 1 then 1 else 0 end) as concuenta,
				sum(case when de.Bid is null then 1 else 0 end) as totalcheque,
				sum(case when de.Bid is null then se.SEliquido else 0 end) as chequemonto	
		FROM CalendarioPagos cp
				inner join SalarioEmpleado se
					on  se.RCNid = cp.CPid
				inner join DatosEmpleado de
					on de.DEid=se.DEid	
		WHERE 
		<cfif isdefined("form.jtreeListaItem")and len(trim(form.jtreeListaItem))>
			cp.Ecodigo in(<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.jtreeListaItem#" list="true">)
		<cfelse>
			cp.Ecodigo = #session.Ecodigo#
		</cfif>	
		<cfif isDefined("form.CKUTILIZARFILTROFECHAS")>
			<cfif len(trim(form.FechaHasta))>
				and cp.CPdesde <= <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#LSParseDateTime(form.FechaHasta)#">
			</cfif>
			<cfif len(trim(form.FechaDesde))>
				and cp.CPhasta >= <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#LSParseDateTime(form.FechaDesde)#">
			</cfif>
		<cfelse>
			<cfif isdefined("form.LISTANOMINA") and len(trim(form.LISTANOMINA)) GT 0>
				and se.RCNid in (<cfqueryparam cfsqltype="cf_sql_integer" value="#form.LISTANOMINA#" list="true" />)
			<cfelse>
				and 1=2
			</cfif>
		</cfif>
	
	</cfquery>	
</cfif>

<cfif rsReporte.recordcount EQ 0>
	<br>
	<br>
	<cf_translate  key="LB_NoSeGeneroUnReporteSegunLosFiltrosDados">No se generó un reporte según los filtros dados. Intente de nuevo!</cf_translate>
	<br>
	<br>
	<cfabort>
</cfif>	

<cfinvoke component="rh.Componentes.RHParametros" method="get" pvalor="2688" default="-1" returnvariable="LvarConceptoASEIICA"/>
<cfif LvarConceptoASEIICA eq '-1'>
	<cfinvoke component="sif.Componentes.Translate" method="Translate" 
		Key="LB_ReporteResumenFirmasDePlanilla" Default="Configuración Faltante" 
		returnvariable="LB_msg1"/>
	<cfinvoke component="sif.Componentes.Translate" method="Translate" 
		Key="LB_ConfigurarDeduccionASEIICAParametrosGenerales" Default="Es necesario configurar la Deducción para ASEIICA en los Parámetros Generales" 
		returnvariable="LB_msg2"/>
	<cf_throw message="#LB_msg1#" detail="#LB_msg2#">
</cfif>

<cfquery name="rsDeducciones" datasource="#session.dsn#">
	SELECT td.TDcodigo,td.TDdescripcion,coalesce(sum(dc.DCvalor),0) monto
	FROM CalendarioPagos cp
		inner join #pre#DeduccionesCalculo dc
			on dc.RCNid = cp.CPid
		inner join DeduccionesEmpleado de
			on dc.Did=de.Did
		inner join TDeduccion td
			on de.TDid = td.TDid
         	<cfif isdefined("form.TCODIGOLISTDD")and len(trim(form.TCODIGOLISTDD))>
            	and td.TDcodigo in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TCODIGOLISTDD#" list="yes">)
            </cfif>
			<cfif isdefined("form.jtreeListaItem")and len(trim(form.jtreeListaItem))>
				and td.Ecodigo in(<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.jtreeListaItem#" list="true">)
			</cfif>        
	WHERE 
		<cfif isdefined("form.jtreeListaItem")and len(trim(form.jtreeListaItem))>
			cp.Ecodigo in(<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.jtreeListaItem#" list="true">)
		<cfelse>
			cp.Ecodigo = #session.Ecodigo#
		</cfif>	
		<cfif isDefined("form.CKUTILIZARFILTROFECHAS")>
			<cfif len(trim(form.FechaHasta))>
				and cp.CPdesde <= <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#LSParseDateTime(form.FechaHasta)#">
			</cfif>
			<cfif len(trim(form.FechaDesde))>
				and cp.CPhasta >= <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#LSParseDateTime(form.FechaDesde)#">
			</cfif>
		<cfelse>
			<cfif isdefined("form.LISTANOMINA") and len(trim(form.LISTANOMINA)) GT 0>
				and dc.RCNid in (<cfqueryparam cfsqltype="cf_sql_integer" value="#form.LISTANOMINA#" list="true" />)
			<cfelse>
				and 1=2
			</cfif>
		</cfif>
	group by td.TDcodigo,td.TDdescripcion
</cfquery>
 
<cfquery name="rsEmpresa" datasource="#session.dsn#">
    select Ecodigo, Edescripcion 
    from Empresas 
    where
    	<cfif isdefined("form.jtreeListaItem")and len(trim(form.jtreeListaItem))>
         	Ecodigo in(<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.jtreeListaItem#" list="true">)
        <cfelse>
         	Ecodigo = #session.Ecodigo#
        </cfif>
</cfquery>
<cfset filtro1 = valueList(rsEmpresa.Edescripcion, ', ')>

<cf_translatedata name="get" tabla="CuentaEmpresarial" col="CEnombre" conexion="asp" returnvariable="LvarCEnombre">
<cfquery datasource="asp" name="rsCEmpresa">
	select #LvarCEnombre# as CEnombre 
	from CuentaEmpresarial 
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
</cfquery>
<cfset LB_Corp = rsCEmpresa.CEnombre>

<cfset filtro2 = "" >
<cfset rsFiltroEncab = getFiltroEncab() >
<cfloop query="rsFiltroEncab">
	<cfif RCtc neq 1 >
        <cfset vTC = "(TC: #RCtc#)">
    <cfelse>
        <cfset vTC = "" >   
    </cfif>
	<cfset filtro2 &= '#CPcodigo# - #Tcodigo# - #Tdescripcion# - #CPdescripcion# #vTC#<br/>'>
</cfloop>
 
<cfif rsReporte.recordcount EQ 0>
	<br>
	<br>
	<cf_translate  key="LB_NoSeGeneroUnReporteSegunLosFiltrosDados">No se generó un reporte según los filtros dados. Intente de nuevo!</cf_translate>
	<br>
	<br>
	<cfabort>
<cfelseif rsReporte.recordcount NEQ 0>
	<cfinclude template="ReporteFirmasPlanilla-html.cfm">
</cfif>


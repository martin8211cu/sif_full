<!--- INCLUDES --->
<cfinclude template="../../../Utiles/sifConcat.cfm">

<!--- PARAMS --->
<cfparam name="form.CPPid" default="">
<cfparam name="form.CtaPres" default="">
<cfparam name="form.mesDesde" default="">
<cfparam name="form.mesHasta" default="">
<cfparam name="form.soloDiferencias" default="">
<cfif isdefined("url.CtaPres")>
	<cfset form.CtaPres=url.CtaPres>
</cfif>
<cfif isdefined("url.CPPid")>
	<cfset form.CPPid=url.CPPid>
	<cfset session.CPPid2=form.CPPid>
</cfif>
<cfif isdefined("url.mesDesde")>
	<cfset form.mesDesde=url.mesDesde>
</cfif>
<cfif isdefined("url.mesHasta")>
	<cfdump var="#url.mesHasta#">
	<cfset form.mesHasta=url.mesHasta>
</cfif>
<cfif isdefined("url.soloDiferencias")>
	<cfset form.soloDiferencias=url.soloDiferencias>
</cfif>
<!--- <cfoutput>
cuenta: #form.CtaPres#
periodo: #form.CPPid#
desde: #form.mesDesde#
hasta: #form.mesHasta#
check: #form.soloDiferencias#
</cfoutput> --->
<cfset LvarContL = 5>
<cfset LvarLineasPagina = 40>
<cfset LvarPAg = 1>
<cfset LvarMeses = arrayNew(1)>
<cfset LvarMeses[1] = "ENERO">
<cfset LvarMeses[2] = "FEBRERO">
<cfset LvarMeses[3] = "MARZO">
<cfset LvarMeses[4] = "ABRIL">
<cfset LvarMeses[5] = "MAYO">
<cfset LvarMeses[6] = "JUNIO">
<cfset LvarMeses[7] = "JULIO">
<cfset LvarMeses[8] = "AGOSTO">
<cfset LvarMeses[9] = "SETIEMBRE">
<cfset LvarMeses[10] = "OCTUBRE">
<cfset LvarMeses[11] = "NOVIEMBRE">
<cfset LvarMeses[12] = "DICIEMBRE">


<cf_htmlReportsHeaders title="Conciliaci&oacute;n NAPs vs Saldos" filename="NapsVsSaldos.xls" irA="rptConciliacion.cfm">

<!--- CREACION DE TABLA TEMPORAL CPanalisis3--->
<cf_dbtemp name="tblCPanalisis3" returnvariable="CPanalisis3">
	<cf_dbtempcol name="CPformato"    	    	type="char(100)">
	<cf_dbtempcol name="CPNAPnum"       	    type="int">
	<cf_dbtempcol name="CPCano"       	    	type="int">
	<cf_dbtempcol name="CPCmes"       	    	type="int">
	<cf_dbtempcol name="CPNAPDtipoMov"      	type="char(2)">
	<cf_dbtempcol name="Monto"              	type="money">
	<cf_dbtempcol name="ControlPresupuesto"    	type="money">
	<cf_dbtempkey cols="CPformato">
</cf_dbtemp>

<!--- CREACION DE TABLA TEMPORAL CPanalisis4--->
<cf_dbtemp name="tblCPanalisis4" returnvariable="CPanalisis4">
	<cf_dbtempcol name="CPformato"    	    	type="char(100)">
	<cf_dbtempcol name="CPCano"       	    	type="int">
	<cf_dbtempcol name="CPNAPDtipoMov"      	type="char(2)">
	<cf_dbtempcol name="MontoAno"              	type="money">
	<cf_dbtempcol name="CPano"              	type="money">
	<cf_dbtempkey cols="CPformato">
</cf_dbtemp>

<!--- CREACION DE TABLA TEMPORAL CPanalisis5--->
<cf_dbtemp name="tblCPanalisis5" returnvariable="CPanalisis5">
	<cf_dbtempcol name="CPformato"    	    	type="char(100)">
	<cf_dbtempcol name="CPNAPnum"       	    type="int">
	<cf_dbtempcol name="CPCano"       	    	type="int">
	<cf_dbtempcol name="CPCmes"       	    	type="int">
	<cf_dbtempcol name="CPNAPDtipoMov"      	type="char(2)">
	<cf_dbtempcol name="Monto1"              	type="money">
	<cf_dbtempcol name="CP1"              	    type="money">
	<cf_dbtempcol name="Monto2"              	type="money">
	<cf_dbtempcol name="CP2"              	    type="money">
	<cf_dbtempcol name="Monto3"              	type="money">
	<cf_dbtempcol name="CP3"              	    type="money">
	<cf_dbtempcol name="Monto4"              	type="money">
	<cf_dbtempcol name="CP4"              	    type="money">
	<cf_dbtempcol name="Monto5"              	type="money">
	<cf_dbtempcol name="CP5"              	    type="money">
	<cf_dbtempcol name="Monto6"              	type="money">
	<cf_dbtempcol name="CP6"              	    type="money">
	<cf_dbtempcol name="Monto7"              	type="money">
	<cf_dbtempcol name="CP7"              	    type="money">
	<cf_dbtempcol name="Monto8"              	type="money">
	<cf_dbtempcol name="CP8"              	    type="money">
	<cf_dbtempcol name="Monto9"              	type="money">
	<cf_dbtempcol name="CP9"              	    type="money">
	<cf_dbtempcol name="Monto10"              	type="money">
	<cf_dbtempcol name="CP10"              	    type="money">
	<cf_dbtempcol name="Monto11"              	type="money">
	<cf_dbtempcol name="CP11"              	    type="money">
	<cf_dbtempcol name="Monto12"              	type="money">
	<cf_dbtempcol name="CP12"              	    type="money">
	<cf_dbtempkey cols="CPformato">
</cf_dbtemp>

<!-- QUERY PRINCIPAL -->
<cfquery name="rsListPresVsNaps" datasource="#Session.DSN#">

select rtrim(cp.CPformato) as CPformato, nd.CPCano, nd.CPCmes, nd.CPNAPDtipoMov, sum(nd.CPNAPDmonto) as Monto,
(select case nd.CPNAPDtipoMov
when 'A' then cc.CPCpresupuestado
when 'CC' then cc.CPCcomprometido
when 'E' then cc.CPCejecutado 
when 'M' then cc.CPCmodificado
when 'ME' then cc.CPCmodificacion_Excesos
when 'RC' then cc.CPCreservado
when 'RP' then cc.CPCreservado_Presupuesto
when 'T' then cc.CPCtrasladado
end 
from CPresupuestoControl cc where nd.Ecodigo = cc.Ecodigo and nd.CPCano = cc.CPCano and nd.CPCmes = cc.CPCmes
and nd.CPcuenta = cc.CPcuenta) as ControlPresupuesto
into #CPanalisis3#
from CPNAPdetalle nd
inner join CPresupuesto cp on nd.Ecodigo = cp.Ecodigo and nd.CPcuenta = cp.CPcuenta
where nd.CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPPid#">
<cfif isDefined("form.CtaPres") AND #form.CtaPres# NEQ "">
	and cp.CPformato = <cfqueryparam cfsqltype="cf_sql_char" value="#TRIM(form.CtaPres)#">
</cfif>

group by nd.Ecodigo, nd.CPcuenta, cp.CPformato, nd.CPCano, nd.CPCmes, nd.CPNAPDtipoMov
order by nd.CPCano, nd.CPCmes, cp.CPformato, nd.CPNAPDtipoMov


select CPformato, CPCano, CPNAPDtipoMov, sum(Monto) as MontoAno, sum(ControlPresupuesto) as CPano
into #CPanalisis4#
from #CPanalisis3# 
group by CPformato, CPCano, CPNAPDtipoMov


select CPformato, CPCano, CPCmes, CPNAPDtipoMov, 
0.00 as Monto1,  0.00 as CP1,
0.00 as Monto2,  0.00 as CP2,
0.00 as Monto3,  0.00 as CP3,
0.00 as Monto4,  0.00 as CP4,
0.00 as Monto5,  0.00 as CP5,
0.00 as Monto6,  0.00 as CP6,
0.00 as Monto7,  0.00 as CP7,
0.00 as Monto8,  0.00 as CP8,
0.00 as Monto9,  0.00 as CP9,
0.00 as Monto10, 0.00 as CP10,
0.00 as Monto11, 0.00 as CP11,
0.00 as Monto12, 0.00 as CP12
into #CPanalisis5#
from #CPanalisis3# 
group by CPformato, CPCano, CPCmes, CPNAPDtipoMov

alter table #CPanalisis5# alter column Monto1 money
alter table #CPanalisis5# alter column Monto2 money
alter table #CPanalisis5# alter column Monto3 money
alter table #CPanalisis5# alter column Monto4 money
alter table #CPanalisis5# alter column Monto5 money
alter table #CPanalisis5# alter column Monto6 money
alter table #CPanalisis5# alter column Monto7 money
alter table #CPanalisis5# alter column Monto8 money
alter table #CPanalisis5# alter column Monto9 money
alter table #CPanalisis5# alter column Monto10 money
alter table #CPanalisis5# alter column Monto11 money
alter table #CPanalisis5# alter column Monto12 money
alter table #CPanalisis5# alter column CP1 money
alter table #CPanalisis5# alter column CP2 money
alter table #CPanalisis5# alter column CP3 money
alter table #CPanalisis5# alter column CP4 money
alter table #CPanalisis5# alter column CP5 money
alter table #CPanalisis5# alter column CP6 money
alter table #CPanalisis5# alter column CP7 money
alter table #CPanalisis5# alter column CP8 money
alter table #CPanalisis5# alter column CP9 money
alter table #CPanalisis5# alter column CP10 money
alter table #CPanalisis5# alter column CP11 money
alter table #CPanalisis5# alter column CP12 money

update #CPanalisis5#
set Monto1 = isnull((select sum(Monto) 
				from #CPanalisis3# 
				where #CPanalisis5#.CPformato = CPformato
				and #CPanalisis5#.CPCano = CPCano
				and #CPanalisis5#.CPNAPDtipoMov = CPNAPDtipoMov 
				and CPCmes <= 1),0),
	CP1 = isnull((select sum(ControlPresupuesto) 
				from #CPanalisis3# 
				where #CPanalisis5#.CPformato = CPformato
				and #CPanalisis5#.CPCano = CPCano
				and #CPanalisis5#.CPNAPDtipoMov = CPNAPDtipoMov 
				and CPCmes <= 1),0),
	Monto2 = isnull((select sum(Monto) 
				from #CPanalisis3# 
				where #CPanalisis5#.CPformato = CPformato
				and #CPanalisis5#.CPCano = CPCano
				and #CPanalisis5#.CPNAPDtipoMov = CPNAPDtipoMov 
				and CPCmes <= 2),0),
	CP2 = isnull((select sum(ControlPresupuesto) 
				from #CPanalisis3# 
				where #CPanalisis5#.CPformato = CPformato
				and #CPanalisis5#.CPCano = CPCano
				and #CPanalisis5#.CPNAPDtipoMov = CPNAPDtipoMov 
				and CPCmes <= 2),0),
	Monto3 = isnull((select sum(Monto) 
				from #CPanalisis3# 
				where #CPanalisis5#.CPformato = CPformato
				and #CPanalisis5#.CPCano = CPCano
				and #CPanalisis5#.CPNAPDtipoMov = CPNAPDtipoMov 
				and CPCmes <= 3),0),
	CP3 = isnull((select sum(ControlPresupuesto) 
				from #CPanalisis3# 
				where #CPanalisis5#.CPformato = CPformato
				and #CPanalisis5#.CPCano = CPCano
				and #CPanalisis5#.CPNAPDtipoMov = CPNAPDtipoMov 
				and CPCmes <= 3),0),
	Monto4 = isnull((select sum(Monto) 
				from #CPanalisis3# 
				where #CPanalisis5#.CPformato = CPformato
				and #CPanalisis5#.CPCano = CPCano
				and #CPanalisis5#.CPNAPDtipoMov = CPNAPDtipoMov 
				and CPCmes <= 4),0),
	CP4 = isnull((select sum(ControlPresupuesto) 
				from #CPanalisis3# 
				where #CPanalisis5#.CPformato = CPformato
				and #CPanalisis5#.CPCano = CPCano
				and #CPanalisis5#.CPNAPDtipoMov = CPNAPDtipoMov 
				and CPCmes <= 4),0),
	Monto5 = isnull((select sum(Monto) 
				from #CPanalisis3# 
				where #CPanalisis5#.CPformato = CPformato
				and #CPanalisis5#.CPCano = CPCano
				and #CPanalisis5#.CPNAPDtipoMov = CPNAPDtipoMov 
				and CPCmes <= 5),0),
	CP5 = isnull((select sum(ControlPresupuesto) 
				from #CPanalisis3# 
				where #CPanalisis5#.CPformato = CPformato
				and #CPanalisis5#.CPCano = CPCano
				and #CPanalisis5#.CPNAPDtipoMov = CPNAPDtipoMov 
				and CPCmes <= 5),0),
	Monto6 = isnull((select sum(Monto) 
				from #CPanalisis3# 
				where #CPanalisis5#.CPformato = CPformato
				and #CPanalisis5#.CPCano = CPCano
				and #CPanalisis5#.CPNAPDtipoMov = CPNAPDtipoMov 
				and CPCmes <= 6),0),
	CP6 = isnull((select sum(ControlPresupuesto) 
				from #CPanalisis3# 
				where #CPanalisis5#.CPformato = CPformato
				and #CPanalisis5#.CPCano = CPCano
				and #CPanalisis5#.CPNAPDtipoMov = CPNAPDtipoMov 
				and CPCmes <= 6),0),
	Monto7 = isnull((select sum(Monto) 
				from #CPanalisis3# 
				where #CPanalisis5#.CPformato = CPformato
				and #CPanalisis5#.CPCano = CPCano
				and #CPanalisis5#.CPNAPDtipoMov = CPNAPDtipoMov 
				and CPCmes <= 7),0),
	CP7 = isnull((select sum(ControlPresupuesto) 
				from #CPanalisis3# 
				where #CPanalisis5#.CPformato = CPformato
				and #CPanalisis5#.CPCano = CPCano
				and #CPanalisis5#.CPNAPDtipoMov = CPNAPDtipoMov 
				and CPCmes <= 7),0),
	Monto8 = isnull((select sum(Monto) 
				from #CPanalisis3# 
				where #CPanalisis5#.CPformato = CPformato
				and #CPanalisis5#.CPCano = CPCano
				and #CPanalisis5#.CPNAPDtipoMov = CPNAPDtipoMov 
				and CPCmes <= 8),0),
	CP8 = isnull((select sum(ControlPresupuesto) 
				from #CPanalisis3# 
				where #CPanalisis5#.CPformato = CPformato
				and #CPanalisis5#.CPCano = CPCano
				and #CPanalisis5#.CPNAPDtipoMov = CPNAPDtipoMov 
				and CPCmes <= 8),0),
	Monto9 = isnull((select sum(Monto) 
				from #CPanalisis3# 
				where #CPanalisis5#.CPformato = CPformato
				and #CPanalisis5#.CPCano = CPCano
				and #CPanalisis5#.CPNAPDtipoMov = CPNAPDtipoMov 
				and CPCmes <= 9),0),
	CP9 = isnull((select sum(ControlPresupuesto) 
				from #CPanalisis3# 
				where #CPanalisis5#.CPformato = CPformato
				and #CPanalisis5#.CPCano = CPCano
				and #CPanalisis5#.CPNAPDtipoMov = CPNAPDtipoMov 
				and CPCmes <= 9),0),
	Monto10 = isnull((select sum(Monto) 
				from #CPanalisis3# 
				where #CPanalisis5#.CPformato = CPformato
				and #CPanalisis5#.CPCano = CPCano
				and #CPanalisis5#.CPNAPDtipoMov = CPNAPDtipoMov 
				and CPCmes <= 10),0),
	CP10 = isnull((select sum(ControlPresupuesto) 
				from #CPanalisis3# 
				where #CPanalisis5#.CPformato = CPformato
				and #CPanalisis5#.CPCano = CPCano
				and #CPanalisis5#.CPNAPDtipoMov = CPNAPDtipoMov 
				and CPCmes <= 10),0),
	Monto11 = isnull((select sum(Monto) 
				from #CPanalisis3# 
				where #CPanalisis5#.CPformato = CPformato
				and #CPanalisis5#.CPCano = CPCano
				and #CPanalisis5#.CPNAPDtipoMov = CPNAPDtipoMov 
				and CPCmes <= 11),0),
	CP11 = isnull((select sum(ControlPresupuesto) 
				from #CPanalisis3# 
				where #CPanalisis5#.CPformato = CPformato
				and #CPanalisis5#.CPCano = CPCano
				and #CPanalisis5#.CPNAPDtipoMov = CPNAPDtipoMov 
				and CPCmes <= 11),0),
	Monto12 = isnull((select sum(Monto) 
				from #CPanalisis3# 
				where #CPanalisis5#.CPformato = CPformato
				and #CPanalisis5#.CPCano = CPCano
				and #CPanalisis5#.CPNAPDtipoMov = CPNAPDtipoMov 
				and CPCmes <= 12),0),
	CP12 = isnull((select sum(ControlPresupuesto) 
				from #CPanalisis3# 
				where #CPanalisis5#.CPformato = CPformato
				and #CPanalisis5#.CPCano = CPCano
				and #CPanalisis5#.CPNAPDtipoMov = CPNAPDtipoMov 
				and CPCmes <= 12),0)

select distinct(CPformato), CPCano, CPNAPDtipoMov, Monto1, CP1, Monto2, CP2, Monto3, CP3, Monto4, CP4, Monto5, CP5, Monto6, CP6, Monto7, CP7, Monto8, CP8, Monto9, CP9, Monto10, CP10, Monto11, CP11, Monto12, CP12 from #CPanalisis5#
<cfif isDefined("form.soloDiferencias") AND  #form.soloDiferencias# EQ "1">
	where (Monto1 != CP1 OR Monto2 != CP2 OR Monto3 != CP3 OR Monto4 != CP4 OR Monto5 != CP5 OR Monto6 != CP6
	OR Monto7 != CP7 OR Monto8 != CP8 OR Monto9 != CP9 OR Monto10 != CP10 OR Monto11 != CP11 OR Monto12 != CP12)
	and CPCmes between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.mesDesde#"> 
	and <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.mesHasta#">
</cfif>
order by CPformato
</cfquery>

<!--- QUERY PERIODOS --->
<cfquery name="rsPeriodo" datasource="#Session.DSN#">
	select CPPid, 
		   CPPtipoPeriodo, 
		   CPPfechaDesde, 
		   CPPfechaHasta, 
		   CPPfechaUltmodif, 
		   CPPestado,
				'Presupuesto ' #_Cat#
					case CPPtipoPeriodo 
					when 1 then 'Mensual' 
					when 2 then 'Bimestral' 
					when 3 then 'Trimestral' 
					when 4 then 'Cuatrimestral' 
					when 6 then 'Semestral' 
					when 12 
					then 'Anual' else '' end
					#_Cat# ' de ' #_Cat# 
						case {fn month(CPPfechaDesde)} 
						when 1 then 'Enero' 
						when 2 then 'Febrero' 
						when 3 then 'Marzo' 
						when 4 then 'Abril' 
						when 5 then 'Mayo' 
						when 6 then 'Junio' 
						when 7 then 'Julio' 
						when 8 then 'Agosto' 
						when 9 then 'Setiembre' 
						when 10 then 'Octubre' 
						when 11 then 'Noviembre' 
						when 12 then 'Diciembre' else '' end
					#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(CPPfechaDesde)}">
					#_Cat# ' a ' #_Cat# 
						case {fn month(CPPfechaHasta)} 
						when 1 then 'Enero' 
						when 2 then 'Febrero' 
						when 3 then 'Marzo' 
						when 4 then 'Abril' 
						when 5 then 'Mayo' 
						when 6 then 'Junio' 
						when 7 then 'Julio' 
						when 8 then 'Agosto' 
						when 9 then 'Setiembre' 
						when 10 then 'Octubre' 
						when 11 then 'Noviembre' 
						when 12 then 'Diciembre' else '' end
					#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(CPPfechaHasta)}">
			as CPPdescripcion
	from CPresupuestoPeriodo p
	where p.Ecodigo = #Session.Ecodigo#
	  and p.CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPPid#">
</cfquery>
<!---<cfdump var="#rsListPresVsNaps#">--->

<!--- ****************** CREACION DE REPORTE ******************--->

<cfoutput>
	<cfset sbGeneraEstilos()>
	<cfset Encabezado()>
	<cfif #rsListPresVsNaps.recordcount# GT 0>
		<cfset Creatabla()>
    <cfset titulos()>
	<cfflush interval="512">
	<cfset LvarCtaAnt = "">
	<cfloop query="rsListPresVsNaps" >
		<cfset sbCortePagina()>
		<tr>
			<td align="center" class="Datos">#rsListPresVsNaps.CPformato#</td>
			<td align="center" class="Datos">#rsListPresVsNaps.CPCano#</td>
			<td align="center" class="Datos">#rsListPresVsNaps.CPNAPDtipoMov#</td>
			<!--- ENERO --->
			<td align="right" onClick="redirectNaps('#rsListPresVsNaps.CPformato#',#rsListPresVsNaps.CPCano#, '#rsListPresVsNaps.CPNAPDtipoMov#', 1)" class="Datos" <cfif #rsListPresVsNaps.Monto1# NEQ #rsListPresVsNaps.CP1# >style="color:red; cursor: pointer;"<cfelse>style="cursor: pointer;"</cfif>>#LSNumberFormat(rsListPresVsNaps.Monto1,',9.00')#</td>

			<td align="right" class="Datos" onClick="redirectPresupuesto('#rsListPresVsNaps.CPformato#',#rsListPresVsNaps.CPCano#, '#rsListPresVsNaps.CPNAPDtipoMov#', 1, #form.CPPid#)" <cfif #rsListPresVsNaps.Monto1# NEQ #rsListPresVsNaps.CP1# >style="color:red; cursor: pointer;"<cfelse>style="cursor: pointer;"</cfif>>#LSNumberFormat(rsListPresVsNaps.CP1,',9.00')#</td>


			<!--- FEBRERO --->
			<td align="right" onClick="redirectNaps('#rsListPresVsNaps.CPformato#',#rsListPresVsNaps.CPCano#, '#rsListPresVsNaps.CPNAPDtipoMov#', 2)" class="Datos" <cfif #rsListPresVsNaps.Monto2# NEQ #rsListPresVsNaps.CP2# >style="color:red; cursor: pointer;"<cfelse>style="cursor: pointer;"</cfif>>#LSNumberFormat(rsListPresVsNaps.Monto2,',9.00')#</td>

			<td align="right" class="Datos" onClick="redirectPresupuesto('#rsListPresVsNaps.CPformato#',#rsListPresVsNaps.CPCano#, '#rsListPresVsNaps.CPNAPDtipoMov#', 2, #form.CPPid#)" <cfif #rsListPresVsNaps.Monto2# NEQ #rsListPresVsNaps.CP2# >style="color:red; cursor: pointer;"<cfelse>style="cursor: pointer;"</cfif>>#LSNumberFormat(rsListPresVsNaps.CP2,',9.00')#</td>


			<!--- MARZO --->
			<td align="right" class="Datos" onClick="redirectNaps('#rsListPresVsNaps.CPformato#',#rsListPresVsNaps.CPCano#, '#rsListPresVsNaps.CPNAPDtipoMov#', 3)" <cfif #rsListPresVsNaps.Monto3# NEQ #rsListPresVsNaps.CP3# >style="color:red; cursor: pointer;"<cfelse>style="cursor: pointer;"</cfif>>#LSNumberFormat(rsListPresVsNaps.Monto3,',9.00')#</td>

			<td align="right" class="Datos" onClick="redirectPresupuesto('#rsListPresVsNaps.CPformato#',#rsListPresVsNaps.CPCano#, '#rsListPresVsNaps.CPNAPDtipoMov#', 3, #form.CPPid#)" <cfif #rsListPresVsNaps.Monto3# NEQ #rsListPresVsNaps.CP3# >style="color:red; cursor: pointer;"<cfelse>style="cursor: pointer;"</cfif>>#LSNumberFormat(rsListPresVsNaps.CP3,',9.00')#</td>

			<!--- ABRIL --->
			<td align="right" class="Datos" onClick="redirectNaps('#rsListPresVsNaps.CPformato#',#rsListPresVsNaps.CPCano#, '#rsListPresVsNaps.CPNAPDtipoMov#', 4)" <cfif #rsListPresVsNaps.Monto4# NEQ #rsListPresVsNaps.CP4# >style="color:red; cursor: pointer;"<cfelse>style="cursor: pointer;"</cfif>>#LSNumberFormat(rsListPresVsNaps.Monto4,',9.00')#</td>

			<td align="right" class="Datos" onClick="redirectPresupuesto('#rsListPresVsNaps.CPformato#',#rsListPresVsNaps.CPCano#, '#rsListPresVsNaps.CPNAPDtipoMov#', 4, #form.CPPid#)" <cfif #rsListPresVsNaps.Monto4# NEQ #rsListPresVsNaps.CP4# >style="color:red; cursor: pointer;"<cfelse>style="cursor: pointer;"</cfif>>#LSNumberFormat(rsListPresVsNaps.CP4,',9.00')#</td>
			

			<!--- MAYO --->
			<td align="right" class="Datos" onClick="redirectNaps('#rsListPresVsNaps.CPformato#',#rsListPresVsNaps.CPCano#, '#rsListPresVsNaps.CPNAPDtipoMov#', 5)" <cfif #rsListPresVsNaps.Monto5# NEQ #rsListPresVsNaps.CP5# >style="color:red; cursor: pointer;"<cfelse>style="cursor: pointer;"</cfif>>#LSNumberFormat(rsListPresVsNaps.Monto5,',9.00')#</td>

			<td align="right" class="Datos" onClick="redirectPresupuesto('#rsListPresVsNaps.CPformato#',#rsListPresVsNaps.CPCano#, '#rsListPresVsNaps.CPNAPDtipoMov#', 5, #form.CPPid#)" <cfif #rsListPresVsNaps.Monto5# NEQ #rsListPresVsNaps.CP5# >style="color:red; cursor: pointer;"<cfelse>style="cursor: pointer;"</cfif>>#LSNumberFormat(rsListPresVsNaps.CP5,',9.00')#</td>
			
			<!--- JUNIO --->
			<td align="right" class="Datos" onClick="redirectNaps('#rsListPresVsNaps.CPformato#',#rsListPresVsNaps.CPCano#, '#rsListPresVsNaps.CPNAPDtipoMov#', 6)" <cfif #rsListPresVsNaps.Monto6# NEQ #rsListPresVsNaps.CP6# >style="color:red; cursor: pointer;"<cfelse>style="cursor: pointer;"</cfif>>#LSNumberFormat(rsListPresVsNaps.Monto6,',9.00')#</td>

			<td align="right" class="Datos" onClick="redirectPresupuesto('#rsListPresVsNaps.CPformato#',#rsListPresVsNaps.CPCano#, '#rsListPresVsNaps.CPNAPDtipoMov#', 6, #form.CPPid#)" <cfif #rsListPresVsNaps.Monto6# NEQ #rsListPresVsNaps.CP6# >style="color:red; cursor: pointer;"<cfelse>style="cursor: pointer;"</cfif>>#LSNumberFormat(rsListPresVsNaps.CP6,',9.00')#</td>
			

			<!--- JULIO --->
			<td align="right" class="Datos" onClick="redirectNaps('#rsListPresVsNaps.CPformato#',#rsListPresVsNaps.CPCano#, '#rsListPresVsNaps.CPNAPDtipoMov#', 7)" <cfif #rsListPresVsNaps.Monto7# NEQ #rsListPresVsNaps.CP7# >style="color:red; cursor: pointer;"<cfelse>style="cursor: pointer;"</cfif>>#LSNumberFormat(rsListPresVsNaps.Monto7,',9.00')#</td>

			<td align="right" class="Datos" onClick="redirectPresupuesto('#rsListPresVsNaps.CPformato#',#rsListPresVsNaps.CPCano#, '#rsListPresVsNaps.CPNAPDtipoMov#', 7, #form.CPPid#)" <cfif #rsListPresVsNaps.Monto7# NEQ #rsListPresVsNaps.CP7# >style="color:red; cursor: pointer;"<cfelse>style="cursor: pointer;"</cfif>>#LSNumberFormat(rsListPresVsNaps.CP7,',9.00')#</td>
			

			<!--- AGOSTO --->
			<td align="right" class="Datos" onClick="redirectNaps('#rsListPresVsNaps.CPformato#',#rsListPresVsNaps.CPCano#, '#rsListPresVsNaps.CPNAPDtipoMov#', 8)" <cfif #rsListPresVsNaps.Monto8# NEQ #rsListPresVsNaps.CP8# >style="color:red; cursor: pointer;"<cfelse>style="cursor: pointer;"</cfif>>#LSNumberFormat(rsListPresVsNaps.Monto8,',9.00')#</td>

			<td align="right" class="Datos" onClick="redirectPresupuesto('#rsListPresVsNaps.CPformato#',#rsListPresVsNaps.CPCano#, '#rsListPresVsNaps.CPNAPDtipoMov#', 8, #form.CPPid#)" <cfif #rsListPresVsNaps.Monto8# NEQ #rsListPresVsNaps.CP8# >style="color:red; cursor: pointer;"<cfelse>style="cursor: pointer;"</cfif>>#LSNumberFormat(rsListPresVsNaps.CP8,',9.00')#</td>
			

			<!--- SEPTIEMBRE --->
			<td align="right" class="Datos" onClick="redirectNaps('#rsListPresVsNaps.CPformato#',#rsListPresVsNaps.CPCano#, '#rsListPresVsNaps.CPNAPDtipoMov#', 9)" <cfif #rsListPresVsNaps.Monto9# NEQ #rsListPresVsNaps.CP9# >style="color:red; cursor: pointer;"<cfelse>style="cursor: pointer;"</cfif>>#LSNumberFormat(rsListPresVsNaps.Monto9,',9.00')#</td>

			<td align="right" class="Datos" onClick="redirectPresupuesto('#rsListPresVsNaps.CPformato#',#rsListPresVsNaps.CPCano#, '#rsListPresVsNaps.CPNAPDtipoMov#', 9, #form.CPPid#)" <cfif #rsListPresVsNaps.Monto9# NEQ #rsListPresVsNaps.CP9# >style="color:red; cursor: pointer;"<cfelse>style="cursor: pointer;"</cfif>>#LSNumberFormat(rsListPresVsNaps.CP9,',9.00')#</td>
			

			<!--- OCTUBRE --->
			<td align="right" class="Datos" onClick="redirectNaps('#rsListPresVsNaps.CPformato#',#rsListPresVsNaps.CPCano#, '#rsListPresVsNaps.CPNAPDtipoMov#', 10)" <cfif #rsListPresVsNaps.Monto10# NEQ #rsListPresVsNaps.CP10# >style="color:red; cursor: pointer;"<cfelse>style="cursor: pointer;"</cfif>>#LSNumberFormat(rsListPresVsNaps.Monto10,',9.00')#</td>

			<td align="right" class="Datos" onClick="redirectPresupuesto('#rsListPresVsNaps.CPformato#',#rsListPresVsNaps.CPCano#, '#rsListPresVsNaps.CPNAPDtipoMov#', 10, #form.CPPid#)" <cfif #rsListPresVsNaps.Monto10# NEQ #rsListPresVsNaps.CP10# >style="color:red; cursor: pointer;"<cfelse>style="cursor: pointer;"</cfif>>#LSNumberFormat(rsListPresVsNaps.CP10,',9.00')#</td>
			

			<!--- NOVIEMBRE --->
			<td align="right" class="Datos" onClick="redirectNaps('#rsListPresVsNaps.CPformato#',#rsListPresVsNaps.CPCano#, '#rsListPresVsNaps.CPNAPDtipoMov#', 11)" <cfif #rsListPresVsNaps.Monto11# NEQ #rsListPresVsNaps.CP11# >style="color:red; cursor: pointer;"<cfelse>style="cursor: pointer;"</cfif>>#LSNumberFormat(rsListPresVsNaps.Monto11,',9.00')#</td>

			<td align="right" class="Datos" onClick="redirectPresupuesto('#rsListPresVsNaps.CPformato#',#rsListPresVsNaps.CPCano#, '#rsListPresVsNaps.CPNAPDtipoMov#', 11, #form.CPPid#)" <cfif #rsListPresVsNaps.Monto11# NEQ #rsListPresVsNaps.CP11# >style="color:red; cursor: pointer;"<cfelse>style="cursor: pointer;"</cfif>>#LSNumberFormat(rsListPresVsNaps.CP11,',9.00')#</td>


			<!--- DICIEMBRE --->
			<td align="right" class="Datos" onClick="redirectNaps('#rsListPresVsNaps.CPformato#',#rsListPresVsNaps.CPCano#, '#rsListPresVsNaps.CPNAPDtipoMov#', 12)" <cfif #rsListPresVsNaps.Monto12# NEQ #rsListPresVsNaps.CP12# >style="color:red; cursor: pointer;"<cfelse>style="cursor: pointer;"</cfif>>#LSNumberFormat(rsListPresVsNaps.Monto12,',9.00')#</td>

			<td align="right" class="Datos" onClick="redirectPresupuesto('#rsListPresVsNaps.CPformato#',#rsListPresVsNaps.CPCano#, '#rsListPresVsNaps.CPNAPDtipoMov#', 12, #form.CPPid#)" <cfif #rsListPresVsNaps.Monto12# NEQ #rsListPresVsNaps.CP12# >style="color:red; cursor: pointer;"<cfelse>style="cursor: pointer;"</cfif>>#LSNumberFormat(rsListPresVsNaps.CP12,',9.00')#</td>

		</tr>
	</cfloop>
	<cfset Cierratabla()>
	</body>
	</html>
	</cfif>
	<cfif #rsListPresVsNaps.recordcount# EQ 0>
		<br><br><br>
		<div align="center" style="font-size:15px">-- No existe informaci&oacute;n que coincida con los filtros proporcionados --</div>
		<div align="center" style="font-size:15px">-- Haga clic en el bot&oacute;n <strong>Regresar</strong> y modifique los filtros --</div>
		<br>
	</cfif>
</cfoutput>



<!--- ****************** FUNCION TITULOS ******************--->
<cffunction name="titulos" output="true">
	<tr>
		<td align="center" class="ColHeader" colspan="3"></td>
		<td align="center" class="ColHeader" colspan="2">Enero</td>
		<td align="center" class="ColHeader" colspan="2">Febrero</td>
		<td align="center" class="ColHeader" colspan="2">Marzo</td>
		<td align="center" class="ColHeader" colspan="2">Abril</td>
		<td align="center" class="ColHeader" colspan="2">Mayo</td>
		<td align="center" class="ColHeader" colspan="2">Junio</td>
		<td align="center" class="ColHeader" colspan="2">Julio</td>
		<td align="center" class="ColHeader" colspan="2">Agosto</td>
		<td align="center" class="ColHeader" colspan="2">Septiembre</td>
		<td align="center" class="ColHeader" colspan="2">Octubre</td>
		<td align="center" class="ColHeader" colspan="2">Noviembre</td>
		<td align="center" class="ColHeader" colspan="2">Diciembre</td>
	</tr>
	<tr>
		<td align="center" class="ColHeader">Cuenta</td>
		<td align="center" class="ColHeader">A&ntilde;o</td>
		<td align="center" class="ColHeader">CPNAPDtipoMov</td>
		<td align="center" class="ColHeader">SaldoNap</td>
		<td align="center" class="ColHeader">Presupuesto</td>
		<td align="center" class="ColHeader">SaldoNap</td>
		<td align="center" class="ColHeader">Presupuesto</td>
		<td align="center" class="ColHeader">SaldoNap</td>
		<td align="center" class="ColHeader">Presupuesto</td>
		<td align="center" class="ColHeader">SaldoNap</td>
		<td align="center" class="ColHeader">Presupuesto</td>
		<td align="center" class="ColHeader">SaldoNap</td>
		<td align="center" class="ColHeader">Presupuesto</td>
		<td align="center" class="ColHeader">SaldoNap</td>
		<td align="center" class="ColHeader">Presupuesto</td>
		<td align="center" class="ColHeader">SaldoNap</td>
		<td align="center" class="ColHeader">Presupuesto</td>
		<td align="center" class="ColHeader">SaldoNap</td>
		<td align="center" class="ColHeader">Presupuesto</td>
		<td align="center" class="ColHeader">SaldoNap</td>
		<td align="center" class="ColHeader">Presupuesto</td>
		<td align="center" class="ColHeader">SaldoNap</td>
		<td align="center" class="ColHeader">Presupuesto</td>
		<td align="center" class="ColHeader">SaldoNap</td>
		<td align="center" class="ColHeader">Presupuesto</td>
		<td align="center" class="ColHeader">SaldoNap</td>
		<td align="center" class="ColHeader">Presupuesto</td>
	</tr>
</cffunction>

<cffunction name="sbGeneraEstilos" output="true">
	<style type="text/css">
		H1.Corte_Pagina
		{
		PAGE-BREAK-AFTER: always
		}
		
		.ColHeader 
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		9px;
			font-weight: 	bold;
			padding-left: 	0px;
			border:		1px solid ##CCCCCC;
			background-color:##CCCCCC
		}
	
		.Header 
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		12px;
			font-weight: 	bold;
			padding-left: 	0px;
			text-align:	center;
		}
	
		.Header1 
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		14px;
			font-weight: 	bold;
			padding-left: 	0px;
		}
	
		.Corte1 
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		12px;
			font-weight: 	bold;
			padding-left: 	0px;
		}
	
	
		.Datos 
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		10px;
			font-weight: 	none;
			white-space:nowrap;
		}
	
		body
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		11px;
		}
	</style>
</cffunction>
<!--- ****************** FUNCION ENCABEZADO ******************--->
<cffunction name="Encabezado" output="true">
	<table width="100%" border="0">
		<tr>
			<td  class="Header1" colspan="27" align="center">
				<strong>#ucase(session.Enombre)#</strong>
			</td>
		</tr>
		<tr>
			<td  class="Header1" colspan="27" align="center"><strong>CONCILIACI&Oacute;N NAPS VS SALDOS</strong></td>
		</tr>
		<tr>
			<td class="Header" colspan="27" align="center"><strong>#ucase(rsPeriodo.CPPDESCRIPCION)#</strong></td>
		</tr>
		<cfif isDefined("form.CtaPres") AND  #form.CtaPres# NEQ "">
			<tr>
			<td class="Header" colspan="27" align="center">
				<strong>CUENTA: #form.CtaPres#</strong>
			</td>
			</tr>
		</cfif>
		<cfif isDefined("form.mesDesde") AND  #form.mesDesde# NEQ ""
		  AND isDefined("form.mesHasta") AND  #form.mesHasta# NEQ "">
			<tr>
			<td class="Header" colspan="27" align="center">
				<cfif #form.mesDesde# EQ #form.mesHasta#>
		  			<strong>MES: #LvarMeses[form.mesDesde]#</strong>
		  			<cfelse>
		  				<strong>PERIODO DE MESES: #LvarMeses[form.mesDesde]# - #LvarMeses[form.mesHasta]#</strong>
		  		</cfif>
				
			</td>
			</tr>
		</cfif>
		<cfif isDefined("form.soloDiferencias") AND  #form.soloDiferencias# EQ "1">
			<tr>
			<td class="Header" colspan="27" align="center">
				<strong>SE MUESTRAN SOLO DIFERENCIAS</strong>
			</td>
			</tr>
		</cfif>
		<tr><td>&nbsp;</td></tr>
	</table>
</cffunction>
<!--- ************************************************************* --->
<!--- ************************************************************* --->
<cffunction name="Creatabla" output="true">
	<table width="100%" border="0">
</cffunction>


<!--- ****************** FUNCION CIERRE TABLA ******************--->
<cffunction name="Cierratabla" output="true">
	</table>
</cffunction>


<!--- ****************** FUNCION CORTE ******************--->
<cffunction name="sbCortePagina" output="true">
	<cfif isdefined("LvarNoCortes")>
		<cfreturn>
	</cfif>
	<cfif LvarContL GTE LvarLineasPagina>
		<tr><td><H1 class=Corte_Pagina></H1></td></tr>
		<cfset Cierratabla()>
		<cfset LvarPAg   = LvarPAg + 1>
		<cfset LvarContL = 5> 
		<cfset Encabezado()>
		<cfset Creatabla()>
		<cfset titulos()>
	</cfif>
	<cfset LvarContL = LvarContL + 1>  
</cffunction>

<script type="text/javascript">
var pantDetSaldoNap
var pantDetPresupuesto
	function redirectNaps(CPformato, CPCano, CPNAPDtipoMov, CPCmes)
	{	
		// conf. de opciones para pantalla nueva
		var opciones="Scrollbars=YES,Titlebar=NO,,location=no,width=700,height=550,top=80,left=300";
		// conf. de parametros
		var paramsUrl = "?CPformato=" + CPformato.trim() + "&CPCano=" + CPCano + "&CPNAPDtipoMov=" + CPNAPDtipoMov.trim() +
						"&CPCmes=" + CPCmes
		//cierra ventana abierta
		closeWindows(pantDetSaldoNap);
		// abre ventana
		pantDetSaldoNap = window.open("rptConciliacion-detSaldoNap.cfm" + paramsUrl,"",opciones);
	}

	function redirectPresupuesto(CPformato, CPCano, CPNAPDtipoMov, CPCmes, CPPid){
		// alert(CPPid)
		// conf. de opciones para pantalla nueva
		var opciones="Scrollbars=YES,Titlebar=NO,,location=no,width=700,height=600,top=60,left=300";
		// conf. de parametros
		var paramsUrl = "?CPformato=" + CPformato.trim() + "&CPCano=" + CPCano + "&CPNAPDtipoMov=" + CPNAPDtipoMov.trim() +
						"&CPCmes=" + CPCmes + "&CPPid=" + CPPid
		closeWindows(pantDetPresupuesto);
		pantDetPresupuesto = window.open("rptConciliacion-detPresupuesto.cfm" + paramsUrl,"",opciones);
	}

	function closeWindows(objWindow){
		if(!objWindow){
			//no es declarada como ventana
		}else{
			if (!objWindow.closed) {
              objWindow.close();
          }
		}
	}
</script>


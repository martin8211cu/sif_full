

<cfif isdefined("url.CFid") and not isdefined("form.CFid")>
	<cfparam name="form.CFid" default="#url.CFid#">
</cfif>
<cfif isdefined("url.dependencias") and not isdefined("form.dependencias")>
	<cfparam name="form.dependencias" default="#url.dependencias#">
</cfif>
<cfif isdefined("url.periodo") and not isdefined("form.periodo")>
	<cfparam name="form.periodo" default="#url.periodo#">
</cfif>
<cfif isdefined("url.mes") and not isdefined("form.mes")>
	<cfparam name="form.mes" default="#url.mes#">
</cfif>
<cfif isdefined("url.nivel_resumen") and not isdefined("form.nivel_resumen")>
	<cfparam name="form.nivel_resumen" default="#url.nivel_resumen#">
</cfif>
<cfif isdefined("url.nivel_totalizar") and not isdefined("form.nivel_totalizar")>
	<cfparam name="form.nivel_totalizar" default="#url.nivel_totalizar#">
</cfif>
<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<cfquery name="cfuncional" datasource="#session.DSN#">
	select 
    	cf.CFdescripcion, 
        d.Ddescripcion, 
        o.Odescripcion
	from CFuncional cf
        inner join Departamentos d
          on d.Dcodigo = cf.Dcodigo
         and d.Ecodigo = cf.Ecodigo
        inner join Oficinas o
          on o.Ocodigo = cf.Ocodigo
         and o.Ecodigo = cf.Ecodigo
	where cf.Ecodigo = #session.Ecodigo#
	and cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
</cfquery>


<cf_templatecss>
<cfoutput>
<table width="99%" align="center" cellpadding="0" cellspacing="0">
	<tr align="center"><td align="center"><font size="4" face="Verdana, Arial, Helvetica, sans-serif"><strong>#session.Enombre#</strong></font></td></tr>
	<tr align="center"><td align="center"><font size="4" face="Verdana, Arial, Helvetica, sans-serif"><strong><cf_translate key=LB_DetalleG>Detalle de Gastos</cf_translate></strong></font></td></tr>
	<tr align="center"><td align="center"><font size="3" face="Times New Roman, Times, serif"><strong><cf_translate key=LB_Departamento>Departamento</cf_translate>: #cfuncional.CFdescripcion#</strong></font></td></tr>
	<cfif isdefined("form.dependencias")>
		<tr align="center"><td align="center"><font size="3" face="Times New Roman, Times, serif"><strong><cf_translate key=LB_Sucursal>Sucursal</cf_translate>: <cf_translate key=LB_Consolidado>Consolidado</cf_translate></strong></font></td></tr>	
	<cfelse>
		<tr align="center"><td align="center"><font size="3" face="Times New Roman, Times, serif"><strong><cf_translate key=LB_Sucursal>Sucursal</cf_translate>: #cfuncional.Odescripcion#</strong></font></td></tr>	
	</cfif>	
	<tr align="center"><td align="center"><font size="3" face="Times New Roman, Times, serif"><strong><cf_translate key=LB_Periodo>Periodo</cf_translate>: #form.mes#/#form.Periodo#</strong></font></td></tr>
</table>
</cfoutput>

<cf_dbtemp name="reporte" returnvariable="reporte" datasource="#session.DSN#">
    <cf_dbtempcol name="CFid"    	type="numeric"      mandatory="yes">
    <cf_dbtempcol name="Ccuenta"    type="numeric"      mandatory="yes">
    <cf_dbtempcol name="Ecodigo"    type="int"          mandatory="yes">
    <cf_dbtempcol name="Ocodigo"    type="int"     		mandatory="yes">
    <cf_dbtempcol name="Speriodo"   type="int"  		mandatory="yes">
    <cf_dbtempcol name="Smes"    	type="int"        	mandatory="yes">
    <cf_dbtempcol name="PCDcatids"  type="numeric"      mandatory="no">
    <cf_dbtempcol name="PCDcatidt"  type="numeric"  	mandatory="no">
    <cf_dbtempcol name="montoaca"   type="money"   		mandatory="no">
    <cf_dbtempcol name="montomes"   type="money"        mandatory="no">
    <cf_dbtempcol name="montoact"   type="money"        mandatory="no">
    <cf_dbtempcol name="subtotaca"  type="money"        mandatory="no">
    <cf_dbtempcol name="subtotmes"  type="money"      	mandatory="no">
    <cf_dbtempcol name="subtotact"  type="money"      	mandatory="no">
    <cf_dbtempcol name="totalaca"   type="money"        mandatory="no">
    <cf_dbtempcol name="totalmes"   type="money"        mandatory="no">
    <cf_dbtempcol name="totalact"   type="money" 		mandatory="no">
</cf_dbtemp>


<cfset LvarMascaraCuenta = ''>

<cfobject component="sif.Componentes.AplicarMascara" name="mascara">

<!--- 2. insertar el padre --->
<cfquery name="CentroFuncional" datasource="#session.DSN#">
		select cf.CFid, cf.CFcuentac
		from CFuncional cf
		where cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
</cfquery>

<cfif len(trim(CentroFuncional.CFcuentac)) EQ 0>
	<cfset LvarMascaraCuenta = '' >
<cfelse>
	<cfset LvarMascaraCuenta = mascara.AplicarMascara(CentroFuncional.CFcuentac, '_', '?')>
	<cfquery datasource="#session.DSN#">
		insert into #reporte# (
			CFid, Ccuenta, Ecodigo, Ocodigo, Speriodo, Smes, 
			montoaca, montomes, montoact, subtotaca, subtotmes, subtotact, totalaca, totalmes, totalact)
		select
			cf.CFid, c.Ccuenta, cf.Ecodigo, cf.Ocodigo, #form.periodo#, #form.mes#,
			0.00,	0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00
		from CFuncional cf, CContables c
		where cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
		  and c.Ecodigo = cf.Ecodigo
		  and c.Cformato like '#LvarMascaraCuenta#'
		  and c.Cmovimiento = 'S'
	</cfquery>
</cfif>


<!--- 3. insertar los hijos (si está el check marcado) --->
<cfif isdefined("form.dependencias")>
	<cfquery name="CentroFuncional" datasource="#session.DSN#">
		select cf.CFid, cf.CFcuentac
		from CFuncional cf1, CFuncional cf
		where cf1.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
		  and cf.Ecodigo = cf1.Ecodigo
		  and <cf_dbfunction name="like" args="cf.CFpath,cf1.CFpath #_Cat# ' % '">
		  and cf.CFid <> cf1.CFid
	</cfquery>

	<cfloop query="CentroFuncional">

		<cfif len(trim(CentroFuncional.CFcuentac)) EQ 0>
			<cfset LvarMascaraCuenta = ''>
		<cfelse>
			<cfset LvarMascaraCuenta = mascara.AplicarMascara(CentroFuncional.CFcuentac, '_', '?')>
			<cfquery datasource="#session.DSN#">
				insert into #reporte# (
					CFid, Ccuenta, Ecodigo, Ocodigo, Speriodo, Smes, PCDcatids, PCDcatidt,
					montoaca, montomes, montoact, subtotaca, subtotmes, subtotact)
				select
					cf.CFid, c.Ccuenta, cf.Ecodigo, cf.Ocodigo, #form.periodo#, #form.mes#, null, null,
					0.00,	0.00, 0.00, 0.00, 0.00, 0.00
				from CFuncional cf, CContables c
				where cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CentroFuncional.CFid#">
				  and c.Ecodigo = cf.Ecodigo
				  and c.Cformato like '#LvarMascaraCuenta#'
				  and c.Cmovimiento = 'S'
				  and not exists ( select 1
				  					from #reporte# r
									where r.Ccuenta = c.Ccuenta
									and r.Ecodigo = cf.Ecodigo
									and r.Ocodigo = cf.Ocodigo  )
			</cfquery>
		</cfif>
	</cfloop>

</cfif>

<!--- Actualizar el PCEcatid del nivel que se quiere usar para subtotal --->
<cfquery datasource="#session.DSN#">
	update #reporte#
	set PCDcatidt = coalesce((
			select min(cc.PCDcatid)
			from PCDCatalogoCuenta cc
			where cc.Ccuenta = #reporte#.Ccuenta
			  and cc.PCDCniv = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.nivel_totalizar#">  <!--- Parametro de nivel de totalizacion ---> 
			), 0)
</cfquery>

<cfquery datasource="#session.DSN#">
	update #reporte#
	set PCDcatids = coalesce((
			select min(cc.PCDcatid) 
			from PCDCatalogoCuenta cc
			where cc.Ccuenta = #reporte#.Ccuenta
			  and cc.PCDCniv = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.nivel_resumen#"> <!--- Parametro de nivel de resumen --->
			), 0)
</cfquery>

<!--- Obtener los montos de las cuentas --->
<cfquery datasource="#session.DSN#">
	update #reporte#
	set 
		montoaca = coalesce((
			select sum(sc.SLinicial)
			from SaldosContables sc
			where sc.Ccuenta  = #reporte#.Ccuenta
			  and sc.Speriodo = #reporte#.Speriodo
			  and sc.Smes     = #reporte#.Smes
			  and sc.Ocodigo  = #reporte#.Ocodigo
			  and sc.Ecodigo  = #reporte#.Ecodigo), 0.00),

		montomes = coalesce((
			select sum(sc.DLdebitos - sc.CLcreditos)
			from SaldosContables sc
			where sc.Ccuenta  = #reporte#.Ccuenta
			  and sc.Speriodo = #reporte#.Speriodo
			  and sc.Smes     = #reporte#.Smes
			  and sc.Ocodigo  = #reporte#.Ocodigo
			  and sc.Ecodigo  = #reporte#.Ecodigo), 0.00)
</cfquery>

<cfquery datasource="#session.DSN#">
	update #reporte#
	set montoact = montoaca + montomes
</cfquery>

<!--- Subtotales --->
<cfquery datasource="#session.DSN#">
	update #reporte#
	set subtotaca = ((
		select sum(montoaca) 
		from #reporte# r1 
		where r1.PCDcatids = #reporte#.PCDcatids))
</cfquery>
 
<cfquery datasource="#session.DSN#">
	update #reporte#
	set subtotmes = ((
		select sum(montomes) 
		from #reporte# r1 
		where r1.PCDcatids = #reporte#.PCDcatids))
</cfquery>

<cfquery datasource="#session.DSN#">
	update #reporte#
	set subtotact = subtotaca + subtotmes
</cfquery>

<!--- totales --->
<cfquery datasource="#session.DSN#">
	update #reporte#
	set totalaca = ((
		select sum(montoaca) 
		from #reporte# r1 
		where r1.PCDcatidt = #reporte#.PCDcatidt))
</cfquery>
 
<cfquery datasource="#session.DSN#">
	update #reporte#
	set totalmes = ((
		select sum(montomes) 
		from #reporte# r1 
		where r1.PCDcatidt = #reporte#.PCDcatidt))
</cfquery>

<cfquery datasource="#session.DSN#">
	update #reporte#
	set totalact = totalaca + totalmes
</cfquery>
<!--- <cfquery datasource="#session.DSN#" name="verReporte">
	select * from #reporte#

</cfquery>

<cf_dump var="#verReporte#"> --->

<!--- Query final --->
<cfquery datasource="#session.DSN#" name="datos">
	select 
		n0.PCEcodigo,
		n0.PCEdescripcion,
		n1.PCDvalor as Grupo, 
		n1.PCDdescripcion as DescripGrupo,
		n2.PCDvalor as Rubro,
		n2.PCDdescripcion as DescripRubro,
		sum(r.montoaca) as MontoAcumAnterior,
		sum(r.montomes) as MontoMes,
		sum(r.montoact) as MontoActual,
		coalesce(sum(p.SPinicial), 0.00) as PresInicial,
		coalesce(sum(p.MLmonto), 0.00)   as PresMes,
		coalesce(sum(p.SPfinal), 0.00)   as PresFinal,
		sum(r.montoaca) - coalesce(sum(p.SPinicial), 0.00) as DifInicial,
		sum(r.montomes) - coalesce(sum(p.MLmonto), 0.00) as DifMes,
		sum(r.montoact) - coalesce(sum(p.SPfinal), 0.00) as DifFinal
	from #reporte# r
		inner join PCDCatalogo n2
			on n2.PCDcatid = r.PCDcatids
		inner join PCDCatalogo n1
			on n1.PCDcatid = r.PCDcatidt
			inner join PCECatalogo n0
				on n0.PCEcatid = n1.PCEcatid
		left outer join SaldosContablesP p
			 on p.Ccuenta  = r.Ccuenta
			and p.Speriodo = r.Speriodo
			and p.Smes     = r.Smes
			and p.Ecodigo  = r.Ecodigo
			and p.Ocodigo  = r.Ocodigo
	group by 
		n0.PCEcodigo, 
		n0.PCEdescripcion, 
		n1.PCDvalor, 
		n1.PCDdescripcion, 
		n2.PCDvalor, 
		n2.PCDdescripcion
	
	order by 1, 3, 5
</cfquery>

<cfif datos.recordcount gt 3000>
	<cfinclude template="gastos-formInc.cfm">
<cfelse>
	<cf_sifHtml2Word>
		<cfinclude template="gastos-formInc.cfm">
	</cf_sifHtml2Word>
</cfif>
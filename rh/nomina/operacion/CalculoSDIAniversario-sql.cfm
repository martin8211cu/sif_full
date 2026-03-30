<!--- OPARRALES
	Fecha: 2017-08-02
	Descripcion: Se realiza calculo de SDI por motivo de aniversario generando historico
	para que se pueda generar reporte IDSE, de igual forma generamos el
	historico de calculo de SDI
	--->
<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#"
	ecodigo="#session.Ecodigo#" pvalor="80" default="0" returnvariable="FactorDiasMensual"/>
<cfif FactorDiasMensual eq 0>
	<cfthrow message="Parametro no definido: Cantidad de d&iacute;as para C&aacute;lculo de N&oacute;mina Mensual">
</cfif>
<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#"
	ecodigo="#session.Ecodigo#" pvalor="2051" default="0" returnvariable="varUMA"/>
<cfif varUMA eq 0>
	<cfthrow message="Parametro no definido: Valor de la Unidad de Medida y Actualizaci&oacute;n (UMA)">
</cfif>
<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#"
	ecodigo="#session.Ecodigo#" pvalor="2052" default="0" returnvariable="varDiasAguinaldo"/>
<cfif varDiasAguinaldo eq 0>
	<cfthrow message="Parametro no definido: D&iacute;as aguinaldo para c&aacute;lculo de Factor de Integraci&oacute;n">
</cfif>
<!---
	Extraemos el ultimo registro de alta por empleado
	y que cumplan aniversario en la semana de calculo.
	52.28571 es equivalente a la divicion de dias de un a�o bisiesto entre 7
	Es el valor estandar de semanas por a�o y se dejo a 5 decimales para mayor presicion.
	Correccion:
	Valida que la diferencia en semanas entre la fecha de vigencia de Nombramiento
	y su fecha de aniversario sea igual a la diferencia en semanas entre la fecha
	de vigencia y la semana a validar.
	Ejemplo:
	Fecha Vigencia Nombramiento = 2010-05-26
	Fecha de Aniversario 		  = 2017-05-26
	Diferencia en semanas		  = 365 Semanas
	Fecha Vigencia Nombramiento = 2010-05-26
	Fecha de Calculo 			  = variable #today# (2017-05-15)
	Diferencia en semanas		  = 364 Semanas
	Resultado					  = Aun no cumple... le falta un semana.
	--->
<cfset today = LSDateFormat(DateAdd("ww",-1,now()),'YYYY-MM-dd')>
<!--- Semana  vencida (anterior). --->
<cfquery name="rsEmpleados" datasource="#session.dsn#">
	SELECT dle.DEid, max(dle.DLfvigencia) as DLfvigencia, dle.RVid,
		bj.cnom, bj.cbaja
	FROM DLaboralesEmpleado dle
	inner join  RHTipoAccion rta on dle.RHTid = rta.RHTid
	inner join (
		select 
			sum(case when rtb.RHTcomportam=1  then 1 else 0 end ) cnom,
			sum(case when rtb.RHTcomportam=2  then 1 else 0 end ) cbaja,
			a.DEid
		from DLaboralesEmpleado a 
		inner join RHTipoAccion rtb
			on a.RHTid = rtb.RHTid AND rtb.RHTcomportam in (1 ,2)
		group by a.DEid
	) bj on dle.DEid = bj.DEid
	WHERE  rta.RHTcomportam = 1 
	and DATEDIFF(year,dle.DLfvigencia,<cfqueryparam cfsqltype="cf_sql_date" value="#today#">) > 0
	and (DATEDIFF(month,dle.DLfvigencia,<cfqueryparam cfsqltype="cf_sql_date" value="#today#">) % 12) = 0
	and DATEDiff(week,dle.DLfvigencia,(CAST(CAST(DatePart(year,<cfqueryparam cfsqltype="cf_sql_date" value="#today#">) AS varchar)
										+ '-' + CAST(DatePart(month,dle.DLfvigencia) AS varchar)
										+ '-' + CAST(DATEPART(day,dle.DLfvigencia) AS varchar) AS DATETIME)))
		= DateDiff(week,dle.DLfvigencia,<cfqueryparam cfsqltype="cf_sql_date" value="#today#">)
	<!--- AND (Round(((DATEDIFF(week,dle.DLfvigencia,'2017-05-22')) % 52),2) / 52) = 0 --->
	group by dle.DEid,dle.RVid, bj.cnom, bj.cbaja
 	having bj.cnom > bj.cbaja
</cfquery>

<cfloop query="rsEmpleados">
	<cfquery name="rsExiste" datasource="#session.dsn#">
		select
			*
		from
				RHHistoricoSDI b
		where
			datepart(week,RHHfecha) = datepart(week,<cfqueryparam cfsqltype="cf_sql_date" value="#today#">)
		and b.DEid = #DEid#
		and b.RHHfuente = 3
	</cfquery>
	<cfif rsExiste.RecordCount gt 0>
		<cfcontinue>
	</cfif>
	<cfset ultimoDiaSem = DateAdd('d',-1,now())>
	<cfset yearTmp = (DateDiff('yyyy', DLfvigencia, today) lte 0 ? 1 : DateDiff('yyyy', DLfvigencia, ultimoDiaSem)) >
	<cfset fechaAniv = LSDateFormat(DateAdd("yyyy",yearTmp,DLfvigencia),'YYYY-MM-dd')>

	<cfquery datasource="#session.dsn#" name="rsDias">
		select
			coalesce(dv.DRVdiasgratifica,0) as DRVdiasgratifica,
			coalesce(dv.DRVdiasprima,0) as DRVdiasprima,
			dv.DRVdias
		from
			RegimenVacaciones r
			inner join 	DRegimenVacaciones dv
			on r.RVid = dv.RVid
			and dv.DRVcant =
			(select coalesce(max(DRVcant),1)
				from DRegimenVacaciones rv2
				where rv2.RVid = dv.RVid
				and rv2.DRVcant <= <cfqueryparam cfsqltype="cf_sql_integer" value="#yearTmp+1#">)
		where r.Ecodigo = #session.Ecodigo#
		and r.RVid = #rsEmpleados.RVid#
	</cfquery>
	<cfif rsDias.RecordCount eq 0>
		<cfthrow message="No existen detalles en R&eacute;gimen de Vacaciones definidos">
	</cfif>
	<!--- Obtenemos el ultimo aumento o ajuste salarial --->
	<cfquery name="rsUltimoSalario" datasource="#session.dsn#">
		select top 1
			rta.RHTdesc,
			dle.DLsalario,
			dle.DLfvigencia
		from
			DLaboralesEmpleado dle,
			RHTipoAccion rta
		where
			dle.RHTid = rta.RHTid
		AND  rta.RHTid in (select bb.RHTid from RHTipoAccion bb where bb.RHTcomportam = 6 OR bb.RHTcomportam = 8)
		AND dle.DEid = #DEid#
		order by dle.DLfvigencia desc
	</cfquery>
	<!--- Obtenemos el salario default (Accion de nombramiento) --->
	<cfquery name="rsSalario" datasource="#session.dsn#">
		select dle.DLsalario
		from DLaboralesEmpleado dle
		where dle.DLfvigencia = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DLfvigencia#">
		and DEid = #rsEmpleados.DEid#
	</cfquery>
	<cfset Salario = rsSalario.DLsalario>
	<!--- validamos que el aumento sea posterior a la ultima accion de alta definitiva --->
	<cfif rsUltimoSalario.RecordCount gt 0 and DateCompare(rsUltimoSalario.DLfvigencia,DLfvigencia,"s") eq 1>
		<cfset Salario = rsUltimoSalario.DLsalario>
	</cfif>
	<cfset pVacacional		= rsDias.DRVdiasprima>
	<cfset factorDias = ((365 + #varDiasAguinaldo# + #pVacacional#)/365)>
	<!--- Factor de Integracion --->
	<cfset objSDI = createObject("component", "rh.Componentes.RH_CalculoSDI")>
	<cfset salarioDiario = (#Salario# / #FactorDiasMensual#)>
	<cfset salarioDiario += objSDI.conceptosAdicionalesSDI(rsEmpleados.DEid,false)>
	<cfset valSDI = (#salarioDiario# * #factorDias#)>
	<!--- Valida SDI --->
	<cfset topeUMA = varUMA * 25>
	<cfif valSDI GT topeUMA>
		<cfset valSDI = #topeUMA#>
	</cfif>
	<cfquery datasource="#session.dsn#">
		update DatosEmpleado set DEsdi = #valSDI# where DEid = #rsEmpleados.DEid#
	</cfquery>
	<cfset vPeriodo = datepart('yyyy',#today#)>
	<cfset vMes		= datepart('m',#today#)>
	<!---
		RHHfuente:
		0 indefinido
		1 Automatico (Proceso interno que afecte SDI) ej. Accion de Nombramiento
		2 Manual (SDI Bimestral)
		3 SDI por Aniversario
		4 Accion de Aumento (comportamiento = 6)
		--->
	<!---Bitacora de SDI --->
	<cfinvoke component="rh.Componentes.RH_CalculoSDI_Historico" method="AddBitacoraSDI" returnvariable="AddBitacoraSDI">
		<cfinvokeargument name="DEid" 		value="#rsEmpleados.DEid#"/>
		<cfinvokeargument name="Fecha" 		value="#fechaAniv#"/>
		<cfinvokeargument name="RHHmonto" 	value="#valSDI#"/>
		<cfinvokeargument name="RHHfuente" 	value="3"/>
		<cfinvokeargument name="Periodo"	value="#vPeriodo#"/>
		<cfinvokeargument name="Mes"		value="#vMes#"/>
	</cfinvoke>
</cfloop>
<cfscript>
	WriteOutput('<script language="JavaScript">window.location = "CalculoSDIAniversario.cfm"</script>');

	</cfscript>

	


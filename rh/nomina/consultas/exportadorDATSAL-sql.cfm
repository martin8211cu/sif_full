<!-----
Cedula(9)
Código de RRHH (4)
i.	0028 Salario Devengado (Salario Base que aplica cargas)
ii.	0018 Salario Neto (Salario Líquido)
iii.0033 Salario Bruto (Salario Base + Anualidad)
iv.	6200 horas extras (diurnas, mixtas y nocturnas)
v.	3 Incapacidades (acción de incapacidad 3: Incapacidad CCSS)
vi.	111 Carrera Profesional
vi.	113 Guardias
vii.110 Dedicación Exclusiva
ix.	0088 Salario base
x.	1155 Aumento General (retroactivo)
xi.	1157 Aumento General (pago de quincena)
Monto (10) con punto decimal
Periodo (8)
------->

 
<cf_dbfunction name="op_concat" returnvariable="concat">

<cfset p=''>
<cfset RCNid=0>
<cfset Tcodigo=''>


<!----- Seteo de filtros----->
<cfif isDefined("form.tiponomina")>
	<cfset p='H'>
</cfif>
<cfif isDefined("form.tiponomina") and isDefined("form.CPid1") and len(trim(form.CPid1))>
	<cfset RCNid=form.CPid1>
</cfif>
<cfif isDefined("form.CPid2") and len(trim(form.CPid2))>
	<cfset RCNid=form.CPid2>
</cfif>

<!---- lista de nominas que cumplen con el filtro----> 
<cfquery datasource="#session.dsn#" name="rsN">
	select distinct CPid, CPhasta as Periodo
	from CalendarioPagos
	where CPid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#RCNid#" list="true">)
</cfquery>
 
<cfset RCNid=0>
<cfif len(trim(rsN.CPid))>
	<cfset RCNid=valuelist(rsN.CPid)>
</cfif>
 

<!---- validaciones de la configuración de las columnas----->
<cfquery datasource="#session.dsn#" name="rsValida">
	select x.cod as cod
	from
	(
	   select 'SalarioBruto' as cod from dual
	   union 
	   select 'HorasExtra' as cod from dual
	   union 
	   select 'Incapacidades' as cod from dual
	   union 
	   select 'CarreraProfe' as cod from dual
	   union 
	   select 'Guardias' as cod from dual
	   union 
	   select 'DedicacionExc' as cod from dual
	) x
	where x.cod not in ( select RHCRPTcodigo 
	                    from RHReportesNomina a 
	                    inner join RHColumnasReporte b
	                        on a.RHRPTNid=b.RHRPTNid
	                    inner join RHConceptosColumna c
	                    	on b.RHCRPTid=c.RHCRPTid
	                    where a.Ecodigo=#session.Ecodigo#
	                    and rtrim(ltrim(RHRPTNcodigo)) = 'DATSAL' 
	                    )
</cfquery>
<cfif len(trim(rsValida.cod))>
	<cf_errorCode code="52229" msg="Configuración requerida. Es necesario configurar las columnas para el reporte: '@codReporte@'"
		codReporte='DATSAL'
		detail="Reporte 'DATSAL': Lista de columnas: #valuelist(rsValida.cod,', ')#"
	> 	
</cfif>
   
<!----- function para obtener el string para las columnas----> 
<cffunction name="getIds" access="private" returntype="void">
	<cfargument name="col" 	 required="true" type="string">
	<cfoutput>
	select c.CIid
    from RHReportesNomina a 
    inner join RHColumnasReporte b
        on a.RHRPTNid=b.RHRPTNid
    inner join RHConceptosColumna c
    	on b.RHCRPTid=c.RHCRPTid
    where a.Ecodigo=#session.Ecodigo#
    and rtrim(ltrim(a.RHRPTNcodigo)) = 'DATSAL'
    and upper(rtrim(ltrim(b.RHCRPTcodigo))) = '#ucase(trim(arguments.col))#'
    </cfoutput> 
</cffunction>
<!----- function para el pintado en la exportacion, simplemente limita los string al tamaño indicado---->
<cffunction name="limitar">
	<cfargument name="texto" type="string">
	<cfargument name="tam" type="string">
	<cfargument name="orientacion" type="string" default="R">

	<cfif arguments.tam lte len(trim(arguments.texto))>
		<cfreturn mid(arguments.texto,1,arguments.tam)>
	<cfelse>
		<cfif arguments.orientacion eq 'R'>
			<cfreturn mid(arguments.texto,1,arguments.tam) & repeatString(" ", arguments.tam-len(trim(arguments.texto)) )>	
		<cfelse>
			<cfreturn repeatString(" ", arguments.tam-len(trim(arguments.texto)) ) & mid(arguments.texto,1,arguments.tam)>	
		</cfif>	
	</cfif>
</cffunction> 


<cf_dbtemp name="reporteDATSAL" returnvariable="t">
	<cf_dbtempcol name="DEid" type="numeric">
	<cf_dbtempcol name="cod" type="varchar(4)">
	<cf_dbtempcol name="monto" type="money">
</cf_dbtemp>
<cf_dbtemp name="reporteDATSAL_Aumentos" returnvariable="au">
	<cf_dbtempcol name="DEid" type="numeric"> 
</cf_dbtemp>
 

<!---- se concuerda buscar acciones de aumento entre las fechas
	Fecha desde: fecha  de envio del calendario de pago anterior al consultado por filtro
	Fecha Hasta: es la fecha hasta del calendario consultado

	A partir de las fechas anteriores se buscan acciones de aumento aplicadas para los empleados. Esto lega la temporal 'au'
	con los DEid de empleados que tienen aumento y deben considerarse.
---->
<cfquery datasource="#session.dsn#" >
	insert into #au# (DEid)
	select distinct de.DEid
	from #p#SalarioEmpleado se
		inner join CalendarioPagos cp
			on se.RCNid=cp.CPid
		inner join DLaboralesEmpleado de
			on se.DEid=de.DEid
		inner join RHTipoAccion rh
			on de.RHTid=rh.RHTid
			and rh.RHTcomportam = 8		
	where se.RCNid=	<cfqueryparam cfsqltype="cf_sql_numeric" value="#RCNid#">
		and de.DLfechaaplic between (
									select distinct coalesce(cp1.CPfenvio,cp1.CPhasta)
									from CalendarioPagos cp1
									where cp1.Ecodigo=cp.Ecodigo
									and cp1.Tcodigo=cp.Tcodigo
									and cp1.CPhasta = <cf_dbfunction name="dateadd" args="-1,cp.CPdesde">
									)
							and cp.CPhasta
</cfquery> 

<cfquery datasource="#session.dsn#"> 
	insert into #t# (DEid, cod, monto) 

	select distinct a.DEid,'0028' as cod, CCSalarioBase as monto
	from #p#CargasCalculo a
		inner join CalendarioPagos d
			on a.RCNid = d.CPid
	where a.RCNid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#RCNid#" list="true">)
	
	union
	select a.DEid,'0018' as cod, SEliquido as monto
	from #p#SalarioEmpleado a
		inner join CalendarioPagos d
			on a.RCNid = d.CPid
	where a.RCNid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#RCNid#" list="true">)
	
	union 
	select se.DEid,'0033' as cod, sum(DLTmonto)/2 as monto
	from DLineaTiempo a
		inner join LineaTiempo b
			on a.LTid=b.LTid
		inner join #p#SalarioEmpleado se	
			on b.DEid=se.DEid
	where  b.LTid = (Select max(x.LTid) from LineaTiempo x where DEid = se.DEid )
	and (
			a.CSid in ( select y.CSid from CIncidentes y where y.CIid in (#getIds('SalarioBruto')#) )<!---- toma todos los conceptos agregados a la columna---->
			or<!----- además toma en cuenta el salario base---->
			a.CSid in (select CSid from ComponentesSalariales where Ecodigo=#session.Ecodigo# and CSsalariobase=1)
		)
	and se.RCNid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#RCNid#" list="true">)
	group by se.DEid
 
	union
	select a.DEid,'6200' as cod, sum(ICmontores) as monto
	from #p#SalarioEmpleado a
		inner join CalendarioPagos d
			on a.RCNid = d.CPid
		inner join #p#IncidenciasCalculo x
			on a.DEid= x.DEid
			and a.RCNid = x.RCNid
			and d.CPid= x.RCNid
		inner join CIncidentes z
			on z.CIid = x.CIid
	where x.CIid in (#getIds('HorasExtra')#)
	and a.RCNid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#RCNid#" list="true">)
	group by a.DEid

	union
	select a.DEid,'110' as cod, sum(ICmontores) as monto
	from #p#SalarioEmpleado a
		inner join CalendarioPagos d
			on a.RCNid = d.CPid
		inner join #p#IncidenciasCalculo x
			on a.DEid= x.DEid
			and a.RCNid = x.RCNid
			and d.CPid= x.RCNid
		inner join CIncidentes z
			on z.CIid = x.CIid
	where x.CIid = (#getIds('DedicacionExc')#)
	and a.RCNid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#RCNid#" list="true">)
	group by a.DEid
	
	union
	select a.DEid,'111' as cod, sum(ICmontores) as monto
	from #p#SalarioEmpleado a
		inner join CalendarioPagos d
			on a.RCNid = d.CPid
		inner join #p#IncidenciasCalculo x
			on a.DEid= x.DEid
			and a.RCNid = x.RCNid
			and d.CPid= x.RCNid
		inner join CIncidentes z
			on z.CIid = x.CIid
	where x.CIid = (#getIds('CarreraProfe')#)
	and a.RCNid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#RCNid#" list="true">)
	group by a.DEid

	union
	select a.DEid,'113' cod, sum(ICmontores) as monto
	from #p#SalarioEmpleado a
		inner join CalendarioPagos d
			on a.RCNid = d.CPid
		inner join #p#IncidenciasCalculo x
			on a.DEid= x.DEid
			and a.RCNid = x.RCNid
			and d.CPid= x.RCNid
		inner join CIncidentes z
			on z.CIid = x.CIid
	where x.CIid = (#getIds('Guardias')#)
	and a.RCNid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#RCNid#" list="true">)
	group by a.DEid

	union
	select a.DEid,'0088', SEsalariobruto as monto
	from #p#SalarioEmpleado a
		inner join CalendarioPagos d
			on a.RCNid = d.CPid
	where a.RCNid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#RCNid#" list="true">)

	union
	select xx.DEid,'3' cod,  sum(xx.monto) as monto
    from
	(
		select a.DEid,x.ICmontores as monto
		from #p#SalarioEmpleado a
			inner join CalendarioPagos d
				on a.RCNid = d.CPid
			inner join #p#IncidenciasCalculo x
				on a.DEid= x.DEid
				and a.RCNid = x.RCNid
				and d.CPid= x.RCNid
			inner join CIncidentes z
				on z.CIid = x.CIid
		where x.CIid in (#getIds('Incapacidades')#)
		and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RCNid#">

		union all   
	    select a.DEid,a.PEmontores as monto
		from #p#PagosEmpleado a
			inner join RHTipoAccion rh
	            on a.RHTid=rh.RHTid
	            and rh.RHTcomportam=5
	            and rh.RHTsubcomportam <> 1
		where  a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RCNid#">
	) xx
	group by xx.DEid

	<!------ ingresa los montos de aumentos retroactivos
		Los Empleados que tienen aumentos se indica en el proceso anterior
		-En este paso se indican la suma de los PagosEmpleado retroactivos o no, y la suma de las incidencias por componentes salariales
	----->
	union
	Select au.DEid,'1155' as cod, 
		coalesce(
			(
				select sum(pe.PEmontores)
				from #p#PagosEmpleado pe
				where pe.DEid=au.DEid
					and pe.RCNid=#RCNid#
					and pe.PEtiporeg in (1,2)
			)
		,0)
		+
		coalesce(
			(
				select sum(hic.ICmontores)
				from #p#IncidenciasCalculo hic
					inner join CIncidentes ci
						on hic.CIid=ci.CIid
						and ci.CSid is not null
				where hic.DEid=au.DEid
					and hic.RCNid=#RCNid#
					and hic.ICfecha in (
										select x.PEdesde
										from #p#PagosEmpleado x
										where x.DEid=au.DEid
											and x.RCNid=#RCNid#
											and x.PEtiporeg in (1,2)
										)
			)		
		,0)  as monto
	from #au# au
	
	union 
	Select au.DEid,'1157' as cod, 
		coalesce(
			(
				select sum(pe.PEmontores)
				from #p#PagosEmpleado pe
				where pe.DEid=au.DEid
					and pe.RCNid=#RCNid#
					and pe.PEtiporeg = 0
			)
		,0)
		+
		coalesce(
			(
				select sum(hic.ICmontores)
				from #p#IncidenciasCalculo hic
					inner join CIncidentes ci
						on hic.CIid=ci.CIid
						and ci.CSid is not null
				where hic.DEid=au.DEid
					and hic.RCNid=#RCNid#
					and hic.ICfecha in (
										select x.PEdesde
										from #p#PagosEmpleado x
										where x.DEid=au.DEid
											and x.RCNid=#RCNid#
											and x.PEtiporeg =0
										)
			)		
		,0)  as monto
	from #au# au 
</cfquery> 

<cfquery datasource="#session.dsn#" name="rsReporte">
	select d.DEidentificacion,monto,cod 
	from #t# t inner join DatosEmpleado d on t.DEid=d.DEid 
	where monto > 0.1
	order by cod,d.DEidentificacion
</cfquery> 

<cfif !len(trim(rsReporte.DEidentificacion))>
	<cf_errorCode code="52228" msg="No existen registros para mostrar">
</cfif>

<cfset salida=''>
<cfloop query="rsReporte">
	<cfset salida&=limitar(DEidentificacion,9)&limitar(cod,4,'L')&limitar(LSNumberFormat(monto,'9.99'),10,'L')&LSDateFormat(rsN.Periodo,'yyyymmdd')&Chr(13)&Chr(10)>
</cfloop>
<cfset archivo=GetTempFile( GetTempDirectory(), 'ReporteDATSAL')>
<cffile action = "write" file = "#archivo#" output = "#salida#" nameconflict="overwrite">
<cfheader name="Content-Disposition" value="attachment; filename=DATSAL.txt" ><!---charset="utf-8"---> 
<cfcontent type="text/plain;charset=windows-1252" file="#archivo#">
<cfsetting requesttimeout="8600">

<cfif isdefined("url.CFid") and not isdefined("form.CFid")>
	<cfparam name="form.CFid" default="#url.CFid#">
</cfif>
<cfif isdefined("url.dependencias") and not isdefined("form.dependencias")>
	<cfparam name="form.dependencias" default="#url.dependencias#">
</cfif>
<cfif isdefined("url.usar") and not isdefined("form.usar")>
	<cfparam name="form.usar" default="#url.usar#">
</cfif>
<cfif isdefined("url.periodo") and not isdefined("form.periodo")>
	<cfparam name="form.periodo" default="#url.periodo#">
</cfif>
<cfif isdefined("url.mes") and not isdefined("form.mes")>
	<cfparam name="form.mes" default="#url.mes#">
</cfif>
<cfif isdefined("url.inicio") and not isdefined("form.inicio")>
	<cfparam name="form.inicio" default="#url.inicio#">
</cfif>
<cfif isdefined("url.final") and not isdefined("form.final")>
	<cfparam name="form.final" default="#url.final#">
</cfif>
<cfif isdefined("url._CFid")>
	<cfparam name="form._CFid" default="#url._CFid#">
</cfif>
<cfif isdefined("url.reporte")>
	<cfparam name="form.reporte" default="#url.reporte#">
</cfif>

<cfparam name="form.CFid" default="">
<cfparam name="form.dependencias" default="0">
<cfparam name="form.usar" default="PM">
<cfparam name="form.periodo" default="#year(now())#">
<cfparam name="form.mes" default="#month(now())#">
<cfparam name="form.inicio" default="">
<cfparam name="form.final" default="">
<cfparam name="form.reporte" default="0"> <!--- 0: resumido, 1: empleados, 2: empleados y cursos --->

<cfset parametros = "&CFid=#form.CFid#&dependencias=#form.dependencias#&usar=#form.usar#&periodo=#form.periodo#&mes=#form.mes#&inicio=#form.inicio#&final=#form.final#" >

<cf_htmlReportsHeaders 
		title="#nombre_proceso#"
		filename="Horas_Capacitacion.xls"
		irA="horascap-filtro.cfm"
		download="yes"
		preview="no">

<cfif isdefined("form.usar") and form.usar eq 'RF' >
	<cfset fecha_inicio = lsdateformat(dateadd('d',-30, now()), 'dd/mm/yyyy') >
	<cfset fecha_final = lsdateformat(now(), 'dd/mm/yyyy') >
	<cfif isdefined("form.inicio") and len(trim(form.inicio))>
		<cfset fecha_inicio = form.inicio >
	</cfif>
	<cfif isdefined("form.final") and len(trim(form.final))>
		<cfset fecha_final = form.final >
	</cfif>
	
	<cfif datecompare(LSParseDateTime(fecha_inicio), LSParseDateTime(fecha_final) ) gte 0 >
		<cfset temp = fecha_inicio >
		<cfset fecha_inicio = fecha_final >
		<cfset fecha_final = temp >
	</cfif>
	
<cfelse> <!--- PM --->
	<cfset fecha_inicio = LSDateFormat(createdate(year(now()), month(now()), 1 ), 'dd/mm/yyyy') >
	<cfset fecha_final = LSDateFormat(createdate(year(now()), month(now()), daysinmonth(now()) ), 'dd/mm/yyyy') >
	<cfif isdefined("form.periodo") and isdefined("form.mes") and len(trim(form.mes)) and len(trim(form.periodo)) >
		<cfset fecha_inicio = LSDateFormat(createdate(form.periodo, form.mes, 1 ), 'dd/mm/yyyy') >
		<cfset fecha_final = LSDateFormat(createdate(form.periodo, form.mes, daysinmonth(createdate(form.periodo, form.mes, 1)) ), 'dd/mm/yyyy') >
	</cfif>
</cfif>

<cfif isdefined("form.CFid") and len(trim(form.CFid)) >
	<cfquery name="rs_centrofuncional"  datasource="#session.DSN#">
		select CFid, CFcodigo, CFdescripcion, CFpath as path
		from CFuncional
		where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
</cfif>

<cf_dbtemp name="datosv1" returnvariable="datos">
	<cf_dbtempcol name="RHCid" 				type="numeric" 			mandatory="yes"> 
	<cf_dbtempcol name="RHCcodigo"			type="varchar(15)"		mandatory="yes"> 	
	<cf_dbtempcol name="RHCnombre"			type="varchar(50)"		mandatory="yes"> 	
	<cf_dbtempcol name="RHCfdesde" 			type="datetime" 		mandatory="yes">
	<cf_dbtempcol name="RHCfhasta" 			type="datetime" 		mandatory="yes">	
	<cf_dbtempcol name="DEid" 				type="numeric" 			mandatory="yes">
	<cf_dbtempcol name="DEidentificacion" 	type="varchar(60)"		mandatory="yes">
	<cf_dbtempcol name="DEnombre" 			type="varchar(100)" 	mandatory="yes">
	<cf_dbtempcol name="DEapellido1" 		type="varchar(80)" 		mandatory="no">
	<cf_dbtempcol name="DEapellido2" 		type="varchar(80)" 		mandatory="no">
	<cf_dbtempcol name="RHEMestado" 		type="integer" 			mandatory="yes">
	<cf_dbtempcol name="CFid" 				type="numeric"  		mandatory="no"> 
	<cf_dbtempcol name="CFcodigo" 			type="varchar(10)" 		mandatory="no">	
	<cf_dbtempcol name="CFdescripcion" 		type="varchar(60)" 		mandatory="no">	
	<cf_dbtempcol name="CFpath" 			type="varchar(255)" 	mandatory="no">	
	<cf_dbtempcol name="horas" 				type="float"  			mandatory="no">	
</cf_dbtemp>

<cfquery datasource="#session.DSN#">
	insert into #datos#( RHCid, RHCcodigo, RHCnombre, RHCfdesde, RHCfhasta, DEid, DEidentificacion, DEnombre, DEapellido1, DEapellido2, RHEMestado )
	select 	ec.RHCid, 
			c.RHCcodigo,
			c.RHCnombre,
			c.RHCfdesde,
			c.RHCfhasta,
			ec.DEid, 
			de.DEidentificacion, 
			de.DEnombre, 
			de.DEapellido1, 
			de.DEapellido2, 
			ec.RHEMestado
	from RHEmpleadoCurso ec
	
	inner join DatosEmpleado de
	on de.DEid=ec.DEid
	
	inner join RHCursos c
	on c.RHCid=ec.RHCid
	and c.RHCfdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(fecha_final)#"> <!--- filtro fecha final --->
	and c.RHCfhasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(fecha_inicio)#"> <!--- filtro fecha inicio --->
	
	where ec.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<!--- datos del centro funcional donde el empleado llevo el curso --->
<cfquery datasource="#session.DSN#">
	update #datos#
	set CFid = ( select Max(p.CFid)
				 from LineaTiempo lt
				 inner join RHPlazas p
				 on p.RHPid=lt.RHPid
				 inner join CFuncional cf
				 on cf.CFid = p.CFid 
				 where lt.DEid=#datos#.DEid
				   and lt.LTdesde = (select max(lt2.LTdesde) from LineaTiempo lt2 where lt2.Ecodigo=lt.Ecodigo and lt2.DEid=lt.DEid) )
</cfquery>
<cfquery datasource="#session.DSN#">
	update #datos#
	 set CFcodigo = (select cf.CFcodigo
						   	from CFuncional cf
						  	where cf.CFid = #datos#.CFid),
	 CFdescripcion = (select cf.CFdescripcion
							 from CFuncional cf
		 					  where cf.CFid = #datos#.CFid),
	 CFpath = 			(select cf.CFpath
							  from CFuncional cf
		 					  where cf.CFid = #datos#.CFid)
</cfquery>


<!--- 	si se indico centro funcional, se eliminan los centros funcionales que no corresponden, 
		excepto si se marco centros funcionales dependientes, estos deben mantenerse --->
<cfif isdefined("form.CFid") and len(trim(form.CFid))>
	<cfquery datasource="#session.DSN#">
		delete from #datos#
		<cfif isdefined("form.dependencias")>
			where CFpath not like '#trim(rs_centrofuncional.path)#%'
		<cfelse>
			where CFid != <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
		</cfif>
	</cfquery>
</cfif>

<!--- Horas dedicadas al curso --->
<cfquery datasource="#session.DSN#">
	update #datos#
	set horas =	coalesce((	select sum(RHAChoras)
							from RHAsistenciaCurso ac
							where ac.RHCid=#datos#.RHCid
							  and ac.DEid=#datos#.DEid
							  and ac.RHACdia between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(fecha_inicio)#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(fecha_final)#">
							group by ac.DEid), 0)
</cfquery>

<cfif isdefined("form.reporte") and form.reporte eq 1 >
	<cfinclude template="horascap-empleados.cfm">
<cfelseif isdefined("form.reporte") and form.reporte eq 2 >
	<cfinclude template="horascap-cursosempleado.cfm">
<cfelse >
	<cfinclude template="horascap-resumido.cfm">
</cfif>
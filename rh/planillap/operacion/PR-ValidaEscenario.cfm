<!--- VALIDACIONES DE ESCENARIO --->

<!--- 1. VALIDACION DE TABLAS --->
<!--- 	 Valida que no queden huecos en el tiempo, para las tablas salariales del escenario.
		 La validacion debe ser por tipo de tabla.
		 Ej: Escenario ==> 01/01/2006 a /31/12/2006
		 	 CORRECTO:
			 			Tabla 1 ==> 01/01/2006 a 30/06/2006
						Tabla 2 ==> 01/07/2006 a 22/10/2006
						Tabla 3 ==> 23/10/2006 a 31/12/2006
				Aqui no quedan espacios de tiempo sin tabla salarial.
						
			INCORRECTO:
			 			Tabla 1 ==> 01/01/2006 a 30/06/2006
						Tabla 3 ==> 23/10/2006 a 31/12/2006
				Aqui el rango 01/07/2006 a 22/10/2006 esta sin tabla salarial, esto no es valido.

 --->

<!--- 1.1 Duracion en dias del escenario (rango de fechas del escenario) --->
<cfquery name="escenario" datasource="#session.DSN#">
	select RHEfdesde, RHEfhasta, datediff(dd, RHEfdesde, RHEfhasta)+1 as duracion
	from RHEscenarios
	where RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
</cfquery>
<!---	
<cfquery name="escenario" datasource="#session.DSN#">
	select RHTTid, sum(datediff(  dd, RHETEfdesde, RHETEfhasta ) +1) as rango
	from RHETablasEscenario
	where RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
	group by RHTTid
	having sum(datediff(  dd, RHETEfdesde, RHETEfhasta ) +1) < <cfqueryparam cfsqltype="cf_sql_integer" value="#escenario.duracion#">
	order by 1
</cfquery>
--->

<cfquery name="valida_tablas" datasource="#session.DSN#">
	select RHTTid, sum( abs( <cf_dbfunction name="datediff" args="RHETEfdesde, RHETEfhasta"> ) +1) as rango
	from RHETablasEscenario
	where RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
	group by RHTTid
	having sum( abs( <cf_dbfunction name="datediff" args="RHETEfdesde, RHETEfhasta"> ) +1) > <cfqueryparam cfsqltype="cf_sql_integer" value="#escenario.duracion#">
	order by RHTTid
</cfquery>
<cfif valida_tablas.recordcount gt 0 >
	<cfquery name="tablas_incompletas" datasource="#session.DSN#">
		select a.RHETEid, a.RHEid, a.RHTTid, a.RHETEdescripcion, a.RHETEfdesde, a.RHETEfhasta, b.RHTTcodigo, b.RHTTdescripcion
		from RHETablasEscenario a
		
		inner join RHTTablaSalarial b
		on b.RHTTid = a.RHTTid
		
		where a.RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#valida_tablas.RHTTid#">
		and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
		order by a.RHTTid, a.RHETEfdesde
	</cfquery>
</cfif>

<!--- 2. VALIDACION DE MONTOS --->
<!--- 	 Valida que los montos de Situacion Actual sean iguales o mayores a 
		 los montos definidos en Plazas Escenarios.
		 PROCESO:
		 	i. 	Traer todos los registros de RHPlazasEscenario que esten CONTENIDOS [fechas] 
			   	en algun registro de RHSituacionActual. Los deja en una tabla temporal.
			ii.	Modifica los montos (SAmonto, PEmonto) de la tabla temporal segun los datos de
			    RHSitucionActual y RHPlazasEscenario      
--->

<!--- TABLA TEMPORAL DE TRABAJO --->
<cf_dbtemp name="ValidarMontos" returnvariable="ValidarMontos" datasource="#session.DSN#">
	<cf_dbtempcol name="Ecodigo"	 type="int"      mandatory="yes"> 
	<cf_dbtempcol name="RHEid"		 type="numeric"  mandatory="yes"> 
	<cf_dbtempcol name="RHPEid"		 type="numeric"  mandatory="yes"> 
	<cf_dbtempcol name="RHSAid"		 type="numeric"  mandatory="yes"> 
	<cf_dbtempcol name="RHPPid"		 type="numeric"  mandatory="yes"> 
	<cf_dbtempcol name="DEid"		 type="numeric"  mandatory="yes"> 
	<cf_dbtempcol name="PEfdesde" 	 type="datetime" mandatory="yes"> 
	<cf_dbtempcol name="PEfhasta" 	 type="datetime" mandatory="yes"> 
	<cf_dbtempcol name="SAmonto"	 type="money"    mandatory="yes">
	<cf_dbtempcol name="PEmonto"	 type="money"    mandatory="yes">
</cf_dbtemp>

<cfquery datasource="#session.DSN#">
	insert into #ValidarMontos#(Ecodigo, RHEid, RHPEid, RHSAid, RHPPid, DEid, PEfdesde, PEfhasta, SAmonto, PEmonto)
	select a.Ecodigo, a. RHEid, a.RHPEid, b.RHSAid, a.RHPPid, a.DEid, a.RHPEfinicioplaza, a.RHPEffinplaza, 0 , 0 
	from RHPlazasEscenario a
	
	inner join RHSituacionActual b
	on b.RHPPid=a.RHPPid
	and b.RHEid=a.RHEid
	
	and a.RHPEfinicioplaza >=b.fdesdeplaza 
	and a.RHPEffinplaza <=b.fhastaplaza
	and b.RHSAocupada = 1
	and b.RHPPid is not null
	
	where a.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
	and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by a.RHPEfinicioplaza
</cfquery>

<cfquery datasource="#session.DSN#">
	update #ValidarMontos#
	set SAmonto = (  select sum(c.Monto)
				from RHSituacionActual b
				inner join RHCSituacionActual c
				on c.RHSAid = b.RHSAid
				where b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and  b.RHSAid = #ValidarMontos#.RHSAid
				group by b.RHSAid   )
	from RHSituacionActual b
	inner join RHCSituacionActual c
	on c.RHSAid = b.RHSAid
	where b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and  b.RHSAid = #ValidarMontos#.RHSAid
</cfquery>

<cfquery datasource="#session.DSN#">
	update #ValidarMontos#
	set PEmonto = (  select sum(c.Monto)
				from RHPlazasEscenario b
				inner join RHComponentesPlaza c
				on c.RHPEid = b.RHPEid
				where b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and  b.RHPEid = #ValidarMontos#.RHPEid
				group by b.RHPEid   )
	from RHPlazasEscenario b
	inner join RHComponentesPlaza c
	on c.RHPEid = b.RHPEid
	where b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and  b.RHPEid = #ValidarMontos#.RHPEid
</cfquery>

<cfquery name="valida_montos" datasource="#session.DSN#">
	select a.Ecodigo, 
		   a.RHEid, 
		   a.RHPEid, 
		   a.RHSAid, 
		   a.RHPPid, 
		   a.DEid, 
		   a.PEfdesde, 
		   a.PEfhasta, 
		   a.SAmonto, 
		   a.PEmonto,
		   b.RHPPcodigo,
		   b.RHPPdescripcion,
		   de.DEidentificacion,
		   de.DEnombre,
		   de.DEapellido1,
		   de.DEapellido2
	from #ValidarMontos# a
	
	inner join RHPlazaPresupuestaria b
	on b.RHPPid = a.RHPPid
	
	inner join DatosEmpleado de
	on de.DEid = a.DEid
		
	where SAmonto > PEmonto
	<cfif isdefined("form.RHPPid") and len(trim(form.RHPPid))>
		and a.RHPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPPid#">
	</cfif>
	
	order by b.RHPPcodigo
</cfquery>

<!--- 3. Cuentas Incorectas  --->
<cfquery name="valida_cuentas" datasource="#session.DSN#">
	select distinct RHEid, a.CPformato as cuenta
		from RHCFormulacion a
		 
		inner join RHFormulacion b
		on b.RHFid=a.RHFid
		and b.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
		
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and ( a.CPformato like '%--%'
			or a.CPformato like '%?%'  
			or a.CPformato like '%*%'
			or a.CPformato like '%!%'  
			or a.CPformato like '% %' )
	order by a.CPformato desc
</cfquery>

<cfif valida_tablas.recordcount gt 0 or valida_montos.recordcount gt 0 or valida_cuentas.recordcount gt 0>
	<cfinclude template="PR-Errores.cfm">
	<cfabort>
</cfif>
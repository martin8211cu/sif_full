<cfinclude template="reporteSalariosCCSSDetalle-Query.cfm">

<!--- Variables --->
<cfset mesl = '' >
<cfset Largo = '' >
<cfset NUMPAT = '' >
<cfset mensaje = '' >
<cfset Ocodigo = '' >
<cfset adscrita = '' >
<cfset periodol = '' >
<cfset Registro25 = '' >
<cfset Registro35 = '' >
<cfset Onumpatinactivo = '' >

<cfset mesl = form.mes >
<cfset periodol = form.periodo >
<cfset Largo = len(trim(form.GrupoPlanilla)) >

<cfset RHQuerySalarios = '' >
<cfif form.masivo EQ 1 >
	<!--- Crea la tabla temporal --->
	<cf_dbtemp name="RHQuerySalarios" returnvariable="RHQuerySalarios" datasource="#session.DSN#">
		<cf_dbtempcol name="Patron"    		type="varchar(30)" 	mandatory="no">
		<cf_dbtempcol name="PatAct"    		type="money" 		mandatory="yes">
		<cf_dbtempcol name="PatAnt"    		type="money" 		mandatory="yes">
		<cf_dbtempcol name="GenAct"    		type="money" 		mandatory="yes">
		<cf_dbtempcol name="GenAnt"    		type="money" 		mandatory="yes">
		<cf_dbtempcol name="TotCamb"    	type="money" 		mandatory="yes">
		<cf_dbtempcol name="TotSCamb"    	type="money" 		mandatory="yes">	
	</cf_dbtemp>
</cfif>

<!--- Crea la tabla temporal --->
<cf_dbtemp name="QuerySalariosDet" returnvariable="QuerySalariosDet" datasource="#session.DSN#">
	<cf_dbtempcol name="DEid"    		type="numeric" 		mandatory="no">
	<cf_dbtempcol name="NUMPAT"    		type="varchar(40)"	mandatory="no">
	<cf_dbtempcol name="FECHDE"    		type="datetime" 	mandatory="no">
	<cf_dbtempcol name="FECHAS"    		type="datetime" 	mandatory="no">
	<cf_dbtempcol name="Ecodigo"    	type="integer" 		mandatory="no">
	<cf_dbtempcol name="Ocodigo"    	type="integer" 		mandatory="no">
	<cf_dbtempcol name="RHPcodigo"    	type="varchar" 		mandatory="no">
	<cf_dbtempcol name="Salario"    	type="money" 		mandatory="no">	
	<cf_dbtempcol name="Incidencias"    type="money" 		mandatory="no">	
	<cf_dbtempcol name="MONTO"    		type="money" 		mandatory="no">	
	<cf_dbtempcol name="Salarioa"    	type="money" 		mandatory="no">	
	<cf_dbtempcol name="Incidenciasa"   type="money" 		mandatory="no">	
	<cf_dbtempcol name="MONTOa"    		type="money" 		mandatory="no">	
	<cf_dbtempcol name="Mensaje"    	type="varchar" 		mandatory="no">	
	<cf_dbtempcol name="Fechamax"    	type="datetime" 	mandatory="no">	
</cf_dbtemp>

<!--- Falta el parametro de Oficina adscrita --->
<cfquery name="rsParametros" datasource="#session.DSN#" >
	select 1 
	from RHParametros 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
		and Pcodigo = 420
</cfquery>
<cfquery name="rsOficina" datasource="#session.DSN#" >
	 select 1 
	 from Oficinas 
	 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
	   and coalesce(Oadscrita,'') != '' 
</cfquery>						   
<cfif rsParametros.recordCount EQ 0 and rsOficina.recordCount EQ 0 >
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_No_esta_el_parametro_de_la_Sucursal_adscrita_ni_en_Oficinas_ni_en_Parametros_Generales"
	Default="No esta el par&aacute;metro de la sucursal adscrita ni en Oficinas ni en Par&aacute;metros Generales."
	returnvariable="LB_No_esta_el_parametro_de_la_Sucursal_adscrita_ni_en_Oficinas_ni_en_Parametros_Generales"/> 
	<cf_throw message="#LB_No_esta_el_parametro_de_la_Sucursal_adscrita_ni_en_Oficinas_ni_en_Parametros_Generales#" errorCode="1035">
</cfif>

<cfquery name="rsPvalor" datasource="#session.DSN#">
	select Pvalor 
	from RHParametros 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
		and Pcodigo = 420
</cfquery>
<cfset adscrita = rsPvalor.Pvalor >
<cfquery name="rsOrdenPatronal" datasource="#session.DSN#">
	select 1 
	from Oficinas 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">  
		and coalesce(Onumpatronal,'0') = '0' 
		and Onumpatinactivo = 0
</cfquery>

<cfquery name="rsCalendarioPagos" datasource="#session.DSN#">
	select 1 
	from CalendarioPagos cp
		inner join  HPagosEmpleado pe
			on cp.CPid = pe.RCNid
			and cp.Tcodigo = pe.Tcodigo 
		inner join Oficinas o
			on  pe.Ocodigo = o.Ocodigo
			and cp.Ecodigo = o.Ecodigo
			and o.Onumpatronal is null 
	where cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">  
		and cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.periodo#">
		and cp.CPmes  = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.mes#">		
</cfquery>

<cfif rsOrdenPatronal.recordCount GT 0 and rsCalendarioPagos.recordCount GT 0 >
	<cfquery name="rsNUMPAT" datasource="#session.DSN#">
		select Pvalor 
		from RHParametros 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
			and Pcodigo = 300
	</cfquery>
	<cfset NUMPAT = trim(rsNUMPAT.Pvalor) >
	
	<!--- Se incluye el metodo detalle() del archivo reporteSalariosCCSSDetalle-Query.cfm --->
	<cfset detalle(RHQuerySalarios, QuerySalariosDet, form.periodo, form.mes, 0, form.GrupoPlanilla, form.masivo, NUMPAT) >

</cfif>

<!--- Se verifica si hay oficinas con diferentes numeros patronales --->
<cfquery name="rsOrdenPatronalDif" datasource="#session.DSN#">
	select 1 
	from Oficinas 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">  
		and coalesce(Onumpatronal,'0') != '0' 
		and Onumpatinactivo = 0
</cfquery>

<cfif rsOrdenPatronalDif.recordCount GT 0 >
	<cfif len(trim(form.GrupoPlanilla)) NEQ 0>
		<cfquery name="rsOnumpatronal_1" datasource="#session.DSN#">
			select min(Onumpatronal) as Onumpatronal
			from Oficinas 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
				and substring(Oficodigo, 1, #Largo#) = <cfqueryparam cfsqltype="cf_sql_char" value="#form.GrupoPlanilla#"> 
				and Onumpatronal is not null	
		</cfquery>
		<cfset NUMPAT = trim(rsOnumpatronal_1.Onumpatronal) >
	<cfelse>
		<cfquery name="rsOnumpatronal_2" datasource="#session.DSN#">
			select min(Onumpatronal) as Onumpatronal
			from Oficinas 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
				and Onumpatronal is not null	
		</cfquery>
		<cfset NUMPAT = trim(rsOnumpatronal_2.Onumpatronal) >
	</cfif> <!--- FIN del len(trim(form.GrupoPlanilla)) NEQ 0 --->
	
	<cfloop condition=" len(trim(NUMPAT)) " >
		<cfquery name="rsCountOnumpatinactivo" datasource="#session.DSN#">
			select count(distinct Onumpatinactivo) as Onumpatinactivo
			from Oficinas 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
				and  Onumpatronal = <cfqueryparam cfsqltype="cf_sql_varchar" value="#NUMPAT#">
		</cfquery>
		
		<cfif rsCountOnumpatinactivo.Onumpatinactivo GT 1 >
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Existen_Oficinas_cerradas_y_otras_abiertas_para_este_numero_patronal"
			Default="Existen Oficinas cerradas y otras abiertas para este n&uacute;mero patronal"
			returnvariable="LB_Existen_Oficinas_cerradas_y_otras_abiertas_para_este_numero_patronal"/> 
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_esto_no_es_permitido"
			Default="esto no es permitido"
			returnvariable="LB_esto_no_es_permitido"/> 
			<cf_throw message="#LB_Existen_Oficinas_cerradas_y_otras_abiertas_para_este_numero_patronal#,&nbsp;#NUMPAT#&nbsp;#LB_esto_no_es_permitido#." errorCode="1040">
		</cfif>
		
		<cfquery name="rsOnumpatinactivo" datasource="#session.DSN#">
			select Onumpatinactivo
			from Oficinas 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
				and  Onumpatronal = <cfqueryparam cfsqltype="cf_sql_varchar" value="#NUMPAT#">
		</cfquery>
		<cfset Onumpatinactivo = trim(rsOnumpatinactivo.Onumpatinactivo) >
		
		<cfquery name="rsCountOadscrita" datasource="#session.DSN#">
			select count(distinct Oadscrita) as Oadscrita
			from Oficinas 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">  
				and Onumpatronal = <cfqueryparam cfsqltype="cf_sql_varchar" value="#NUMPAT#">	
		</cfquery>
		

		<cfif rsCountOadscrita.Oadscrita GT 1 >
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Existen_mas_de_un_Registro_de_adscripcion_para_este_numero_patronal"
			Default="Existen mas de un Registro de adscripci&oacute;n para este n&uacute;mero patronal"
			returnvariable="LB_Existen_mas_de_un_Registro_de_adscripcion_para_este_numero_patronal"/> 
			
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_esto_no_es_permitido"
			Default="esto no es permitido"
			returnvariable="LB_esto_no_es_permitido"/>
			
			<cf_throw message="#LB_Existen_mas_de_un_Registro_de_adscripcion_para_este_numero_patronal#,&nbsp;#NUMPAT#&nbsp;#LB_esto_no_es_permitido#" errorCode="1045">
		<cfelse>
			<cfquery name="rsOadscrita" datasource="#session.DSN#">
				select Oadscrita
				from Oficinas 
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">  
					and Onumpatronal = <cfqueryparam cfsqltype="cf_sql_varchar" value="#NUMPAT#">	
			</cfquery>
			<cfset adscrita = trim(rsOadscrita.Oadscrita) >
		
			<cfif len(trim(adscrita)) EQ 0>
				<cfquery name="rsOadscrita_Pvalor" datasource="#session.DSN#">
					select Pvalor 
					from RHParametros 
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
						and Pcodigo = 420
				</cfquery>
				<cfset adscrita = trim(rsOadscrita_Pvalor.Pvalor) >
			</cfif>
			
			<cfif Onumpatinactivo EQ 0 >
				<!--- Se incluye el metodo del archivo reporteSalariosCCSSDetalle-Query.cfm --->
				<cfset detalle(RHQuerySalarios, QuerySalariosDet, form.periodo, form.mes, 1, form.GrupoPlanilla, form.masivo, NUMPAT) >
			</cfif>
			
			<cfif len(trim(form.GrupoPlanilla)) >
				<cfquery name="rsOnumpatronal_3" datasource="#session.DSN#">
					select min(Onumpatronal) as Onumpatronal
					from Oficinas 
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
						and substring(Oficodigo, 1, #Largo#) = <cfqueryparam cfsqltype="cf_sql_char" value="#form.GrupoPlanilla#"> 
						and Onumpatronal > <cfqueryparam cfsqltype="cf_sql_varchar" value="#NUMPAT#">	
						and Onumpatronal is not null	
				</cfquery>
				<cfset NUMPAT = trim(rsOnumpatronal_3.Onumpatronal) >

			<cfelse>
				<cfquery name="rsOnumpatronal_4" datasource="#session.DSN#">
					select min(Onumpatronal) as Onumpatronal
					from Oficinas 
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
						and Onumpatronal > <cfqueryparam cfsqltype="cf_sql_varchar" value="#NUMPAT#">	
						and Onumpatronal is not null	
				</cfquery>
				<cfset NUMPAT = trim(rsOnumpatronal_4.Onumpatronal) >
			</cfif>
		</cfif> <!--- FIN del rsCountOadscrita.Oadscrita GT 1 --->
		
	</cfloop> <!--- FIN del condition="NUMPAT" --->
				
</cfif> <!--- FIN del rsOrdenPatronalDif.recordCount GT 0 --->

<cfif form.masivo EQ 0>
	<cfquery name="rsDatos" datasource="#session.DSN#" >
		select	a.NUMPAT as NumPatronal,
				b.DEidentificacion as Cedula, 
				ltrim(rtrim(b.DEapellido1)) || ' ' || ltrim(rtrim(b.DEapellido2)) || ', ' || ltrim(rtrim(b.DEnombre)) as Nombre,
				a.MONTO as Actual,
				a.MONTOa as Anterior,
				Mensaje as Cambio
		from #QuerySalariosDet# a 
			inner join DatosEmpleado b
				on a.DEid = b.DEid
		order by a.NUMPAT, ltrim(rtrim(b.DEapellido1)) || ' ' || ltrim(rtrim(b.DEapellido2)) || ', ' || ltrim(rtrim(b.DEnombre))
	</cfquery>

	<!---
	<cfquery name="rsTotalOrdenPatronal" datasource="#session.DSN#">	
		select sum(MONTO) as MONTO, sum(MONTOa) as MONTOa
		from #QuerySalariosDet#
	</cfquery>
	--->
	
	<cfquery name="rsTotalGeneral" datasource="#session.DSN#">
		select sum(MONTO) as MONTO, sum(MONTOa) as MONTOa 
		from #QuerySalariosDet#
	</cfquery>
	
	<cfquery name="rsTotalCambios" datasource="#session.DSN#">
		Select sum(MONTO) as MONTO 
		from #QuerySalariosDet# 
		where Mensaje != 'S'
	</cfquery>

	<cfquery name="rsTotalSinCambios" datasource="#session.DSN#">
		Select sum(MONTO) as MONTO 
		from #QuerySalariosDet# 
		where Mensaje = 'S'
	</cfquery>

<cfelse>
	<cfquery name="rsResultado" datasource="#session.DSN#">
		select Patron,PatAct,PatAnt,GenAct, GenAnt,	TotCamb, TotSCamb, count(distinct DEid) as TotEmp
		from #RHQuerySalarios# a
			inner join #QuerySalariosDet# b
				on a.Patron = b.NUMPAT
		group by Patron
	</cfquery>
</cfif> 




<!--- PROCESO DE ELIMINACION DE UNA TABLA SALARIAL DEL ESCENARIO --->
<!--- Cuando se borra una tabla salarial del escenario, deben eliminarse
	  todos los registros asociados a esa tabla en todo el escenario.
	  Incluso el proceso de eliminacion, borra todos los cortes de esa
	  tabla salarial en el escenario.
 --->

<cfquery name="rsBorrarTabla" datasource="#session.DSN#">
	select RHTTid, RHETEfdesde, RHETEfhasta
	from RHETablasEscenario
	where RHETEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHETEid#">
	  and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
	  and Ecodigo = #session.Ecodigo#
</cfquery>

<cfquery name="rsBorrarSA" datasource="#session.DSN#">
	select RHTTid, RHSAid, RHPPid, CFid
	from RHSituacionActual
	where RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
	  and fdesdeplaza = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsBorrarTabla.RHETEfdesde#">
	  and fhastaplaza = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsBorrarTabla.RHETEfhasta#">
	  and Ecodigo = #session.Ecodigo#
</cfquery>
<cfset lvarRHSAids = valueList(rsBorrarSA.RHSAid)>
<cfif len(trim(lvarRHSAids)) eq 0>
	<cfset lvarRHSAids = -1>
</cfif>


<!--- Por algun motivo en la formulacion esta generando registros, con el mismo RHETEid para tablas salariales diferentes. 
	  Se supone que el RHETEid tiene asociada uan sola tabla salarial, revisar esto --->
<cfquery name="rsListaTablas" datasource="#session.DSN#">
	select RHETEid
	from RHETablasEscenario
	where RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsBorrarTabla.RHTTid#">
	  and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
	  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
</cfquery>

<cfset vTablas = valuelist(rsListaTablas.RHETEid) >
<cfif len(trim(rsBorrarTabla.RHTTid))>
	<cftransaction>

	<!--- solo por seguridad, siempre deberia estar lleno --->
	<cfif len(trim(vTablas))>
		<!--- ELIMINA EL DETALLE DE OTRAS PARTIDAS --->
		<cfquery name="deleteOP" datasource="#session.DSN#">
			delete RHOPDFormulacion
			from RHOPDFormulacion a
			inner join RHOPFormulacion b
				on b.RHOPFid = a.RHOPFid
			where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and b.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
		</cfquery>
		<!--- ELIMINA LOS DATOS DE LAS OTRAS PARTIDAS --->
		<cfquery name="deleteOP" datasource="#session.DSN#">
			delete from RHOPFormulacion
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
		</cfquery>
	</cfif>


	<!---Eliminar cortes del detalle(componentes) de la formulacion---->
	<cfquery datasource="#session.DSN#">
		delete RHCortesPeriodoF
		from RHCortesPeriodoF cpf			
			inner join RHCFormulacion cfor
				on cpf.RHCFid = cfor.RHCFid and cfor.Ecodigo = cpf.Ecodigo
			inner join RHFormulacion f
				on f.RHFid = cfor.RHFid and f.Ecodigo = cfor.Ecodigo
				 and f.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
			inner join RHSituacionActual sa
				on sa.RHSAid = f.RHSAid
				  and sa.fdesdeplaza = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsBorrarTabla.RHETEfdesde#">
	 			  and sa.fhastaplaza = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsBorrarTabla.RHETEfhasta#">
				  and sa.RHSAid in(<cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHSAids#" list="yes">)
		where cpf.Ecodigo = #session.Ecodigo#
			
	</cfquery>
	<!---Eliminar componentes de la formulacion---->
	<cfquery datasource="#session.DSN#">
		delete RHCFormulacion 
		from RHCFormulacion a
			inner join RHFormulacion b
				on b.RHFid = a.RHFid
				  and b.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
			inner join RHSituacionActual sa
				on sa.RHSAid = b.RHSAid
				  and sa.fdesdeplaza = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsBorrarTabla.RHETEfdesde#">
	 			  and sa.fhastaplaza = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsBorrarTabla.RHETEfhasta#">
				  and sa.RHSAid in(<cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHSAids#" list="yes">)	
		where a.Ecodigo = #session.Ecodigo#
		  
	</cfquery>
	<!----Eliminar formulacion del escenario------>
	<cfquery datasource="#session.DSN#">
		delete from RHFormulacion
		from RHFormulacion f
			inner join RHSituacionActual sa
				on sa.RHSAid = f.RHSAid and sa.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
				  and sa.fdesdeplaza = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsBorrarTabla.RHETEfdesde#">
	 			  and sa.fhastaplaza = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsBorrarTabla.RHETEfhasta#">
				  and sa.RHSAid in(<cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHSAids#" list="yes">)	
		where f.Ecodigo = #session.Ecodigo#
		  and f.RHEid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
	</cfquery>
	<!----- ELIMINAR DATOS DEL TAB DE EMPLEADOS ------>
	<cfquery datasource="#session.DSN#">
		delete from RHComponentesPlaza
		where RHPEid in (select distinct RHPEid 
						from RHPlazasEscenario
						where Ecodigo = #session.Ecodigo#
							and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
							and RHPPid in (
										  select distinct RHPPid 
										  from RHSituacionActual 
										  where RHSAid in(<cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHSAids#" list="yes">)
										 )
							and RHPEfinicioplaza = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsBorrarTabla.RHETEfdesde#">
							and RHPEffinplaza = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsBorrarTabla.RHETEfhasta#">

						)
	</cfquery>
	<!----Eliminar las plazas actuales importadas para el escenario---->
	<cfquery datasource="#session.DSN#">
		delete from RHPlazasEscenario
		where Ecodigo = #session.Ecodigo#
		  and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">	
		  and RHPPid in (
						  select distinct RHPPid 
						  from RHSituacionActual 
						  where RHSAid in(<cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHSAids#" list="yes">)
						 )
		  and RHPEfinicioplaza = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsBorrarTabla.RHETEfdesde#">
		  and RHPEffinplaza = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsBorrarTabla.RHETEfhasta#">		
	</cfquery>
	<!----//////////////// ELIMINAR LA SITUACION ACTUAL //////////////////---->
	<!--- Eliminar los componentes de las plazas actuales importadas para escenario --->
	<cfquery datasource="#session.DSN#">
		delete from RHCSituacionActual
		where RHSAid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHSAids#" list="yes">)
	</cfquery>
	
	<!----Eliminar las plazas actuales importadas para el escenario---->
	<cfquery datasource="#session.DSN#">
		delete from RHSituacionActual
		where Ecodigo = #session.Ecodigo#
			and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
			and RHSAid in(<cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHSAids#" list="yes">)
	</cfquery>
	
	<!---<!--- Elimina Detalle Otras Partidas Con Distribusion por C. Funcional--->
	<cfquery datasource="#session.dsn#">
		delete from RHDOtrasPartidas
			from RHDOtrasPartidas dop
				inner join RHOtrasPartidas eop
					on eop.RHOPid = dop.RHOPid
					  and eop.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
				inner join RHPOtrasPartidas pop
					on pop.Ecodigo = eop.Ecodigo and pop.RHPOPid = eop.RHPOPid and pop.RHPOPdistribucionCF = 1
		where dop.CFid not in (select distinct CFid
					  from RHSituacionActual
					  where Ecodigo = #session.Ecodigo#
						and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
						and RHPPid is not null
					 )
	</cfquery>
	
	
	<!--- Elimina Encabezado Otras Partidas --->
	<cfquery datasource="#session.dsn#">
		delete from RHOtrasPartidas
		where RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
		 and (select count(1) from RHDOtrasPartidas dop where dop.RHOPid = RHOtrasPartidas.RHOPid) = 0
	</cfquery>--->
	
	<!--- Elimina Detalle Tabla Salarial --->
	<cfquery datasource="#session.DSN#">
		delete from RHDTablasEscenario
		where Ecodigo = #session.Ecodigo#
			and RHETEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHETEid#">
	</cfquery>
	
	<!--- Elimina Encabezado Tabla Salarial --->
	<cfquery datasource="#session.DSN#">
		delete from RHETablasEscenario
		where Ecodigo = #session.Ecodigo#
			and RHETEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHETEid#">
	</cfquery>

	</cftransaction>
</cfif>
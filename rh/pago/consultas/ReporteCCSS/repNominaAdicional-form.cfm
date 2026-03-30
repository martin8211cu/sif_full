<cfif isdefined("url.Periodo") and len(trim(url.Periodo))>
	<cfset form.CPperiodo = url.Periodo>
<cfelse>
	<cfset form.CPperiodo = form.Periodo>
</cfif>
<cfif isdefined("url.Mes") and len(trim(url.Mes))>
	<cfset form.CPmes = url.Mes>
<cfelse>
	<cfset form.CPmes = form.Mes>
</cfif>

<cfif form.CPmes eq 1>
	<cfset  Lvar_periodoA = form.CPperiodo - 1> 
	<cfset  Lvar_mesA = 12> 
<cfelse>
	<cfset  Lvar_periodoA = form.CPperiodo > 
	<cfset  Lvar_mesA = form.CPmes - 1> 
</cfif>
<cfif Lvar_mesA eq 1>
	<cfset  Lvar_periodoT = Lvar_periodoA - 1> 
	<cfset  Lvar_mesT = 12> 
<cfelse>
	<cfset  Lvar_periodoT = Lvar_periodoA > 
	<cfset  Lvar_mesT = Lvar_mesA - 1> 
</cfif>

<!--- Tabla temporal de calendario de pagos --->
	<cf_dbtemp name="TempAdd" returnvariable="TempAdd" datasource="#session.DSN#">
		<cf_dbtempcol name="DEid"    		type="numeric" 		mandatory="no">
		<cf_dbtempcol name="Ecodigo" 		type="Integer" 		mandatory="no">
		<cf_dbtempcol name="Salario" 		type="money" 		mandatory="no">
		<cf_dbtempcol name="Incidencias" 	type="money" 		mandatory="no">
		<cf_dbtempcol name="MONTO" 			type="money" 		mandatory="no">
		<cf_dbtempcol name="CPmes" 			type="Integer" 		mandatory="no">
		<cf_dbtempcol name="CPperiodo" 		type="Integer" 		mandatory="no">
		<cf_dbtempcol name="CLASEG" 		type="char(1)"		mandatory="no">
		<cf_dbtempcol name="APE1" 			type="char(20)" 	mandatory="no"> <!---  Primer Apellido--->
		<cf_dbtempcol name="APE2" 			type="char(20)" 	mandatory="no"> <!---  Segundo Apellido--->
		<cf_dbtempcol name="NOMBRE" 		type="char(60)" 	mandatory="no"> <!---  Nombre--->
		<cf_dbtempcol name="IDENTI" 		type="char(25)" 	mandatory="no"> <!---  Codigo de Identificacion--->
		<cf_dbtempindex cols="DEid">
		<cf_dbtempindex cols="CPmes,CPperiodo, DEid">
	</cf_dbtemp>



		<cfquery  datasource="#Session.DSN#" name="LZ">
			insert into  #TempAdd# (DEid, Ecodigo, Salario, CPmes, CPperiodo)
			select 
				pe.DEid, 
				#session.Ecodigo# as Ecodigo, 
				sum(PEmontores) as Montores, pe.CPmes, pe.CPperiodo
			from CalendarioPagos cp
				inner join  HPagosEmpleado pe
				on pe.RCNid  	= cp.CPid
			where cp.Ecodigo   	= #session.Ecodigo#
			  and cp.CPperiodo 	= #form.CPperiodo#
			  and cp.CPmes     	= #form.CPmes#
			 <!--- and cp.CPperiodo 	= pe.CPperiodo
			  and cp.CPmes 		= pe.CPmes--->
			  and cp.CPnocargasley 	= 0
			group by pe.DEid, pe.CPmes, pe.CPperiodo
		</cfquery>
		

		
		<!--- ***************************************************** ---> 
		<!--- les actualizo las incidencias                         --->
		<!--- ***************************************************** --->
		<cfquery datasource="#Session.DSN#">
			update #TempAdd# 
			set Incidencias = coalesce((
									select sum(ICmontores)
										from CalendarioPagos cp 
											inner join HIncidenciasCalculo ic
												on  ic.RCNid    = cp.CPid
											inner join CIncidentes ci
												on  ic.CIid     = ci.CIid
										where cp.Ecodigo        = #session.Ecodigo#
											and cp.CPperiodo    = #form.CPperiodo#
											and cp.CPmes        = #form.CPmes#
									<!---	and ic.CPperiodo 	= cp.CPperiodo
											and ic.CPmes 		= cp.CPmes	--->
											and cp.CPnocargasley 	= 0
											and ci.CInocargasley 	= 0
											and ic.DEid     		= #TempAdd#.DEid
											and ic.CPperiodo 	= #TempAdd#.CPperiodo
											and ic.CPmes 		= #TempAdd#.CPmes
						
									),0)
		</cfquery>
		
	<cfquery datasource="#Session.DSN#">
		delete from #TempAdd#
		where #TempAdd#.CPmes = #form.CPmes#
			and #TempAdd#.CPperiodo = #form.CPperiodo#
	</cfquery>

		
	<cfquery datasource="#Session.DSN#">
		update #TempAdd# set 
			  APE1 = (select a.DEapellido1 from DatosEmpleado a where a.DEid = #TempAdd#.DEid)
			, APE2 = (select a.DEapellido2 from DatosEmpleado a where a.DEid = #TempAdd#.DEid)
			, NOMBRE = (select a.DEnombre from DatosEmpleado a where a.DEid = #TempAdd#.DEid)
			, IDENTI = (select a.DEidentificacion from DatosEmpleado a where a.DEid = #TempAdd#.DEid)
			, MONTO = #TempAdd#.Incidencias + #TempAdd#.Salario
			where #TempAdd#.DEid = (select a.DEid from DatosEmpleado a where a.DEid = #TempAdd#.DEid)
	</cfquery>

		
	<!--- ******************************************************************************************---> 
	<!--- se actualiza El tipo de Seguro  (C = para todos (IVM+SEM), A = sólo pensionados (SEM) )   --->
	<!--- ******************************************************************************************---> 
	<cfquery datasource="#Session.DSN#">
		update #TempAdd#
		set CLASEG = 'A'
		where exists(
			select 1
			from DLaboralesEmpleado d
			inner join  RHTipoAccion t 
				on d.RHTid = t.RHTid
				and RHTpension = 1
				and RHTcomportam = 1			
			where d.DEid = #TempAdd#.DEid)
	</cfquery>

	<cfquery datasource="#Session.DSN#">
		update #TempAdd#
		set CLASEG = 'C'
		where CLASEG is null
	</cfquery>
	
	<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#" ecodigo="#session.Ecodigo#" pvalor="2043" default="" returnvariable="vCMagisterio"/>
	<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#" ecodigo="#session.Ecodigo#" pvalor="2044" default="" returnvariable="vIndRep"/>

	<cfif len(rtrim(ltrim(#vCMagisterio#)))  GT 0 >
		<cfquery datasource="#Session.DSN#">
			update #TempAdd#
			set CLASEG = '#vIndRep#'
			where #TempAdd#.DEid = (select DEid
											from CargasEmpleado
											where DEid = #TempAdd#.DEid
											and CEhasta is null
											and	DClinea = (select convert(numeric, Pvalor)
												from RHParametros
													where Pcodigo in (2043) and Ecodigo = #session.Ecodigo#))
		
		</cfquery>
	</cfif>
	
	<cfquery  datasource="#Session.DSN#" name="rsReporte">
		select <cf_dbfunction name="concat" args="APE1,' ',APE2,'  ',NOMBRE" > as nombre
			, sum(MONTO) as CorteMes
			,*
		from  #TempAdd# 
		group by CPmes, CPperiodo
		order by CPmes, CPperiodo, DEid
	</cfquery>

<!----================ PINTA EL REPORTE ================---->
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_PlanillaAdicional" Default="Reporte Planillas Adicionales" returnvariable="LB_PlanillaAdicional"/>
<cfinclude template="repNominaAdicional-rep.cfm">
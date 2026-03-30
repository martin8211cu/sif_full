	<cfset pre=''>
	<cfif isdefined("ckNominasHistoricas")>
	<cfset pre='H'>
	</cfif>
	<!--- convirtiendo numeros de lista de deduccion por form a una lista coldfusion--->
	<cfif isdefined("form.DeduccionesList") and len(trim(form.DeduccionesList)) GT 0>
	<cfset listaDeDeducciones=''>
		<cfloop list="#form.DeduccionesList#" index="i">
			<cfset listaDeDeducciones = listAppend(listaDeDeducciones, "'"&i&"'")>
		</cfloop>
	</cfif>	
	
	<cf_dbfunction name="OP_concat" returnvariable="concat">
	<cfquery datasource="#session.dsn#" name="rsdatos">
		select distinct se.DEid,rcn.RCNid,rcn.Tcodigo,rcn.RCDescripcion as nomina,rcn.RCdesde as fechaDesde,rcn.RChasta as fechaHasta,
		cf.CFid, cf.CFcodigo, cf.CFdescripcion, 
		de.DEidentificacion as cedula, de.DEnombre #concat#' '#concat# de.DEapellido1 #concat#' '#concat# de.DEapellido2 as nombre,
		<cfif radRep eq 3><!--- deducciones--->
		tde.TDdescripcion as descripcion, dc.DCvalor as monto
		<cfelseif radRep eq 4><!--- cargas---> 
		dc.DCdescripcion as descripcion, cc.CCvaloremp as monto, cc.CCvalorpat as monto2
		<cfelseif radRep eq 5><!--- incidencias--->
		ci.CIdescripcion as descripcion, ic.ICmontores as monto2, ic.ICvalor as monto
		</cfif>
		from #pre#RCalculoNomina rcn 
			inner join  #pre#SalarioEmpleado se
				on rcn.RCNid=se.RCNid 
			inner join DatosEmpleado de
				on se.DEid=de.DEid   
			<cfif radRep eq 3><!--- deducciones--->
			inner join #pre#DeduccionesCalculo dc
				on rcn.RCNid=dc.RCNid
			inner join DeduccionesEmpleado ded
				on dc.Did=ded.Did
				and se.DEid=ded.DEid
			 inner join TDeduccion tde
				on ded.TDid=tde.TDid
			<cfelseif radRep eq 4><!--- cargas--->
			inner join #pre#CargasCalculo cc
				on rcn.RCNid=cc.RCNid
				and se.DEid=cc.DEid 
			inner join DCargas dc
				on cc.DClinea=dc.DClinea	
			<cfelseif radRep eq 5><!--- incidencias--->
			inner join #pre#IncidenciasCalculo ic
				on rcn.RCNid=ic.RCNid
				and se.DEid=ic.DEid 
			inner join CIncidentes ci
				on ic.CIid=ci.CIid
			</cfif>
			left join LineaTiempo lt
				on rcn.Ecodigo=lt.Ecodigo
				and se.DEid=lt.DEid
				and lt.LTdesde <=rcn.RChasta
				and lt.LThasta >=rcn.RCdesde
			 inner join RHPlazas rhp
				on lt.RHPid = rhp.RHPid   
				and lt.Ecodigo=rhp.Ecodigo
			 inner join CFuncional cf
				on rhp.CFid=cf.CFid   
		where rcn.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			<cfif radRep eq 3><!--- deducciones--->
				and dc.DCvalor > 0
				<cfif isdefined("listaDeDeducciones") and len(trim(listaDeDeducciones)) GT 0>
				and tde.TDcodigo in (#preservesinglequotes(listaDeDeducciones)#)
				</cfif>
			<cfelseif radRep eq 4><!--- cargas---> 
				<cfif isdefined("form.CargasList") and len(trim(form.CargasList)) GT 0>
				and dc.DClinea in (#form.CargasList#)
				</cfif>
			<cfelseif radRep eq 5><!--- incidencias---> 
				<cfif isdefined("form.IncidenciasList") and len(trim(form.IncidenciasList)) GT 0>
				and ci.CIid in (#form.IncidenciasList#)
				</cfif>
			</cfif>
		
		<cfif isdefined("form.TcodigoList") and len(trim(form.TcodigoList)) GT 0>
			and rcn.RCNid in (#form.TcodigoList#)
		</cfif>
		
		<cfif isdefined("form.FechaDesde") and len(trim(form.FechaDesde)) GT 0 and isdefined("form.ckUtilizarFiltroFechas")>
			and rcn.RChasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.FechaDesde)#">
		</cfif>
		<cfif isdefined("form.FechaHasta") and len(trim(form.FechaHasta)) GT 0 and isdefined("form.ckUtilizarFiltroFechas")>
			and rcn.RCdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.FechaHasta)#">
		</cfif>
		 order by rcn.Tcodigo, rcn.RCdesde
	</cfquery>

	<cfinclude template="ReporteNominas-html.cfm">
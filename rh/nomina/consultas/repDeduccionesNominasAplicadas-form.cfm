<cfif isdefined("url.Periodo") and len(trim(url.Periodo))>
	<cfset form.Periodo = url.Periodo>
</cfif>
<cfif isdefined("url.Mes") and len(trim(url.Mes))>
	<cfset form.Mes = url.Mes>
</cfif>
<cfif isdefined("url.TDid") and len(trim(url.TDid))>
	<cfset form.TDid = url.TDid>
</cfif>

<cfset vs_tablaCalculo = 'HRCalculoNomina'>
<cfset vs_tablaDeducciones = 'HDeduccionesCalculo'>
	
	
<cfquery name="rsDeducciones" datasource="#session.DSN#">

Select DEid,CPperiodo,CPmes,DEidentificacion,Nombre,Ddescripcion,TDdescripcion,Dreferencia,TDid,sum(Monto) as Monto
 from(
	select c.DEid,a.CPperiodo,a.CPmes,
		d.DEidentificacion, 
		<cf_dbfunction name="concat" args="d.DEapellido1+' '+d.DEapellido2+'  '+d.DEnombre" delimiters="+"> as Nombre,
		e.Ddescripcion,f.TDdescripcion, e.Dreferencia,f.TDid, c.DCvalor as Monto
	from CalendarioPagos a inner join HRCalculoNomina b on a.CPid = b.RCNid 
		inner join HDeduccionesCalculo c on b.RCNid = c.RCNid
		inner join DatosEmpleado d on c.DEid = d.DEid
		inner join DeduccionesEmpleado e on d.DEid = e.DEid and c.Did = e.Did
		inner join TDeduccion f on e.TDid = f.TDid
	where 
		<cfif isdefined("form.Periodo")	and len(trim(form.Periodo)) and isdefined("form.Mes") and len(trim(form.Mes))>
			a.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Periodo#">
			and a.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Mes#">
			and f.TDid  = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.TDid#" >
		</cfif>	
		<cfif isdefined("form.FechaDesde")	and len(trim(form.FechaDesde)) and isdefined("form.FechaHasta") and len(trim(form.FechaHasta))>
			(a.CPdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.FechaDesde)#"> 
			and  a.CPhasta <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.FechaHasta)#">)
			and f.TDid  = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.TDid#" >
		</cfif>
Union All
	Select ld.DEid,year(dl.DLfvigencia) as CPperiodo,month(dl.DLfvigencia) as CPmes,
		de.DEidentificacion, 
		<cf_dbfunction name="concat" args="de.DEapellido1+' '+de.DEapellido2+'  '+de.DEnombre" delimiters="+"> as Nombre,
		td.TDdescripcion as Ddescripcion,td.TDdescripcion, 
		left((de.DEapellido1 + ' ' + de.DEapellido2 + ' ' + de.DEnombre),20) as Dreferencia,
		e.TDid, ld.importe as Monto
	from RHLiquidacionPersonal liq
		inner join DLaboralesEmpleado dl
			on liq.DLlinea = dl.DLlinea
			and liq.Ecodigo = dl.Ecodigo
			and dl.DEid = liq.DEid
		inner join DatosEmpleado de
			on de.DEid = dl.DEid
		inner join RHLiqDeduccion ld
			on ld.DLlinea = dl.DLlinea
			and dl.DEid = ld.DEid
		inner join DeduccionesEmpleado e 
			on ld.DEid = e.DEid and ld.Did = e.Did
		inner join TDeduccion td 
		on td.TDid = e.TDid
	where
			<cfif isdefined("form.Periodo")	and len(trim(form.Periodo)) and isdefined("form.Mes") and len(trim(form.Mes))>
			year(dl.DLfvigencia) = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Periodo#">
			and month(dl.DLfvigencia) = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Mes#">
			and e.TDid  = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.TDid#" >
		</cfif>	
		<cfif isdefined("form.FechaDesde")	and len(trim(form.FechaDesde)) and isdefined("form.FechaHasta") and len(trim(form.FechaHasta))>
			(dl.DLfvigencia >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.FechaDesde)#"> 
			and  dl.DLfvigencia <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.FechaHasta)#">)
			and e.TDid  = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.TDid#" >
		</cfif>
	) s
Group by DEid,CPperiodo,CPmes,DEidentificacion,Nombre,Ddescripcion,TDdescripcion,Dreferencia,TDid
order by Nombre
</cfquery>



<cfif isdefined("form.Periodo")	and len(trim(form.Periodo)) and isdefined("form.Mes") and len(trim(form.Mes))>
	<cfquery name="rsFechas" datasource="#session.DSN#">
		select min(CPdesde)as fdesde, max(CPhasta)as fhasta
		from CalendarioPagos a
		where CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Periodo#">
		and CPmes =	<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Mes#">
	</cfquery>
	<cfset fdesde = rsFechas.fdesde>
	<cfset fhasta = rsFechas.fhasta>
<cfelse>
	<cfset fdesde = form.FechaDesde>
	<cfset fhasta = form.FechaHasta>
</cfif>

<!----================ PINTA EL REPORTE ================---->
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ReporteDeDeduccionesNominasAplicadas" Default="Reporte de deducciones n&oacute;minas aplicadas" returnvariable="LB_ReporteDeDeduccionesNominasAplicadas"/>
<!---
<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#LB_ReporteDeDeduccionesNominasAplicadas#">
		<cfinclude template="/rh/portlets/pNavegacion.cfm">				
			<cfinclude template="repDeduccionesNominasAplicadas-rep.cfm">
	<cf_web_portlet_end>
<cf_templatefooter>--->
<cfinclude template="repDeduccionesNominasAplicadas-rep.cfm">
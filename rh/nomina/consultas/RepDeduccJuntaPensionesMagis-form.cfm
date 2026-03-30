<cfif isdefined("url.Periodo") and len(trim(url.Periodo))>
	<cfset form.Periodo = url.Periodo>
</cfif>
<cfif isdefined("url.Mes") and len(trim(url.Mes))>
	<cfset form.Mes = url.Mes>
</cfif>
<cfif isdefined("url.CPid") and len(trim(url.CPid))>
	<cfset form.CPid = url.CPid>
</cfif>
<cfif isdefined('url.muestraResum')>
	<cfset form.muestraResum = url.muestraResum >
</cfif>

<cfset vs_tablaCalculo = 'HRCalculoNomina'>
<cfset vs_tablaDeducciones = 'HDeduccionesCalculo'>

<cfquery name="rsDClineaMagis" datasource="#session.DSN#">
	select Pvalor
	from RHParametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	<!--- parametro en el q se guarda la carga del magisterio --->
	and Pcodigo = 2043
</cfquery>	
	
<cfif rsDClineaMagis.RecordCount >
	
<cfquery name="rsCargaAsocMagis" datasource="#session.DSN#">	
	select DClinea
	from DCargas
	where DClinea  = #rsDClineaMagis.Pvalor#
	and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>	
	
<cfquery name="rsDeducciones" datasource="#session.DSN#">
	select 
	    a.CPperiodo
		,a.CPmes		
		,d.DEidentificacion 
		,d.DEapellido1
		,d.DEapellido2
		,d.DEnombre
		,salEmpl.SEsalariobruto
		,RegVac.RVcodigo
		,HCargCal.CCvaloremp
		,HCargCal.CCvalorpat
	from CalendarioPagos a 
	
			inner join HRCalculoNomina b 
				on a.CPid = b.RCNid 			
				
			inner join HSalarioEmpleado salEmpl
				on salEmpl.RCNid = b.RCNid
								
			inner join HCargasCalculo HCargCal
				on 	salEmpl.RCNid = HCargCal.RCNid  
				and salEmpl.DEid  = HCargCal.DEid 
				
			inner join DatosEmpleado d 
				on salEmpl.DEid = d.DEid
				
			inner join LineaTiempo lt
				on lt.DEid = d.DEid
				and <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp"> between LTdesde and LThasta

					inner join RegimenVacaciones RegVac
						on lt.RVid = RegVac.RVid
						and lt.Ecodigo = RegVac.Ecodigo
													
				inner join DCargas DetallCarg
					on DetallCarg.DClinea = HCargCal.DClinea
					and DetallCarg.DClinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCargaAsocMagis.DClinea#">
								
	where  
		<cfif isdefined("form.Periodo")	and len(trim(form.Periodo)) and isdefined("form.Mes") and len(trim(form.Mes))>
			a.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Periodo#">
			and a.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Mes#">			
		</cfif>		
		 and a.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
		 
		order by RegVac.RVcodigo ,<cf_dbfunction name="concat" args="d.DEapellido1+' '+d.DEapellido2+'  '+d.DEnombre" delimiters="+">
</cfquery>
<!---<cf_dump var="#rsDeducciones#">--->

<cfelse>
<cfthrow message="Se debe configurar la carga para el Junta de Pensiones del Magisterio, en Parámetros Generales, Tab Otros opción Carga paraMagisterio">

</cfif> 
<!----================ PINTA EL REPORTE ================---->
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ReporteDeDeduccionesMagisterio" Default="Reporte de las deducciones de la Junta de Pensiones del Magisterio Nacional " returnvariable="LB_ReporteDeDeduccionesMagisterio"/>

<cfinclude template="RepDeduccJuntaPensionesMagis-rep.cfm">
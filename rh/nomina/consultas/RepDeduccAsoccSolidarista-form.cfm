<!---<cf_dump var="#form#">--->

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
	
<!--- FILAS PARA LAS DEDUCCIONES DE LA ASOCIACION SOLIDARISTA --->
<cfquery name="rsColumDinamiDeduccAsoc" datasource="#session.DSN#">
	select RHCRPTid,RHCRPTcodigo,RHCRPTdescripcion
	from RHReportesNomina a
	inner join RHColumnasReporte b
		on b.RHRPTNid = a.RHRPTNid 
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and a.RHRPTNcodigo = 'ASOCT'
</cfquery>	

										
<cfquery name="rsTodaslasTDid" datasource="#session.DSN#">		
	select distinct TDid	
	from RHReportesNomina a
		inner join RHColumnasReporte b		
			on b.RHRPTNid = a.RHRPTNid
			
		inner join RHConceptosColumna ConcepColum	
			 on ConcepColum.RHCRPTid = b.RHCRPTid
			 and ConcepColum.TDid is not null
			 
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and a.RHRPTNcodigo = 'ASOCT'		
</cfquery>
<!---<cf_dump var="#rsTodaslasTDid#">--->
	
<cfif rsTodaslasTDid.RecordCount >
	<cfset Lvar_TDid = ValueList(rsTodaslasTDid.TDid)>
											
<cfquery name="rsDeducciones" datasource="#session.DSN#">
		select  d.DEidentificacion ,d.DEnombre ,d.DEapellido1 ,d.DEapellido2 ,a.CPid ,d.DEid 
			from CalendarioPagos a 
			
				inner join HRCalculoNomina b 
					on b.RCNid= a.CPid 
					and b.Ecodigo = a.Ecodigo 
			
				inner join HSalarioEmpleado salEmpl 
					on salEmpl.RCNid = b.RCNid 
				
				inner join DatosEmpleado d 
					on d.DEid = salEmpl.DEid 
					and d.Ecodigo = a.Ecodigo 
			
				inner join HDeduccionesCalculo HDeduccCal 
					on HDeduccCal.DEid = salEmpl .DEid 
					and HDeduccCal.RCNid = salEmpl .RCNid 
			
					inner join DeduccionesEmpleado deduccEmpl 
						on deduccEmpl.Did = HDeduccCal.Did 
						and deduccEmpl.DEid = HDeduccCal.DEid
			
						inner join TDeduccion c 
							on c.TDid = deduccEmpl.TDid 
							and c.TDid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_TDid#" list="yes">) 
							
				where  a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					<cfif isdefined("form.Periodo")	and len(trim(form.Periodo)) and isdefined("form.Mes") and len(trim(form.Mes))>
						and a.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Periodo#">
						and a.CPmes   = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Mes#">	
					</cfif>					
				and a.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">		 
					
				order by d.DEapellido1 + ' ' + d.DEapellido2 + ' ' + d.DEnombre 
	</cfquery>
	<cfelse>
	<cfthrow message="No existen Conceptos de Deducción asociados a los Reportes Dinámicos, Debe asociar los conceptos de Deduccion correspondiente..">
	
</cfif>

<!---<cf_dump var="#rsDeducciones#">--->


<!----================ PINTA EL REPORTE ================---->
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ReporteDeDeduccionesAsoc" Default="Reporte de las deducciones de la Asociaci&oacute;n Solidarista " returnvariable="LB_ReporteDeDeduccionesAsoc"/>

<cfinclude template="RepDeduccAsoccSolidarista-rep.cfm">
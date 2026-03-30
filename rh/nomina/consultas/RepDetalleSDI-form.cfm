<cfset FechaInicio 	=  createdate(#form.periodo#,#form.mes#,01)>
<cfset FechaFinal 	=  dateadd('m',2,#FechaInicio#-1)>

<cfinvoke component="rh.Componentes.RH_ReporteCalculoSDI" method="CargarDatos" returnvariable="rsDatosEmpleado">	
	<cfinvokeargument name="FInicio" 		value="#FechaInicio#">
	<cfinvokeargument name="FFinal"	 		value="#FechaFinal#">
    <cfinvokeargument name="MesInic"	 	value="#form.mes#">
    <cfinvokeargument name="PeriodoInic"	value="#form.periodo#">
    <cfinvokeargument name="Tcodigo"		value="#form.Tcodigo#">
    
</cfinvoke>

<cfquery name="rsTnomina" datasource="#session.dsn#">
    select Tcodigo, Tdescripcion
    from TiposNomina
    where Ecodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
    and Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Tcodigo#">
</cfquery>

<!----================ PINTA EL REPORTE ================---->
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ReporteSalarioDiarioIntegradoBimestre" Default="Reporte de Salario Diario Integrado Bimestre" returnvariable="LB_ReporteSalarioDiarioIntegradoBimestre"/>


<cfif #form.tReporte# EQ 1>
	<cfinclude template="RepDetalleSDI-Resumen-rep.cfm">
<cfelse>
	<cfinclude template="RepDetalleSDI-rep.cfm">
</cfif>
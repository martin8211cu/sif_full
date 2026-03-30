<cfset FechaInicio 	=  createdate(#form.periodo#,#form.mes#,01)>
<cfset FechaFinal 	=  dateadd('m',2,#FechaInicio#-1)>

<cfinvoke component="rh.Componentes.RH_ReporteCalculoSDI_IDSE" method="CargarDatos" returnvariable="rsDatosEmpleado">
	<cfinvokeargument name="FInicio" 			value="#FechaInicio#">
	<cfinvokeargument name="FFinal"	 			value="#FechaFinal#">
    <cfinvokeargument name="MesInic"	 		value="#form.mes#">
    <cfinvokeargument name="PeriodoInic"		value="#form.periodo#">
    <cfinvokeargument name="Tcodigo"			value="#form.Tcodigo#">
	<cfinvokeargument name="ValidaOfiOEmp"		value="#rePatOfi#">
    <cfinvokeargument name="RegistroPatronal"	value="#regpat#">

</cfinvoke>

<cfquery name="rsTnomina" datasource="#session.dsn#">
    select Tcodigo, Tdescripcion
    from TiposNomina
    where Ecodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
    and Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Tcodigo#">
</cfquery>

<!----================ PINTA EL REPORTE ================---->
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ReporteSalarioDiarioIntegradoBimestre" Default="Reporte de Modificacion de  Salario Diario Integrado Bimestre" returnvariable="LB_ReporteSalarioDiarioIntegradoBimestre"/>

<cfinclude template="RepSDI_IDSE_B-rep.cfm">

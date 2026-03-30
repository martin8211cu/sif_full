<cfset FechaIni 	=  lsdateformat(#form.FechaInicio#,'yyyymmdd')>
<cfset FechaFinal 	=  dateadd('m',2,#FechaInicio#-1)>

<cfset RegistroPatronal = #regPat#> <!---Registro Patronal IMSS --->
<cfset ValidaOfiOEmp = #rePatOfi#> <!---Con esta variable se si es un registro por ofina o no --->

<!---<cfthrow message = "#FechaIni#">--->

<!---<cfinvoke component="rh.Componentes.RH_ReporteCalculoSDI_IDSE" method="CargarDatos" returnvariable="rsDatosEmpleado">
	<cfinvokeargument name="FInicio" 		value="#FechaInicio#">
	<cfinvokeargument name="FFinal"	 		value="#FechaFinal#">
    <cfinvokeargument name="MesInic"	 	value="#form.mes#">
    <cfinvokeargument name="PeriodoInic"	value="#form.periodo#">
    <cfinvokeargument name="Tcodigo"		value="#form.Tcodigo#">

</cfinvoke>--->

<cfquery name="rsTnomina" datasource="#session.dsn#">
    select Tcodigo, Tdescripcion
    from TiposNomina
    where Ecodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
    and Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Tcodigo#">
</cfquery>


<cfquery name ="rsDatosEmpleado" datasource="#session.dsn#">
	SELECT LTRIM(RTRIM(DESeguroSocial)) as NSS,LTRIM(RTRIM(DEapellido1)) as apepat,LTRIM(RTRIM(DEapellido2)) apemat,
    LTRIM(RTRIM(DEnombre)) as nombres,DEsdi as sdi, LTdesde as fecha, DEidentificacion as numEmp, curp
 	FROM DatosEmpleado de left join LineaTiempo lt  on de.DEid = lt.DEid
	<!--- esto es mi código +++++++++++++++++++++++++++++++++++++++++++ --->
	<cfif ValidaOfiOEmp eq "1">
		inner join oficinas o
		on o.Ocodigo = lt.Ocodigo
	</cfif>
	<!--- esto es mi código +++++++++++++++++++++++++++++++++++++++++++ --->
	where de.Ecodigo = #session.Ecodigo# and LTdesde ='#FechaIni#' and lt.Tcodigo=#form.Tcodigo#
	<!--- esto es mi código +++++++++++++++++++++++++++++++++++++++++++ --->
	<cfif ValidaOfiOEmp eq "1">
		and o.Onumpatronal = '#RegistroPatronal#'
	</cfif>
	<!--- esto es mi código +++++++++++++++++++++++++++++++++++++++++++ --->

</cfquery>

<!----================ PINTA EL REPORTE ================---->
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ReporteSalarioDiarioIntegradoBimestre" Default="Reporte de Modificacion de  Salario Diario Integrado Bimestre" returnvariable="LB_ReporteSalarioDiarioIntegradoBimestre"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_NoSeEncontraronRegistros" Default="No Se Encontraron Registros" returnvariable="LB_NoSeEncontraronRegistros"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ULTIMALINEA" Default="ULTIMA LINEA" returnvariable="LB_ULTIMALINEA"/>


<cfinclude template="RepSDI_IDSE-rep.cfm">

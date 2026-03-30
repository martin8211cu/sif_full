
<!--- 
	Modificado por : Rodolfo Jimenez Jara, ROJIJA
	Fecha: 06 de Enero del 2005
	Motivo: Creación del reporte  de empleados Inactivos --->
<!--- cfquery --->

<cfif isdefined("Url.CFcodigo") and not isdefined("Url.CFdescripcion")>
	<cfquery name="rsCFuncional" datasource="#session.DSN#">
		select CFid , CFdescripcion
		from CFuncional
		where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and CFcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Url.CFcodigo#">
	</cfquery>
	<cfif isdefined("rsCFuncional") and rsCFuncional.RecordCount NEQ 0>
		<cfset VarCFid = rsCFuncional.CFid>
	</cfif>
<cfelseif isdefined("Url.CFid") and len(trim(Url.CFid)) and isdefined("Url.CFdescripcion")>
	<cfset VarCFid = Url.CFid>
</cfif>


<cfquery name="rsReporte" datasource="#session.DSN#">
	select    
		a.DEidentificacion  as DEidentificacion, 
		{fn concat({fn concat({fn concat({fn concat(a.DEapellido1,' ')},a.DEapellido2)},' ')},a.DEnombre)} as NombreCompleto,
		DEfechanac as DEfechanac,
		e.CFid,
		e.CFcodigo, 
		e.CFdescripcion, 
		b.LThasta, 
		EVfvacas as EVfvacas,
		EVfvacas as EVfanual
	from DatosEmpleado a
		inner join LineaTiempo b
			on a.DEid = b.DEid
			<cfif isdefined("Url.Corte") and len(trim(Url.Corte))>
				<!--- Empleados Activos a esa fecha --->
				and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Url.Corte)#">  between b.LTdesde and b.LThasta 
			<cfelse>
				<!--- Empleados Activos a hoy --->
				and <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp"> between b.LTdesde and b.LThasta
			</cfif>
		inner join  RHPlazas d
			on d.RHPid = b.RHPid
		inner join CFuncional e
			on d.CFid = e.CFid
		inner join Empresas f
			on a.Ecodigo =  f.Ecodigo
		left outer join EVacacionesEmpleado eve
			on a.DEid = eve.DEid
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			<cfif isdefined ("VarCFid")and len(trim(VarCFid))>
				and d.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#VarCFid#">
			</cfif>
			<cfswitch expression="#Url.Cumplimiento#">
				<cfcase value="A"> 
					and <cf_dbfunction name="date_part" args="MM,eve.EVfvacas"> = <cfqueryparam cfsqltype="cf_sql_integer" value="#Url.mes#">
					<cfif isdefined("Url.dia") and trim(Url.dia) GT 0>
				   		and <cf_dbfunction name="date_part" args="DD,eve.EVfvacas"> <= <cfqueryparam cfsqltype="cf_sql_integer" value="#Url.dia#">
					</cfif>
					order by 4, eve.EVfvacas
				</cfcase>
				<cfcase value="V"> 
					and <cf_dbfunction name="date_part" args="MM,eve.EVfvacas"> = <cfqueryparam cfsqltype="cf_sql_integer" value="#Url.mes#">
					<cfif isdefined("Url.dia") and trim(Url.dia) GT 0>
				   		and <cf_dbfunction name="date_part" args="DD,eve.EVfvacas"> <= <cfqueryparam cfsqltype="cf_sql_integer" value="#Url.dia#">
					</cfif>
					order by 4, eve.EVfvacas
				</cfcase>
			</cfswitch>
			
</cfquery>

<cfif rsReporte.recordcount GT 1500>
	<br>
	<br>
	<cf_translate  key="LB_SeGeneroUnReporteMasGrandeDeLoPermitido">Se genero un reporte más grande de lo permitido.  Se abortó el proceso</cf_translate>
	<br>
	<br>
	<cfabort>
<cfelseif rsReporte.recordcount NEQ 0>
	<!--- <cf_dump var="#form#"> --->
	<!--- Define cual reporte va a llamar --->
	<cfset archivo = "EmpleAnualVac.cfr">
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Hasta"
	Default="Hasta :"
	returnvariable="LB_Hasta"/> 

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Todos"
	Default="Todos"
	returnvariable="LB_Todos"/> 	
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ConsultaDeVacacionesDeEmpleados"
	Default="Consulta de Vacaciones de Empleados"
	returnvariable="LB_ConsultaDeVacacionesDeEmpleados"/> 
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ConsultaDeAnualidadesDeEmpleados"
	Default="Consulta de Anualidades de Empleados"
	returnvariable="LB_ConsultaDeAnualidadesDeEmpleados"/>	
	
	<cfset LvarCantidad = rsReporte.recordcount > 
	<cfif isdefined("Url.Corte") and len(trim(Url.Corte))>
		<cfset LvarDescFechas = LB_Hasta & Url.Corte>
	<cfelse>
		<cfset LvarDescFechas = LB_Todos>
	</cfif>
	<cfif isdefined("Url.Cumplimiento") and Url.Cumplimiento EQ "V">
		<cfset LvarTitulo = LB_ConsultaDeVacacionesDeEmpleados>
		<cfset LvarTipo = 'V'>
	<cfelse>
		<cfset LvarTitulo = LB_ConsultaDeAnualidadesDeEmpleados>
		<cfset LvarTipo = 'A'>
	</cfif>
	
	<cfquery name="rsEmpresa" datasource="#session.DSN#">
		select Edescripcion 
		from Empresas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>
	<!--- INVOCA EL REPORTE --->
	
	<cfreport format="#Url.formato#" template= "#archivo#" query="rsReporte">
		<cfreportparam name="Ecodigo" value="#session.Ecodigo#">
		<cfreportparam name="Edescripcion" value="#rsEmpresa.Edescripcion#">
		<cfreportparam name="DescFechas" value="#LvarDescFechas#">
		<cfreportparam name="Cantidad" value="#LvarCantidad#">
		<cfreportparam name="Tipo" value="#LvarTipo#">
		<cfreportparam name="Titulo" value="#LvarTitulo#">
	</cfreport>

<cfelseif rsReporte.recordcount EQ 0>
	<br>
	<br>
	<cf_translate  key="LB_NoSeGeneroUnReporteSegunLosFiltrosDados">No se generó un reporte según los filtros dados. Por favor intente de nuevo.</cf_translate>
	<br>
	<br>
	<cfabort>
</cfif>



<!--- 
	Modificado por : Rodolfo Jimenez Jara, ROJIJA
	Fecha: 06 de Enero del 2005
	Motivo: Creación del reporte  de empleados Inactivos --->
<!--- cfquery --->

<cfif isdefined("form.CFcodigo") and not isdefined("form.CFdescripcion")>
	<cfquery name="rsCFuncional" datasource="#session.DSN#">
		select CFid , CFdescripcion
		from CFuncional
		where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and CFcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CFcodigo#">
	</cfquery>
	<cfif isdefined("rsCFuncional") and rsCFuncional.RecordCount NEQ 0>
		<cfset VarCFid = rsCFuncional.CFid>
	</cfif>
<cfelseif isdefined("form.CFid") and len(trim(form.CFid)) and isdefined("form.CFdescripcion")>
	<cfset VarCFid = form.CFid>
</cfif>

<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cfquery name="rsReporte" datasource="#session.DSN#">
	select    a.DEidentificacion  as DEidentificacion , a.DEapellido1 #LvarCNCT# ' ' #LvarCNCT# a.DEapellido2 #LvarCNCT# ', ' #LvarCNCT# a.DEnombre as NombreCompleto
	, DEfechanac as DEfechanac  
	, e.CFid ,e.CFcodigo, e.CFdescripcion, b.LThasta, EVfvacas as EVfvacas ,EVfanual as EVfanual
	from DatosEmpleado a
		inner join LineaTiempo b
			on a.DEid = b.DEid
		<cfif isdefined("form.Corte") and len(trim(form.Corte))>
			and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.Corte)#">  between b.LTdesde and b.LThasta -- Empleados Activos a esa fecha
		<cfelse>
			and getdate() between b.LTdesde and b.LThasta -- Empleados Activos a hoy		
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
		<cfswitch expression="#form.Cumplimiento#">
			<cfcase value="A"> 
				and datepart(mm,eve.EVfanual) = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.mes#">
				<cfif isdefined("form.dia") and trim(form.dia) GT 0>
				   and datepart(dd,eve.EVfanual) <= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.dia#">
				</cfif>
				order by 4, eve.EVfanual
			</cfcase>
			<cfcase value="V"> 
				and datepart(mm,eve.EVfvacas) = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.mes#">
				<cfif isdefined("form.dia") and trim(form.dia) GT 0>
				   and datepart(dd,eve.EVfvacas) <= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.dia#">
				</cfif>
				order by 4, eve.EVfvacas
			</cfcase>
		</cfswitch>
</cfquery>

<cfif rsReporte.recordcount GT 1500>
	<br>
	<br>
	Se genero un reporte más grande de lo permitido.  Se abortó el proceso
	<br>
	<br>
	<cfabort>
<cfelseif rsReporte.recordcount NEQ 0>
	<!--- <cf_dump var="#form#"> --->
	<!--- Define cual reporte va a llamar --->
	<cfset archivo = "EmpleAnualVac.cfr">
	
	<cfset LvarCantidad = rsReporte.recordcount > 
	<cfif isdefined("form.Corte") and len(trim(form.Corte))>
		<cfset LvarDescFechas = 'Hasta :' & form.Corte>
	<cfelse>
		<cfset LvarDescFechas = 'Todos'>
	</cfif>
	<cfif isdefined("form.Cumplimiento") and form.Cumplimiento EQ "V">
		<cfset LvarTitulo = "Consulta de Vacaciones de Empleados">
		<cfset LvarTipo = 'V'>
	<cfelse>
		<cfset LvarTitulo = "Consulta de Anualidades de Empleados">
		<cfset LvarTipo = 'A'>
	</cfif>
	
	<cfquery name="rsEmpresa" datasource="#session.DSN#">
		select Edescripcion 
		from Empresas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>
	<!--- INVOCA EL REPORTE --->
	
	<cfreport format="#form.formato#" template= "#archivo#" query="rsReporte">
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
	No se generó un reporte según los filtros dados. Por favor intente de nuevo.
	<br>
	<br>
	<cfabort>
</cfif>



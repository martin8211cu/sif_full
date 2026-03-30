<!--- 
	Modificado por : Rodolfo Jimenez Jara, ROJIJA
	Fecha: 05 de Enero del 2005
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
	
		
	select    de.DEidentificacion  as DEidentificacion , de.DEapellido1 #LvarCNCT# ' ' #LvarCNCT# de.DEapellido2 #LvarCNCT# ', ' #LvarCNCT# de.DEnombre as NombreCompleto
		, e.CFid ,e.CFcodigo, e.CFdescripcion,  max(b.LThasta) as LThasta
	from DatosEmpleado de
			inner join LineaTiempo b
				on de.DEid = b.DEid
				and not exists(
					select 1
					from LineaTiempo lt
					where lt.DEid = de.DEid
					<cfif isdefined("form.CumpleHasta") and len(trim(form.CumpleHasta))>
						and  <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.CumpleHasta)#"> between LTdesde and LThasta
					<cfelse>
						and getdate() between LTdesde and LThasta
					</cfif>
					)
			inner join  RHPlazas d
				on d.RHPid = b.RHPid
			inner join CFuncional e
				on d.CFid = e.CFid
			inner join Empresas f
				on de.Ecodigo =  f.Ecodigo
	where de.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and exists
		(
		select 1
		from DLaboralesEmpleado dl
			inner join RHTipoAccion ta
				on ta.RHTid = dl.RHTid
				and ta.RHTcomportam = 1 --- Nombramiento
		where dl.DEid = de.DEid
			<cfif isdefined("form.CumpleHasta") and len(trim(form.CumpleHasta))>
				 and dl.DLfvigencia <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.CumpleHasta)#"> 
			<cfelse>
				 and dl.DLfvigencia <= getdate() 
			</cfif>

		)
		 <cfif isdefined ("VarCFid")and len(trim(VarCFid))>
			and d.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#VarCFid#">
		</cfif>
	group by de.DEidentificacion  , de.DEapellido1 #LvarCNCT# ' ' #LvarCNCT# de.DEapellido2 #LvarCNCT# ', ' #LvarCNCT# de.DEnombre , e.CFid ,e.CFcodigo, e.CFdescripcion
	order by 3, b.LThasta

</cfquery>

<cfif rsReporte.recordcount GT 1500>
	<br>
	<br>
	Se genero un reporte más grande de lo permitido.  Se abortó el proceso
	<br>
	<br>
	<cfabort>
<cfelseif rsReporte.recordcount NEQ 0>
		
	<!--- Define cual reporte va a llamar --->
	<cfset archivo = "EmpleInactivos.cfr">
	
	<cfset LvarCantidad = rsReporte.recordcount > 
	<cfif isdefined("form.CumpleHasta") and len(trim(form.CumpleHasta))>
		<cfset LvarDescFechas = 'Hasta :' & form.CumpleHasta>
	<cfelse>
		<cfset LvarDescFechas = 'Todos'>
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
	</cfreport>

<cfelseif rsReporte.recordcount EQ 0>
	<br>
	<br>
	No se generó un reporte según los filtros dados. Por favor intente de nuevo.
	<br>
	<br>
	<cfabort>
</cfif>



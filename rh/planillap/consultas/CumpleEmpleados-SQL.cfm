<!--- 
	Modificado por : Rodolfo Jimenez Jara, ROJIJA
	Fecha: 05 de Enero del 2005
	Motivo: Creación del reporte  de Cumpleaños de Empleados  --->
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


<cfquery name="rsReporte" datasource="#session.DSN#">
	select    a.DEidentificacion  as DEidentificacion , a.DEapellido1 || ' ' || a.DEapellido2 || ', ' || a.DEnombre as NombreCompleto
	, DEfechanac as DEfechanac  
	, e.CFid ,e.CFcodigo, e.CFdescripcion, b.LThasta
	from DatosEmpleado a
		inner join LineaTiempo b
			on a.DEid = b.DEid
			and getdate() between b.LTdesde and b.LThasta -- Empleados Activos
		inner join  RHPlazas d
			on d.RHPid = b.RHPid
		inner join CFuncional e
			on d.CFid = e.CFid
		inner join Empresas f
			on a.Ecodigo =  f.Ecodigo
		
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		 <cfif isdefined ("VarCFid")and len(trim(VarCFid))>
			and d.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#VarCFid#">
		</cfif>
			
		<cfif isdefined("form.optCumple") and form.optCumple EQ 0> <!--- Cumpleaños de Hoy --->
			and  a.DEfechanac = <cfqueryparam cfsqltype="cf_sql_date" value="#LSPARSEDATETIME(LSDateFormat(now(),"DD/MM/YYYY"))#">  
		<cfelseif isdefined("form.optCumple") and form.optCumple EQ 1> <!--- Cumpleaños de esta semana --->
			and datepart(wk,a.DEfechanac) = datepart(wk,<cfqueryparam cfsqltype="cf_sql_date" value="#LSPARSEDATETIME(LSDateFormat(now(),"DD/MM/YYYY"))#">)
		<cfelse><!--- Cumpleaños del mes --->
			and datepart(mm,a.DEfechanac) = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.mes#">
		</cfif>
		
		order by 4, a.DEfechanac

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
	<cfset archivo = "CumpleEmpleados.cfr">
	
	<cfset LvarCantidad = rsReporte.recordcount > 
	<cfif isdefined("form.optCumple") and form.optCumple GTE 0>
		<cfswitch expression="#form.optCumple#">
				<cfcase value="0"> 
					<cfset Hoy = LSDateFormat(now(), "dd/mm/yyyy")>
					<cfset LvarDescFechas = Hoy>			
				</cfcase>
				<cfcase value="1"> 
					<!---	DateAdd(datepart, number, date)
							DayOfWeek(date) 

					 --->
					
					<cfset IniSemana = LSDateFormat(DateAdd('d', (-1*DayOfWeek(now())+1), now()), "dd/mm/yyyy")>
					<cfset FinSemana = LSDateFormat(DateAdd('d', (-1*DayOfWeek(now()))+7, now()), "dd/mm/yyyy")> 
					
					<cfset LvarDescFechas = 'Semana del ' & IniSemana & ' al ' & FinSemana>
				</cfcase>
				<cfcase value="2"> 
				
					<cfset IniMes = LSDateFormat(CreateDate(datepart('yyyy',now()), form.mes, 1),"dd/mm/yyyy")>
					<cfset mesSig = CreateDate(datepart('yyyy',now()), form.mes+1, 1)>
					<cfset FinMes = LSDateFormat(DateAdd('d', -1, mesSig), "dd/mm/yyyy")> 
				
					<cfset LvarDescFechas = ' Desde ' & IniMes & ' hasta el ' & FinMes >
				</cfcase>
			</cfswitch>
		
		<!--- <cfdump var="#IniSemana#">
		<cf_dump var="#FinSemana#"> --->
		
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



<!--- 
	Modificado por : Rodolfo Jimenez Jara
	Fecha: 02 de Enero del 2005
	Motivo: Creación del reporte  del cumplimiento de fechas por empleado --->
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

<cfif isdefined('form.CumpleDesde') and len(trim(form.CumpleDesde))>
	<cfset diadesde = 0>
	<cfset mesdesde = 0>
	<cfset diadesde = datepart('d', LSParseDateTime(form.CumpleDesde))>
	<cfset mesdesde = datepart('m', LSParseDateTime(form.CumpleDesde))>
	<cfset LvarCumpleDesde = diadesde & mesdesde>		

	<cfset LvarDescFechas = 'Desde el dia: ' & diadesde & ' del mes: ' & mesdesde>

</cfif>

<cfif isdefined('form.CumpleHasta') and len(trim(form.CumpleHasta))>
	<cfset diahasta = 0>
	<cfset meshasta = 0>
	<cfset diahasta = datepart('d', LSParseDateTime(form.CumpleHasta))>
	<cfset meshasta = datepart('m', LSParseDateTime(form.CumpleHasta))>
 	<cfset LvarCumpleHasta = diahasta & meshasta>								
	<cfif isdefined('LvarDescFechas') and len(trim(LvarDescFechas))>
		<cfset LvarDescFechas = LvarDescFechas & ' Hasta el día: ' & diahasta & ' del mes: ' & meshasta>
	<cfelse>
		<cfset LvarDescFechas = ' Hasta el día: ' & diahasta & ' del mes: ' & meshasta>
	</cfif>
	
</cfif>

<cfswitch expression="#form.Cumplimiento#">
	<cfcase value="C"> <cfset LvarCumplimiento = 'Cumpleaños'> </cfcase>
	<cfcase value="A"> <cfset LvarCumplimiento = 'Anuales'> </cfcase>
	<cfcase value="V"> <cfset LvarCumplimiento = 'Vacaciones'> </cfcase>
	<cfcase value="I"> <cfset LvarCumplimiento = 'Ingreso'> </cfcase>
</cfswitch>

<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cfquery name="rsReporte" datasource="#session.DSN#">
	select    a.DEidentificacion  as DEidentificacion , a.DEapellido1 #LvarCNCT# ' ' #LvarCNCT# a.DEapellido2 #LvarCNCT# ', ' #LvarCNCT# a.DEnombre as NombreCompleto
	, DEfechanac as DEfechanac , EVfvacas as EVfvacas ,EVfanual as EVfanual, min(DLfechaaplic) as ingreso
	, e.CFid ,e.CFcodigo, e.CFdescripcion
	from DatosEmpleado a
		inner join LineaTiempo b
			on a.DEid = b.DEid
		<cfif form.Estado EQ "A">
			and getdate() between b.LTdesde and b.LThasta -- Empleados Activos
		<cfelseif form.Estado EQ "I">
			and getdate() > b.LThasta -- Empleados Inactivos
		</cfif>
		inner join  RHPlazas d
			on d.RHPid = b.RHPid
		inner join CFuncional e
			on d.CFid = e.CFid
		inner join Empresas f
			on a.Ecodigo =  f.Ecodigo
		left outer join EVacacionesEmpleado eve
			on a.DEid = eve.DEid
		left outer join DLaboralesEmpleado dle
			on a.Ecodigo = dle.Ecodigo
			and a.DEid = dle.DEid
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		 <cfif isdefined ("VarCFid")and len(trim(VarCFid))>
			and d.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#VarCFid#">
		 </cfif>
		<cfif isdefined("form.CumpleDesde") and len(trim(form.CumpleDesde)) and isdefined("form.CumpleHasta") and len(trim(form.CumpleHasta))>
			<cfswitch expression="#form.Cumplimiento#">
				<cfcase value="C"> 
					and (datepart(dd,a.DEfechanac) between #diadesde# and #diahasta#
					and datepart(mm,a.DEfechanac) between #mesdesde# and #meshasta#)
				</cfcase>
				<cfcase value="A"> 
					and (datepart(dd,eve.EVfanual) between #diadesde# and #diahasta#
					and datepart(mm,eve.EVfanual) between #mesdesde# and #meshasta#)
				</cfcase>
				<cfcase value="V"> 
					and (datepart(dd,eve.EVfvacas) between #diadesde# and #diahasta#
					and datepart(mm,eve.EVfvacas) between #mesdesde# and #meshasta#)
				</cfcase>
				<cfcase value="I"> 
					and (datepart(dd,dle.DLfechaaplic) between #diadesde# and #diahasta#
					and datepart(mm,dle.DLfechaaplic) between #mesdesde# and #meshasta#)
				</cfcase>
			</cfswitch>
		 
		<cfelseif isdefined("form.CumpleDesde") and len(trim(form.CumpleDesde))>
			<cfswitch expression="#form.Cumplimiento#">
				<cfcase value="C"> 
					and (datepart(dd,a.DEfechanac) >= #diadesde# 
					and datepart(mm,a.DEfechanac) >= #mesdesde# )
				</cfcase>
				<cfcase value="A"> 
					and (datepart(dd,eve.EVfanual) >= #diadesde# 
					and datepart(mm,eve.EVfanual) >= #mesdesde# )
				</cfcase>
				<cfcase value="V"> 
					and (datepart(dd,eve.EVfvacas) >= #diadesde# 
					and datepart(mm,eve.EVfvacas) >= #mesdesde# )
				</cfcase>
				<cfcase value="I"> 
					and (datepart(dd,dle.DLfechaaplic) >= #diadesde# 
					and datepart(mm,dle.DLfechaaplic) >= #mesdesde# )
				</cfcase>
			</cfswitch>
		 
		 <cfelseif isdefined("form.CumpleHasta") and len(trim(form.CumpleHasta))>
			<cfswitch expression="#form.Cumplimiento#">
				<cfcase value="C"> 
					and (datepart(dd,a.DEfechanac) <= #diahasta# )
					and (datepart(mm,a.DEfechanac) <= #meshasta# )
				</cfcase>
				<cfcase value="A"> 
					and (datepart(dd,eve.EVfanual) <= #diahasta# )
					and (datepart(mm,eve.EVfanual) <= #meshasta# )
				</cfcase>
				<cfcase value="V"> 
					and (datepart(dd,eve.EVfvacas) <= #diahasta# )
					and (datepart(mm,eve.EVfvacas) <= #meshasta# )
				</cfcase>
				<cfcase value="I"> 
					and (datepart(dd,dle.DLfechaaplic) <= #diahasta# )
					and (datepart(mm,dle.DLfechaaplic) <= #meshasta# )
				</cfcase>
			</cfswitch>
		 </cfif>
		 group by a.DEidentificacion  , a.DEapellido1 #LvarCNCT# ' ' #LvarCNCT# a.DEapellido2 #LvarCNCT# ', ' #LvarCNCT# a.DEnombre, DEfechanac, EVfvacas, EVfanual, e.CFid , e.CFcodigo, e.CFdescripcion
		 <cfswitch expression="#form.Cumplimiento#">
			<cfcase value="C"> 
				order by 7, a.DEfechanac
			</cfcase>
			<cfcase value="A"> 
				order by 7, eve.EVfanual
			</cfcase>
			<cfcase value="V"> 
				order by 7, eve.EVfvacas
			</cfcase>
			<cfcase value="I"> 
				order by 7, dle.DLfechaaplic
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
		
	<!--- Define cual reporte va a llamar --->
	<cfset archivo = "CumpleFechas.cfr">
	
	<cfif form.Estado EQ "A">
		<cfset LvarEstado = ' Activos'>
	<cfelseif form.Estado EQ "I">
		<cfset LvarEstado = ' Inactivos'> 
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
		<cfreportparam name="Cumplimiento" value="#LvarCumplimiento#">
		<cfreportparam name="Tipo" value="#form.Cumplimiento#">
		<cfreportparam name="DescFechas" value="#LvarDescFechas#">
		<cfreportparam name="Estado" value="#LvarEstado#">
	</cfreport>

<cfelseif rsReporte.recordcount EQ 0>
	<br>
	<br>
	No se generó un reporte según los filtros dados. Por favor intente de nuevo.
	<br>
	<br>
	<cfabort>
</cfif>



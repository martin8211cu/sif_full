	<cfset hoy = Now()>
	<cfset InicioSemana = Dateadd('d', 1-DayOfWeek(hoy), hoy)>
	<cfset FinalSemana  = Dateadd('d', 7-DayOfWeek(hoy), hoy)>
	<cfset InicioMMDD   = DateFormat(InicioSemana,'MMDD')>
	<cfset FinalMMDD    = DateFormat(FinalSemana,'MMDD')>
	
	<cfquery datasource="#session.dsn#" name="cumpleanos_mes" maxrows="1">
		select count(1) as cant
		from DatosEmpleado
		where <cf_dbfunction name="date_part" args="MM,DEfechanac"> = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Month(Now())#">
		  and Ecodigo in (
			select Ecodigo
			from Empresas
			where cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">)
	</cfquery>
	<cfquery datasource="#session.dsn#" name="cumpleanos_semana" maxrows="1">
		select count(1) as cant
		from DatosEmpleado
		where <cf_dbfunction name="date_part" args="MM,DEfechanac">*100+<cf_dbfunction name="date_part" args="DD,DEfechanac">
			between <cfqueryparam cfsqltype="cf_sql_numeric" value="#InicioMMDD#">
				and <cfqueryparam cfsqltype="cf_sql_numeric" value="#FinalMMDD#">
		  and Ecodigo in (
			select Ecodigo
			from Empresas
			where cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">)
	</cfquery>
	<cfquery datasource="#session.dsn#" name="cumpleanos_dia" maxrows="1">
		select count(1) as cant
		from DatosEmpleado
		where <cf_dbfunction name="date_part" args="MM,DEfechanac"> = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Month(Now())#">
		  and <cf_dbfunction name="date_part" args="DD,DEfechanac"> = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Day(Now())#">
		  and Ecodigo in (
			select Ecodigo
			from Empresas
			where cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">)
	</cfquery>
	
	<cfset rango_cumple = "">
	
	<cfquery datasource="#session.dsn#" name="cumpleanos_feliz" maxrows="20">
		select DEfechanac, DEnombre, DEapellido1, DEapellido2
		from DatosEmpleado
		where Ecodigo in (
			select Ecodigo
			from Empresas
			where cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">)
		<cfif cumpleanos_mes.cant GE 1 And cumpleanos_mes.cant LE 20 or cumpleanos_semana.cant IS 0>
			<!--- mensual  --->
			  and <cf_dbfunction name="date_part" args="MM,DEfechanac"> = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Month(Now())#">
			  <cfset rango_cumple = 'Cumpleaños del Mes'>
			  <cfset cant_cumple = cumpleanos_mes.cant>
		<cfelseif cumpleanos_semana.cant GE 1 And cumpleanos_semana.cant LE 20 or cumpleanos_dia.cant IS 0>
			<!--- semanal --->
			  and <cf_dbfunction name="date_part" args="MM,DEfechanac">*100+<cf_dbfunction name="date_part" args="DD,DEfechanac">
				between <cfqueryparam cfsqltype="cf_sql_numeric" value="#InicioMMDD#">
					and <cfqueryparam cfsqltype="cf_sql_numeric" value="#FinalMMDD#">
			  <cfset rango_cumple = 'Cumpleaños esta Semana'>
			  <cfset cant_cumple = cumpleanos_semana.cant>
		<cfelse>
			<!--- diario --->
			  and <cf_dbfunction name="date_part" args="MM,DEfechanac"> = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Month(Now())#">
			  and <cf_dbfunction name="date_part" args="DD,DEfechanac"> = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Day(Now())#">
			  <cfset rango_cumple = 'Cumpleaños del Día'>
			  <cfset cant_cumple = cumpleanos_dia.cant>
		</cfif>
		order by <cf_dbfunction name="date_part" args="DD,DEfechanac">, upper(DEnombre)
	</cfquery>
	<cfset capitalizar = CreateObject("Component", "capitalizar")>
	<div style="width:162px;overflow:hidden" >
	<table align="center" height="130" width="162" style="width:162px;overflow:hidden" border="0" cellspacing="0" cellpadding="0">
	<tr>
	<td align="center" width="100%">
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		<tr><td nowrap class='TituloListas'><cfoutput>#rango_cumple#</cfoutput></td></tr>
		<cfoutput query="cumpleanos_feliz">
			<cfset LvarListaNon = CurrentRow Mod 2>
			<tr class=<cfif LvarListaNon>"listaNon"<cfelse>"listaPar"</cfif> 
				onmouseover="this.className='listaParSel';" 
				onmouseout="this.className='<cfif LvarListaNon>listaNon<cfelse>listaPar</cfif>';">
				<td nowrap class=<cfif LvarListaNon>"listaNon"<cfelse>"listaPar"</cfif>>#capitalizar.capitalizar(DEnombre)# #capitalizar.capitalizar(DEapellido1)#  #capitalizar.capitalizar(DEapellido2)#</td>
			</tr>
		</cfoutput>
		</table>
	</td>
	</tr>
	</table></div>
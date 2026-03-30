<!---
	Modificado por : Rodolfo Jimenez Jara, ROJIJA
	Fecha: 05 de Enero del 2005
	Motivo: Creación del reporte  de Cumpleaños de Empleados  --->
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




<cfset fechaActual = LSParseDateTime(LSDateFormat(now(),'dd/mm/yyyy'))>

<cfquery name="rsReporte" datasource="#session.DSN#">
	select  a.DEidentificacion  as DEidentificacion , {fn concat({fn concat({fn concat({fn concat(a.DEapellido1 , ' ' )}, a.DEapellido2 )}, ' ' )}, a.DEnombre )} as NombreCompleto
	, LTdesde as LTdesde
	, e.CFid ,e.CFcodigo, e.CFdescripcion, b.LThasta,
	#YEAR(now())# - DATEPART(YEAR, b.LTdesde) AS anios
	from DatosEmpleado a
		inner join LineaTiempo b
			on a.DEid = b.DEid
			and <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp"> between b.LTdesde and b.LThasta <!--- -- Empleados Activos --->
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

		AND #YEAR(now())# - DATEPART(YEAR, b.LTdesde) > 0

		<cfif isdefined("Url.optCumple") and Url.optCumple EQ 0>
			<!--- Aniversario de Hoy --->
			and <cf_dbfunction name="date_part" args="DD,b.LTdesde"> = <cf_dbfunction name="date_part" args="DD,#fechaActual#">
			and <cf_dbfunction name="date_part" args="MM,b.LTdesde"> = <cf_dbfunction name="date_part" args="MM,#fechaActual#">
		<cfelseif isdefined("Url.optCumple") and Url.optCumple EQ 1>
			<!--- Aniversario de esta semana --->
			and <cf_dbfunction name="date_part" args="WK,b.LTdesde"> = <cf_dbfunction name="date_part" args="WK,#fechaActual#">
		<cfelse>
			<!--- Aniversario del mes --->
			and <cf_dbfunction name="date_part" args="MM,b.LTdesde"> = <cfqueryparam cfsqltype="cf_sql_integer" value="#Url.mes#">
		</cfif>

		order by 4, b.LTdesde

</cfquery>

<cfif rsReporte.recordcount GT 1500>
	<br>
	<br>
	<cf_translate  key="LB_SeGeneroUnReporteMasGrandeDeLoPermitido">Se genero un reporte más grande de lo permitido.  Se abortó el proceso</cf_translate>
	<br>
	<br>
	<cfabort>
<cfelseif rsReporte.recordcount NEQ 0>

	<!--- Define cual reporte va a llamar --->
	<cfset archivo = "CumpleAniversarioEmpleados.cfr">
	<cfset LvarCantidad = rsReporte.recordcount >
	<cfif isdefined("Url.optCumple") and Url.optCumple GTE 0>
		<cfswitch expression="#Url.optCumple#">
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
				    <cfset IniMes = LSDateFormat(CreateDate(datepart('yyyy',now()), Url.mes, 1),"dd/mm/yyyy")>
				    <!--- 	LZ 2006-12-07 Se modifica esta consulta, porque cuando llega a sacar el
				    		Reporte de Diciembre se cae, porque supone que sigue el mes 13, se modifico la sentencia  --->
				    <cfif Url.mes LT 12>
						<cfset mesSig = CreateDate(datepart('yyyy',now()), Url.mes+1, 1)>
					<cfelse>
						<cfset mesSig = CreateDate(datepart('yyyy',dateAdd('yyyy',1,now())), 1, 1)>
					</cfif>
					<cfset FinMes = LSDateFormat(DateAdd('d', -1, mesSig), "dd/mm/yyyy")>
					<cfset LvarDescFechas 	= 'Desde ' & IniMes & ' hasta el ' & FinMes >
					<cfset LvarDescFechasXLS = '<cf_translate key="LB_Desde">Desde</cf_translate> ' & IniMes & ' <cf_translate key="LB_HastaEl">hasta el</cf_translate> ' & FinMes >

				</cfcase>
			</cfswitch>

	</cfif>

	<cfquery name="rsEmpresa" datasource="#session.DSN#">
		select Edescripcion
		from Empresas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>
	<!--- INVOCA EL REPORTE --->
	<cfif isdefined("Url.formato") and Url.formato neq 'Excel'>
		<cfreport format="#Url.formato#" template= "#archivo#" query="rsReporte">
			<cfreportparam name="Ecodigo" value="#session.Ecodigo#">
			<cfreportparam name="Edescripcion" value="#rsEmpresa.Edescripcion#">
			<cfreportparam name="DescFechas" value="#LvarDescFechas#">
			<cfreportparam name="Cantidad" value="#LvarCantidad#">
		</cfreport>
	<cfelse>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_ConsultaAniversarioLaboral"
			Default="Consulta de Aniversario Laboral"
			returnvariable="LB_ConsultaAniversarioLaboral"/>

		<cfcontent type="application/vnd.ms-excel">
		<cfheader 	name="Content-Disposition"
			value="attachment;filename=Natalicios_#session.Usucodigo#_#LSDateFormat(now(), 'yyyymmdd')#_#LSTimeFormat(now(),'HHMmSs')#.xls" >
		<cfset getPageContext().getResponse().setHeader("Cache-Control", "public")>

		<style type="text/css">
			.xl24
			{mso-style-parent:style0;
			mso-number-format:"dd\/mm\/yyyy\;\@";}
			.xl25
			{mso-style-parent:style0;
			mso-number-format:"\@";}
		</style>
		<table width="100%" cellpadding="2" cellspacing="0" align="center" border="0">
			<cfoutput>
			<tr>
				<td colspan="3">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;" align="center" class="areaFiltro">
					<tr>
						<td colspan="3" nowrap align="center" ><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">#Session.Enombre#</strong></td>
					</tr>
					<tr><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">
						<td colspan="3" nowrap align="center"><strong style="font-family:'Times New Roman', Times, serif; font-size:13pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">#LB_ConsultaDeCumpleannosDeEmpleados#</strong></td>		</strong>
					</tr>

					<tr>
						<td  colspan="3"  align="center" class="LetraTitulo">
							<b><cf_translate key="LB_Cumpleanos">Cumpleaños</cf_translate></b>:&nbsp;
							<cfif isdefined("Url.optCumple") and url.optCumple EQ 0>
								#LSDateFormat(fechaActual,'dd/mm/yyyy')#
							<cfelseif isdefined("Url.optCumple") and url.optCumple EQ 1>
								#LvarDescFechas#
							<cfelse>
								#LvarDescFechasXLS#
							</cfif>
					  </td>
					</tr>
					<tr>
						<td colspan="3"  align="center" class="LetraTitulo">
							<b><cf_translate key="LB_Empleados">Empleados</cf_translate></b>:&nbsp;
							#rsReporte.recordCount#
					  </td>
					</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td colspan="3">&nbsp;</td>
			</tr>
			</cfoutput>
			<cfoutput query="rsReporte" group="CFid">
					<tr>
					<td colspan="3"><b>
					  <cf_translate key="LB_CentroFuncional">Centro Funcional</cf_translate></b>:&nbsp; #trim(CFcodigo) & " - " & trim(CFdescripcion)#</td>
					</tr>
					<tr>
						<td width="20%" bgcolor="##CCCCCC"><b><cf_translate key="LB_Cedula">C&eacute;dula</cf_translate></b></td>
						<td width="60%" bgcolor="##CCCCCC"><b>
					  <cf_translate key="LB_NombreEmpleado">Nombre del Empleado</cf_translate></b></td>
						<td width="20%" align="left" bgcolor="##CCCCCC"><b>
					  <cf_translate key="LB_CentroFuncional">Fecha de Cumplea&ntilde;os</cf_translate></b></td>

					</tr>
				<cfset cantempleados = 0>
				<cfoutput>
					<tr>
						<td align="left" class="xl25"> #DEidentificacion#</td>
						<td>#NombreCompleto#</td>
						<td align="left" class="xl24">#LSDateFormat(LTdesde, "DD/MM/YYYY")#</td>
					</tr>
					<cfset cantempleados = cantempleados + 1 >
  				</cfoutput>
				<tr>
					<td colspan="3"></td>
				</tr>
				<tr>
					<td colspan="2"  bgcolor="##CCCCCC"><b>
						<cf_translate key="LB_TotalEmpleado">Total Empleados</cf_translate></b>:&nbsp; #trim(CFcodigo) & " - " & trim(CFdescripcion)# </td>
				 	<td bgcolor="##CCCCCC" align="right"> #cantempleados#</td>
				</tr>
				<tr>
					<td colspan="3">&nbsp;</td>
				</tr>
			</cfoutput>
		</table>


	</cfif>

<cfelseif rsReporte.recordcount EQ 0>
	<!--- EN CASO DE NO OBTENER REGISTROS, SE ENVIA ALERTA Y SE REGRESA A LA PAG. PRINCIPAL --->
	<script language="javascript">
		alert('No existe información para generar el reporte!');
		document.location = 'CumpleAniversarioLaboral.cfm';
	</script>
</cfif>



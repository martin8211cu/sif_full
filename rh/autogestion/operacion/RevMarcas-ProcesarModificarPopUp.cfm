<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title><cf_translate key="LB_RecursosHumanos" XmlFile="/rh/generales.xml">Recursos Humanos</cf_translate></title>
</head>
<body>
<cfsilent>
<!--- Esta pantalla requiere el Url.CAMid --->
<cfparam name="Url.CAMid" type="numeric">
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Feriado"
	Default="Feriado"
	returnvariable="LB_Feriado"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Modificacion_de_Marcas_del_Reloj"
	Default="Modificaci&oacute;n de Marcas del Reloj"
	returnvariable="LB_Modificacion_de_Marcas_del_Reloj"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_MontoDeFeriado"
	Default="Monto de feriado"
	returnvariable="LB_MontoDeFeriado"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_HorasExtraB"
	Default="Horas extra B"
	returnvariable="LB_HorasExtraB"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_HorasExtraA"
	Default="Horas extra A"
	returnvariable="LB_HorasExtraA"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_HorasNormales"
	Default="Horas normales"
	returnvariable="LB_HorasNormales"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_HorasARebajar"
	Default="Horas a  rebajar"
	returnvariable="LB_HorasARebajar"/>
<cfquery name="rsEmpleado" datasource="#session.DSN#">
	select 	{fn concat({fn concat({fn concat({fn concat(b.DEapellido1 , ' ' )}, b.DEapellido2 )},  ' ' )}, b.DEnombre)} as Empleado, 
			a.CAMfdesde, a.CAMfhasta, a.CAMid,
			case when a.RHJid is not null then 
				c.RHJdescripcion
			else
				'#LB_Feriado#'
			end as Jornada,
			coalesce(round(<cf_dbfunction name="to_float" args="coalesce(a.CAMtotminutos,1)">/60.00, 2),0) as HorasTotales,
			coalesce(round(<cf_dbfunction name="to_float" args="coalesce(a.CAMociominutos,1)">/60.00, 2),0) as TiempoOcio,
			coalesce(round(<cf_dbfunction name="to_float" args="coalesce(a.CAMtotminlab,1)">/60.00, 2),0) as HorasLaboradas,
			coalesce(a.CAMsuphorasreb,0) as CAMsuphorasreb,
			coalesce(a.CAMsuphorasjornada,0) as CAMsuphorasjornada,
			coalesce(a.CAMsuphorasextA,0) as CAMsuphorasextA,
			coalesce(a.CAMsuphorasextB,0) as CAMsuphorasextB,
			coalesce(a.CAMsupmontoferiado,0) as CAMsupmontoferiado,
			a.DEid
	from RHCMCalculoAcumMarcas a
		inner join DatosEmpleado b
			on a.DEid = b.DEid
			and a.Ecodigo = b.Ecodigo
		left outer join RHJornadas c
			on a.RHJid = c.RHJid
			and a.Ecodigo = c.Ecodigo
		inner join RHCMEmpleadosGrupo d
				on a.DEid = d.DEid
				and a.Ecodigo = d.Ecodigo
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.CAMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CAMid#">
</cfquery>
</cfsilent>
<cf_templatecss>
<!--- Se pinta la información del Empleado con el portlet de empleados de rh (la variable form.DEid es requerida por el portlet) --->
<cfset form.DEid = rsEmpleado.DEid>
<cfinclude template="/rh/portlets/pEmpleado.cfm">
<table align="center" width="95%" border="0" cellpadding="0" cellspacing="0"><tr><td>
<cf_web_portlet_start titulo="#LB_Modificacion_de_Marcas_del_Reloj#">
<cfoutput>
	<form name="form1" method="post" action="RevMarcas-ProcesarModificarPopUp-sql.cfm">
		<input type="hidden" name="CAMid" value="#url.CAMid#">
			<table width="100%" cellpadding="2" cellspacing="0">
				<tr>
					<td width="31%" align="right" nowrap><strong><cf_translate key="LB_FechaDesde">Fecha desde</cf_translate>:&nbsp;</strong></td>
					<td width="25%">#LSDateFormat(rsEmpleado.CAMfdesde,'dd/mm/yyyy')#</td>
					<td width="16%" align="right" nowrap><strong>#LB_HorasARebajar#:&nbsp;</strong></td>
					<td width="28%">
						<cf_inputNumber name="CAMsuphorasreb" value="#LSCurrencyFormat(rsEmpleado.CAMsuphorasreb,'none')#" enteros="2" decimales="2" tabindex="1">
					</td>
				</tr>
				<tr>
					<td align="right" nowrap><strong><cf_translate key="LB_FechaHasta">Fecha hasta</cf_translate>:&nbsp;</strong></td>
					<td>#LSDateFormat(rsEmpleado.CAMfhasta,'dd/mm/yyyy')#</td>
					<td align="right" nowrap><strong>#LB_HorasNormales#:&nbsp;</strong></td>
					<td>
						<cf_inputNumber name="CAMsuphorasjornada" value="#LSCurrencyFormat(rsEmpleado.CAMsuphorasjornada,'none')#" enteros="2" decimales="2" tabindex="1">
					</td>
				</tr>
				<tr>
					<td align="right" nowrap><strong><cf_translate key="LB_Jornada">Jornada</cf_translate>:&nbsp;</strong></td>
					<td >#rsEmpleado.Jornada#</td>
					<td align="right" nowrap><strong>#LB_HorasExtraA#:&nbsp;</strong></td>
					<td>
						<cf_inputNumber name="CAMsuphorasextA" value="#LSCurrencyFormat(rsEmpleado.CAMsuphorasextA,'none')#" enteros="2" decimales="2" tabindex="1">
					</td>
				</tr>
				<tr>
					<td align="right" nowrap><strong><cf_translate key="LB_HorasTotales">Horas totales</cf_translate>:&nbsp;</strong></td>
					<td >#rsEmpleado.HorasTotales#</td>
					<td align="right" nowrap><strong>#LB_HorasExtraB#:&nbsp;</strong></td>
					<td>
						<cf_inputNumber name="CAMsuphorasextB" value="#LSCurrencyFormat(rsEmpleado.CAMsuphorasextB,'none')#" enteros="2" decimales="2" tabindex="1">
					</td>
				</tr>
				<tr>
					<td align="right" nowrap><strong><cf_translate key="LB_TiempoOcioso">Tiempo Ocioso</cf_translate>:&nbsp;</strong></td>
					<td >#rsEmpleado.TiempoOcio#</td>
					<td align="right" nowrap><strong>#LB_MontoDeFeriado#:&nbsp;</strong></td>
					<td>
						<cf_inputNumber name="CAMsupmontoferiado" value="#LSCurrencyFormat(rsEmpleado.CAMsupmontoferiado,'none')#" enteros="2" decimales="2" tabindex="1">
					</td>
				</tr>
				<tr>
					<td align="right" nowrap><strong><cf_translate key="LB_HorasLaboradas">Horas laboradas</cf_translate>:&nbsp;</strong></td>
					<td >#rsEmpleado.HorasLaboradas#</td>
				</tr>
			</table>
			<cf_botones modo="CAMBIO" include="Cerrar" exclude="Nuevo">
	</form>
	<cf_qforms>
		<cf_qformsrequiredfield args="CAMsuphorasreb,#LB_HorasARebajar#"/>
		<cf_qformsrequiredfield args="CAMsuphorasjornada,#LB_HorasNormales#"/>
		<cf_qformsrequiredfield args="CAMsuphorasextA,#LB_HorasExtraA#"/>
		<cf_qformsrequiredfield args="CAMsuphorasextB,#LB_HorasExtraB#"/>
		<cf_qformsrequiredfield args="CAMsupmontoferiado,#LB_MontoDeFeriado#"/>
	</cf_qforms>
	<script type="text/javascript" language="javascript1.2">
		<!--//
		function funcCerrar(){
			window.close();
		}
		//-->
	</script>
</cfoutput>
<cf_web_portlet_end>
</td></tr></table>
</body>
</html>
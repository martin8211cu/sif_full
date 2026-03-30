<cf_templatecss>
<link href="/cfmx/plantillas/portal_asp2/portal.css" rel="stylesheet" type="text/css">

<cfoutput>
<cfparam name="url.fecha" default="">
<cfif REFind('^[0-9]{2}/[0-9]{2}/[0-9]{4}$', url.fecha) is 0>
	<cfset url.fecha = DateFormat(Now(), 'DD/MM/YYYY')>
</cfif>

<cfset ComponenteAgenda = CreateObject("Component", "home.Componentes.Agenda")>
<cfset CodigoAgenda = ComponenteAgenda.MiAgenda() >

<!--- fecha/hora de la cita en proceso --->
<!---
<cfquery name="CitaEnCurso" datasource="asp" maxrows="1">
  select max(c.inicio) as cita_actual 
	from ORGCita c, ORGAgendaCita ac
	where ac.agenda = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CodigoAgenda#">
	  and ac.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	  and c.CEcodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	  and c.fecha     = <cfqueryparam cfsqltype="cf_sql_date"    value="#LSParseDateTime(url.fecha)#">
	  and c.cita      *= ac.cita
	  and c.inicio <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
</cfquery>
--->


<cfset fecha = CreateDateTime(DatePart("yyyy", now()), DatePart("m", now()), DatePart("d", now()), '00', '00','00') >

<cfset Fechaini = CreateDateTime(DatePart("yyyy", url.fecha),  DatePart("m", url.fecha),DatePart("d", url.fecha), '00', '00','00') >
<cfset FechaFin = CreateDateTime(DatePart("yyyy", url.fecha),  DatePart("m", url.fecha),DatePart("d", url.fecha), '23', '59','59') >

<!--- cita siguientes y la que esta en proceso (si la hay)--->
<cfquery datasource="asp" name="data" maxrows="5">
	select c.cita, c.fecha, c.inicio, c.final, 
		c.texto, c.url_link, c.origen, c.referencia,
		ac.agenda, ac.confirmada, ac.notificar, ac.eliminada,
		case	when ac.confirmada = 0 then 0
				when exists (select * from ORGAgendaCita ot
					where ot.cita = ac.cita
					  and ot.CEcodigo = ac.CEcodigo
					  and ot.confirmada = 0)
					then 0
				else 1 end as TodosVan,
		case	when ac.eliminada = 1 then 1
				when exists (select * from ORGAgendaCita ot
					where ot.cita = ac.cita
					  and ot.CEcodigo = ac.CEcodigo
					  and ot.eliminada = 1)
					then 1
				else 0 end as AlguienElimino
	from ORGAgendaCita ac, ORGCita c
	where ac.agenda = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CodigoAgenda#">
	  and ac.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	  and c.CEcodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	  and c.fecha     between  <cfqueryparam cfsqltype="cf_sql_timestamp"    value="#Fechaini#"> and  <cfqueryparam cfsqltype="cf_sql_timestamp"    value="#FechaFin#">
	  and c.cita      = ac.cita
	  and c.inicio >= <cfqueryparam cfsqltype="cf_sql_date" value="#fecha#">
	  

	order by c.inicio, ac.agenda
</cfquery>

<table width="162"  border="0" cellspacing="0" cellpadding="2">
	<tr>
		<td width="1" class="tituloListas">&nbsp;</td>
		<td width="35" class="tituloListas">&nbsp;</td>
		<td width="123" class="tituloListas">Asunto</td>
	</tr>
	
	<cfif data.recordcount gt 0>
		<cfset corte = '' >
		<cfloop query="data">
			<cfif comparenocase(corte,data.texto) neq 0 >
				<tr>
					<td valign="top">
						<cfset hora = LSTimeFormat(inicio,'hh:mm') >
						<a href="agenda.cfm?fecha=#url.fecha#">#hora#</a>
					</td>
					<td colspan="2"><a href="agenda.cfm?fecha=#url.fecha#" target="_top" title="#HTMLEditFormat(data.texto)#"><div style="width:110;overflow:hidden;white-space:nowrap">#HTMLEditFormat(data.texto)#</div></a></td>
				</tr>
			</cfif>
			<cfset corte = data.texto > 
		</cfloop>
	<cfelse>
		<tr >
			<td colspan="3" align="center"><a href="javascript:void(0)" target="_top" title="No tiene actividades pendientes"><cf_translate key="agenda_no_actividades_pendientes" xmlFile="/home/menu/general.xml">No tiene actividades pendientes</cf_translate></a></td>
		</tr>
	</cfif>

	<tr >
		<td colspan="3">
			<table width="20%" border="0" cellpadding="0" cellspacing="0" align="center">
				<td width="1%" align="right" valign="middle"><a href="agenda.cfm?fecha=#url.fecha#" target="_top" title="Modificar mi agenda"><img border="0" src="ftv4doc.gif" alt="Ver/Modificar mi agenda"></a></td>
				<td align="left" nowrap valign="middle" ><a href="agenda.cfm?fecha=#url.fecha#" target="_top" title="Ver/Modificar mi agenda"><strong>Ver mi agenda</strong></a></td>
			</table>
		</td>
	</tr>

	<!---
	<tr>
		<td colspan="3">
			<table width="20%" cellpadding="0" cellspacing="0">
				<td width="1%" align="right" valign="middle"><a href="Horario.cfm" target="_top" title="Modificar mi Horario"><img border="0" src="ftv4doc.gif" alt="Modificar mi Horario"></a></td>
				<td align="left" nowrap valign="middle"><a href="Horario.cfm" target="_top" title="Modificar mi Horario"><strong>Modificar mi Horario</strong></a></td>
			</table>
		</td>
	</tr>
	--->

</table>

</cfoutput>

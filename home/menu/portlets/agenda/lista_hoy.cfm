<cfoutput>
<cfparam name="url.fecha" default="">
<cfif REFind('^[0-9]{2}/[0-9]{2}/[0-9]{4}$', url.fecha) is 0>
	<cfset url.fecha = DateFormat(Now(), 'DD/MM/YYYY')>
</cfif>

<cfset ComponenteAgenda = CreateObject("Component", "home.Componentes.Agenda")>
<cfset CodigoAgenda = ComponenteAgenda.MiAgenda() >
<cfset dataHoy = ComponenteAgenda.ListarCitas(CodigoAgenda, LSParseDateTime(url.fecha), true)>
<cfquery dbtype="query" name="data">
	select * 
	from dataHoy
	where cita > 0
</cfquery>

<cf_web_portlet skin="portlet" titulo="Pendientes para Hoy">
<table width="162"  border="0" cellspacing="0" cellpadding="2">
	<tr>
		<td width="2" class="tituloListas">&nbsp;</td>
		<td width="36" class="tituloListas">&nbsp;</td>
		<td width="124" class="tituloListas">Asunto</td>
	</tr>
	
	<cfloop query="data">
		<tr class="listaNon">
			<td>&nbsp;</td>
			<td>
				<cfset hora = LSTimeFormat(inicio,'hh:mm') >
				<a href="javascript:void(0)">#hora#</a>
			</td>
			<td><a href="javascript:void(0)" title="#data.texto#">#data.texto#</a></td>
		</tr>
	</cfloop>
</table>
</cf_web_portlet>

</cfoutput>

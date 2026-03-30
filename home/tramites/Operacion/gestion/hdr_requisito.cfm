<cfoutput>
<cfinvoke component="home.tramites.componentes.tramites"
	method="detalle_tramite"
	id_persona="#url.id_persona#"
	id_tramite="#url.id_tramite#"
	id_requisito="#url.id_requisito#"
	returnvariable="Dtramite" />

<table width="260" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td colspan="2" bgcolor="##ECE9D8" style="padding:3px; border-bottom:1px solid black; border-top:1px solid black; "><strong>Requisito</strong></td>
	</tr>
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr>
		<td colspan="2"><strong> </strong>#Dtramite.nombre_requisito#</td>
	</tr>
	<tr>
		<td><img src="/cfmx/home/tramites/images/#Dtramite.img#" width="16" height="16" border="0" alt="#Dtramite.img#" title="#Dtramite.estado#"></td>
		<td>#Dtramite.Estado#</td>
	</tr>
	<cfif Len(Trim(Dtramite.fecha_registro))>
		<tr>
			<td><strong>Fecha :</strong></td>
			<td>#LSDateFormat(Dtramite.fecha_registro,'dd/mm/yyyy')#</td>
		</tr>
	</cfif>
	<cfif Len(Trim(Dtramite.nombre_funcionario))>
		<tr>
			<td colspan="2"><strong>Recibido por :</strong> </td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td>#Dtramite.nombre_funcionario#</td>
	  	</tr>
	</cfif>
</table>
</cfoutput>

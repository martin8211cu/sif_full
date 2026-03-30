<style type="text/css">
	.letra{ color: #293d6b;
			font-weight:bold;  }
</style> 

<table width="100%" cellpadding="2" cellspacing="0">

<cfoutput query="instancia" group="nombre_paso">
	<tr bgcolor="##c8d7e3">
		<td style="cursor:pointer;"  width="5%" nowrap class="letra"  >#instancia.paso_numero#</td>
		<td colspan="3" style="cursor:pointer;" class="letra"  >#instancia.nombre_paso#</td>
	</tr>

	<cfset i = 1 >
	<cfoutput>
		<tr id="tr_#instancia.id_requisito#" class="<cfif i mod 2>listaPar<cfelse>listaNon</cfif>" onmouseover="this.className='listaParSel';" onmouseout="this.className='<cfif i mod 2>listaPar<cfelse>listaNon</cfif>';" >
			<td width="10" align="center"><img id="img#instancia.id_requisito#" style="display: <cfif isdefined("url.id_requisito")><cfif url.id_requisito eq instancia.id_requisito>block<cfelse>none</cfif><cfelseif i eq 1>block<cfelse>none</cfif>;" src="/cfmx/home/tramites/images/tri-closed.gif"></td>
			<td width="16"><a href="javascript: informacion(#instancia.id_requisito#,'#JSStringFormat(instancia.nombre_requisito)#'); "><img src="../../images/#img#" width="16" height="16" border="0" alt="#img#" title="#estado#"></a></td>
			<td width="16" align="center"><a href="javascript: informacion(#instancia.id_requisito#,'#JSStringFormat(instancia.nombre_requisito)#'); " >#CurrentRow#.</a></td>
			<td width="376"><a href="javascript: informacion(#instancia.id_requisito#,'#JSStringFormat(instancia.nombre_requisito)#'); " >#instancia.nombre_requisito#</a></td>
		</tr>
		<cfset i = i + 1 >
	</cfoutput>
</cfoutput>
</table>


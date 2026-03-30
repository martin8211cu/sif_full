<cfoutput>
<table width="100%" cellpadding="2" cellspacing="0">

<cfloop query="instancia">
	<tr id="tr_#instancia.id_requisito#" class="<cfif instancia.currentrow mod 2>listaPar<cfelse>listaNon</cfif>" onmouseover="this.className='listaParSel';" onmouseout="this.className='<cfif instancia.currentrow mod 2>listaPar<cfelse>listaNon</cfif>';" >
		<td class="bajada" width="10" align="center"><img id="img#instancia.id_requisito#" style="display: <cfif isdefined("url.id_requisito")><cfif url.id_requisito eq instancia.id_requisito>block<cfelse>none</cfif><cfelseif instancia.currentrow eq 1>block<cfelse>none</cfif>;" src="/cfmx/home/tramites/images/tri-closed.gif"></td>
		<td class="bajada" width="16"><a href="javascript: informacion(#instancia.id_requisito#,'#JSStringFormat(instancia.nombre_requisito)#'); "><img src="/cfmx/home/tramites/images/#img#" width="16" height="16" border="0" alt="#img#" title="#estado#"></a></td>
		<td class="bajada" width="16" align="center"><a href="javascript: informacion(#instancia.id_requisito#,'#JSStringFormat(instancia.nombre_requisito)#'); " >#CurrentRow#.</a></td>
		<td class="bajada" width="376"><a href="javascript: informacion(#instancia.id_requisito#,'#JSStringFormat(instancia.nombre_requisito)#'); " >#instancia.nombre_requisito#</a></td>
	</tr>
</cfloop>
</table>
</cfoutput>


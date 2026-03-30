<cfif ArrayLen(session.parche.errores)>
	<cfif IsDefined('url.olvidar_errores')>
		<cfset session.parche.errores = ArrayNew(1)>
	<cfelse>
		<cf_web_portlet_start titulo="Errores encontrados" tipo="light" width="700">
	
		<p style="font-weight:bold;color:darkred"> Se detectaron los siguientes errores en la generación del parche, por favor
		verifique que esto no le cause problemas.</p>
		<table cellpadding="2" cellspacing="0" border="0" width="700"><tr class="tituloListas">
			<th>Archivo</th><th>Mensaje</th></tr>
		<cfloop from="1" to="#ArrayLen(session.parche.errores)#" index="i">
		<tr class="lista<cfif i mod 2>Non<cfelse>Par</cfif>"><td valign="top"> 
		<cfoutput>#HTMLEditFormat(session.parche.errores[i].archivo)# </cfoutput></td>
			<td valign="top"> <cfoutput>#HTMLEditFormat(session.parche.errores[i].msg)# </cfoutput></td>
			</tr>
		</cfloop>
		</table>
		<p>
		<a href="?olvidar_errores=yes" style="text-decoration:underline"> Ya revisé estos errores, gracias.</a>
		</p>
		<p>&nbsp;</p>
		<cf_web_portlet_end>
	</cfif>
</cfif>
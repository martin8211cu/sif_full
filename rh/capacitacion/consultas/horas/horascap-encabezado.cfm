	<cfif form.reporte eq 2>
		<table width="100%" cellpadding="4" cellspacing="0"><tr><td width="99%" align="right"><a href="horascap.cfm<cfoutput>?reporte=1&_CFid=#form._CFid##parametros#</cfoutput>"><img border="0" src="/cfmx/plantillas/soinasp01/css/images/btnAnterior.gif" /></a></td><td align="right"><a href="horascap.cfm<cfoutput>?reporte=1&_CFid=#form._CFid##parametros#</cfoutput>">Regresar</a></td></tr></table>
	<cfelse >
		<table width="100%" cellpadding="4" cellspacing="0"><tr><td width="99%" align="right"><a href="horascap.cfm<cfoutput>?reporte=0&#parametros#</cfoutput>"><img border="0" src="/cfmx/plantillas/soinasp01/css/images/btnAnterior.gif" /></a></td><td align="right"><a href="horascap.cfm?<cfoutput>reporte=0#parametros#</cfoutput>">Regresar</a></td></tr></table>
	</cfif>	
	
	<br />
	<table width="90%" cellpadding="3" cellspacing="0" align="center">
		<tr><td align="center" style="font-size:18px;"><strong style="font-size:18; "><cfoutput>#session.Enombre#</cfoutput></strong></td></tr>
		<tr><td align="center" style="font-size:14;"><strong style="font-size:14;"><cfoutput>#nombre_proceso#</cfoutput></strong></td></tr>
		<cfif isdefined("form.CFid") and len(rtrim(form.CFid))>
			<tr><td align="center" ><strong style="font-size:14;"><cfoutput>#LB_Centro_Funcional#</cfoutput>:&nbsp;</strong><cfoutput>#trim(rs_centrofuncional.CFcodigo)#-#rs_centrofuncional.CFdescripcion#</cfoutput></td></tr>
		<cfelse>
			<tr><td align="center" ><strong style="font-size:14;"><cfoutput>#LB_Centro_Funcional#</cfoutput>:&nbsp;</strong>Todos</td></tr>
		</cfif>
	</table>
	<br />

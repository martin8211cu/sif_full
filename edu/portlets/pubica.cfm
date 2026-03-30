<cfif isdefined("Session.Edu.Usucodigo")>
	<cfquery name="rsNombre" datasource="asp">
		select Pnombre+' '+isnull(Papellido1,'')+' '+isnull(Papellido2,'') as nombre 
		from Usuario u 
			inner join DatosPersonales p
				 on p.datos_personales = u.datos_personales
		where u.Usucodigo = <cfqueryparam value="#Session.Edu.Usucodigo#" cfsqltype="cf_sql_numeric">
	</cfquery>
	
	<cfquery name="rsMensajes" datasource="asp">
		select 	case count(1) 
					when 0 then 'No tiene mensajes nuevos' 
					when 1 then 'Tiene 1 mensaje nuevo' 
					else 'Tiene '+convert(varchar, count(1))+' mensajes nuevos' 
				end as mensaje 
		from Buzon 
		where Usucodigo = <cfqueryparam value="#Session.Edu.Usucodigo#" cfsqltype="cf_sql_numeric">
		  and Bestado = 0
	</cfquery>
	
	<cfset meses="Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Setiembre,Octubre,Noviembre,Diciembre">
	
	<cfoutput>
		<table class="area" width="100%" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td width="25%" style="padding-left: 5px;">
					<a href="/jsp/sdc/org/agenda/">
						<img alt="Ir a agenda personal" src="/cfmx/edu/Imagenes/agenda.gif" width="32" height="25" align="ABSMIDDLE" border="0" />
					</a>
					<a href="/jsp/sdc/org/agenda/">
					#LSDateFormat(Now(), 'dd')# de #ListGetAt(meses, LSDateFormat(Now(), 'm'), ',')# de #LSDateFormat(Now(), 'yyyy')#
					<!--- <fmt:formatDate value="${ubica.result[0].data.row[0].fecha}" type="date" dateStyle="long"/> --->
					</a>
				</td>
				<td class="tituloAlterno" width="50%">
					<cfif rsNombre.recordCount EQ 1>
							<a href="/jsp/sdc/cfg/cfg/usuario.jsp">#rsNombre.nombre#</a>
							<a href="/jsp/sdc/cfg/cfg/usuario.jsp"><img alt="Ir a configuraci&oacute;n personal" src="/cfmx/edu/Imagenes/yo.gif" width="32" height="25" align="ABSMIDDLE" border="0" /></a>
					<cfelse>
						Sin conexi&oacute;n
					</cfif>
				</td>
				<td align="right" width="25%" style="padding-right: 5px;">
					<a href="/cfmx/edu/buzon/index.cfm?a=#LSDateFormat(Now(), 'ddmmyyyy')##LSTimeFormat(Now(),'hhmmss')#">#rsMensajes.mensaje#</a>
					<a href="/cfmx/edu/buzon/index.cfm?a=#LSDateFormat(Now(), 'ddmmyyyy')##LSTimeFormat(Now(),'hhmmss')#"><img alt="ir al buz&oacute;n" src="/cfmx/edu/Imagenes/email/e-mail.gif" height="25" align="ABSMIDDLE" border="0" /></a> 
				</td>
			</tr>
		</table>
	</cfoutput>
</cfif>
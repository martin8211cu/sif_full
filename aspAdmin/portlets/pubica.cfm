<cfif isdefined("Session.Usucodigo") and Len(trim(Session.Usucodigo)) GT 0>
	<cfquery name="rsNombre" datasource="#session.DSN#">
		select Pnombre+' '+isnull(Papellido1,'')+' '+isnull(Papellido2,'') as nombre 
		from Usuario u 
		where u.Ulocalizacion = <cfqueryparam value="#Session.Ulocalizacion#" cfsqltype="cf_sql_char">
		and u.Usucodigo = #Session.Usucodigo#
	</cfquery>
	
	<cfquery name="rsMensajes" datasource="#session.DSN#">
		select (case count(1) 
		when 0 then 'No tiene mensajes' 
		when 1 then 'Tiene 1 mensaje' 
		else 'Tiene '+convert(varchar, count(*))+' mensajes' 
		end) as mensaje 
		from Buzon 
		where Ulocalizacion = <cfqueryparam value="#Session.Ulocalizacion#" cfsqltype="cf_sql_char">
		and Usucodigo = #Session.Usucodigo#
	</cfquery>
	
	<cfset meses="Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Setiembre,Octubre,Noviembre,Diciembre">
	
	<cfoutput>
		<table class="area" width="100%" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td width="25%">
					<a href="/jsp/sdc/org/agenda/">
						<img alt="Ir a agenda personal" src="/cfmx/sif/imagenes/agenda.gif" width="32" height="25" align="ABSMIDDLE" border="0" />
					</a>
					<a href="/jsp/sdc/org/agenda/">
					#LSDateFormat(Now(), 'dd')# de #ListGetAt(meses, LSDateFormat(Now(), 'm'), ',')# de #LSDateFormat(Now(), 'yyyy')#
					</a>
				</td>
				<td class="tituloAlterno" width="50%">
					<cfif rsNombre.recordCount EQ 1>
							<a href="/cfmx/sif/framework/catalogos/Usuario.cfm">#rsNombre.nombre#</a>
							<a href="/cfmx/sif/framework/catalogos/Usuario.cfm"><img alt="Ir a configuraci&oacute;n personal" src="/cfmx/sif/imagenes/yo.gif" width="32" height="25" align="ABSMIDDLE" border="0" /></a>
					<cfelse>
						Sin conexi&oacute;n
					</cfif>
				</td>
				<td align="right" width="25%">
<!--- 					<a href="/jsp/sdc/org/buzon/">#rsMensajes.mensaje#</a>
					<a href="/jsp/sdc/org/buzon/"><img alt="ir al buz&oacute;n" src="/cfmx/sif/imagenes/buzon.gif" width="34" height="23" align="ABSMIDDLE" border="0" /></a>  --->
					<a href="/cfmx/sif/framework/buzon/index.cfm">#rsMensajes.mensaje#</a>
					<a href="/cfmx/sif/framework/buzon/index.cfm"><img alt="ir al buz&oacute;n" src="/cfmx/sif/imagenes/buzon.gif" width="34" height="23" align="ABSMIDDLE" border="0" /></a>			  </td>
			</tr>
		</table>
	</cfoutput>
</cfif>
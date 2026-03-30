<cfset Session.modulo="ADMIN">
<cfparam default="Administraci&oacute;n del Centro de Estudio" name="title">
<cfparam default="Administraci&oacute;n del Centro de Estudio" name="moduleName">
<cfparam default="/cfmx/edu/ced/MenuCED.cfm" name="moduleRef">
<cfoutput>
	<table width="100%" border="0" style="background-color:##ccc;border:1px solid ##999; padding:2px; border-bottom: 1px solid ##333; border-right: 1px solid ##333">
		<tr>
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
				<td style="padding-right: 5px;">
					<a href="/cfmx/edu/buzon/index.cfm?a=#LSDateFormat(Now(), 'ddmmyyyy')##LSTimeFormat(Now(),'hhmmss')#"><img alt="ir al buz&oacute;n" src="/cfmx/edu/Imagenes/email/e-mail.gif" height="25" align="ABSMIDDLE" border="0" /></a> 
					<a href="/cfmx/edu/buzon/index.cfm?a=#LSDateFormat(Now(), 'ddmmyyyy')##LSTimeFormat(Now(),'hhmmss')#">#rsMensajes.mensaje#</a>
				</td>
			</cfif>
			<td align="right" align="58%" style="font-size:12px;">
				<strong>#title#</strong>
			</td>
			<td align="right" width="42%">
				<span class="toprightitems"><a href="/cfmx/home/menu/micuenta/index.cfm" style="color:##000000;"><cfoutput>#session.Usulogin#, #session.CEnombre#</cfoutput></a></span>
			</td>
		</tr>
	</table>
</cfoutput>
<cfset modulo = 'MenuCED.cfm'>
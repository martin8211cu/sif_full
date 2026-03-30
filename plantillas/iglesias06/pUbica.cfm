<cfif Not IsDefined("request.PORTLET_PUBICA")>
<cfset request.PORTLET_PUBICA=1>

<cfif isdefined("Session.Usucodigo") and Len(trim(Session.Usucodigo)) GT 0>
	<cfquery name="rsNombre" datasource="asp">
		select distinct c.CEnombre || '<br>' || p.Pnombre+' '+isnull(p.Papellido1,'')+' '+isnull(p.Papellido2,'') as nombre 
		from Usuario u, CuentaEmpresarial c, DatosPersonales p
		where u.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
		  and c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
		  and u.CEcodigo = c.CEcodigo
		  and u.datos_personales = p.datos_personales
	</cfquery>
	
	
	<cfset meses="Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Setiembre,Octubre,Noviembre,Diciembre">
	
	<cfoutput>
	<cfif rsNombre.recordCount EQ 1>			
		<table width="100%" cellpadding="0" cellspacing="0" border="0" align="center">
			<tr>
				<td width="14%" nowrap><a href="/cfmx/hosting/publico/afiliacion/afiliacion.cfm" title="Ir a configuraci&oacute;n personal" style="text-decoration:none"><font color="##000099" face="Verdana"><strong>#rsNombre.nombre#</strong></font></a></td>
				<td width="86%" nowrap><cfinclude template="login-form2.cfm"></td>
			</tr>
		</table>
	</cfif>		
	</cfoutput>
</cfif>

</cfif>
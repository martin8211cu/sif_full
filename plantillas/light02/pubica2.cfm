<cfif isdefined("Session.Usucodigo") and Len(trim(Session.Usucodigo)) GT 0>
	<cfquery name="rsNombre" datasource="asp">
		select Pnombre || '' || Papellido1 || '' || Papellido2 as nombre
		from Usuario a, DatosPersonales b
		where a.Usucodigo=#session.Usucodigo#
		and a.datos_personales=b.datos_personales
	</cfquery>
	
	<cfset meses="Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Setiembre,Octubre,Noviembre,Diciembre">
	
	<cfoutput>
	<cfif rsNombre.recordCount EQ 1>							

		<table width="100%" cellpadding="0" cellspacing="0" border="0" align="center" >
			<tr>
				<td width="50%" nowrap valign="middle" align="center"><a href="/cfmx/home/menu/micuenta/" title="Ir a configuraci&oacute;n personal" style="text-decoration:none"><font color="##000099" face="Verdana"><font size="2"><strong>#rsNombre.nombre#</strong></font></font></a></td>
				<td width="50%" nowrap valign="middle"><cfinclude template="/plantillas/light02/login-form2.cfm"></td>
			</tr>
		</table>
		
	</cfif>		
	</cfoutput>
</cfif>
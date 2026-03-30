<cfif isdefined("Session.Usucodigo") and Len(trim(Session.Usucodigo)) GT 0>
	<cfinclude template="../Utiles/sifConcat.cfm">
	<cfquery name="rsNombre" datasource="asp">
		select d.Pnombre #_Cat# rtrim(' ' #_Cat# d.Papellido1 #_Cat# rtrim(' ' #_Cat# d.Papellido2)) as nombre
		from Usuario u, DatosPersonales d, CuentaEmpresarial e
		where u.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
		  and u.datos_personales = d.datos_personales
		  and u.CEcodigo = e.CEcodigo
	</cfquery>

	<cfoutput>
		<table width="100%" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td class="tituloPersona" align="right" >
					<cfif rsNombre.recordCount EQ 1>
							<a href="/cfmx/home/menu/micuenta/" title="Modificar mi informaci&oacute;n Personal">#rsNombre.nombre#</a>
							<!---<a href="/cfmx/home/menu/micuenta/"><img alt="Ir a configuraci&oacute;n personal" src="/cfmx/sif/imagenes/yo.gif" width="32" height="25" align="ABSMIDDLE" border="0" /></a>--->
					<cfelse>
						Sin conexi&oacute;n
					</cfif>
				</td>
			</tr>
		</table>
	</cfoutput>
</cfif>
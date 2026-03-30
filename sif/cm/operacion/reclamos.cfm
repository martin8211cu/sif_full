<cf_templateheader title="Trabajar con Reclamos">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Registro de Solicitudes de Compra'>

		<cfset modo = 'ALTA'>
		<cfif isdefined("form.ERid") and len(trim(form.ERid)) >
			<cfset modo = 'CAMBIO'>
		</cfif>
		<cfoutput>
			<table width="100%" cellpadding="0" cellspacing="0" align="center">
				<tr><td><cfinclude template="../../portlets/pNavegacion.cfm"></td></tr>
				
				<tr>
					<td align="center">
						<table width="98%" cellpadding="0" cellspacing="0" align="center">
							<tr><td class="subTitulo" align="center"><font size="2">Encabezado de Reclamo</strong></td></tr>
							<form name="form1" action="reclamos-sql.cfm" method="post">
							<tr><td align="center"><cfinclude template="reclamoE-form.cfm"></td></tr>
							<cfif modo neq 'ALTA'>
								<tr><td class="subTitulo" align="center"><font size="2">Detalle de Reclamo</font></td></tr>
								<tr><td>&nbsp;</td></tr>
								<tr><td><cfinclude template="reclamosD-form.cfm"></td></tr>
								<tr><td>&nbsp;</td></tr>
							</cfif>
							<tr><td align="center">
								<input type="submit" name="Cambio" value="Modificar">
								<input type="submit" name="Regresar" value="Regresar" onClick="this.form.action='reclamos-lista.cfm';">
							</td></tr>
							</form>
						</table>
					</td>
				</tr>
				
				<tr><td>&nbsp;</td></tr>

			</table>
		</cfoutput>
	<cf_web_portlet_end>
<cf_templatefooter>
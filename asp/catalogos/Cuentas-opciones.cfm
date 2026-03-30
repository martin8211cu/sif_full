<table width="100%" border="0" cellpadding="2" cellspacing="0" align="center">
  <tr>
	<td align="right" width="25%">
		<cfif not isdefined("Session.Progreso.CEcodigo")>
			<img src="/cfmx/asp/imagenes/w-check.gif" border="0">
		</cfif>
	</td>
	<td class="etiquetaProgreso" align="left" width="25%" nowrap><a href="/cfmx/asp/catalogos/Cuentas.cfm?o=2" tabindex="-1">Crear Nueva Cuenta Empresarial</a></td>
	<td align="right" width="10%">
		<cfif isdefined("Session.Progreso.CEcodigo") and Len(Trim(Session.Progreso.CEcodigo)) NEQ 0>
			<img src="/cfmx/asp/imagenes/w-check.gif" border="0">
		</cfif>
	</td>
	<td class="etiquetaProgreso" align="left" width="40%" onMouseOver="javascript: this.style.bgcolor='black' " nowrap><a href="javascript: showList(true);" tabindex="-1">Trabajar con Cuenta Empresarial Existente</a></td>
  </tr>
</table>
